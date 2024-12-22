package main

import (
	"encoding/json"
	"encoding/yaml"
	"list"
	"tool/cli"
	"tool/exec"
)

host_egress: string | *"br0" @tag(host_egress)

vm_bridge: string | *"vmbr0" @tag(vm_bridge)

let dnsmasq_conf = {
	logfile: "/tmp/dnsmasq-\(vm_bridge).log"
	pidfile: "/run/dnsmasq-\(vm_bridge).pid"
}

command: setup: [string]: [string]: exec.Run

command: setup: {
	bridge: {
		let xs = [
			{cmd: "ip link add \(vm_bridge) type bridge"},
			{cmd: "ip address add 172.31.0.1/24 dev \(vm_bridge)"},
			{cmd: "ip address add fd00:ebee:172:31::1/64 dev \(vm_bridge)"},
			{cmd: "ip link set dev \(vm_bridge) up"},
		]
		{#DepRun & {in: tasks: xs}}.out
	}
	dnsmasq: {
		let xs = [
			{cmd: "dnsmasq --conf-file=/srv/dnsmasq/dnsmasq.conf --interface=\(vm_bridge) --log-facility=\(dnsmasq_conf.logfile) --pid-file=\(dnsmasq_conf.pidfile)"},
		]
		{#DepRun & {in: {dep: bridge.s1, tasks: xs}}}.out
	}
	iptables: {
		let xs = [
			{cmd: "iptables --table nat --insert POSTROUTING --source 172.31.0.0/24 --out-interface \(host_egress) --jump MASQUERADE"},
			{cmd: "iptables --table filter --insert FORWARD --in-interface \(host_egress) --out-interface \(vm_bridge) --match conntrack --ctstate ESTABLISHED,RELATED --jump ACCEPT"},
			{cmd: "iptables --table filter --insert FORWARD --in-interface \(vm_bridge) --out-interface \(host_egress) --jump ACCEPT"},
		]
		{#DepRun & {in: {parallel: true, tasks: xs}}}.out
	}
	matchbox: {
		let xs = [
			{cmd: "docker run --detach --name matchbox --network host --rm --mount type=bind,source=/srv/matchbox,destination=/var/lib/matchbox quay.io/poseidon/matchbox:latest -address=0.0.0.0:8080 -log-level=debug"},
		]
		{#DepRun & {in: tasks: xs}}.out
	}
}

command: clean: [string]: [string]: exec.Run & {mustSucceed: false}

command: clean: {
	bridge: {
		let xs = [
			{cmd: "ip link set dev \(vm_bridge) down"},
			{cmd: "ip link del \(vm_bridge) type bridge"},
		]
		{#DepRun & {in: tasks: xs}}.out
	}
	dnsmasq: {
		let xs = [
			{cmd: "pkill --pidfile \(dnsmasq_conf.pidfile)"},
			{cmd: "rm --force \(dnsmasq_conf.logfile)"},
		]
		{#DepRun & {in: tasks: xs}}.out
	}
	iptables: {
		let xs = [
			{cmd: "iptables --table nat --delete POSTROUTING --source 172.31.0.0/24 --out-interface \(host_egress) --jump MASQUERADE"},
			{cmd: "iptables --table filter --delete FORWARD --in-interface \(host_egress) --out-interface \(vm_bridge) --match conntrack --ctstate ESTABLISHED,RELATED --jump ACCEPT"},
			{cmd: "iptables --table filter --delete FORWARD --in-interface \(vm_bridge) --out-interface \(host_egress) --jump ACCEPT"},
		]
		{#DepRun & {in: {parallel: true, tasks: xs}}}.out
	}
	matchbox: {
		let xs = [
			{cmd: "docker stop matchbox"},
		]
		{#DepRun & {in: tasks: xs}}.out
	}
}

ask: cli.Ask & {
	prompt:   """
		What vm do you want to operate?
		\(yaml.Marshal([for k, _ in vm {k}]))
		"""
	response: string
}

name: *ask.response | string @tag(name)

let api_socket = "/run/cloud-hypervisor-\(name).sock"

let call_ch_remote = ["ch-remote", "--api-socket", api_socket]

let vmm_logfile = "/tmp/cloud-hypervisor-\(name).log"
let vmm_early_boot_logfile = "/tmp/cloud-hypervisor-\(name)-early-boot.log"

command: start: [string]: [string]: exec.Run

command: start: {
	tuntap: {
		let tap = vm[name].meta.tap
		let xs = [
			{cmd: "ip tuntap add dev \(tap) mode tap"},
			{cmd: "ip link set \(tap) master \(vm_bridge)"},
			{cmd: "ip link set dev \(tap) up"},
		]
		{#DepRun & {in: tasks: xs}}.out
	}
	vmm: {
		let xs = [
			{cmd: ["bash", "-c", "nohup cloud-hypervisor --api-socket \(api_socket) --log-file \(vmm_logfile) &>\(vmm_early_boot_logfile) &"]},
			{cmd: ["sleep", "0.1"]},
			{cmd: list.Concat([call_ch_remote, ["create"]]), stdin: json.Marshal(vm[name].config)},
			{cmd: list.Concat([call_ch_remote, ["boot"]])},
		]
		{#DepRun & {in: {dep: [for v in tuntap {v}], tasks: xs}}}.out
	}
}

command: shutdown: [string]: [string]: exec.Run

command: shutdown: vmm: {
	let xs = [
		{cmd: list.Concat([call_ch_remote, ["power-button"]])},
		{cmd: ["bash", "-c", "while ch-remote --api-socket \(api_socket) ping 2>/dev/null; do sleep 1; done"]},
	]
	{#DepRun & {in: tasks: xs}}.out
}

command: destroy: [string]: [string]: exec.Run & {mustSucceed: false}

command: destroy: {
	tuntap: {
		let tap = vm[name].meta.tap
		let xs = [
			{cmd: "ip link set dev \(tap) down"},
			{cmd: "ip tuntap del dev \(tap) mode tap"},
		]
		{#DepRun & {in: {dep: [for v in vmm {v}], tasks: xs}}}.out
	}
	vmm: {
		let xs = [
			{cmd: list.Concat([call_ch_remote, ["shutdown"]])},
			{cmd: list.Concat([call_ch_remote, ["shutdown-vmm"]])},
		]
		{#DepRun & {in: tasks: xs}}.out
	}
}

command: console: [string]: exec.Run

command: console: {
	let socket = vm[name].config.serial.socket
	let xs = [
		{cmd: ["minicom", "-D", "unix#\(socket)", "-w"]},
	]
	{#DepRun & {in: tasks: xs}}.out
}
