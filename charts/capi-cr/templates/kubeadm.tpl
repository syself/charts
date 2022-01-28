{{- define "kubeadm.controlPlaneRef.kubeadmControlPlane" -}}
{{- $part := first . -}}
{{- if eq "kubeadm" (lower $part.controlPlaneRef) -}}
apiVersion: controlplane.cluster.x-k8s.io/v1beta1
kind: KubeadmControlPlane
name: {{ $part.name }}-control-plane
{{- else -}}
{{required "Please specify a controlPlaneRef - supported values are: kubeadm" nil }}
{{- end }}
{{- end -}}


{{- define "kubeadm.kubeadmConfigTemplate" -}}
{{- if not (empty (dig "controlPlaneRef" "" .cluster)) -}}
{{- if eq "kubeadm" (lower .cluster.controlPlaneRef) -}}
{{- $kct := (pluck .name .root.Values.kubeadm.workers | first  ) -}}
{{- if not (empty $kct) -}}
apiVersion: bootstrap.cluster.x-k8s.io/v1beta1
kind: KubeadmConfigTemplate
name: {{ .cluster.name }}-{{ .name }}-{{ include "KubeadmConfigTemplateSpec" (list $kct) | sha256sum | trunc -5 }}
{{- else -}}
{{required (printf "Please specify a KubeadmConfigTemplate under kubeadm.workers.%s " .name ) nil }}
{{- end }}
{{- end -}}
{{- else -}}
{{required "Please specify a controlPlaneRef - supported values are: kubeadm" nil }}
{{- end }}
{{- end -}}


{{- define "kubeadm.cloud-init.basic" -}}
{{- $part := first . -}}
{{- if hasKey $part "files" -}}
{{- with $part.files -}}
files:
  {{- toYaml . | nindent 0 }}
{{- end }}
{{- end }}
{{- if hasKey $part "users" }}
{{- with $part.users }}
users:
  {{- toYaml . | nindent 0 }}
{{- end }}
{{- end }}
{{- if hasKey $part "preKubeadmCommands" }}
{{- with $part.preKubeadmCommands }}
preKubeadmCommands:
  {{- toYaml . | nindent 0 }}
{{- end }}
{{- end }}
{{- if hasKey $part "postKubeadmCommands" }}
{{- with $part.postKubeadmCommands }}
postKubeadmCommands:
  {{- toYaml . | nindent 0 }}
{{- end }}
{{- end }}
{{- if hasKey $part "useExperimentalRetryJoin" }}
useExperimentalRetryJoin: {{ $part.useExperimentalRetryJoin | default "false" }}
{{- end }}
{{- if hasKey $part "verbosity" }}
verbosity: {{ $part.verbosity }}
{{- end }}
{{- end -}}


{{- define "kubeadm.cloud-init.nodeRegistration" }}
{{- $path := first . -}}
nodeRegistration:
  {{- if hasKey $path "criSocket" }}
  criSocket: {{ $path.criSocket }}
  {{- end }}
  {{- if hasKey $path "taints" }}
  {{- with $path.taints}}
  taints:
  {{- toYaml . | nindent 2}}
  {{- end }}
  {{- end }}
  kubeletExtraArgs:
  {{- with $path.kubelet.extraArgs }}
    {{- toYaml . | nindent 4 }}
  {{- end }}
{{- end }}