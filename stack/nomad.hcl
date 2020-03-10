nomad_cluster "nomad" {
  version = "v0.10.4-custom"

  nodes = 1 // default

  network {
    name = "network.onprem"
    ip_address = "10.5.0.10"
  }

  // volume {
  //   source = "./plugins"
  //   destination = "/plugins"
  // }

  // volume {
  //   source      = "./binaries"
  //   destination = "/usr/bin"
  // }

  // image {
  //   name = "consul:1.7.1"
  // }

  // image {
  //   name = "haproxy:2.0"
  // }

  // image {
  //   name = "prom/haproxy-exporter"
  // }

  // image {
  //   name = "prom/prometheus:latest"
  // }

  // image {
  //   name = "grafana/grafana"
  // }

  image {
    name = "hashicorp/demo-webapp-lb-guide"
  }

  image {
    name = "shipyardrun/nomad-autoscaler:v0.10.4-custom"
  }

  env {
    key = "CONSUL_SERVER"
    value = "consul.container.shipyard"
  }
  
  env {
    key = "CONSUL_DATACENTER"
    value = "dc1"
  }
}