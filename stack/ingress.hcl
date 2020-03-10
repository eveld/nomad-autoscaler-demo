ingress "consul" {
  target  = "container.consul"

  network {
    name = "network.onprem"
  }

  port {
    local  = 8500
    remote = 8500
    host   = 8500
  }
}

ingress "prometheus" {
  target  = "nomad_cluster.nomad"

  network {
    name = "network.onprem"
  }

  port {
    local  = 9090
    remote = 9090
    host   = 9090
  }
}

ingress "grafana" {
  target  = "nomad_cluster.nomad"

  network {
    name = "network.onprem"
  }

  port {
    local  = 3000
    remote = 3000
    host   = 3000
  }
}

ingress "ingress" {
  target  = "nomad_cluster.nomad"

  network {
    name = "network.onprem"
  }

  port {
    local  = 8080
    remote = 8080
    host   = 8080
  }
}

ingress "nomad" {
  target  = "nomad_cluster.nomad"

  network {
    name = "network.onprem"
  }

  port {
    local  = 4646
    remote = 4646
    host   = 4646
  }
}