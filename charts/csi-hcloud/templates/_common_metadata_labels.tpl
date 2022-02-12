{{- /*
From obsolete Kubernetes Incubator Common chart
https://github.com/helm/charts/blob/master/incubator/common/

common.labelize takes a dict or map and generates labels.

Values will be quoted. Keys will not.

*/ -}}
{{- define "common.labelize" -}}
    {{- range $k, $v := . }}
        {{ $k }}: {{ $v | quote }}
    {{- end -}}
{{- end -}}

{{- /*
common.chartref prints a chart name and version.

It does minimal escaping for use in Kubernetes labels.

*/ -}}
{{- define "common.chartref" -}}
    {{- replace "+" "_" .Chart.Version | printf "%s-%s" .Chart.Name -}}
{{- end -}}

{{- /*
common.labels.standard prints the standard Helm labels.

The standard labels are frequently used in metadata.
*/ -}}
{{- define "common.labels.standard" -}}
app: {{ template "common.name" . }}
app.kubernetes.io/name: {{ template "common.name" . }}
helm.sh/chart: {{ template "common.chartref" . }}
app.kubernetes.io/managed-by: {{ .Release.Service | quote }}
release: {{ .Release.Name | quote }}
app.kubernetes.io/instance: {{ .Release.Name | quote }}
{{- if .Values.common.labels.standard }}
{{ toYaml .Values.common.labels.standard }}
{{- end }}
{{- end -}}

{{- /* The standard labels are frequently used in metadata.
*/ -}}
{{- define "common.labels.selector" -}}
{{- if .Values.common.labels.selector }}
{{- toYaml .Values.common.labels.selector }}
{{- end }}
{{- end -}}
