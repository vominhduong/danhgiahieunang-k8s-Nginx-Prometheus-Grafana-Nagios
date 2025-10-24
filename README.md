# danhgiahieunang-k8s-Nginx-Prometheus-Grafana-Nagios
Hệ thống giám sát webserver nginx được triển khai trên k8s cluster bằng prometheus, grafana, nagios
## thành phần hệ thống
### nagios
Giám sát trạng thái các node worker, master :
 - Trạng thái up/down
 - http port 30030(port triển khai nginx server).
 - Khả năng ssh
 - Trạng thái ping
### Prometheus
 - Thu thập các metric từ cụm k8s
 - Trực quan hóa dự liệu thu thập từ metrics
 - alertmanager
### Grafana
 - Trực quan dữ liệu dễ quan sát hơn
### Rancher
 - điều khiển cụm k8s cluster một cách trực quan bằng giao diện

