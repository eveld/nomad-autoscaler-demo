datacenter = "dc1"

data_dir = "/tmp/nomad"

server {
  enabled          = true
  bootstrap_expect = 1
}

client {
  enabled = true

  host_volume "plugins" {
    path = "/opt/nomad-autoscaler/plugins"
    read_only = true
  }
}

telemetry {
  publish_allocation_metrics = true
  publish_node_metrics       = true
  prometheus_metrics         = true
}