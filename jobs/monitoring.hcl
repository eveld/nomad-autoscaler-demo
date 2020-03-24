job "monitoring" {
  datacenters = ["dc1"]

  group "prometheus" {
    count = 1

    restart {
      attempts = 2
      interval = "30m"
      delay    = "15s"
      mode     = "fail"
    }

    ephemeral_disk {
      size = 300
    }

    task "prometheus" {
      template {
        change_mode   = "signal"
        change_signal = "SIGHUP"
        destination   = "local/prometheus.yml"

        data = <<EOH
---
global:
  scrape_interval:     1s
  evaluation_interval: 1s

scrape_configs:
  - job_name: haproxy_exporter
    consul_sd_configs:
    - server: '127.0.0.1:8500'
      services: ['haproxy-exporter']

  - job_name: consul
    metrics_path: /v1/agent/metrics
    params:
      format: ['prometheus']
    static_configs:
    - targets: ['127.0.0.1:8500']

  - job_name: nomad
    metrics_path: /v1/metrics
    params:
      format: ['prometheus']
    static_configs:
    - targets: ['127.0.0.1:4646']
EOH
      }

      driver = "docker"

      config {
        image        = "prom/prometheus:latest"
        network_mode = "host"

        volumes = [
          "local/prometheus.yml:/etc/prometheus/prometheus.yml",
        ]

        port_map {
          ui = 9090
        }
      }

      resources {
        cpu    = 100
        memory = 1024

        network {
          mbits = 10

          port "ui" {
            static = 9090
          }
        }
      }

      service {
        name = "prometheus"
        tags = ["urlprefix-/"]
        port = "ui"

        check {
          name     = "ui port alive"
          type     = "http"
          path     = "/-/healthy"
          interval = "10s"
          timeout  = "2s"
        }
      }
    }
  }

  group "grafana" {
    count = 1

    restart {
      attempts = 2
      interval = "30m"
      delay    = "15s"
      mode     = "fail"
    }

    task "grafana" {
      artifact {
        source      = "https://raw.githubusercontent.com/eveld/autoscaler/master/jobs/grafana/dashboard.json"
        destination = "local/dashboard.json"
      }

      template {
        data = <<EOF
- name: 'default'
  org_id: 1
  folder: ''
  type: 'file'
  options:
    folder: '/var/lib/grafana/dashboards'
        EOF
        destination = "local/dashboard.yaml"
      }

      template {
        data = <<EOF
apiVersion: 1
datasources:
- name: Prometheus
  type: prometheus
  url: http://{{ env "attr.unique.network.ip-address" }}:9090
  access: proxy
  isDefault: true
        EOF
        destination = "local/datasource.yaml"
      }

      driver = "docker"

      config {
        image = "grafana/grafana"

        port_map {
          grafana_ui = 3000
        }

        volumes = [
          "local/dashboard.json:/var/lib/grafana/dashboards/default/",
          "local/datasource.yaml:/etc/grafana/provisioning/datasources/datasource.yaml",
          "local/dashboard.yaml:/etc/grafana/provisioning/dashboards/dashboard.yaml"
        ]
      }

      resources {
        cpu    = 100
        memory = 1024

        network {
          mbits = 10

          port "grafana_ui" {
            static = 3000
          }
        }
      }
    }
  }
}