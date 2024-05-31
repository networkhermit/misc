package main

#VmConfig: [K=string]: {
	meta: tap: string
	config: {
		console: {
			mode: string | *"Off"
			...
		}
		cpus: {
			boot_vcpus: int & >=1 | *4
			max_vcpus:  int & >=1 | *boot_vcpus
			...
		}
		disks: [...{
			path: string
			...
		}]
		memory: {
			size: int64 | *8Gi
			...
		}
		net: [...{
			mac: string
			tap: string | *meta.tap
			...
		}]
		payload: {
			firmware: string | *"/var/lib/libvirt/boot/CLOUDHV.fd"
			...
		}
		serial: {
			mode:   string | *"Socket"
			socket: string | *"/run/cloud-hypervisor-serial-\(K).sock"
			...
		}
		...
	}
}
