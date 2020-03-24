.PHONY: autoscaler jobs nomad plugins proxy web consul

nomad:
	sudo rm -rf /tmp/nomad || true
	sudo nomad agent -config=nomad/server.hcl

consul:
	sudo rm -rf /tmp/consul || true
	consul agent -config-file consul/server.hcl

autoscaler:
	nomad run jobs/autoscaler.hcl

monitoring:
	nomad run jobs/monitoring.hcl

ingress:
	nomad run jobs/ingress.hcl

web:
	nomad run jobs/web.hcl

web-nomad:
	nomad run jobs/web-nomad-metrics.hcl

web-prometheus:
	nomad run jobs/web-prometheus-metrics.hcl

web-latency:
	nomad run jobs/web-latency.hcl

load:
	hey -z 5m -c 30 http://127.0.0.1:8080

extreme-load:
	hey -z 5m -c 100 http://127.0.0.1:8080