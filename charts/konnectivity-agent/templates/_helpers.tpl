{{/*
Expand the name of the chart.
*/}}
{{- define "konnectivity-agent.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "konnectivity-agent.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "konnectivity-agent.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "konnectivity-agent.labels" -}}
helm.sh/chart: {{ include "konnectivity-agent.chart" . }}
{{ include "konnectivity-agent.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
addonmanager.kubernetes.io/mode: Reconcile
{{- end }}

{{/*
Common labels for server
*/}}
{{- define "konnectivity-server.labels" -}}
helm.sh/chart: {{ include "konnectivity-agent.chart" . }}
{{ include "konnectivity-server.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
addonmanager.kubernetes.io/mode: Reconcile
{{- end }}


{{/*
Selector labels for server
*/}}
{{- define "konnectivity-server.selectorLabels" -}}
app.kubernetes.io/name: konnectivity-server
app.kubernetes.io/instance: konnectivity-server
k8s-app: konnectivity-agent
{{- end }}

{{/*
Selector labels
*/}}
{{- define "konnectivity-agent.selectorLabels" -}}
app.kubernetes.io/name: {{ include "konnectivity-agent.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
k8s-app: konnectivity-agent
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "konnectivity-agent.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "konnectivity-agent.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}
