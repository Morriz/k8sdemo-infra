resource "template_file" "controller-acc-user-data" {
  template = "${file("./user-data/controller-acc.yaml")}"
  vars = {
    // etcd_discovery_url = "${replace(file("etcd_discovery_url.txt"), "/\n/", "")}"
    authorized_keys = "  - ${join("\n  - ", split("\n", trimspace(file("../ssl/authorized_keys"))))}"
    ETCD_ENDPOINTS = "http://127.0.0.1:2379"
    K8S_VER = "${var.k8s-ver-acc}"
    SERVICE_NETWORK = "${var.service-network-acc}"
    POD_NETWORK = "${var.pod-network-acc}"
    DNS_SERVICE_IP = "${var.dns-service-ip-acc}"
    K8S_SERVICE_IP = "${var.k8s-service-ip-acc}"
    ARTIFACT_URL = "${var.artifact-url-acc}"
    CA_PEM = "${base64encode(file("../ssl/acc-k8s/ca.pem"))}"
    APISERVER_PEM = "${base64encode(file("../ssl/acc-k8s/apiserver.pem"))}"
    APISERVERKEY_PEM = "${base64encode(file("../ssl/acc-k8s/apiserver-key.pem"))}"
  }
}

resource "template_file" "worker-acc-user-data" {
  template = "${file("./user-data/worker-acc.yaml")}"
  vars = {
    // etcd_discovery_url = "${replace(file("etcd_discovery_url.txt"), "/\n/", "")}"
    authorized_keys = "  - ${join("\n  - ", split("\n", trimspace(file("../ssl/authorized_keys"))))}"
    ETCD_ENDPOINTS = "http://${var.controller-ip-acc}:2379"
    CONTROLLER_IP = "${var.controller-ip-acc}"
    K8S_VER = "${var.k8s-ver-acc}"
    DNS_SERVICE_IP = "${var.dns-service-ip-acc}"
    ARTIFACT_URL = "${var.artifact-url-acc}"
    CA_PEM = "${base64encode(file("../ssl/acc-k8s/ca.pem"))}"
    WORKER_PEM = "${base64encode(file("../ssl/acc-k8s/worker.pem"))}"
    WORKERKEY_PEM = "${base64encode(file("../ssl/acc-k8s/worker-key.pem"))}"
  }
}

resource "template_file" "controller-prod-user-data" {
  template = "${file("./user-data/controller-prod.yaml")}"
  vars = {
    // etcd_discovery_url = "${replace(file("etcd_discovery_url.txt"), "/\n/", "")}"
    authorized_keys = "  - ${join("\n  - ", split("\n", trimspace(file("../ssl/authorized_keys"))))}"
    ETCD_ENDPOINTS = "http://127.0.0.1:2379"
    K8S_VER = "${var.k8s-ver-prod}"
    SERVICE_NETWORK = "${var.service-network-prod}"
    POD_NETWORK = "${var.pod-network-prod}"
    DNS_SERVICE_IP = "${var.dns-service-ip-prod}"
    K8S_SERVICE_IP = "${var.k8s-service-ip-prod}"
    ARTIFACT_URL = "${var.artifact-url-prod}"
    CA_PEM = "${base64encode(file("../ssl/prod-k8s/ca.pem"))}"
    APISERVER_PEM = "${base64encode(file("../ssl/prod-k8s/apiserver.pem"))}"
    APISERVERKEY_PEM = "${base64encode(file("../ssl/prod-k8s/apiserver-key.pem"))}"
  }
}

resource "template_file" "worker-prod-user-data" {
  template = "${file("./user-data/worker-prod.yaml")}"
  vars = {
    // etcd_discovery_url = "${replace(file("etcd_discovery_url.txt"), "/\n/", "")}"
    authorized_keys = "  - ${join("\n  - ", split("\n", trimspace(file("../ssl/authorized_keys"))))}"
    ETCD_ENDPOINTS = "http://${var.controller-ip-prod}:2379"
    CONTROLLER_IP = "${var.controller-ip-prod}"
    K8S_VER = "${var.k8s-ver-prod}"
    DNS_SERVICE_IP = "${var.dns-service-ip-prod}"
    ARTIFACT_URL = "${var.artifact-url-prod}"
    CA_PEM = "${base64encode(file("../ssl/prod-k8s/ca.pem"))}"
    WORKER_PEM = "${base64encode(file("../ssl/prod-k8s/worker.pem"))}"
    WORKERKEY_PEM = "${base64encode(file("../ssl/prod-k8s/worker-key.pem"))}"
  }
}
