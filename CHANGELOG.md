# Changelog

All notable changes to Kubernetes and Helm resources for Choreo Connect version `1.2.x` in each resource release,
will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/)

## [v1.2.0.1] - 2023-03-22

### Added

- Helm resources for Choreo Connect Deployment (refer to [issue](https://github.com/wso2/kubernetes-microgateway/issues/106)).

### Removed

- Remove configs `apiArtifactsMountEmptyDir` and `dropinsMountEmptyDir` as the directories are already exists in Docker images (refer to [issue](https://github.com/wso2/kubernetes-microgateway/issues/61)).

### Fixed

- Remove unused environment variable `apim_admin_pwd` set in Enforcer (refer to [issue](https://github.com/wso2/kubernetes-microgateway/issues/87)).

For detailed information on the tasks carried out during this release, please see the GitHub milestone [v1.2.0.1](https://github.com/wso2/kubernetes-microgateway/milestone/20?closed=1)

## [v1.2.0.2] - 2023-09

### Added

- Support for mounting ConfigMaps and Secrets (refer to [issue](https://github.com/wso2/kubernetes-microgateway/issues/116)).

For detailed information on the tasks carried out during this release, please see the GitHub milestone [v1.2.0.2](https://github.com/wso2/kubernetes-microgateway/milestone/21?closed=1)
