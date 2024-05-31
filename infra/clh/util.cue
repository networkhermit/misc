package main

#DepRun: {
	in: {
		dep?:     _
		parallel: bool | *false
		tasks: [...{...}]
	}
	out: X={
		for i, v in in.tasks {
			"s\(i+1)": v & {
				let p = in.parallel || i == 0
				if p {
					if in.dep != _|_ {
						$after: in.dep
					}
				}
				if !p {
					$after: [X["s\(i)"]]
				}
			}
		}
	}
}
