{{/*
Fullname of configMap/secret that contains environment vaiables
*/}}
{{- define "monochart.env.fullname" -}}
{{- $root := index . 0 -}}
{{- $postfix := index . 1 -}}
{{- printf "%s-%s-%s" (include "common.fullname" $root) "env" $postfix -}}
{{- end -}}


{{/*
Environments
*/}}
{{- define "monochart.env" -}}
{{- $root := . -}}
{{- $path := index . 0 -}}
{{- $part := index . 1 -}}
{{- if $path.Values.configMaps | or $path.Values.secrets | or $path.Values.common.envFrom | or $part.configMaps | or $part.secrets | or $part.envFrom }}
envFrom:
{{- range $name, $config := $path.Values.configMaps -}}
{{- if $config.enabled }}
{{- if not ( empty $config.env ) }}
- configMapRef:
    name: {{ include "monochart.env.fullname" (list $path $name) }}
{{- end }}
{{- end }}
{{- end }}

{{- range $name, $secret := $path.Values.secrets -}}
{{- if $secret.enabled }}
{{- if not ( empty $secret.env ) }}
- secretRef:
    name: {{ include "monochart.env.fullname" (list $path $name) }}
{{- end }}
{{- end }}
{{- end }}
{{- range $name, $secret := $part.secrets -}}
{{- if $secret.enabled }}
{{- if not ( empty $secret.env ) }}
- secretRef:
    name: {{ include "monochart.env.fullname" (list $path $name) }}
{{- end }}
{{- end }}
{{- end }}
{{- if $path.Values.common.envFrom }}
{{- with $path.Values.common.envFrom }}
{{- range $name := .configMaps }}
- configMapRef:
    name: {{ $name }}
{{- end }}
{{- range $name := .secrets }}
- secretRef:
    name: {{ $name }}
{{- end }}
{{- end }}
{{- end -}}
{{- if $part.envFrom }}
{{- with $part.envFrom }}
{{- range $name := .configMaps }}
- configMapRef:
    name: {{ $name }}
{{- end }}
{{- range $name := .secrets }}
- secretRef:
    name: {{ $name }}
{{- end -}}
{{- end -}}
{{- end -}}
{{- end -}}
{{- if or $path.Values.common.env | or $part.env | or $path.Values.common.envFromFieldRefFieldPath | or $part.envFromFieldRefFieldPath}}
env:
{{- with $path.Values.common.env }}
{{- range $name, $value := . }}
  - name: {{ $name }}
    value: {{ default "" $value | quote }}
{{- end }}
{{- end -}}
{{- with $part.env }}
{{- range $name, $value := . }}
  - name: {{ $name }}
    value: {{ default "" $value | quote }}
{{- end -}}
{{- end -}}

{{/*
https://kubernetes.io/docs/tasks/inject-data-application/environment-variable-expose-pod-information/#use-pod-fields-as-values-for-environment-variables
*/}}
{{- with $path.Values.common.envFromFieldRefFieldPath }}
{{- range $name, $value := . }}
  - name: {{ $name }}
    valueFrom:
      fieldRef:
        fieldPath: {{ $value }}
{{- end -}}
{{- end -}}
{{- with $part.envFromFieldRefFieldPath }}
{{- range $name, $value := . }}
  - name: {{ $name }}
    valueFrom:
      fieldRef:
        fieldPath: {{ $value }}
{{- end -}}
{{- end -}}
{{/*
https://kubernetes.io/docs/concepts/configuration/secret/#using-secrets-as-environment-variables
*/}}
{{- with $path.Values.common.envFromSecretKeyRef }}
{{- range $data := . }}
  - name: {{ $data.name }}
    valueFrom:
      secretKeyRef:
        name: {{ $data.secret }}
        key: {{ $data.key }}
{{- end }}
{{- end }}
{{- with $part.envFromSecretKeyRef }}
{{- range $data := . }}
  - name: {{ $data.name }}
    valueFrom:
      secretKeyRef:
        name: {{ $data.secret }}
        key: {{ $data.key }}
{{- end }}
{{- end }}
{{- end -}}
{{- end -}}