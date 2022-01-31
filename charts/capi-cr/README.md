# capi-cr

![Version: 1.0.1](https://img.shields.io/badge/Version-1.0.1-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square)

Helm Chart for deploying a Kubernetes Cluster with the cluster-api.

**Homepage:** <https://github.com/syself/charts/tree/main/charts/cluster-api>

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| cluster.annotations | object | `{}` | Specifies some custom annotations |
| cluster.controlPlane | object | `{}` | Configures the state of the control Plane. Will configure the underlying CR of KCP or similar and a optional HealthCheck for the controlPlane |
| cluster.controlPlaneRef | string | `"kubeadm"` | Specifies which Kubernetes installation method is used. Supported values: kubeadm |
| cluster.infrastructureRef | string | `nil` |  |
| cluster.labels | object | `{}` | Specifies some custom labels |
| cluster.network | object | `{"podCIDRBlocks":[],"serviceCIDRBlocks":[]}` | Specifies the IP Range for the Kubernetes cluster. |
| cluster.network.podCIDRBlocks | list | `[]` | Specifies the podCIDR for Kubernetes |
| cluster.paused | string | `nil` | Tells the cluster-api controller to pause the cluster |
| cluster.serviceDomain | string | `nil` | Specifies the internal Kubernetes Domain |
| cluster.workers | object | `{}` |  |
| common.labels | object | the chart will add some internal labels | Defines labels which are shared between all created resources. |
| hetzner | object | `{}` |  |
| kubeadm.controlPlane | object | `{}` |  |
| kubeadm.workers | object | `{}` |  |

