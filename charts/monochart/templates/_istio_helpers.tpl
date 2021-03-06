{{/*
Template for https://istio.io/latest/docs/reference/config/networking/gateway/
*/}}

{{- define "monochart.istio.gateway.servers" -}}
{{- $root := first . }}
{{- range $item := last . }}
- port: 
    number: {{ .port.number }}
    name: {{ .port.name | quote }}
    protocol: {{ default "HTTP" .port.protocol }}
  hosts:
{{ toYaml .hosts | indent 2 }}
{{- if not ( empty .tls ) }}
  tls:
{{ toYaml .tls | indent 4 }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Template for https://istio.io/docs/reference/config/networking/v1alpha3/virtual-service/#HTTPRoute
*/}}
{{- define "monochart.istio.virtualService.httpRoute" -}}
{{- $root := first . }}
{{- range $item := last . }}
- name: {{ .name | quote }}

{{- if not ( empty .match ) }}
  match:
{{ toYaml .match | indent 2 }}
{{- end }}

{{- if not ( empty .route ) }}
  route:
{{- include "monochart.istio.virtualService.route" ( list $root .route ) | indent 2 }}
{{- end }}

{{- if not ( empty .redirect ) }}
  redirect:
{{ toYaml .redirect | indent 4 }}
{{- end }}

{{- if not ( empty .rewrite ) }}
  rewrite:
{{ toYaml .rewrite | indent 4 }}
{{- end }}

{{- if not ( empty .timeout ) }}
  timeout:
{{ toYaml .timeout | indent 4 }}
{{- end }}

{{- if not ( empty .retries ) }}
  retries:
{{ toYaml .retries | indent 4 }}
{{- end }}

{{- if not ( empty .fault ) }}
  fault:
{{ toYaml .fault | indent 4 }}
{{- end }}

{{- if not ( empty .mirror ) }}
  mirror:
{{ toYaml .mirror | indent 4 }}
{{- end }}

{{- if not ( empty .corsPolicy ) }}
  corsPolicy:
{{ toYaml .corsPolicy | indent 4 }}
{{- end }}

{{- if not ( empty .headers ) }}
  headers:
{{ toYaml .headers | indent 4 }}
{{- end }}

{{- end }}

{{- end -}}

{{/*
Template for https://istio.io/docs/reference/config/networking/v1alpha3/virtual-service/#HTTPRouteDestination
*/}}
{{- define "monochart.istio.virtualService.route" -}}
{{- $root := first . }}
{{- range $item := last . }}
- weight: {{ $item.weight | default 100 }}
{{- include "monochart.istio.virtualService.destination" ( list $root $item ) | indent 2 }}
{{- $additional := omit $item "destination" "weight"}}
{{- if not ( empty $additional ) }}
{{ toYaml $additional | indent 2 }}
{{- end }}
{{- end }}
{{- end -}}

{{/*
Template for https://istio.io/docs/reference/config/networking/v1alpha3/virtual-service/#Destination
*/}}
{{- define "monochart.istio.virtualService.destination" -}}
{{- $root := first . }}
{{- $serviceName := include "common.fullname" $root -}}
{{- $item := last . }}
{{- $destination := hasKey $item "destination" |  ternary  $item.destination (dict) }}
destination:
  host: {{ empty $destination.host | ternary $serviceName $destination.host }}
{{- if not ( empty $destination.subset ) }}
  subset: {{ $destination.subset | quote }}
{{- end }}
{{- if not ( empty $destination.port ) }}
  port:
{{- include "monochart.istio.virtualService.destination.port" ( list $root $destination.port ) | indent 4 }}
{{- end }}
{{- end -}}

{{/*
Template for https://istio.io/docs/reference/config/networking/v1alpha3/virtual-service/#PortSelector
if port defined with name, get the port number from .Values.services
*/}}
{{- define "monochart.istio.virtualService.destination.port" -}}
{{- $root := first . }}
{{- $item := last . }}
{{- if kindIs "string" $item }}
number: {{ (index $root.Values.service.ports $item).external }}
{{- else }}
{{ toYaml $item }}
{{- end }}
{{- end -}}

{{/*
Template for any routes.
 ex.: https://istio.io/docs/reference/config/networking/v1alpha3/virtual-service/#TCPRoute
 ex.: https://istio.io/docs/reference/config/networking/v1alpha3/virtual-service/#TLSRoute
*/}}
{{- define "monochart.istio.virtualService.Xroute" -}}
{{- $root := first . }}
{{- range $item := last . }}
{{- if not ( empty $item.match ) }}
- match:
{{ toYaml $item.match | indent 2 }}
{{- end -}}
{{- if not ( empty .route ) }}
  route:
{{- include "monochart.istio.virtualService.route" ( list $root .route ) | indent 2 }}
{{- end }}
{{- end }}
{{- end -}}


{{/*
 ex.: https://istio.io/latest/docs/reference/config/networking/destination-rule/
*/}}
{{- define "monochart.istio.destinationRule.trafficPolicy" -}}
{{- $root := first . }}
{{- $item := last . }}

{{- if not ( empty $item.loadBalancer ) }}
loadBalancer:
{{ toYaml $item.loadBalancer | indent 2 }}
{{- end }}

{{- if not ( empty $item.connectionPool ) }}
connectionPool:
{{ toYaml $item.connectionPool | indent 2 }}
{{- end }}

{{- if not ( empty $item.outlierDetection ) }}
outlierDetection:
{{ toYaml $item.outlierDetection | indent 2 }}
{{- end }}

{{- if not ( empty $item.tls ) }}
tls:
{{ toYaml $item.tls | indent 2 }}
{{- end }}

{{- if not ( empty $item.portLevelSettings ) }}
portLevelSettings:
  {{ toYaml $item.portLevelSettings | indent 2 }}
{{- end }}

{{- end }}

{{/*
 ex.: https://istio.io/latest/docs/reference/config/networking/destination-rule/
*/}}
{{- define "monochart.istio.destinationRule.subsets" -}}
{{- $root := first . }}
{{- range $item := last . }}
- name: {{ .name | quote }}

{{- if not ( empty .labels ) }}
  labels:
{{ toYaml .labels | indent 4 }}
{{- end }}

{{- if not ( empty .trafficPolicy ) }}
  trafficPolicy:
{{- include "monochart.istio.destinationRule.trafficPolicy" ( list $root .trafficPolicy ) | indent 4 }}
{{- end }}

{{- end }}
{{- end -}}

