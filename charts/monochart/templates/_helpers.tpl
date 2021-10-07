{{/*
Fullname of configMap/secret that contains files
*/}}
{{- define "monochart.files.fullname" -}}
{{- $root := index . 0 -}}
{{- $postfix := index . 1 -}}
{{- printf "%s-%s-%s" (include "common.fullname" $root) "files" $postfix -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "monochart.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "common.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Volumes template block for deployable resources
*/}}
{{- define "monochart.files.volumes" -}}
{{- $root := . -}}
{{- range $name, $config := $root.Values.configMaps -}}
{{- if $config.enabled -}}
{{- if not ( empty $config.files ) }}
- name: config-{{ $name }}-files
  configMap:
    name: {{ include "monochart.files.fullname" (list $root $name) }}
{{- end -}}
{{- end -}}
{{- end -}}
{{- range $name, $secret := $root.Values.secrets -}}
{{- if $secret.enabled }}
{{- if not ( empty $secret.files ) }}
- name: secret-{{ $name }}-files
  secret:
    secretName: {{ include "monochart.files.fullname" (list $root $name) }}
{{- end -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
VolumeMounts template block for deployable resources
*/}}
{{- define "monochart.files.volumeMounts" -}}
{{- range $name, $config := .Values.configMaps -}}
{{- if $config.enabled }}
{{- if not ( empty $config.files ) }}
- mountPath: {{ default (printf "/%s" $name) $config.mountPath }}
  name: config-{{ $name }}-files
{{- end }}
{{- end }}
{{- end -}}
{{- range $name, $secret := .Values.secrets -}}
{{- if $secret.enabled }}
{{- if not ( empty $secret.files ) }}
- mountPath: {{ default (printf "/%s" $name) $secret.mountPath }}
  name: secret-{{ $name }}-files
  readOnly: true
{{- end -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
The pod anti-affinity rule to prefer not to be scheduled onto a node if that node is already running a pod with same app
*/}}
{{- define "monochart.affinityRule.ShouldBeOnDifferentNode" -}}
- weight: 100
  podAffinityTerm:
    labelSelector:
      matchExpressions:
      - key: app
        operator: In
        values:
        - {{ include "common.name" . }}
      - key: release
        operator: In
        values:
        - {{ .Release.Name | quote }}
    topologyKey: "kubernetes.io/hostname"
{{- end -}}

# https://helm.sh/docs/howto/charts_tips_and_tricks/#creating-image-pull-secrets
{{- define "monochart.imagePullSecret.generate" }}
{{- printf "{\"auths\": {\"%s\": {\"auth\": \"%s\"}}}" .Values.regcred.image.pullSecret.registry (printf "%s:%s" .Values.regcred.image.pullSecret.username .Values.regcred.image.pullSecret.password | b64enc) | b64enc }}
{{- end }}


# https://helm.sh/docs/howto/charts_tips_and_tricks/#creating-image-pull-secrets
{{- define "monochart.imagePullSecret" }}
{{- $root := . -}}
{{- $path := first . -}}
{{- $part := last . -}}
{{- if or ($path.Values.regcred.enabled) ( not (empty ($path.Values.common.pod.pullSecrets))) ( not (empty (dig "pod" "pullSecrets" "" $part ))) }}
imagePullSecrets:
{{- if $path.Values.regcred.enabled }}
- name: regcred-{{ include "common.fullname" $path }}
{{- end }}
{{- if not (empty (dig "pod" "pullSecrets" "" $part )) }}
{{- with $part.pod.pullSecrets }}
{{- range . }}
- name: {{ . }}
{{- end }}
{{- end }}
{{- end }}
{{- if not (empty $path.Values.common.pod.pullSecrets) }}
{{- with $path.Values.common.pod.pullSecrets }}
{{- range . }}
- name: {{ . }}
{{- end }}
{{- end -}}
{{- end -}}
{{- end }}
{{- end }}