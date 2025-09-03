#!/bin/bash

echo "📦 Instalando Grafana y Node Exporter en Raspberry Pi..."

# Instalar dependencias
sudo apt update
sudo apt install -y gnupg ca-certificates curl

# Agregar repositorio de Grafana
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://apt.grafana.com/gpg.key | gpg --dearmor | sudo tee /etc/apt/keyrings/grafana.gpg > /dev/null
echo "deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://apt.grafana.com stable main" | sudo tee /etc/apt/sources.list.d/grafana.list

# Instalar Grafana
sudo apt update
sudo apt install grafana -y

# Iniciar servicio de Grafana
sudo systemctl daemon-reexec
sudo systemctl enable grafana-server
sudo systemctl start grafana-server

# Instalar Node Exporter desde URL directa (versión ARM64 válida)
cd /tmp
curl -LO https://github.com/prometheus/node_exporter/releases/download/v1.8.0/node_exporter-1.8.0.linux-arm64.tar.gz
tar -xzf node_exporter-1.8.0.linux-arm64.tar.gz
sudo cp node_exporter-1.8.0.linux-arm64/node_exporter /usr/local/bin/
sudo useradd --no-create-home --shell /usr/sbin/nologin node_exporter

# Crear servicio systemd para Node Exporter
sudo tee /etc/systemd/system/node_exporter.service > /dev/null <<EOF
[Unit]
Description=Node Exporter
After=network.target

[Service]
User=node_exporter
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=default.target
EOF

# Activar y arrancar Node Exporter
sudo systemctl daemon-reexec
sudo systemctl enable --now node_exporter

# Validar servicios
echo ""
echo "🧪 Validando servicios..."
sudo systemctl status grafana-server --no-pager
sudo systemctl status node_exporter --no-pager

echo ""
echo "✅ Grafana disponible en http://192.168.1.113:3000 (admin/admin)"
echo "✅ Node Exporter en http://192.168.1.113:9100/metrics"
