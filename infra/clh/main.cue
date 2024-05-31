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
}
