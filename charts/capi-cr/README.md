# cluster-api-deploy-cluster

![Version: 1.0.0](https://img.shields.io/badge/Version-1.0.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square)

Helm Chart for deploying a Kubernetes Cluster with the cluster-api.

**Homepage:** <https://github.com/syself/charts/tree/main/charts/cluster-api>

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| cluster.annotations | object | `{}` | Specifies some custom annotations |
| cluster.apiServerPort | int | `6443` | The port where the kube-apiserver is listening. Also important since this is the destination Port for the kube-apiServer loadbalancer |
| cluster.controlPlane | object | `{"healthCheck":{"annotations":null,"enabled":true,"labels":{},"maxUnhealthy":"50%","nodeStartupTimeout":"4m","unhealthyConditions":[{"status":"Unknown","timeout":"300s","type":"Ready"},{"status":"False","timeout":"300s","type":"Ready"}]},"replicas":1,"type":null,"version":null}` | Configures the state of the control Plane. Will configure the underlying CR of KCP or similar and a optional HealthCheck for the controlPlane |
| cluster.controlPlane.healthCheck | object | `{"annotations":null,"enabled":true,"labels":{},"maxUnhealthy":"50%","nodeStartupTimeout":"4m","unhealthyConditions":[{"status":"Unknown","timeout":"300s","type":"Ready"},{"status":"False","timeout":"300s","type":"Ready"}]}` | Specifies a health Check for the control Planes |
| cluster.controlPlane.healthCheck.annotations | string | `nil` | Specifies some custom annotations for the HealthCheck CR |
| cluster.controlPlane.healthCheck.labels | object | `{}` | Specifies some custom labels for the HealthCheck CR |
| cluster.controlPlane.replicas | int | `1` | Sets the amount of created control Planes. For HA set replicas to 3 or 5. |
| cluster.controlPlane.type | string | `nil` | Specifies a sub resource of the infrastructure provider. For example if a infrastructure provider have more than one CR for specifing a machine Template (e.g Baremetal, cloud). For hetzner: hcloud |
| cluster.controlPlane.version | string | `nil` | Specifies the Kubernetes Version. This needs to match with the installed version of the node image usually specified in the machine Template of the infrastructure provider. If you update Kubernetes this needs to be updated first |
| cluster.controlPlaneRef | string | `"kubeadm"` | Specifies which Kubernetes installation method is used. Supported values: kubeadm |
| cluster.infrastructureRef | string | `nil` |  |
| cluster.labels | object | `{}` | Specifies some custom labels |
| cluster.name | string | `"test"` | Set the name of the target cluster |
| cluster.network | object | `{"podCIDR":{},"serviceCIDR":{}}` | Specifies the IP Range for the Kubernetes cluster. |
| cluster.paused | bool | `true` | Tells the cluster-api controller to pause the cluster |
| cluster.serviceDomain | string | `"cluster.local"` | Specifies the internal Kubernetes Domain |
| cluster.workers.md-0.annotations | object | `{}` | Specifies some custom annotations for the MachineDeployment CR |
| cluster.workers.md-0.enabled | bool | `false` | Enables or disables the machineDeployment |
| cluster.workers.md-0.failureDomain | string | `nil` | Specifies the failureDomain for the machineDeployment. Colloquially known as the location of the nodes. Values are defined by the supported infrastructure provider |
| cluster.workers.md-0.healthCheck | object | `{"annotations":{"annotation":"test"},"enabled":true,"labels":{"test":"labels"},"maxUnhealthy":"50%","nodeStartupTimeout":"4m","unhealthyConditions":[{"status":"Unknown","timeout":"300s","type":"Ready"},{"status":"False","timeout":"300s","type":"Ready"}]}` | HealthCheck for the specified machineDeployment |
| cluster.workers.md-0.labels | object | `{}` | Specifies some custom labels for the MachineDeployment CR |
| cluster.workers.md-0.nodeDrainTimeout | string | `"20m"` | The maximum time a drain could take from the cluster-api perspective. The real drain by kubernetes needs to be specified accordingly. |
| cluster.workers.md-0.progressDeadlineSeconds | string | `"600s"` |  |
| cluster.workers.md-0.replicas | string | `nil` | Specifies the amount of nodes |
| cluster.workers.md-0.revisionHistoryLimit | int | `2` |  |
| cluster.workers.md-0.strategy | object | `{"rollingUpdate":{"deletePolicy":null,"maxSurge":1,"maxUnavailable":0}}` | Configure the update and replacement strategy |
| cluster.workers.md-0.type | string | `nil` | Specifies a sub resource of the infrastructure provider. For example if a infrastructure provider have more than one CR for specifing a machine Template (e.g Baremetal, cloud). For hetzner: hcloud |
| cluster.workers.md-0.version | string | `nil` | Specifies the Kubernetes Version of this machineDeployment. This needs to match with the installed version of the node image usually specified in the machine Template of the infrastructure provider |
| common.labels | object | the chart will add some internal labels | Defines labels which are shared between all created resources. |
| hetzner.cluster.annotations | object | `{}` | Specifies some custom annotations for the HetznerCluster CR |
| hetzner.cluster.controlPlaneEndpoint.dns | string | `"test.local"` |  |
| hetzner.cluster.controlPlaneEndpoint.port | int | `443` |  |
| hetzner.cluster.controlPlaneLoadBalancer.algorithm | string | `"least_connection"` |  |
| hetzner.cluster.controlPlaneLoadBalancer.extraTargets[0].destinationPort | int | `6443` |  |
| hetzner.cluster.controlPlaneLoadBalancer.extraTargets[0].listenPort | int | `443` |  |
| hetzner.cluster.controlPlaneLoadBalancer.extraTargets[0].protocol | string | `"tcp"` |  |
| hetzner.cluster.controlPlaneLoadBalancer.port | int | `6443` |  |
| hetzner.cluster.controlPlaneLoadBalancer.region | string | `"nbg1"` |  |
| hetzner.cluster.controlPlaneLoadBalancer.type | string | `"lb11"` |  |
| hetzner.cluster.controlPlaneRegions | list | Could be set to "fsn1", "ngb1", or "hel1" | Sets the controlPlaneRegion for the control-planes.  |
| hetzner.cluster.hetznerSecretRef.key.hcloudToken | string | `"token"` |  |
| hetzner.cluster.hetznerSecretRef.name | string | `"hetzner"` |  |
| hetzner.cluster.labels | object | `{}` | Specifies some custom labels for the HetznerCluster CR |
| hetzner.cluster.network | object | `{}` | Sets a private network in Hetzner Cloud |
| hetzner.cluster.placementGroups[0].name | string | `"control-plane"` |  |
| hetzner.cluster.placementGroups[0].type | string | `"spread"` |  |
| hetzner.cluster.placementGroups[1].name | string | `"md-0"` |  |
| hetzner.cluster.placementGroups[1].type | string | `"spread"` |  |
| hetzner.cluster.sshKeys[0].name | string | `"test-key"` |  |
| hetzner.hcloud.controlPlane.annotations.test | string | `"annotation"` |  |
| hetzner.hcloud.controlPlane.imageName | string | `"fedora-34"` |  |
| hetzner.hcloud.controlPlane.labels.test | string | `"label"` |  |
| hetzner.hcloud.controlPlane.placementGroupName | string | `"control-plane"` |  |
| hetzner.hcloud.controlPlane.sshKeys[0].name | string | `"test-2"` |  |
| hetzner.hcloud.controlPlane.type | string | `"cp31"` |  |
| hetzner.hcloud.workers.md-0.annotations.annotation | string | `"test"` |  |
| hetzner.hcloud.workers.md-0.imageName | string | `"test-image"` |  |
| hetzner.hcloud.workers.md-0.labels.test | string | `"label"` |  |
| hetzner.hcloud.workers.md-0.placementGroupName | string | `"md-0"` |  |
| hetzner.hcloud.workers.md-0.sshKeys[0].name | string | `"test-2"` |  |
| hetzner.hcloud.workers.md-0.type | string | `"cpx41"` |  |
| hetzner.hcloud.workers.md-1.imageName | string | `"test-image"` |  |
| hetzner.hcloud.workers.md-1.type | string | `"cpx31"` |  |
| hetzner.hcloud.workers.md-2.annotations.annotation | string | `"test"` |  |
| hetzner.hcloud.workers.md-2.imageName | string | `"test-image"` |  |
| hetzner.hcloud.workers.md-2.labels.test | string | `"label"` |  |
| hetzner.hcloud.workers.md-2.placementGroupName | string | `"md-0"` |  |
| hetzner.hcloud.workers.md-2.type | string | `"cpx21"` |  |
| kubeadm.controlPlane.annotations | object | `{}` | Specifies some custom annotations for the KCP CR |
| kubeadm.controlPlane.apiServer | object | `{"extraArgs":{},"extraVolumes":[],"timeoutForControlPlane":"5m"}` | Configure the kube-apiserver |
| kubeadm.controlPlane.apiServer.extraArgs | object | `{}` | Configure the kube-apiserver flags |
| kubeadm.controlPlane.apiServer.extraVolumes | list | `[]` | Configure extraVolumes |
| kubeadm.controlPlane.apiServer.timeoutForControlPlane | string | `"5m"` | Specifies the timeout for the controlPlanes |
| kubeadm.controlPlane.controllerManager | object | `{"extraArgs":{},"extraVolumes":[]}` | Configure the controller-manager |
| kubeadm.controlPlane.controllerManager.extraArgs | object | `{}` | Configure the controller-manager flags |
| kubeadm.controlPlane.controllerManager.extraVolumes | list | `[]` | Configure extraVolumes |
| kubeadm.controlPlane.dns | object | `{"imageRepository":"quay.io","imageTag":"coredns"}` | Configure the installed DNS solution  |
| kubeadm.controlPlane.etcd | object | `{"local":{"dataDir":"/var/lib/etcd","extraArgs":{}}}` | Configure etcd |
| kubeadm.controlPlane.etcd.local.extraArgs | object | `{}` | Configure the etcd flags |
| kubeadm.controlPlane.files | list | `[]` | Configure files |
| kubeadm.controlPlane.initConfiguration | object | `{"criSocket":null,"kubelet":{"extraArgs":{}},"taints":null}` | Configure initConfiguration for the control-plane |
| kubeadm.controlPlane.initConfiguration.kubelet.extraArgs | object | `{}` | Configure kubelet flags for the initConfiguration |
| kubeadm.controlPlane.joinConfiguration | object | `{"criSocket":null,"kubelet":{"extraArgs":{}},"taints":null}` | Configure joinConfiguration for the control-plane  |
| kubeadm.controlPlane.joinConfiguration.kubelet.extraArgs | object | `{}` | Configure kubelet flags for the joinConfiguration |
| kubeadm.controlPlane.labels | object | `{}` | Specifies some custom labels for the KCP CR |
| kubeadm.controlPlane.nodeDrainTimeout | string | `nil` | The maximum time a drain could take from the cluster-api perspective. The real drain by kubernetes needs to be specified accordingly. |
| kubeadm.controlPlane.postKubeadmCommands | list | `[]` | Set postKubeadmCommands which let you run commands after kubeadm init runs. |
| kubeadm.controlPlane.preKubeadmCommands | list | `[]` | Set preKubeadmCommands which let you run commands before kubeadm init runs. |
| kubeadm.controlPlane.scheduler | object | `{"extraArgs":{},"extraVolumes":{}}` | Configure the scheduler |
| kubeadm.controlPlane.scheduler.extraVolumes | object | `{}` | Configure extraVolumes |
| kubeadm.controlPlane.upgradeAfter | string | `nil` |  |
| kubeadm.controlPlane.useExperimentalRetryJoin | string | `nil` | If true this adds a script for retrying joining. |
| kubeadm.controlPlane.users | list | `[]` | Configure Users on the node |
| kubeadm.controlPlane.verbosity | string | `nil` | Sets the verbosity level |
| kubeadm.workers.md-0.annotations | object | `{}` | Specifies some custom annotations for the KubeadmConfigTemplate CR |
| kubeadm.workers.md-0.files | list | `[]` | Configure Files |
| kubeadm.workers.md-0.joinConfiguration | object | `{"criSocket":null,"kubelet":{"extraArgs":{}},"taints":null}` | Configure joinConfiguration for the worker |
| kubeadm.workers.md-0.joinConfiguration.kubelet.extraArgs | object | `{}` | Configure kubelet flags for the joinConfiguration |
| kubeadm.workers.md-0.labels | object | `{}` | Specifies some custom labels for the KubeadmConfigTemplate CR |
| kubeadm.workers.md-0.postKubeadmCommands | list | `[]` | Set postKubeadmCommands which let you run commands after kubeadm init runs. |
| kubeadm.workers.md-0.preKubeadmCommands | list | `[]` | Set preKubeadmCommands which let you run commands before kubeadm init runs. |
| kubeadm.workers.md-0.useExperimentalRetryJoin | string | `nil` | If true this adds a script for retrying joining. |
| kubeadm.workers.md-0.users | string | `nil` |  |
| kubeadm.workers.md-0.verbosity | string | `nil` | Sets the verbosity level |

