
{{- define "monochart.containers.template" -}}
{{- $root := first . -}}
{{- $part := index . 1 -}}
{{- $pod := last . -}}

{{- range $key, $val := $part }}
{{- if $val }}
- name: {{ if hasKey $val "name" }}{{ $val.name }}{{ else }}{{ $root.Release.Name }}{{ end }}
  image: {{ required "image.repository is required!" $val.repository }}:{{ required "image.tag is required!" $val.tag }}
{{- include "monochart.env" (list $root $val ) | indent 2 }}
    {{- if $val.env }}
    {{- with $val.env }}
    {{- range $name, $value := $val.env }}
    - name: {{ $name }}
      value: {{ default "" $value | quote }}
    {{- end }}
    {{- end }}
    {{- end }}
{{- if hasKey $val "command" }}
{{- with $val.command }}
  command:
{{ toYaml . | indent 4 }}
{{- end }}
{{- end }}
{{- if hasKey $val "args" }}
{{- with $val.args }}
  args:
{{ toYaml . | indent 4 }}
{{- end }}
{{- end }}
{{- if hasKey $val "pullPolicy" }}
  imagePullPolicy: {{ $val.pullPolicy }}
{{- end }}
{{- if hasKey $val "securityContext" }}
{{- with $val.securityContext }}
  securityContext:
{{ toYaml . | indent 2 }}
{{- end }}
{{- end }}
{{- if or $root.Values.persistence.enabled | or $root.Values.configMaps | or $root.Values.secrets  }}
  volumeMounts:
  - mountPath: {{ $root.Values.persistence.mountPath | quote }}
    name: storage
{{- include "monochart.files.volumeMounts" $root | indent 2 }}
{{- end }}
{{- if hasKey $val "resources" }}
{{- with $val.resources }}
  resources:
{{ toYaml . | indent 4 }}
{{- end -}}
{{- end }}
{{- if eq $pod "pod" }}
  ports:
{{- range $name, $port := $root.Values.service.ports }}
{{- if $port }}
  - name: {{ $name }}
    containerPort: {{ $port.internal }}
    protocol: {{ default "TCP" $port.protocol  }}
{{- end -}}
{{- end -}}
{{- if hasKey $val "probes" }}
{{- with $val.probes }}
{{ toYaml . | indent 2 }}
{{- end -}}
{{- end -}}
{{- end -}}
{{- end }} 
{{- end }} 
{{- end }}


{{- define "monochart.containers.job" -}}
{{ $root := first . -}}
{{ $part := last . -}}
containers:
{{- if hasKey $root.Values.common "containers" }}
{{- include "monochart.containers.template" (list $root $root.Values.common.containers "" ) }}
{{- end }}
{{- if hasKey $part "containers" }}
{{- include "monochart.containers.template" (list $root $part.containers "" ) }}
{{- end }}
{{- end -}}

{{/*
 ex.: https://kubernetes.io/docs/concepts/workloads/pods/init-containers/
*/}}
{{- define "monochart.containers.init" -}}
{{ $root := first . -}}
{{ $part := last . -}}
initContainers:
{{- if hasKey $root.Values.common "initContainers" }}
{{- include "monochart.containers.template" (list $root $root.Values.common.initContainers "" ) }}
{{- end }}
{{- if hasKey $part "initContainers" }}
{{- include "monochart.containers.template" (list $root $part.initContainers "" ) }}
{{- end }}
{{- end -}}



{{- define "monochart.containers.pod" -}}
{{ $root := first . -}}
{{ $part := last . -}}
containers:
{{- if hasKey $root.Values.common "containers" }}
{{- include "monochart.containers.template" (list $root $root.Values.common.containers "pod" ) }}
{{- end }}
{{- if hasKey $part "containers" }}
{{- include "monochart.containers.template" (list $root $part.containers "pod" ) }}
{{- end }}
{{- end -}}

