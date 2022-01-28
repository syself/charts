{{- /*
fullname defines a name for a resource by using the release name. This could be extended by using several parameters.

The prevailing wisdom is that names should only contain a-z, 0-9 plus dot (.) and dash (-), and should
not exceed 63 characters.

Parameters:

- .Values.fullnameOverride: Replaces the computed name with this given name
- .Values.fullnamePrefix: Prefix
- .Values.global.fullnamePrefix: Global prefix
- .Values.fullnameSuffix: Suffix
- .Values.global.fullnameSuffix: Global suffix

The applied order is: "global prefix + prefix + name + suffix + global suffix"

Usage: 'name: "{{- template "common.fullname" . -}}"'
*/ -}}
{{- define "common.fullname"}}
    {{- $global := default (dict) .Values.global -}}
    {{- $base := default .Release.Name .Values.fullnameOverride -}}
    {{- $gpre := default "" $global.fullnamePrefix -}}
    {{- $pre := default "" .Values.fullnamePrefix -}}
    {{- $suf := default "" .Values.fullnameSuffix -}}
    {{- $gsuf := default "" $global.fullnameSuffix -}}
    {{- $name := print $gpre $pre $base $suf $gsuf -}}
    {{- $name | lower | trunc 54 | trimSuffix "-" -}}
{{- end -}}
