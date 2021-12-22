{{/*
Expand the name of the chart.
*/}}
{{- define "choreo-connect.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "choreo-connect.fullname" -}}
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
{{- define "choreo-connect.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "choreo-connect.labels" -}}
helm.sh/chart: {{ include "choreo-connect.chart" . }}
{{ include "choreo-connect.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "choreo-connect.selectorLabels" -}}
app.kubernetes.io/name: {{ include "choreo-connect.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "choreo-connect.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "choreo-connect.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Subscriptions secret name.
*/}}
{{- define "choreo-connect.subscriptionCredsSecretName" -}}
{{- printf "%s-%s" (include "choreo-connect.fullname" .) "wso2-subscription-creds" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Docker image name.
*/}}
{{- define "image" }}
{{- $imageName := .deployment.imageName }}
{{- $imageTag := .deployment.imageTag | default "" }}
{{- if or (eq .Values.wso2.subscription.username "") (eq .Values.wso2.subscription.password "") -}}
{{- $dockerRegistry := .Values.wso2.deployment.dockerRegistry | default "wso2" }}
image: {{ $dockerRegistry }}/{{ $imageName }}{{- if not (eq $imageTag "") }}{{- printf ":%s" $imageTag -}}{{- end }}
{{- else }}
{{- $dockerRegistry := .Values.wso2.deployment.dockerRegistry | default "docker.wso2.com" }}
{{- $parts := len (split "." $imageTag) }}
{{- if and (eq $parts 3) (eq $dockerRegistry "docker.wso2.com") }}
image: {{ $dockerRegistry }}/{{ $imageName }}{{- if not (eq $imageTag "") }}:{{ $imageTag }}.0{{- end }}
{{- else }}
image: {{ $dockerRegistry }}/{{ $imageName }}{{- if not (eq $imageTag "") }}:{{ $imageTag }}{{- end }}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Volume subPath.
*/}}
{{- define "subPath" }}
{{- if . -}}
subPath: {{ . }}
{{- end -}}
{{- end -}}

{{/*
Adapter
*/}}
{{- define "choreo-connect.adapterFullname" -}}
{{ printf "%s-adapter" (include "choreo-connect.fullname" .) | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end -}}
