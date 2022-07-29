# Changelog

All notable changes to Kubernetes and Helm resources for Choreo Connect version `1.0.x` in each resource release,
will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/)

## [v1.0.0.1] - 2022-01-27

### Added

- Helm resources for Choreo Connect Deployment (refer to [issue](https://github.com/wso2/kubernetes-microgateway/issues/22)).

For detailed information on the tasks carried out during this release, please see the GitHub milestone [v1.0.0.1](https://github.com/wso2/kubernetes-microgateway/milestone/3)

## [v1.0.0.2] - 2022-04-20

### Added

- Enable configuring multiple APIM Control Plane listener services and Traffic Manager services (refer to [issue](https://github.com/wso2/kubernetes-microgateway/issues/32)).

For detailed information on the tasks carried out during this release, please see the GitHub milestone [v1.0.0.2](https://github.com/wso2/kubernetes-microgateway/milestone/4)

## [v1.0.0.3] - 2022-06-23

### Changed

- Readiness and liveness probe endpoints (refer to [issue](https://github.com/wso2/kubernetes-microgateway/issues/40)).

For detailed information on the tasks carried out during this release, please see the GitHub milestone [v1.0.0.3](https://github.com/wso2/kubernetes-microgateway/milestone/7)

## [v1.0.0.4] - 2022-07-11

### Added

- Mount empty dir to write Router heap/CPU profile data (refer to [issue](https://github.com/wso2/kubernetes-microgateway/issues/49)).
- Override Docker registry in component level (refer to [issue](https://github.com/wso2/kubernetes-microgateway/issues/50)).

For detailed information on the tasks carried out during this release, please see the GitHub milestone [v1.0.0.4](https://github.com/wso2/kubernetes-microgateway/milestone/9)

## [v1.0.0.5] - 2022-07-14

### Added

- Expose HTTP port of the Router component and make ingress target port configurable (refer to [issue](https://github.com/wso2/kubernetes-microgateway/issues/54)).
- Make automountServiceAccountToken configurable in each component (refer to [issue](https://github.com/wso2/kubernetes-microgateway/issues/55)).

For detailed information on the tasks carried out during this release, please see the GitHub milestone [v1.0.0.5](https://github.com/wso2/kubernetes-microgateway/milestone/11)

## [v1.0.0.6] - 2022-07-29

### Added

- Add new configuration to prevent mounting an empty directory for adapter artifacts (refer to [issue](https://github.com/wso2/kubernetes-microgateway/issues/63))
- Add new configuration to prevent mounting an empty directory for enforcer dropins JARs (refer to [issue](https://github.com/wso2/kubernetes-microgateway/issues/65))

### Changed

- Update default ingress TLS secrets (refer to [issue](https://github.com/wso2/kubernetes-microgateway/issues/69))

For detailed information on the tasks carried out during this release, please see the GitHub milestone [v1.0.0.6](https://github.com/wso2/kubernetes-microgateway/milestone/13) 

## [v1.0.0.7] - 2022-07-29

### Fixed

- Error applying Router backendCaCerts (refer to [issue](https://github.com/wso2/kubernetes-microgateway/issues/76))

For detailed information on the tasks carried out during this release, please see the GitHub milestone [v1.0.0.7](https://github.com/wso2/kubernetes-microgateway/milestone/15)
