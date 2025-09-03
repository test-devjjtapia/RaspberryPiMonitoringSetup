#  Raspberry Pi Monitoring Setup

Script automatizado para instalar y configurar Grafana y Node Exporter en Raspberry Pi para monitoreo del sistema.

##  Descripción

Este script bash automatiza la instalación de:
- **Grafana**: Plataforma de visualización y monitoreo
- **Node Exporter**: Exportador de métricas del sistema para Prometheus

##  Requisitos Previos

- Raspberry Pi con Raspbian/Raspberry Pi OS
- Arquitectura ARM64
- Acceso a internet
- Permisos de administrador (sudo)
- Al menos 1GB de espacio libre en disco

##  Instalación

### Opción 1: Descarga directa
```bash
# Descargar el script
curl -O https://raw.githubusercontent.com/tu-usuario/tu-repo/main/raspberrypi_monitoring_fixed_v2.sh

# Hacer ejecutable
chmod +x raspberrypi_monitoring_fixed_v2.sh

# Ejecutar
./raspberrypi_monitoring_fixed_v2.sh
```

### Opción 2: Clonar repositorio
```bash
git clone https://github.com/tu-usuario/tu-repo.git
cd tu-repo
chmod +x raspberrypi_monitoring_fixed_v2.sh
./raspberrypi_monitoring_fixed_v2.sh
```

##  Qué hace el script

1. **Actualiza el sistema** y instala dependencias necesarias
2. **Configura el repositorio de Grafana** con las claves GPG correspondientes
3. **Instala Grafana** desde el repositorio oficial
4. **Configura Grafana** como servicio systemd
5. **Descarga e instala Node Exporter** (versión 1.8.0 para ARM64)
6. **Crea usuario dedicado** para Node Exporter
7. **Configura Node Exporter** como servicio systemd
8. **Valida la instalación** de ambos servicios

##  Acceso a los Servicios

Una vez completada la instalación:

### Grafana
- **URL**: `http://192.168.1.113:3000`
- **Usuario**: `admin`
- **Contraseña**: `admin`

### Node Exporter
- **Métricas**: `http://192.168.1.113:9100/metrics`

> **Nota**: Cambia `192.168.1.113` por la IP real de tu Raspberry Pi

##  Verificación

Para verificar que los servicios están funcionando:

```bash
# Estado de Grafana
sudo systemctl status grafana-server

# Estado de Node Exporter
sudo systemctl status node_exporter
```

##  Configuración Posterior

### Configurar Grafana

1. Accede a Grafana en tu navegador
2. Inicia sesión con admin/admin
3. Cambia la contraseña cuando se te solicite
4. Configura Prometheus como fuente de datos:
   - URL: `http://localhost:9090` (si tienes Prometheus instalado)
   - Para usar solo Node Exporter: `http://localhost:9100`

### Dashboards Recomendados

- **Node Exporter Full**: ID 1860
- **Raspberry Pi Monitoring**: ID 10578
- **System Overview**: ID 405

## Comandos Utiles

```bash
# Reiniciar servicios
sudo systemctl restart grafana-server
sudo systemctl restart node_exporter

# Ver logs
sudo journalctl -u grafana-server -f
sudo journalctl -u node_exporter -f

# Detener servicios
sudo systemctl stop grafana-server
sudo systemctl stop node_exporter
```

##  Personalización

### Cambiar configuración de Grafana

El archivo de configuración se encuentra en:
```
/etc/grafana/grafana.ini
```

### Configuración de Node Exporter

Para personalizar las métricas de Node Exporter, edita el archivo de servicio:
```bash
sudo nano /etc/systemd/system/node_exporter.service
```

##  Solución de Problemas

### Grafana no inicia
```bash
# Verificar logs
sudo journalctl -u grafana-server --no-pager

# Verificar configuración
sudo grafana-cli admin reset-admin-password newpassword
```

### Node Exporter no responde
```bash
# Verificar el proceso
ps aux | grep node_exporter

# Verificar permisos
ls -la /usr/local/bin/node_exporter
```

### Problemas de conectividad
```bash
# Verificar puertos abiertos
netstat -tulpn | grep -E "(3000|9100)"

# Verificar firewall
sudo ufw status
```

##  Notas

- El script está optimizado para Raspberry Pi con arquitectura ARM64
- Se recomienda cambiar la contraseña por defecto de Grafana
- Node Exporter ejecuta en el puerto 9100 por defecto
- Grafana ejecuta en el puerto 3000 por defecto

##  Enlaces Utiles

- [Documentación oficial de Grafana](https://grafana.com/docs/)
- [Documentación de Node Exporter](https://github.com/prometheus/node_exporter)
- [Dashboards de la comunidad](https://grafana.com/grafana/dashboards/)

## Contribuciones

Las contribuciones son bienvenidas. Para cambios importantes:

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

##  Licencia

Este proyecto está bajo la Licencia MIT. Ver el archivo `LICENSE` para más detalles.

##  Disclaimer

Usalo bajo tu propia responsabilidad. Siempre haz respaldos antes de ejecutar scripts de instalación automática.
