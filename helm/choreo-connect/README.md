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

* An already setup [Kubernetes cluster](https://kubernetes.io/docs/setup).<br><br>

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
  helm install --name <RELEASE_NAME> wso2/choreo-connect --version 1.0.0-1 --namespace <NAMESPACE>
  ```
  
  Helm version 3

  ```
  helm install <RELEASE_NAME> wso2/choreo-connect --version 1.0.0-1 --namespace <NAMESPACE> --create-namespace
  ```

The above steps will deploy the Choreo Connect using WSO2 product Docker images available at DockerHub.

If you are using WSO2 product Docker images available from WSO2 Private Docker Registry,
please provide your WSO2 Subscription credentials via input values (using `--set` argument). 

Please see the following example.

```
 helm install --name <RELEASE_NAME> wso2/choreo-connect --version 1.0.0-1 --namespace <NAMESPACE> \
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
 helm install --name <RELEASE_NAME> <HELM_HOME>/choreo-connect --version 1.0.0-1 --namespace <NAMESPACE>
 ```

 Helm version 3

```
helm install <RELEASE_NAME> <HELM_HOME>/choreo-connect --version 1.0.0-1 --namespace <NAMESPACE> --create-namespace
```

The above steps will deploy the deployment pattern using WSO2 product Docker images available at DockerHub.

If you are using WSO2 product Docker images available from WSO2 Private Docker Registry,
please provide your WSO2 Subscription credentials via input values (using `--set` argument). 

Please see the following example.

```
 helm install --name <RELEASE_NAME> <HELM_HOME>/choreo-connect --version 1.0.0-1 --namespace <NAMESPACE> --set wso2.subscription.username=<SUBSCRIPTION_USERNAME> --set wso2.subscription.password=<SUBSCRIPTION_PASSWORD>
```

### 2. Deployment Mode (Deployment Options)

There are two types of deployment options namely,
- WSO2 API Manager as a Control Plane
- Standalone Gateway

For more information, please refer [Choreo Connect Deployment Options](https://apim.docs.wso2.com/en/latest/deploy-and-publish/deploy-on-gateway/choreo-connect/getting-started/deploy/cc-deploy-overview/)

#### 2.1. Standalone Mode (Default)

The following example shows how to deploy Choreo Connect with "Standalone" deployment mode. This is the default mode,
hence if you have not specified `wso2.deployment.mode` "Standalone" deployment mode is applied.

Helm v2

```
helm install --name <RELEASE_NAME> wso2/choreo-connect --version 1.0.0-1 --namespace <NAMESPACE> \
  --set wso2.deployment.mode=STANDALONE
```

Helm v3

```
helm install <RELEASE_NAME> wso2/choreo-connect --version 1.0.0-1 --namespace <NAMESPACE> --create-namespace
  --set wso2.deployment.mode=STANDALONE
```

#### 2.2. WSO2 API Manager as a Control Plane

##### Setup 1: Deploy WSO2 API Manager

Add the WSO2 Helm chart repository.
```
 helm repo add wso2 https://helm.wso2.com && helm repo update
```

Helm version 2

```
helm install --name apim-as-cp wso2/am-single-node --version 4.0.0-1 --namespace apim \
  --set wso2.deployment.am.ingress.gateway.hostname=gw.wso2.com \
  --set-file wso2.deployment.am.config."deployment\.toml"=https://raw.githubusercontent.com/wso2/kubernetes-microgateway/1.0.0-1/resources/controlplane-deployment.toml
```

Helm version 3

```
helm install apim-as-cp wso2/am-single-node --version 4.0.0-1 --namespace apim --create-namespace \
  --set wso2.deployment.am.ingress.gateway.hostname=gw.wso2.com \
  --set-file wso2.deployment.am.config."deployment\.toml"=https://raw.githubusercontent.com/wso2/kubernetes-microgateway/1.0.0-1/resources/controlplane-deployment.toml
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

Choreo Connect is used as the gateway of API Manager, hence we need to delete the gateway Ingress resource of gateway component of the WSO2 API Manager.

```
kubectl delete ing -n apim wso2am-single-node-am-gateway-ingress
```

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

For more information on installing WSO2 API Manager, ref the repository [wso2/kubernetes-apim](https://github.com/wso2/kubernetes-apim)

##### Setup 2: Deploy Choreo Connect
The following example shows how to deploy Choreo Connect with "WSO2 API Manager as a Control Plane" deployment mode.

Helm v2

```
helm install --name <RELEASE_NAME> wso2/choreo-connect --version 1.0.0-1 --namespace <NAMESPACE> \
  --set wso2.deployment.mode=APIM_AS_CP \
  --set wso2.apim.controlPlane.hostName=am.wso2.com \
  --set wso2.apim.controlPlane.serviceName=wso2am-single-node-am-service.apim
```

Helm v3

```
helm install <RELEASE_NAME> wso2/choreo-connect --version 1.0.0-1 --namespace <NAMESPACE> --create-namespace \
  --set wso2.deployment.mode=APIM_AS_CP \
  --set wso2.apim.controlPlane.hostName=am.wso2.com \
  --set wso2.apim.controlPlane.serviceName=wso2am-single-node-am-service.apim
```

NOTE: If you do not have sufficient resources you can adjust them setting following values when installing the chart.
  ```
  --set wso2.deployment.adapter.resources.requests.memory=300Mi \
  --set wso2.deployment.adapter.resources.requests.cpu=300m \
  --set wso2.deployment.adapter.resources.limits.memory=300Mi \
  --set wso2.deployment.adapter.resources.limits.cpu=300m \
  \
  --set wso2.deployment.gatewayRuntime.enforcer.resources.requests.memory=1000Mi \
  --set wso2.deployment.gatewayRuntime.enforcer.resources.requests.cpu=500m \
  --set wso2.deployment.gatewayRuntime.enforcer.resources.limits.memory=1000Mi \
  --set wso2.deployment.gatewayRuntime.enforcer.resources.limits.cpu=500m \
  \
  --set wso2.deployment.gatewayRuntime.router.resources.requests.memory=300Mi \
  --set wso2.deployment.gatewayRuntime.router.resources.requests.cpu=500m \
  --set wso2.deployment.gatewayRuntime.router.resources.limits.memory=300Mi \
  --set wso2.deployment.gatewayRuntime.router.resources.limits.cpu=500m
  ```

### 3. Choreo Analytics

If you need to enable Choreo Analytics with Choreo Connect, please follow the documentation on [API Analytics Getting Started Guide](https://apim.docs.wso2.com/en/latest/api-analytics/getting-started-guide/) to obtain the on-prem key for Analytics.

The following example shows how to enable Analytics with the helm charts.

Helm v2

```
helm install --name <RELEASE_NAME> wso2/choreo-connect --version 1.0.0-1 --namespace <NAMESPACE> \
  --set wso2.choreoAnalytics.enabled=true \
  --set wso2.choreoAnalytics.endpoint=<CHOREO_ANALYTICS_ENDPOINT> \
  --set wso2.choreoAnalytics.onpremKey=<ONPREM_KEY>
```

Helm v3

```
helm install <RELEASE_NAME> wso2/choreo-connect --version 1.0.0-1 --namespace <NAMESPACE> --create-namespace \
  --set wso2.choreoAnalytics.enabled=true \
  --set wso2.choreoAnalytics.endpoint=<CHOREO_ANALYTICS_ENDPOINT> \
  --set wso2.choreoAnalytics.onpremKey=<ONPREM_KEY>
```

You will be able to see the Analytics data when you log into Choreo Analytics Portal.

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

###### Ingress Configurations

| Parameter                                                                   | Description                                                                               | Default Value               |
|-----------------------------------------------------------------------------|-------------------------------------------------------------------------------------------|-----------------------------|
| `wso2.ingress.adapter.enabled`                                              | Create ingress resource for adapter Rest endpoint. Adapter ingress is disabled when the Choreo Connect Mode is "APIM_AS_CP" (i.e. not "STANDALONE") even it is enabled with this config | true                        |
| `wso2.ingress.adapter.hostname`                                             | Hostname for adapter in STANDALONE mode                                                   | adapter.wso2.com            |
| `wso2.ingress.adapter.tlsSecretName`                                        | TLS secret for the adapter host. Using default secret if not specified                    | -                           |
| `wso2.ingress.adapter.annotations`                                          | Annotations for the adapter ingress                                                       | Community NGINX Ingress controller annotations |
| `wso2.ingress.gateway.enabled`                                              | If enabled, create the ingress for gateway                                                | true                        |
| `wso2.ingress.gateway.hostname`                                             | Hostname for gateway                                                                      | gw.wso2.com                 |
| `wso2.ingress.gateway.tlsSecretName`                                        | TLS secret for the gateway host. Using default secret if not specified                    | -                           |
| `wso2.ingress.adapter.annotations`                                          | Annotations for the gateway ingress                                                       | Community NGINX Ingress controller annotations |
| `wso2.ingress.internal.enabled`                                             | Enable internal ingress resource only for the debugging purposes and check router related config_dumps etc. In a production scenario this should be disabled.   | false                        |
| `wso2.ingress.internal.hostname`                                            | Hostname for gateway                                                                      | internal.wso2.com           |
| `wso2.ingress.internal.annotations`                                         | Annotations for the gateway ingress                                                       | Community NGINX Ingress controller annotations |

######   Externally installed WSO2 API Manager Control Plane Configurations

| Parameter                                                                   | Description                                                                               | Default Value               |
|-----------------------------------------------------------------------------|-------------------------------------------------------------------------------------------|-----------------------------|
| `wso2.apim.controlPlane.hostName`                                           | Hostname of the control plane                                                             | am.wso2.com                 |
| `wso2.apim.controlPlane.serviceName`                                        | K8s service name (if in another namespace, `<serviceName>.<namespace>`) of the control plane   | wso2am-single-node-am-service.apim |
| `wso2.apim.trafficManager.serviceName`                                      | K8s service name of the traffic manager. If not defined, default to control plane service name | -                      |


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
| `wso2.deployment.adapter.imageName`                                         | Image name for adapter                                                                    | "choreo-connect-adapter"    |
| `wso2.deployment.adapter.imageTag`                                          | Image tag for adapter                                                                     | "1.0.0"                     |
| `wso2.deployment.adapter.imagePullPolicy`                                   | Image pull policy of the container                                                        | "IfNotPresent"              |
| `wso2.deployment.adapter.resources.requests.memory`                         | Resources for the adapter container - Memory request                                      | "300Mi"                     |
| `wso2.deployment.adapter.resources.requests.cpu`                            | Resources for the adapter container - CPU request                                         | "300m"                      |
| `wso2.deployment.adapter.resources.limits.memory`                           | Resources for the adapter container - Memory limit                                        | "500Mi"                     |
| `wso2.deployment.adapter.resources.limits.cpu`                              | Resources for the adapter container - CPU limit                                           | "500m"                      |
| `wso2.deployment.adapter.affinity`                                          | Affinity for adapter pods assignment                                                      | -                           |
| `wso2.deployment.adapter.nodeSelector`                                      | Node labels for adapter pods assignment                                                   | -                           |
| `wso2.deployment.adapter.tolerations`                                       | Tolerations for adapter pods assignment                                                   | -                           |
| `wso2.deployment.adapter.containerSecurityContext`                          | Security context of the the adapter container                                             | allowPrivilegeEscalation:&nbsp;false</br>readOnlyRootFilesystem:&nbsp;true</br>capabilities:</br>&nbsp;&nbsp;drop:</br>&nbsp;&nbsp;&nbsp;&nbsp;-&nbsp;all</br>&nbsp;&nbsp;add: ["NET_RAW"]|
| `wso2.deployment.adapter.livenessProbe.initialDelaySeconds`                 | Number of seconds after the container has started before liveness probes are initiated    | 10                          |
| `wso2.deployment.adapter.livenessProbe.periodSeconds`                       | How often (in seconds) to perform the probe                                               | 30                          |
| `wso2.deployment.adapter.readinessProbe.initialDelaySeconds`                | Number of seconds after the container has started before readiness probes are initiated   | 8                           |
| `wso2.deployment.adapter.readinessProbe.periodSeconds`                      | How often (in seconds) to perform the probe                                               | 5                           |
| `wso2.deployment.adapter.podAnnotations`                                    | Key value pair of annotations for the pod                                                 | sidecar.istio.io/inject: "false" |
| `wso2.deployment.adapter.configToml`                                        | Define templated config.toml file, if empty using default config.toml                     | Default templated config toml file |
| `wso2.deployment.adapter.logConfigToml`                                     | Define templated log_config.toml file, if empty using default log_config.toml             | Default templated log config toml file |
| `wso2.deployment.adapter.envOverride`                                       | Set (or override) environment variables as values or from ConfigMaps or Secrets           | -                           |
| `wso2.deployment.adapter.security.keystore`                                 | Private key and cert in PEM format                                                        | Default Certs               |
| `wso2.deployment.adapter.security.truststore`                               | Truststore certs as array of secrets {secretName, subPath}                                | Default Certs               |
| `wso2.deployment.adapter.security.consul`                                   | Certs for consul integration                                                              | Default Certs               |

###### Choreo Connect Gateway Runtime Configurations

Gateway runtime (enforcer + router) deployment configurations

| Parameter                                                                   | Description                                                                               | Default Value               |
|-----------------------------------------------------------------------------|-------------------------------------------------------------------------------------------|-----------------------------|
| `wso2.deployment.gatewayRuntime.podAnnotations`                             | Key value pair of annotations for the pod                                                 | -                           |
| `wso2.deployment.gatewayRuntime.replicaCount`                               | Pod count                                                                                 | 1                           |
| `wso2.deployment.gatewayRuntime.autoscaling.enabled`                        | Horizontal pod auto scaling is enabled                                                    | true                        |
| `wso2.deployment.gatewayRuntime.autoscaling.minReplicas`                    | Horizontal pod auto scaling - Minimum replica count                                       | 1                           |
| `wso2.deployment.gatewayRuntime.autoscaling.maxReplicas`                    | Horizontal pod auto scaling - Maximum replica count                                       | 5                           |
| `wso2.deployment.gatewayRuntime.autoscaling.targetCPUUtilizationPercentage` | Horizontal pod auto scaling - target CPU Utilization percentage                           | 75                          |
| `wso2.deployment.gatewayRuntime.autoscaling.targetMemoryUtilizationPercentage` | Horizontal pod auto scaling - target memory Utilization percentage                     | 75                          |
| `wso2.deployment.adapter.affinity`                                          | Affinity for gateway runtime pods assignment                                              | -                           |
| `wso2.deployment.adapter.nodeSelector`                                      | Node labels for gateway runtime pods assignment                                           | -                           |
| `wso2.deployment.adapter.tolerations`                                       | Tolerations for gateway runtime pods assignment                                           | -                           |
| `wso2.deployment.adapter.podSecurityContext`                                | Security context of the the gateway runtime pod                                           | runAsUser: 10500</br>runAsGroup: 10500|

###### Choreo Connect Gateway Runtime - Enforcer Configurations

| Parameter                                                                   | Description                                                                               | Default Value               |
|-----------------------------------------------------------------------------|-------------------------------------------------------------------------------------------|-----------------------------|
| `wso2.deployment.gatewayRuntime.enforcer.imageName`                         | Image name for enforcer                                                                   | "choreo-connect-enforcer"   |
| `wso2.deployment.gatewayRuntime.enforcer.imageTag`                          | Image tag for enforcer                                                                    | "1.0.0"                     |
| `wso2.deployment.gatewayRuntime.enforcer.imagePullPolicy`                   | Image pull policy of the container                                                        | "IfNotPresent"              |
| `wso2.deployment.gatewayRuntime.enforcer.envOverride`                       | Set (or override) environment variables as values or from ConfigMaps or Secrets           | -                           |
| `wso2.deployment.gatewayRuntime.enforcer.resources.requests.memory`         | Resources for the adapter container - Memory request                                      | "500Mi"                     |
| `wso2.deployment.gatewayRuntime.enforcer.resources.requests.cpu`            | Resources for the adapter container - CPU request                                         | "500m"                      |
| `wso2.deployment.gatewayRuntime.enforcer.resources.limits.memory`           | Resources for the adapter container - Memory limit                                        | "1000Mi"                    |
| `wso2.deployment.gatewayRuntime.enforcer.resources.limits.cpu`              | Resources for the adapter container - CPU limit                                           | "1000m"                     |
| `wso2.deployment.gatewayRuntime.enforcer.startupProbe.periodSeconds`        | How often (in seconds) to perform the probe                                               | 5                           |
| `wso2.deployment.gatewayRuntime.enforcer.startupProbe.failureThreshold`     | Number of time startup probe should be done before mark fail                              | 30                          |
| `wso2.deployment.gatewayRuntime.enforcer.livenessProbe.initialDelaySeconds` | Number of seconds after the container has started before liveness probes are initiated    | 10                          |
| `wso2.deployment.gatewayRuntime.enforcer.livenessProbe.periodSeconds`       | How often (in seconds) to perform the probe                                               | 30                          |
| `wso2.deployment.gatewayRuntime.enforcer.readinessProbe.initialDelaySeconds`| Number of seconds after the container has started before readiness probes are initiated   | 8                           |
| `wso2.deployment.gatewayRuntime.enforcer.readinessProbe.periodSeconds`      | How often (in seconds) to perform the probe                                               | 5                           |
| `wso2.deployment.gatewayRuntime.enforcer.containerSecurityContext`          | Security context of the the adapter container                                             | allowPrivilegeEscalation:&nbsp;false</br>readOnlyRootFilesystem:&nbsp;true</br>capabilities:</br>&nbsp;&nbsp;drop:</br>&nbsp;&nbsp;&nbsp;&nbsp;-&nbsp;all</br>&nbsp;&nbsp;add: ["NET_RAW"]|
| `wso2.deployment.gatewayRuntime.enforcer.security.keystore`                 | Private key and cert in PEM format                                                        | Default Certs               |
| `wso2.deployment.gatewayRuntime.enforcer.security.backendJWT.enabled`       | Passing end user attributes to the backend - enabled                                      | false                       |
| `wso2.deployment.gatewayRuntime.enforcer.security.backendJWT.keystore`      | Passing end user attributes to the backend - Keys for signing                             | Default Certs               |
| `wso2.deployment.gatewayRuntime.enforcer.security.testTokenIssuer.enabled`  | Test token issuer - enabled                                                               | true                        |
| `wso2.deployment.gatewayRuntime.enforcer.security.truststore`               | Truststore certs as array of secrets {secretName, subPath}                                | Default Certs               |
| `wso2.deployment.gatewayRuntime.enforcer.log4j2Properties`                  | Define templated log4j2.properties file, if empty using default log4j2.properties         | Default templated log4j property file |

###### Choreo Connect Gateway Runtime - Router Configurations

| Parameter                                                                   | Description                                                                               | Default Value               |
|-----------------------------------------------------------------------------|-------------------------------------------------------------------------------------------|-----------------------------|
| `wso2.deployment.gatewayRuntime.router.imageName`                           | Image name for enforcer                                                                   | "choreo-connect-router"     |
| `wso2.deployment.gatewayRuntime.router.imageTag`                            | Image tag for enforcer                                                                    | "1.0.0"                     |
| `wso2.deployment.gatewayRuntime.router.imagePullPolicy`                     | Image pull policy of the container                                                        | "IfNotPresent"              |
| `wso2.deployment.gatewayRuntime.router.envOverride`                         | Set (or override) environment variables as values or from ConfigMaps or Secrets           | -                           |
| `wso2.deployment.gatewayRuntime.router.resources.requests.memory`           | Resources for the adapter container - Memory request                                      | "300Mi"                     |
| `wso2.deployment.gatewayRuntime.router.resources.requests.cpu`              | Resources for the adapter container - CPU request                                         | "500m"                      |
| `wso2.deployment.gatewayRuntime.router.resources.limits.memory`             | Resources for the adapter container - Memory limit                                        | "500Mi"                     |
| `wso2.deployment.gatewayRuntime.router.resources.limits.cpu`                | Resources for the adapter container - CPU limit                                           | "1000m"                     |
| `wso2.deployment.gatewayRuntime.router.startupProbe.periodSeconds`          | How often (in seconds) to perform the probe                                               | 5                           |
| `wso2.deployment.gatewayRuntime.router.startupProbe.failureThreshold`       | Number of time startup probe should be done before mark fail                              | 30                          |
| `wso2.deployment.gatewayRuntime.router.livenessProbe.initialDelaySeconds`   | Number of seconds after the container has started before liveness probes are initiated    | 20                          |
| `wso2.deployment.gatewayRuntime.router.livenessProbe.periodSeconds`         | How often (in seconds) to perform the probe                                               | 10                          |
| `wso2.deployment.gatewayRuntime.router.readinessProbe.initialDelaySeconds`  | Number of seconds after the container has started before readiness probes are initiated   | 20                          |
| `wso2.deployment.gatewayRuntime.router.readinessProbe.periodSeconds`        | How often (in seconds) to perform the probe                                               | 5                           |
| `wso2.deployment.gatewayRuntime.router.containerSecurityContext`            | Security context of the the adapter container                                             | allowPrivilegeEscalation:&nbsp;false</br>readOnlyRootFilesystem:&nbsp;true</br>capabilities:</br>&nbsp;&nbsp;drop:</br>&nbsp;&nbsp;&nbsp;&nbsp;-&nbsp;all</br>&nbsp;&nbsp;add: ["NET_RAW"]|
| `wso2.deployment.gatewayRuntime.router.security.keystore`                   | Private key and cert in PEM format                                                        | Default Certs               |

###### Kubernetes Configurations

| Parameter                                                                   | Description                                                                               | Default Value               |
|-----------------------------------------------------------------------------|-------------------------------------------------------------------------------------------|-----------------------------|
| `kubernetes.serviceAccount.create`                                          | Specifies whether a service account should be created                                     | true                        |
| `kubernetes.serviceAccount.annotations`                                     | Annotations to add to the service account                                                 | -                           |
| `kubernetes.serviceAccount.name`                                            | The name of the service account to use                                                    | -                           |

###### Helm Release Name Configurations

| Parameter                                                                   | Description                                                                               | Default Value               |
|-----------------------------------------------------------------------------|-------------------------------------------------------------------------------------------|-----------------------------|
| `nameOverride`                                                              | Name to override. Default to "choreo-connect"                                             | -                           |
| `fullnameOverride`                                                          | Full name to override. Default to "<RELEASE_NAME>-choreo-connect"                         | -                           |
