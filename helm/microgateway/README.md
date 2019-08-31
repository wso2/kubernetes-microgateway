# Helm Chart for deployment of WSO2 API Microgateway 

## Contents

* [Prerequisites](#prerequisites)
* [Quick Start Guide](#quick-start-guide)

## Prerequisites

* In order to use WSO2 Helm resources, you need an active WSO2 subscription. If you do not possess an active WSO2
  subscription already, you can sign up for a WSO2 Free Trial Subscription from [here](https://wso2.com/free-trial-subscription)
  . Otherwise you can proceed with docker images which are created using GA releases.<br><br>

* Install [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git), [Helm](https://github.com/kubernetes/helm/blob/master/docs/install.md)
(and Tiller) and [Kubernetes client](https://kubernetes.io/docs/tasks/tools/install-kubectl/) (compatible with v1.10) in order to run the 
steps provided in the following quick start guide.<br><br>

* An already setup [Kubernetes cluster](https://kubernetes.io/docs/setup/pick-right-solution/).<br><br>

* Install [NGINX Ingress Controller](https://kubernetes.github.io/ingress-nginx/deploy/). Please note that Helm resources for WSO2 product
deployment patterns are compatible with NGINX Ingress Controller Git release [`nginx-0.22.0`](https://github.com/kubernetes/ingress-nginx/releases/tag/nginx-0.22.0).
  
## Quick Start Guide
>In the context of this document, <br>
>* `KUBERNETES_HOME` will refer to a local copy of the [`wso2/kubernetes-microgateway`](https://github.com/wso2/kubernetes-microgateway/)
Git repository. <br>
>* `HELM_HOME` will refer to `<KUBERNETES_HOME>/helm/microgateway`. <br>

##### 1. Clone the Kubernetes Resources for WSO2 Identity Server Git repository.

```
git clone https://github.com/wso2/kubernetes-microgateway.git
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
