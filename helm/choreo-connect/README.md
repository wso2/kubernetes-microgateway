# Helm Chart for deployment of Choreo Connect

## Contents

* [Prerequisites](#prerequisites)
* [Quick Start Guide](#quick-start-guide)
* [Configuration](#configuration)

## Prerequisites

* WSO2 product Docker images used for the Kubernetes deployment.
  
  WSO2 product Docker images available at [DockerHub](https://hub.docker.com/u/wso2/) package General Availability (GA)
  versions of WSO2 products with no [WSO2 Updates](https://wso2.com/updates).

  For a production grade deployment of the desired WSO2 product-version, it is highly recommended to use the relevant
  Docker image which packages WSO2 Updates, available at [WSO2 Private Docker Registry](https://docker.wso2.com/). In order
  to use these images, you need an active [WSO2 Subscription](https://wso2.com/subscription).
  <br><br>

* Install [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git), [Helm](https://helm.sh/docs/intro/install/)
  and [Kubernetes client](https://kubernetes.io/docs/tasks/tools/install-kubectl/) in order to run the steps provided in the
  following quick start guide.<br><br>

* An already setup [Kubernetes cluster](https://kubernetes.io/docs/setup).<br>
  Minimum CPU: 4vCPU<br>
  Minimum Memory: 4GB<br><br>

* Install [NGINX Ingress Controller](https://kubernetes.github.io/ingress-nginx/deploy/).<br><br>

* Add the WSO2 Helm chart repository.

    ```
     helm repo add wso2 https://helm.wso2.com && helm repo update
    ```

## Quick Start Guide

### 1. Install the Helm Chart

You can install the relevant Helm chart either from [WSO2 Helm Chart Repository](https://hub.helm.sh/charts/wso2) or by source.

**Note:**

* `NAMESPACE` should be the Kubernetes Namespace in which the resources are deployed.

#### 1.1. Install Chart From [WSO2 Helm Chart Repository](https://hub.helm.sh/charts/wso2)

  Helm version 2
  
  ```
  helm install --name <RELEASE_NAME> wso2/choreo-connect --version 1.1.0-6 --namespace <NAMESPACE>
  ```
  
  Helm version 3

  ```
  helm install <RELEASE_NAME> wso2/choreo-connect --version 1.1.0-6 --namespace <NAMESPACE> --create-namespace
  ```

The above steps will deploy the Choreo Connect using WSO2 product Docker images available at DockerHub.

If you are using WSO2 product Docker images available from WSO2 Private Docker Registry,
please provide your WSO2 Subscription credentials via input values (using `--set` argument). 

Please see the following example.

```
 helm install --name <RELEASE_NAME> wso2/choreo-connect --version 1.1.0-6 --namespace <NAMESPACE> \
  --set wso2.subscription.username=<SUBSCRIPTION_USERNAME> \
  --set wso2.subscription.password=<SUBSCRIPTION_PASSWORD>
```

#### 1.2. Install Chart From Source

>In the context of this document, <br>
>* `KUBERNETES_HOME` will refer to a local copy of the [`wso2/kubernetes-microgateway`](https://github.com/wso2/kubernetes-microgateway/)
Git repository. <br>
>* `HELM_HOME` will refer to `<KUBERNETES_HOME>/helm/choreo-connect`. <br>

##### 1. Clone the Kubernetes Resources for WSO2 Choreo Connect Git repository.

```
git clone https://github.com/wso2/kubernetes-microgateway.git
```

##### 2. Deploy Helm chart for Choreo Connect deployment.

 Helm version 2

 ```
 helm install --name <RELEASE_NAME> <HELM_HOME>/choreo-connect --namespace <NAMESPACE>
 ```

 Helm version 3

```
helm install <RELEASE_NAME> <HELM_HOME>/choreo-connect --namespace <NAMESPACE> --create-namespace
```

The above steps will deploy the deployment pattern using WSO2 product Docker images available at DockerHub.

If you are using WSO2 product Docker images available from WSO2 Private Docker Registry,
please provide your WSO2 Subscription credentials via input values (using `--set` argument). 

Please see the following example.

```
 helm install --name <RELEASE_NAME> <HELM_HOME>/choreo-connect --namespace <NAMESPACE> --set wso2.subscription.username=<SUBSCRIPTION_USERNAME> --set wso2.subscription.password=<SUBSCRIPTION_PASSWORD>
```

### 2. Deployment Mode (Deployment Options)

There are two types of deployment options namely,
- WSO2 API Manager as a Control Plane
- Standalone Gateway

For more information, please refer [Choreo Connect Deployment Options](https://apim.docs.wso2.com/en/4.1.0/deploy-and-publish/deploy-on-gateway/choreo-connect/getting-started/deploy/cc-deploy-overview/)

#### 2.1. Standalone Mode (Default)

The following example shows how to deploy Choreo Connect with "Standalone" deployment mode. This is the default mode,
hence if you have not specified `wso2.deployment.mode` "Standalone" deployment mode is applied.

Helm v2

```
helm install --name <RELEASE_NAME> wso2/choreo-connect --version 1.1.0-6 --namespace <NAMESPACE> \
  --set wso2.deployment.mode=STANDALONE
```

Helm v3

```
helm install <RELEASE_NAME> wso2/choreo-connect --version 1.1.0-6 --namespace <NAMESPACE> --create-namespace
  --set wso2.deployment.mode=STANDALONE
```

#### 2.2. WSO2 API Manager as a Control Plane

The following deployment option require a Kubernetes cluster with following resources.

* An already setup [Kubernetes cluster](https://kubernetes.io/docs/setup).<br>
  Minimum CPU: 8vCPU<br>
  Minimum Memory: 8GB<br>

##### Setup 1: Deploy WSO2 API Manager

Add the WSO2 Helm chart repository.
```
 helm repo add wso2 https://helm.wso2.com && helm repo update
```

Helm version 2

```
helm install --name apim-as-cp wso2/am-single-node --version 4.1.0-1 --namespace apim \
  --set wso2.deployment.am.ingress.gateway.hostname=gw.wso2.com \
  --set wso2.deployment.am.ingress.gateway.enabled=false \
  --set-file wso2.deployment.am.config."deployment\.toml"=https://raw.githubusercontent.com/wso2/kubernetes-microgateway/v1.1.0.6/resources/controlplane-deployment.toml
```

Helm version 3

```
helm install apim-as-cp wso2/am-single-node --version 4.1.0-1 --namespace apim --create-namespace \
  --set wso2.deployment.am.ingress.gateway.hostname=gw.wso2.com \
  --set wso2.deployment.am.ingress.gateway.enabled=false \
  --set-file wso2.deployment.am.config."deployment\.toml"=https://raw.githubusercontent.com/wso2/kubernetes-microgateway/v1.1.0.6/resources/controlplane-deployment.toml
```

NOTE: If you do not have sufficient resources you can adjust them setting following values when installing the chart.
```
--set wso2.deployment.am.resources.requests.memory=2Gi \
--set wso2.deployment.am.resources.requests.cpu=1000m \
--set wso2.deployment.am.resources.limits.memory=2Gi \
--set wso2.deployment.am.resources.limits.cpu=1000m
```


The above steps will deploy the deployment pattern using WSO2 product Docker images available at DockerHub, in the namespace `apim`,
with the service name `wso2am-single-node-am-service` and with the hostname `am.wso2.com`.

Obtain the external IP (`EXTERNAL-IP`) of the API Manager Publisher-DevPortal Ingress resource.
```
kubectl get ing -n apim wso2am-single-node-am-ingress
```

Add a DNS record mapping the hostnames and the external IP.

If the defined hostnames (in the previous step) are backed by a DNS service, add a DNS record mapping the hostnames and
the external IP (`EXTERNAL-IP`) in the relevant DNS service.

If the defined hostnames are not backed by a DNS service, for the purpose of evaluation you may add an entry mapping the
hostnames and the external IP in the `/etc/hosts` file at the client-side.

```
<EXTERNAL-IP>  am.wso2.com
```

For more information on installing WSO2 API Manager, refer the repository [wso2/kubernetes-apim](https://github.com/wso2/kubernetes-apim)

##### Setup 2: Deploy Choreo Connect
The following example shows how to deploy Choreo Connect with "WSO2 API Manager as a Control Plane" deployment mode.

Helm v2

```
helm install --name <RELEASE_NAME> wso2/choreo-connect --version 1.1.0-6 --namespace <NAMESPACE> \
  --set wso2.deployment.mode=APIM_AS_CP \
  --set wso2.apim.controlPlane.hostName=am.wso2.com \
  --set wso2.apim.controlPlane.serviceName=wso2am-single-node-am-service.apim
```

Helm v3

```
helm install <RELEASE_NAME> wso2/choreo-connect --version 1.1.0-6 --namespace <NAMESPACE> --create-namespace \
  --set wso2.deployment.mode=APIM_AS_CP \
  --set wso2.apim.controlPlane.hostName=am.wso2.com \
  --set wso2.apim.controlPlane.serviceName=wso2am-single-node-am-service.apim
```

### 3. Choreo Analytics

If you need to enable Choreo Analytics with Choreo Connect, please follow the documentation on [API Analytics Getting Started Guide](https://apim.docs.wso2.com/en/4.1.0/api-analytics/getting-started-guide/) to obtain the on-prem key for Analytics.

The following example shows how to enable Analytics with the helm charts.

Helm v2

```
helm install --name <RELEASE_NAME> wso2/choreo-connect --version 1.1.0-6 --namespace <NAMESPACE> \
  --set wso2.choreoAnalytics.enabled=true \
  --set wso2.choreoAnalytics.endpoint=<CHOREO_ANALYTICS_ENDPOINT> \
  --set wso2.choreoAnalytics.onpremKey=<ONPREM_KEY>
```

Helm v3

```
helm install <RELEASE_NAME> wso2/choreo-connect --version 1.1.0-6 --namespace <NAMESPACE> --create-namespace \
  --set wso2.choreoAnalytics.enabled=true \
  --set wso2.choreoAnalytics.endpoint=<CHOREO_ANALYTICS_ENDPOINT> \
  --set wso2.choreoAnalytics.onpremKey=<ONPREM_KEY>
```

You will be able to see the Analytics data when you log into Choreo Analytics Portal.

### 4. Obtain the external IP

#### 1. Deployment Mode: Standalone

Obtain the external IP (`EXTERNAL-IP`) of the Choreo Connect Ingress resources, by listing down the Kubernetes Ingresses.

```  
kubectl get ing -n <NAMESPACE>
```

The output under the relevant column stands for the following.

Choreo Connect Adapter

- NAME: Metadata name of the Kubernetes Ingress resource (Default to "<RELEASE_NAME>-choreo-connect-adapter")
- HOSTS: Hostname of the Choreo Connect Adapter (Default to "adapter.wso2.com")
- ADDRESS: External IP (`EXTERNAL-IP`) exposing the Choreo Connect Adapter to outside of the Kubernetes environment
- PORTS: Externally exposed service ports of the Choreo Connect Adapter

Choreo Connect Router

- NAME: Metadata name of the Kubernetes Ingress resource (Default to "<RELEASE_NAME>-choreo-connect-router")
- HOSTS: Hostname of the router service (Default to "gw.wso2.com")
- ADDRESS: External IP (`EXTERNAL-IP`) exposing the router to outside of the Kubernetes environment
- PORTS: Externally exposed router ports of the Choreo Connect

#### 2. Deployment Mode: API Manager as Control Plane

Obtain the external IP (`EXTERNAL-IP`) of the Choreo Connect Ingress resources, by listing down the Kubernetes Ingresses.

```  
kubectl get ing -n apim
```

The output under the relevant column stands for the following.

API Manager Control Plane

- NAME: Metadata name of the Kubernetes Ingress resource (`wso2am-pattern-3-am-cp-ingress`)
- HOSTS: Hostname of the WSO2 API Manager's Control Plane service (`am.wso2.com`)
- ADDRESS: External IP (`EXTERNAL-IP`) exposing the API Manager's Control Plane service to outside of the Kubernetes environment
- PORTS: Externally exposed service ports of the API Manager's Control Plane service

```  
kubectl get ing -n <NAMESPACE>
```

The output under the relevant column stands for the following.

Choreo Connect Router

- NAME: Metadata name of the Kubernetes Ingress resource (Default to "<RELEASE_NAME>-choreo-connect-router")
- HOSTS: Hostname of the router service (Default to "gw.wso2.com")
- ADDRESS: External IP (`EXTERNAL-IP`) exposing the router to outside of the Kubernetes environment
- PORTS: Externally exposed router ports of the Choreo Connect

### 5. Add a DNS record mapping the hostnames and the external IP

If the defined hostnames (in the previous step) are backed by a DNS service, add a DNS record mapping the hostnames and
the external IP (`EXTERNAL-IP`) in the relevant DNS service.

If the defined hostnames are not backed by a DNS service, for the purpose of evaluation you may add an entry mapping the
hostnames and the external IP in the `/etc/hosts` file at the client-side.

### 6. Access Services

#### 1. Deployment Mode: Standalone

- Adapter Endpoint: `https://<wso2.deployment.adapter.ingress.hostname>` (Default to `https://adapter.wso2.com`)
- Router Endpoint: `https://<wso2.deployment.gatewayRuntime.router.ingress.hostname>` (Default to `https://gw.wso2.com`)

Follow the document [Deploying a REST API in Choreo Connect](https://apim.docs.wso2.com/en/4.1.0/deploy-and-publish/deploy-on-gateway/choreo-connect/deploy-api/deploy-rest-api-in-choreo-connect/#choreo-connect-as-a-standalone-gateway) to deploy an API.

#### 2. Deployment Mode: API Manager as Control Plane

- API Manager Publisher: [https://am.wso2.com/publisher/](https://am.wso2.com/publisher/)
- API Manager DevPortal: [https://am.wso2.com/devportal/](https://am.wso2.com/devportal/)

Follow the document [Deploying a REST API in Choreo Connect](https://apim.docs.wso2.com/en/4.1.0/deploy-and-publish/deploy-on-gateway/choreo-connect/deploy-api/deploy-rest-api-in-choreo-connect/#choreo-connect-with-wso2-api-manager-as-a-control-plane) to deploy an API.

## Configuration

a. The default product configurations are available at `<HELM_HOME>/confs` folder. Change the
configurations as necessary.

b. Open the `<HELM_HOME>/values.yaml` and provide the following values.

###### WSO2 Subscription Configurations

| Parameter                                                                   | Description                                                                               | Default Value                                   |
|-----------------------------------------------------------------------------|-------------------------------------------------------------------------------------------|-------------------------------------------------|
| `wso2.subscription.username`                                                | Your WSO2 Subscription username                                                           | -                                               |
| `wso2.subscription.password`                                                | Your WSO2 Subscription password                                                           | -                                               |
| `wso2.choreoAnalytics.enabled`                                              | Chorero Analytics enabled or not                                                          | false                                           |
| `wso2.choreoAnalytics.endpoint`                                             | Choreo Analytics endpoint                                                                 | https://analytics-event-auth.choreo.dev/auth/v1 |
| `wso2.choreoAnalytics.onpremKey`                                            | On-prem key for Choreo Analytics                                                          | -                                               |

If you do not have active WSO2 subscription do not change the parameters `wso2.deployment.username`, `wso2.deployment.password`. 

######   Externally installed WSO2 API Manager Control Plane Configurations

| Parameter                                | Description                                                                               | Default Value                    |
|------------------------------------------|-------------------------------------------------------------------------------------------|----------------------------------|
| `wso2.apim.controlPlane.hostName`        | Hostname of the control plane                                                             | am.wso2.com                      |
| `wso2.apim.controlPlane.serviceName`     | K8s service name (if in another namespace, `<serviceName>.<namespace>`) of the control plane   | wso2am-single-node-am-service.apim |
| `wso2.apim.controlPlane.eventListeners`  | List of K8s service names of control plane, which Choreo Connect listen for events. If empty default to `wso2.apim.controlPlane.serviceName`  | [] |
| `wso2.apim.trafficManagers`              | List of K8s service names of traffic managers. If empty default to `wso2.apim.controlPlane.eventListeners` | []          |

###### Choreo Connect Configurations

| Parameter                                                                   | Description                                                                               | Default Value               |
|-----------------------------------------------------------------------------|-------------------------------------------------------------------------------------------|-----------------------------|
| `wso2.deployment.mode`                                                      | Deployment option: one of "STANDALONE" or "APIM_AS_CP"                                    | "STANDALONE"                |
| `wso2.deployment.labelName`                                                 | Label (environment) name of the deployment                                                | "Default"                   |
| `wso2.deployment.dockerRegistry`                                            | If a custom image must be used, define the docker registry.                               | DockerHub registry          |
| `wso2.deployment.imagePullSecrets`                                          | Image pull secrets to pull images from docker registry.                                   | -                           |

###### Choreo Connect Adapter Configurations

| Parameter                                                                   | Description                                                                               | Default Value               |
|-----------------------------------------------------------------------------|-------------------------------------------------------------------------------------------|-----------------------------|
| `wso2.deployment.adapter.dockerRegistry`                                    | Docker registry. If this value is not empty, this overrides the value in `wso2.deployment.dockerRegistry` | -           |
| `wso2.deployment.adapter.imageName`                                         | Image name for adapter                                                                    | "choreo-connect-adapter"    |
| `wso2.deployment.adapter.imageTag`                                          | Image tag for adapter                                                                     | "1.1.0"                     |
| `wso2.deployment.adapter.imagePullPolicy`                                   | Image pull policy of the container                                                        | "IfNotPresent"              |
| `wso2.deployment.adapter.replicaCount`                                      | Pods count                                                                                | 1                           |
| `wso2.deployment.adapter.ingress.enabled`                                   | Create ingress resource for adapter Rest endpoint. Adapter ingress is disabled when the Choreo Connect Mode is "APIM_AS_CP" (i.e. not "STANDALONE") even it is enabled with this config | true                        |
| `wso2.deployment.adapter.ingress.hostname`                                  | Hostname for adapter in STANDALONE mode                                                   | adapter.wso2.com            |
| `wso2.deployment.adapter.ingress.tlsSecretName`                             | TLS secret for the adapter host. Using default secret if not specified                    | Default TLS secret          |
| `wso2.deployment.adapter.ingress.annotations`                               | Annotations for the adapter ingress                                                       | Community NGINX Ingress controller annotations |
| `wso2.deployment.adapter.resources.requests.memory`                         | Resources for the adapter container - Memory request                                      | "500Mi"                     |
| `wso2.deployment.adapter.resources.requests.cpu`                            | Resources for the adapter container - CPU request                                         | "500m"                      |
| `wso2.deployment.adapter.resources.limits.memory`                           | Resources for the adapter container - Memory limit                                        | "500Mi"                     |
| `wso2.deployment.adapter.resources.limits.cpu`                              | Resources for the adapter container - CPU limit                                           | "500m"                      |
| `wso2.deployment.adapter.affinity`                                          | Affinity for adapter pods assignment                                                      | -                           |
| `wso2.deployment.adapter.nodeSelector`                                      | Node labels for adapter pods assignment                                                   | -                           |
| `wso2.deployment.adapter.tolerations`                                       | Tolerations for adapter pods assignment                                                   | -                           |
| `wso2.deployment.adapter.automountServiceAccountToken`                      | Auto mount Service Account Token to the pod                                               | false                       |
| `wso2.deployment.adapter.podSecurityContext`                                | Security context of the the adapter pod                                                   | runAsUser:&nbsp;10500</br>runAsGroup:&nbsp;10500 |
| `wso2.deployment.adapter.containerSecurityContext`                          | Security context of the the adapter container                                             | allowPrivilegeEscalation:&nbsp;false</br>readOnlyRootFilesystem:&nbsp;true</br>capabilities:</br>&nbsp;&nbsp;drop:</br>&nbsp;&nbsp;&nbsp;&nbsp;-&nbsp;all</br>|
| `wso2.deployment.adapter.livenessProbe.initialDelaySeconds`                 | Number of seconds after the container has started before liveness probes are initiated    | 10                          |
| `wso2.deployment.adapter.livenessProbe.periodSeconds`                       | How often (in seconds) to perform the probe                                               | 30                          |
| `wso2.deployment.adapter.readinessProbe.initialDelaySeconds`                | Number of seconds after the container has started before readiness probes are initiated   | 8                           |
| `wso2.deployment.adapter.readinessProbe.periodSeconds`                      | How often (in seconds) to perform the probe                                               | 5                           |
| `wso2.deployment.adapter.podAnnotations`                                    | Key value pair of annotations for the pod                                                 | sidecar.istio.io/inject: "false" |
| `wso2.deployment.adapter.configToml`                                        | Define templated config.toml file, if empty using default config.toml                     | Default templated config toml file |
| `wso2.deployment.adapter.logConfigToml`                                     | Define templated log_config.toml file, if empty using default log_config.toml             | Default templated log config toml file |
| `wso2.deployment.adapter.apiArtifactsMountEmptyDir`         | Mount an empty directory on API artifacts directory         |           true         |
| `wso2.deployment.adapter.envOverride`                                       | Set (or override) environment variables as values or from ConfigMaps or Secrets           | Default passwords           |
| `wso2.deployment.adapter.security.sslHostname`                              | Hostname for SSL verification, this value should be included in SAN of keystore certs     | adapter                     |
| `wso2.deployment.adapter.security.adapterRestService.enabled`               | Enable or disable adapter Rest service. If "default": enabled in "STANDALONE" mode and disabled in "APIM_AS_CP" mode <oneof `"default"` or `"true"` or `"false"`> | "default" |
| `wso2.deployment.adapter.security.keystore`                                 | Private key and cert in PEM format (Refer [Configure Certificates](#configure-certificates)) | Default Certs           |
| `wso2.deployment.adapter.security.truststore`                               | Truststore certs as array of secrets {secretName, subPath} (Refer [Configure Certificates](#configure-certificates))  | Default Certs |
| `wso2.deployment.adapter.security.consul`                                   | Certs for consul integration                                                              | -                         |

###### Choreo Connect Gateway Runtime Configurations

Gateway runtime (enforcer + router) deployment configurations

| Parameter                                                                   | Description                                                                               | Default Value               |
|-----------------------------------------------------------------------------|-------------------------------------------------------------------------------------------|-----------------------------|
| `wso2.deployment.gatewayRuntime.podAnnotations`                             | Key value pair of annotations for the pod                                                 | -                           |
| `wso2.deployment.gatewayRuntime.replicaCount`                               | Pod count, this is applicable only if `wso2.deployment.gatewayRuntime.autoscaling.enabled` is disabled | 1              |
| `wso2.deployment.gatewayRuntime.autoscaling.enabled`                        | Horizontal pod auto scaling is enabled                                                    | true                        |
| `wso2.deployment.gatewayRuntime.autoscaling.minReplicas`                    | Horizontal pod auto scaling - Minimum replica count                                       | 1                           |
| `wso2.deployment.gatewayRuntime.autoscaling.maxReplicas`                    | Horizontal pod auto scaling - Maximum replica count                                       | 5                           |
| `wso2.deployment.gatewayRuntime.autoscaling.targetCPUUtilizationPercentage` | Horizontal pod auto scaling - target CPU Utilization percentage                           | 75                          |
| `wso2.deployment.gatewayRuntime.autoscaling.targetMemoryUtilizationPercentage` | Horizontal pod auto scaling - target memory Utilization percentage                     | 75                          |
| `wso2.deployment.gatewayRuntime.affinity`                                   | Affinity for gateway runtime pods assignment                                              | -                           |
| `wso2.deployment.gatewayRuntime.nodeSelector`                               | Node labels for gateway runtime pods assignment                                           | -                           |
| `wso2.deployment.gatewayRuntime.tolerations`                                | Tolerations for gateway runtime pods assignment                                           | -                           |
| `wso2.deployment.gatewayRuntime.automountServiceAccountToken`               | Auto mount Service Account Token to the pod                                               | false                       |
| `wso2.deployment.gatewayRuntime.podSecurityContext`                         | Security context of the the gateway runtime pod                                           | runAsUser:&nbsp;10500</br>runAsGroup:&nbsp;10500|

###### Choreo Connect Gateway Runtime - Enforcer Configurations

| Parameter                                                                   | Description                                                                               | Default Value               |
|-----------------------------------------------------------------------------|-------------------------------------------------------------------------------------------|-----------------------------|
| `wso2.deployment.gatewayRuntime.enforcer.dockerRegistry`                    | Docker registry. If this value is not empty, this overrides the value in `wso2.deployment.dockerRegistry` | -           |
| `wso2.deployment.gatewayRuntime.enforcer.imageName`                         | Image name for enforcer                                                                   | "choreo-connect-enforcer"   |
| `wso2.deployment.gatewayRuntime.enforcer.imageTag`                          | Image tag for enforcer                                                                    | "1.1.0"                     |
| `wso2.deployment.gatewayRuntime.enforcer.imagePullPolicy`                   | Image pull policy of the container                                                        | "IfNotPresent"              |
| `wso2.deployment.gatewayRuntime.enforcer.envOverride`                       | Set (or override) environment variables as values or from ConfigMaps or Secrets           | Default Passwords           |
| `wso2.deployment.gatewayRuntime.enforcer.dropins`                           | Mount enforcer lib dropins JARs to the `dropins` directory, array of ConfigMap names      | -                           |
| `wso2.deployment.gatewayRuntime.enforcer.dropinsMountEmptyDir`          | Mount an empty directory on dropins JARs directory          |           true          |
| `wso2.deployment.gatewayRuntime.enforcer.resources.requests.memory`         | Resources for the adapter container - Memory request                                      | "1000Mi"                    |
| `wso2.deployment.gatewayRuntime.enforcer.resources.requests.cpu`            | Resources for the adapter container - CPU request                                         | "1000m"                     |
| `wso2.deployment.gatewayRuntime.enforcer.resources.limits.memory`           | Resources for the adapter container - Memory limit                                        | "1000Mi"                    |
| `wso2.deployment.gatewayRuntime.enforcer.resources.limits.cpu`              | Resources for the adapter container - CPU limit                                           | "1000m"                     |
| `wso2.deployment.gatewayRuntime.enforcer.startupProbe.periodSeconds`        | How often (in seconds) to perform the probe                                               | 5                           |
| `wso2.deployment.gatewayRuntime.enforcer.startupProbe.failureThreshold`     | Number of time startup probe should be done before mark fail                              | 30                          |
| `wso2.deployment.gatewayRuntime.enforcer.livenessProbe.initialDelaySeconds` | Number of seconds after the container has started before liveness probes are initiated    | 10                          |
| `wso2.deployment.gatewayRuntime.enforcer.livenessProbe.periodSeconds`       | How often (in seconds) to perform the probe                                               | 30                          |
| `wso2.deployment.gatewayRuntime.enforcer.readinessProbe.initialDelaySeconds`| Number of seconds after the container has started before readiness probes are initiated   | 8                           |
| `wso2.deployment.gatewayRuntime.enforcer.readinessProbe.periodSeconds`      | How often (in seconds) to perform the probe                                               | 5                           |
| `wso2.deployment.gatewayRuntime.enforcer.containerSecurityContext`          | Security context of the the adapter container                                             | allowPrivilegeEscalation:&nbsp;false</br>readOnlyRootFilesystem:&nbsp;true</br>capabilities:</br>&nbsp;&nbsp;drop:</br>&nbsp;&nbsp;&nbsp;&nbsp;-&nbsp;all</br>|
| `wso2.deployment.gatewayRuntime.enforcer.security.sslHostname`              | Hostname for SSL verification, this value should be included in SAN of keystore certs     | enforcer                    |
| `wso2.deployment.gatewayRuntime.enforcer.security.keystore`                 | Private key and cert in PEM format (Refer [Configure Certificates](#configure-certificates)) | Default Certs            |
| `wso2.deployment.gatewayRuntime.enforcer.security.backendJWT.enabled`       | Passing end user attributes to the backend - enabled                                      | false                       |
| `wso2.deployment.gatewayRuntime.enforcer.security.backendJWT.keystore`      | Private key and cert in PEM format (Refer [Configure Certificates](#configure-certificates))  | Default Certs           |
| `wso2.deployment.gatewayRuntime.enforcer.security.testTokenIssuer.enabled`  | Test token issuer - enabled                                                               | true                        |
| `wso2.deployment.gatewayRuntime.enforcer.security.truststore`               | Truststore certs as array of secrets {secretName, subPath} (Refer [Configure Certificates](#configure-certificates))  | Default Certs |
| `wso2.deployment.gatewayRuntime.enforcer.log4j2Properties`                  | Define templated log4j2.properties file, if empty using default log4j2.properties         | Default templated log4j property file |

###### Choreo Connect Gateway Runtime - Router Configurations

| Parameter                                                                   | Description                                                                               | Default Value               |
|-----------------------------------------------------------------------------|-------------------------------------------------------------------------------------------|-----------------------------|
| `wso2.deployment.gatewayRuntime.router.dockerRegistry`                      | Docker registry. If this value is not empty, this overrides the value in `wso2.deployment.dockerRegistry` | -           |
| `wso2.deployment.gatewayRuntime.router.imageName`                           | Image name for enforcer                                                                   | "choreo-connect-router"     |
| `wso2.deployment.gatewayRuntime.router.imageTag`                            | Image tag for enforcer                                                                    | "1.1.0"                     |
| `wso2.deployment.gatewayRuntime.router.imagePullPolicy`                     | Image pull policy of the container                                                        | "IfNotPresent"              |
| `wso2.deployment.gatewayRuntime.router.ingress.enabled`                     | If enabled, create the ingress for router (gateway)                                       | true                        |
| `wso2.deployment.gatewayRuntime.router.ingress.hostname`                    | Hostname for router (gateway)                                                             | gw.wso2.com                 |
| `wso2.deployment.gatewayRuntime.router.ingress.tlsSecretName`               | TLS secret for the router host. Using default secret if not specified                     | Default TLS secret          |
| `wso2.deployment.gatewayRuntime.router.ingress.annotations`                 | Annotations for the router ingress                                                        | Community NGINX Ingress controller annotations |
| `wso2.deployment.gatewayRuntime.router.ingress.targetPort`                  | Port of the router service to route requests                                              | 9095                        |
| `wso2.deployment.gatewayRuntime.router.envOverride`                         | Set (or override) environment variables as values or from ConfigMaps or Secrets           | -                           |
| `wso2.deployment.gatewayRuntime.router.resources.requests.memory`           | Resources for the adapter container - Memory request                                      | "500Mi"                     |
| `wso2.deployment.gatewayRuntime.router.resources.requests.cpu`              | Resources for the adapter container - CPU request                                         | "1000m"                     |
| `wso2.deployment.gatewayRuntime.router.resources.limits.memory`             | Resources for the adapter container - Memory limit                                        | "500Mi"                     |
| `wso2.deployment.gatewayRuntime.router.resources.limits.cpu`                | Resources for the adapter container - CPU limit                                           | "1000m"                     |
| `wso2.deployment.gatewayRuntime.router.startupProbe.periodSeconds`          | How often (in seconds) to perform the probe                                               | 5                           |
| `wso2.deployment.gatewayRuntime.router.startupProbe.failureThreshold`       | Number of time startup probe should be done before mark fail                              | 30                          |
| `wso2.deployment.gatewayRuntime.router.livenessProbe.initialDelaySeconds`   | Number of seconds after the container has started before liveness probes are initiated    | 20                          |
| `wso2.deployment.gatewayRuntime.router.livenessProbe.periodSeconds`         | How often (in seconds) to perform the probe                                               | 10                          |
| `wso2.deployment.gatewayRuntime.router.readinessProbe.initialDelaySeconds`  | Number of seconds after the container has started before readiness probes are initiated   | 20                          |
| `wso2.deployment.gatewayRuntime.router.readinessProbe.periodSeconds`        | How often (in seconds) to perform the probe                                               | 5                           |
| `wso2.deployment.gatewayRuntime.router.containerSecurityContext`            | Security context of the the adapter container                                             | allowPrivilegeEscalation:&nbsp;false</br>readOnlyRootFilesystem:&nbsp;true</br>capabilities:</br>&nbsp;&nbsp;drop:</br>&nbsp;&nbsp;&nbsp;&nbsp;-&nbsp;all</br>|
| `wso2.deployment.gatewayRuntime.router.security.backendCaCerts`             | Trusted backend certs in PEM format (Refer [Configure Certificates](#configure-certificates)) | Default envoy CA Certs  |
| `wso2.deployment.gatewayRuntime.router.security.keystore`                   | Private key and cert in PEM format (Refer [Configure Certificates](#configure-certificates))  | Default Certs           |
| `wso2.deployment.gatewayRuntime.router.debug.heapProfile.mountEmptyDir`     | Mount an K8s empty dir to write Heap/CPU profile data                                     | false                       |
| `wso2.deployment.gatewayRuntime.router.debug.heapProfile.mountPath`         | Path to mount the empty dir to write Heap/CPU profile data                                | "/var/log/envoy"            |

## Kubernetes Specific Configurations

| Parameter                                                                   | Description                                                                               | Default Value               |
|-----------------------------------------------------------------------------|-------------------------------------------------------------------------------------------|-----------------------------|
| `kubernetes.serviceAccount.create`                                          | Specifies whether a service account should be created                                     | true                        |
| `kubernetes.serviceAccount.annotations`                                     | Annotations to add to the service account                                                 | -                           |
| `kubernetes.serviceAccount.name`                                            | The name of the service account to use, if `create` is true, a service account with this name is created | -            |
| `kubernetes.ingress.className`                                              | Kubernetes ingress class name to be applied to all ingress resources                      | -                           |

## Helm Release Name Configurations

| Parameter                                                                   | Description                                                                               | Default Value               |
|-----------------------------------------------------------------------------|-------------------------------------------------------------------------------------------|-----------------------------|
| `nameOverride`                                                              | Name to override. Default to "choreo-connect"                                             | -                           |
| `fullnameOverride`                                                          | Full name to override. Default to "<RELEASE_NAME>-choreo-connect"                         | -                           |

## Configure Certificates

You can refer a value in a secret by specifying values as follows.

- secretName: Name of the secret in the same namespace that Choreo Connect is going to be installed
- subPath: Sub path in the K8s secret (or the key of the K8s secret).

```yaml
secretName: "router-keystore"
subPath: "tls.key"
```

### Keystore

The following is a sample how to define the keystore. If you have created a secret in the same namespace that Choreo Connect going to be installed, you can refer them in the config as follows.

```yaml
keystore:
  key:
    secretName: "router-keystore"
    subPath: "tls.key"
  cert:
    secretName: "router-keystore"
    subPath: "tls.crt"
```

### Truststore

The following is a sample how to define the truststore. If you have created a secret in the same namespace that Choreo Connect going to be installed, you can refer them in the config as follows.

```yaml
truststore:
  - secretName: "adapter-certs"
    subPath: "tls.crt"
  - secretName: "controlplane-cert"
    subPath: "wso2carbon.pem"
```

## Configure Passwords

You can configure passwords thorough environment variables. Additionally, any other environments variables can be set/override as follows.
You can use plain values in the `value` section or else you can use `valueFrom`. This configuration is the same way you can define environment variables in Kubernetes Pods.

```yaml
envOverride:
  - name: enforcer_admin_pwd
    value: admin
  - name: tm_admin_pwd
    valueFrom:
      secretKeyRef:
        name: my-secret
        key: tm_password
```
