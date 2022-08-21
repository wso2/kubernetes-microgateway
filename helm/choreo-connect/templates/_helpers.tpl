{{/*
Copyright (c) 2022, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at
http://www.apache.org/licenses/LICENSE-2.0
Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/}}

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
{{- if .Values.kubernetes.serviceAccount.create }}
{{- default (include "choreo-connect.fullname" .) .Values.kubernetes.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.kubernetes.serviceAccount.name }}
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
{{- $componentLevelDockerRegistry := .deployment.dockerRegistry }}
{{- $imageName := .deployment.imageName }}
{{- $imageTag := .deployment.imageTag | default "" }}
{{- if or (eq .Values.wso2.subscription.username "") (eq .Values.wso2.subscription.password "") -}}
{{- $dockerRegistry := $componentLevelDockerRegistry | default .Values.wso2.deployment.dockerRegistry | default "wso2" }}
image: {{ $dockerRegistry }}/{{ $imageName }}{{- if not (eq $imageTag "") }}{{- printf ":%s" $imageTag -}}{{- end }}
{{- else }}
{{- $dockerRegistry := $componentLevelDockerRegistry | default .Values.wso2.deployment.dockerRegistry | default "docker.wso2.com" }}
{{- $parts := len (split "." $imageTag) }}
{{- if and (eq $parts 3) (eq $dockerRegistry "docker.wso2.com") }}
image: {{ $dockerRegistry }}/{{ $imageName }}{{- if not (eq $imageTag "") }}:{{ $imageTag }}.0{{- end }}
{{- else }}
image: {{ $dockerRegistry }}/{{ $imageName }}{{- if not (eq $imageTag "") }}:{{ $imageTag }}{{- end }}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Truststore Secret Volume Names
*/}}
{{- define "choreo-connect.deployment.secretVolumeName" -}}
{{ (regexReplaceAll "\\W+" (printf "%s-%s-%s" .prefix .secret.secretName .secret.subPath | lower | trunc 63 ) "-" ) | trimSuffix "-"}}
{{- end -}}

{{/*
Truststore Secret Volumes Mounts
*/}}
{{- define "choreo-connect.deployment.truststore.volumes" -}}
{{- range .truststore -}}
{{- if . -}}
{{- /* Didn't used "nindent" when using this template, that makes new lines, hence do the indentation here */}}
        - name: {{ include "choreo-connect.deployment.secretVolumeName" (dict "prefix" $.prefix "secret" .) }}
          secret:
            secretName: {{ .secretName }}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Truststore Secret Volume Mounts
*/}}
{{- define "choreo-connect.deployment.truststore.mounts" -}}
{{- range .truststore -}}
{{- if . -}}
{{- /* Didn't used "nindent" when using this template, that makes new lines, hence do the indentation here */ -}}
{{- /* Appended '.pem' since there can be file extension check inside the component */}}
            - mountPath: /home/wso2/security/truststore{{ if .subPath  }}{{ printf "/%s-%s.pem" .secretName (.subPath | replace "." "-") }}{{- end }}
              name: {{ include "choreo-connect.deployment.secretVolumeName" (dict "prefix" $.prefix "secret" .) }}
              readOnly: true
              subPath: {{ .subPath | quote }}
{{- end -}}
{{- end -}}
{{- end -}}



{{/*
Deployment Mode
*/}}
{{- define "choreo-connect.deploymentMode.isStandalone" -}}
{{- if eq (upper .Values.wso2.deployment.mode) "STANDALONE" -}}
True
{{- end -}}
{{- end -}}

{{/*
Adapter
*/}}
{{- define "choreo-connect.adapterFullname" -}}
{{ printf "%s-adapter" (include "choreo-connect.fullname" .) | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end -}}

{{/*
Enforcer
*/}}
{{- define "choreo-connect.enforcerFullname" -}}
{{ printf "%s-enforcer" (include "choreo-connect.fullname" .) | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end -}}

{{/*
Router
*/}}
{{- define "choreo-connect.routerFullname" -}}
{{ printf "%s-router" (include "choreo-connect.fullname" .) | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end -}}
