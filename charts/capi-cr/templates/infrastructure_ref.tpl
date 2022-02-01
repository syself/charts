
{{- define "infrastructureRef.cluster" -}}
{{- $part := first . -}}
{{- $root := last . -}}
apiVersion: infrastructure.cluster.x-k8s.io/v1beta1
{{- if eq "hetzner" (lower $part.infrastructureRef ) }}
kind: HetznerCluster
name: {{ include "common.fullname" $root }}
{{- else -}}
{{required "Please specify a infrastrucutreRef - supported values are: hetzner" nil }}
{{- end }}
{{- end -}}

{{/*
Common deployment template for machineTemplate
@param .cluster   The cluster scope
@param .name      The Key of a passed range representing the name

*/}}
{{- define "infrastructureRef.machineTemplate" -}}
{{- if empty .cluster.controlPlane.type -}}
{{ required "controlPlane.type could not be empty" nil}}
{{- end -}}
{{- if eq "hetzner" (lower .cluster.infrastructureRef) -}}
{{- if eq "hcloud" (lower .cluster.controlPlane.type) -}}
{{- $mt := "" -}}
{{- if eq "control-plane" (lower .name) -}}
{{- $mt = .root.Values.hetzner.hcloud.controlPlane  -}}
{{- else -}}
{{- $mt = (pluck .name .root.Values.hetzner.hcloud.workers | first  ) -}}
{{- end -}}
{{- if not (empty $mt) -}}
apiVersion: infrastructure.cluster.x-k8s.io/v1beta1
kind: HCloudMachineTemplate
name: {{ include "common.fullname" .root }}-{{ .name }}-{{ include "HCloudMachineTemplateSpec" (list .root.Values.hetzner.cluster $mt) | sha256sum | trunc -5 }}
{{- else -}}
{{- if eq "control-plane" (lower .name) -}}
{{required (printf "Please specify a HCloudMachineTemplate under hetzner.hcloud.controlPlane" ) nil }}
{{- else -}}
{{required (printf "Please specify a HCloudMachineTemplate under hetzner.hcloud.workers.%s " .name ) nil }}
{{- end }}
{{- end }}
{{- end }}
{{- else }}
{{required "Please specify a infrastrucutreRef - supported values are: hetzner" nil }}
{{- end }}
{{- end -}}
