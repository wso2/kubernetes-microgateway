
# Helm Chart for deployment of WSO2 API Microgateway

## Contents
*  [Prerequisites](#prerequisites)
*  [Quick Start Guide](#quick-start-guide)
*  [Configuration](#configuration)
*  [Enabling Centralized Logging](#enabling-centralized-logging)

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
### 1. Install Chart From Source

>In the context of this document, <br>
>*  `KUBERNETES_HOME` will refer to a local copy of the [`wso2/kubernetes-microgateway`](https://github.com/wso2/kubernetes-microgateway/) Git repository. <br>
>*  `HELM_HOME` will refer to `<KUBERNETES_HOME>/helm/microgateway`. <br>

##### Clone the Helm Resources for WSO2 API Microgateway Git repository.
```
git clone https://github.com/wso2/kubernetes-microgateway.git
```

##### Deploy Helm chart for WSO2 API Microgateway deployment.
Helm version 2
 ```
 helm install --dep-up --name <RELEASE_NAME> <HELM_HOME> --namespace <NAMESPACE>
 ```
 
Helm version 3
 - Deploy the Kubernetes resources using the Helm Chart
    ```
    helm install <RELEASE_NAME> <HELM_HOME> --namespace <NAMESPACE> --dependency-update --create-namespace
    ```
### 2. Obtain the external IP

Obtain the external IP (`EXTERNAL-IP`) of the API Microgateway Ingress resources, by listing down the Kubernetes Ingresses.
```  
kubectl get ing -n <NAMESPACE>
```

The output under the relevant column stands for the following.

API  Microgateway

- NAME: Metadata name of the Kubernetes Ingress resource (defaults to `wso2micro-gw-ingress`)
- HOSTS: Hostname of the WSO2 API Microgateway service (`<wso2.deployment.wso2microgw.ingress.hostname>`)
- ADDRESS: External IP (`EXTERNAL-IP`) exposing the API Microgateway service to outside of the Kubernetes environment
- PORTS: Externally exposed service ports of the API Microgateway service

### 3. Add a DNS record mapping the hostnames and the external IP

If the defined hostnames (in the previous step) are backed by a DNS service, add a DNS record mapping the hostnames and
the external IP (`EXTERNAL-IP`) in the relevant DNS service.

If the defined hostnames are not backed by a DNS service, for the purpose of evaluation you may add an entry mapping the
hostnames and the external IP in the `/etc/hosts` file at the client-side.

```
<EXTERNAL-IP> <wso2.deployment.wso2microgw.ingress.hostname>
```

## Configuration

The following tables lists the configurable parameters of the chart and their default values.

###### WSO2 Subscription Configurations
| Parameter | Description | Default Value |
|-----------------------------------------------------------------------------|-------------------------------------------------------------------------------------------|-----------------------------|
| `wso2.subscription.username` | Your WSO2 Subscription username | "" |
| `wso2.subscription.password` | Your WSO2 Subscription password | "" |
  
If you do not have an active WSO2 subscription, **do not change** the parameters `wso2.subscription.username` and `wso2.subscription.password`.


###### Centralized Logging Configurations 
| Parameter | Description | Default Value |
|-----------------------------------------------------------------------------|-------------------------------------------------------------------------------------------|-----------------------------|
| `wso2.centralizedLogging.enabled` | Enable Centralized logging for WSO2 components | false | | |
| `wso2.centralizedLogging.logstash.config.logstashYaml` | Logstash custom deployment configuration file | - |
| `wso2.centralizedLogging.logstash.config.logstashConf` | Logstash custom deployment configuration file | - |
| `wso2.centralizedLogging.logstash.elasticsearch.username` | Elasticsearch username | elastic |
| `wso2.centralizedLogging.logstash.elasticsearch.password` | Elasticsearch password | changeme |
| `wso2.centralizedLogging.logstash.indexNodeID.wso2ISNode` | Elasticsearch IS Node log index ID(index name: ${NODE_ID}-${NODE_IP}) | wso2 |
  
###### Micro Gateway Configurations
| Parameter | Description | Default Value |
|-----------------------------------------------------------------------------|-------------------------------------------------------------------------------------------|-----------------------------|
| `wso2.deployment.wso2microgw.dockerRegistry` | Docker registry of the microgateway image | "" |
| `wso2.deployment.wso2microgw.imageName` | Image name for microgateway node | "" |
| `wso2.deployment.wso2microgw.imageTag` | Image tag for microgateway node | "" |
| `wso2.deployment.wso2microgw.replicas` | Number of replicas for microgateway node | 1 |
| `wso2.deployment.wso2microgw.minReadySeconds` | Refer to [doc](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.10/#deploymentspec-v1-apps)| 1 75 |
| `wso2.deployment.wso2microgw.strategy.rollingUpdate.maxSurge` | Refer to [doc](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.10/#deploymentstrategy-v1-apps) | 1 |
| `wso2.deployment.wso2microgw.strategy.rollingUpdate.maxUnavailable` | Refer to [doc](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.10/#deploymentstrategy-v1-apps) | 0 |
| `wso2.deployment.wso2microgw.livenessProbe.initialDelaySeconds` | Initial delay for the live-ness probe for microgateway node | 40 |
| `wso2.deployment.wso2microgw.livenessProbe.periodSeconds` | Period of the live-ness probe for microgateway node | 10 |
| `wso2.deployment.wso2microgw.readinessProbe.initialDelaySeconds` | Initial delay for the readiness probe for microgateway node | 40 |
| `wso2.deployment.wso2microgw.readinessProbe.periodSeconds` | Period of the readiness probe for microgateway node | 10 |
| `wso2.deployment.wso2microgw.imagePullPolicy` | Refer to [doc](https://kubernetes.io/docs/concepts/containers/images#updating-images) | Always |
| `wso2.deployment.wso2microgw.resources.requests.memory` | The minimum amount of memory that should be allocated for a Pod | 1Gi |
| `wso2.deployment.wso2microgw.resources.requests.cpu` | The minimum amount of CPU that should be allocated for a Pod | 2000m |
| `wso2.deployment.wso2microgw.resources.limits.memory` | The maximum amount of memory that should be allocated for a Pod | 2Gi |
| `wso2.deployment.wso2microgw.resources.limits.cpu` | The maximum amount of CPU that should be allocated for a Pod | 2000m |
| `wso2.deployment.wso2microgw.ingress.hostname` | Hostname for Microgateway | am.wso2.com |
| `wso2.deployment.wso2microgw.ingress.annotations` | Ingress resource annotations for Microgateway  | - |
| `wso2.deployment.wso2microgw.config` | Custom deployment configuration file for Microgateway  | - |

## Enabling Centralized Logging
Centralized logging with Logstash and Elasticsearch is disabled by default. However, if it is required to be enabled, the following steps should be followed.

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
