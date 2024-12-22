package main

vm: #VmConfig

vm: {
	let nodes = {
		control_plan: [
			{mac: "42:eb:ee:16:18:10"},
			{mac: "42:eb:ee:16:18:20"},
			{mac: "42:eb:ee:16:18:30"},
		]
		worker: [
			{mac: "42:eb:ee:16:18:11"},
			{mac: "42:eb:ee:16:18:21"},
			{mac: "42:eb:ee:16:18:31"},
		]
	}
	for i, v in nodes.control_plan {
		"c\(i+1)": {
			meta: tap: "vmtapc\(i)"
			config: {
				cpus: boot_vcpus: 2
				disks: [{
					path: "/dev/secondary/talos-control-plane-\(i+1)"
				}]
				memory: size: 4Gi
				net: [{
					mac: v.mac
				}]
			}
		}
	}
	for i, v in nodes.worker {
		"w\(i+1)": {
			meta: tap: "vmtapw\(i)"
			config: {
				cpus: boot_vcpus: 8
				disks: [{
					path: "/dev/secondary/talos-worker-\(i+1)"
				}]
				memory: size: 32Gi
				net: [{
					mac: v.mac
				}]
			}
		}
	}
	let pets = [
		{
			mac:  "42:eb:ee:16:18:f1"
			name: "alpine"
		},
		{
			mac:  "42:eb:ee:16:18:f2"
			name: "artix"
		},
		{
			mac:  "42:eb:ee:16:18:f3"
			name: "fedora"
		},
		{
			mac:  "42:eb:ee:16:18:f4"
			name: "freebsd"
		},
		{
			mac:  "42:eb:ee:16:18:f5"
			name: "gentoo"
		},
		{
			mac:  "42:eb:ee:16:18:f6"
			name: "nixos"
		},
		{
			mac:  "42:eb:ee:16:18:f7"
			name: "openbsd"
		},
		{
			mac:  "42:eb:ee:16:18:f8"
			name: "void"
		},
	]
	for i, v in pets {
		"\(v.name)": {
			meta: tap: "vmtapwp\(i+1)"
			config: {
				disks: [{
					path: "/var/lib/libvirt/images/\(v.name).raw"
				}]
				net: [{
					mac: v.mac
				}]
			}
		}
	}
}
