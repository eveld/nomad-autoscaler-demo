.PHONY: autoscaler jobs nomad plugins proxy web consul

nomad:
	sudo /home/eveld/go/bin/nomad agent -config=nomad/server.hcl

consul:
	consul agent -config-file consul/server.hcl

autoscaler:
	/home/eveld/go/bin/nomad-autoscaler run -config=autoscaler/config.hcl

apps: monitoring ingress web-v1

monitoring:
	/home/eveld/go/bin/nomad run jobs/monitoring.hcl

ingress:
	/home/eveld/go/bin/nomad run jobs/ingress.hcl

web-v1:
	/home/eveld/go/bin/nomad run jobs/web-v1.hcl

web-v2:
	/home/eveld/go/bin/nomad run jobs/web-v2.hcl

load:
	hey -z 5m -c 30 http://127.0.0.1:8080

extreme-load:
	hey -z 5m -c 100 http://127.0.0.1:8080