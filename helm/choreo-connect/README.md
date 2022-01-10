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

#### Install Chart From [WSO2 Helm Chart Repository](https://hub.helm.sh/charts/wso2)

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

#### Install Chart From Source

>In the context of this document, <br>
>* `KUBERNETES_HOME` will refer to a local copy of the [`wso2/kubernetes-microgateway`](https://github.com/wso2/kubernetes-microgateway/)
Git repository. <br>
>* `HELM_HOME` will refer to `<KUBERNETES_HOME>/helm/choreo-connect`. <br>

##### 1. Clone the Kubernetes Resources for WSO2 Choreo Connect Git repository.

```
git clone https://github.com/wso2/kubernetes-microgateway.git
```

##### Deploy Helm chart for Choreo Connect deployment.

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

#### Standalone Mode (Default)

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

#### WSO2 API Manager as a Control Plane

##### Setup 1: Deploy WSO2 API Manager

Change the directory to `KUBERNETES_HOME`.
```
cd <KUBERNETES_HOME>
```

Add the WSO2 Helm chart repository.
```
 helm repo add wso2 https://helm.wso2.com && helm repo update
```

Helm version 2

```
helm install --name apim-as-cp wso2/am-single-node --version 4.0.0-1 --namespace apim \
  --set-file wso2.deployment.am.config."deployment\.toml"=resources/controlplane-deployment.toml
```

Helm version 3

```
helm install apim-as-cp wso2/am-single-node --version 4.0.0-1 --namespace apim --create-namespace \
  --set-file wso2.deployment.am.config."deployment\.toml"=resources/controlplane-deployment.toml
```

NOTE:
  If you do not have sufficient resources you can adjust them setting following values when installing the chart.
  ```
  --set wso2.deployment.am.resources.requests.memory=2Gi \
  --set wso2.deployment.am.resources.requests.cpu=2000m \
  --set wso2.deployment.am.resources.limits.memory=2Gi \
  --set wso2.deployment.am.resources.limits.cpu=2000m
  ```


The above steps will deploy the deployment pattern using WSO2 product Docker images available at DockerHub, in the namespace `apim`,
with the service name `wso2am-single-node-am-service` and with the hostname `am.wso2.com`.

Delete the Ingress resource of gateway component of the WSO2 API Manager, so let's install Choreo Connect as the gateway component.
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

NOTE:
  If you do not have sufficient resources you can adjust them setting following values when installing the chart.
    ```
    --set wso2.deployment.adapter.resources.requests.memory=300Mi \
    --set wso2.deployment.adapter.resources.requests.cpu=300m \
    --set wso2.deployment.adapter.resources.limits.memory=500Mi \
    --set wso2.deployment.adapter.resources.limits.cpu=500m \

    --set wso2.deployment.gatewayRuntime.enforcer.resources.requests.memory=500Mi \
    --set wso2.deployment.gatewayRuntime.enforcer.resources.requests.cpu=500m \
    --set wso2.deployment.gatewayRuntime.enforcer.resources.limits.memory=1000Mi \
    --set wso2.deployment.gatewayRuntime.enforcer.resources.limits.cpu=1000m \

    --set wso2.deployment.gatewayRuntime.router.resources.requests.memory=300Mi \
    --set wso2.deployment.gatewayRuntime.router.resources.requests.cpu=500m \
    --set wso2.deployment.gatewayRuntime.router.resources.limits.memory=500Mi \
    --set wso2.deployment.gatewayRuntime.router.resources.limits.cpu=1000m
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


### 2. Obtain the external IP

Obtain the external IP (`EXTERNAL-IP`) of the Chore Connect Ingress resource, by listing down the Kubernetes Ingresses.

```  
kubectl get ing -n <NAMESPACE>
```

The output under the relevant column stands for the following.

Choreo Connect Adapter
- NAME: Metadata name of the Kubernetes Ingress resource (defaults to "<RELEASE_NAME>-choreo-connect-adapter-ingress")
- HOSTS: Hostname of the Choreo Connect Adapter (defaults to "adapter.wso2.com")
- ADDRESS: External IP (`EXTERNAL-IP`) exposing the Chore Connect Adapter to outside of the Kubernetes environment
- PORTS: Externally exposed service ports of the Choreo Connect Adapter

Choreo Connect Gateway
- NAME: Metadata name of the Kubernetes Ingress resource (defaults to "<RELEASE_NAME>-choreo-connect-ingress"")
- HOSTS: Hostname of the gateway service (defaults to "gw.wso2.com")
- ADDRESS: External IP (`EXTERNAL-IP`) exposing the gateway to outside of the Kubernetes environment
- PORTS: Externally exposed gateway ports of the Choreo Connect

### 3. Add a DNS record mapping the hostnames and the external IP

If the defined hostnames (in the previous step) are backed by a DNS service, add a DNS record mapping the hostnames and
the external IP (`EXTERNAL-IP`) in the relevant DNS service.

If the defined hostnames are not backed by a DNS service, for the purpose of evaluation you may add an entry mapping the
hostnames and the external IP in the `/etc/hosts` file at the client-side.

```
<EXTERNAL-IP> <wso2.deployment.am.ingress.management.hostname> <wso2.deployment.am.ingress.gateway.hostname>
```



##### 2. Provide configurations.

a. The default product configurations are available at `<HELM_HOME>/confs` folder. Change the
configurations as necessary.

b. Open the `<HELM_HOME>/values.yaml` and provide the following values.

###### WSO2 Subscription Configurations

| Parameter                                                                   | Description                                                                               | Default Value               |
|-----------------------------------------------------------------------------|-------------------------------------------------------------------------------------------|-----------------------------|
| `wso2.subscription.username`                                                | Your WSO2 Subscription username                                                           | ""                          |
| `wso2.subscription.password`                                                | Your WSO2 Subscription password                                                           | ""                          |

If you do not have active WSO2 subscription do not change the parameters `wso2.deployment.username`, `wso2.deployment.password`. 

###### Centralized Logging Configurations

| Parameter                                                                   | Description                                                                               | Default Value               |
|-----------------------------------------------------------------------------|-------------------------------------------------------------------------------------------|-----------------------------|
| `wso2.centralizedLogging.enabled`                                           | Enable Centralized logging for WSO2 components                                            | true                        |                                                                                         |                             |    
| `wso2.centralizedLogging.logstash.imageTag`                                 | Logstash Sidecar container image tag                                                      | 7.2.0                       |  
| `wso2.centralizedLogging.logstash.elasticsearch.username`                   | Elasticsearch username                                                                    | elastic                     |  
| `wso2.centralizedLogging.logstash.elasticsearch.password`                   | Elasticsearch password                                                                    | changeme                    |  
| `wso2.centralizedLogging.logstash.indexNodeID.wso2ISNode`                   | Elasticsearch IS Node log index ID(index name: ${NODE_ID}-${NODE_IP})                     | wso2                        |

###### Micro Gateway Configurations

| Parameter                                                                   | Description                                                                               | Default Value               |
|-----------------------------------------------------------------------------|-------------------------------------------------------------------------------------------|-----------------------------|
| `wso2.deployment.wso2microgw.dockerRegistry`                                | Docker registry of the microgateway image                                                 | ""                          |
| `wso2.deployment.wso2microgw.imageName`                                     | Image name for microgateway node                                                          | ""                          |
| `wso2.deployment.wso2microgw.imageTag`                                      | Image tag for microgateway node                                                           | ""                          |
| `wso2.deployment.wso2microgw.replicas`                                      | Number of replicas for microgateway node                                                  | 1                           |
| `wso2.deployment.wso2microgw.minReadySeconds`                               | Refer to [doc](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.10/#deploymentspec-v1-apps)| 1  75                        |
| `wso2.deployment.wso2microgw.strategy.rollingUpdate.maxSurge`               | Refer to [doc](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.10/#deploymentstrategy-v1-apps) | 1                           |
| `wso2.deployment.wso2microgw.strategy.rollingUpdate.maxUnavailable`         | Refer to [doc](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.10/#deploymentstrategy-v1-apps) | 0                           |
| `wso2.deployment.wso2microgw.livenessProbe.initialDelaySeconds`             | Initial delay for the live-ness probe for microgateway node                               | 40                           |
| `wso2.deployment.wso2microgw.livenessProbe.periodSeconds`                   | Period of the live-ness probe for microgateway node                                       | 10                           |
| `wso2.deployment.wso2microgw.readinessProbe.initialDelaySeconds`            | Initial delay for the readiness probe for microgateway node                               | 40                           |
| `wso2.deployment.wso2microgw.readinessProbe.periodSeconds`                  | Period of the readiness probe for microgateway node                                       | 10                           |
| `wso2.deployment.wso2microgw.imagePullPolicy`                               | Refer to [doc](https://kubernetes.io/docs/concepts/containers/images#updating-images)     | Always                       |
| `wso2.deployment.wso2microgw.resources.requests.memory`                     | The minimum amount of memory that should be allocated for a Pod                           | 1Gi                          |
| `wso2.deployment.wso2microgw.resources.requests.cpu`                        | The minimum amount of CPU that should be allocated for a Pod                              | 2000m                        |
| `wso2.deployment.wso2microgw.resources.limits.memory`                       | The maximum amount of memory that should be allocated for a Pod                           | 2Gi                          |
| `wso2.deployment.wso2microgw.resources.limits.cpu`                          | The maximum amount of CPU that should be allocated for a Pod                              | 2000m                        |

**Note**: The above mentioned default, minimum resource amounts for running WSO2 API Microgateway are based on its [official documentation](https://docs.wso2.com/display/MG301/Installation+Prerequisites#InstallationPrerequisites-MicrogatewayRuntime).

##### 3. Deploy WSO2 Identity server.

```
helm install --dep-up --name <RELEASE_NAME> <HELM_HOME> --namespace <NAMESPACE>
```

`NAMESPACE` should be the Kubernetes Namespace in which the resources are deployed

##### 4. Access Management Console.

Default deployment will expose `<RELEASE_NAME>` host (to expose Administrative services and Management Console).

To access the console in the environment,

a. Obtain the external IP (`EXTERNAL-IP`) of the Ingress resources by listing down the Kubernetes Ingresses.

```
kubectl get ing -n <NAMESPACE>
```

```
NAME                       HOSTS                ADDRESS        PORTS     AGE
wso2micro-gw-ingress       <RELEASE_NAME>       <EXTERNAL-IP>  80, 443   3m
```

b. Add the above host as an entry in /etc/hosts file as follows:

```
<EXTERNAL-IP>	<RELEASE_NAME>
```

## Enabling Centralized Logging

Centralized logging with Logstash and Elasticsearch is disabled by default. However, if it is required to be enabled, 
the following steps should be followed.

1. Set `centralizedLogging.enabled` to `true` in the [values.yaml](values.yaml) file.
2. Add elasticsearch Helm repository to download sub-charts required for Centralized logging.
```
helm repo add elasticsearch https://helm.elastic.co
```
3. Create a requirements.yaml at <HELM_HOME> and add the following dependencies in the file.
```
dependencies:
  - name: kibana
    version: "7.2.1-0"
    repository: "https://helm.elastic.co"
    condition: wso2.centralizedLogging.enabled
  - name: elasticsearch
    version: "7.2.1-0"
    repository: "https://helm.elastic.co"
    condition: wso2.centralizedLogging.enabled

```
4. Add override configurations for Elasticsearch in the [values.yaml](values.yaml) file.
```
wso2:
  ( ... )
  
elasticsearch:
  clusterName: wso2-elasticsearch
```
