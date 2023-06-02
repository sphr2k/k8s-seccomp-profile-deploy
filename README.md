# seccomp-profile-deploy

## Purpose

In our clusters, we enforce the Pod Security Standards `Restricted` profile which allows either the `RuntimeDefault` seccomp profile or a custom profile.

`seccomp-profile-deploy` is a simple DaemonSet that is used to copy seccomp profiles to every Kubernetes node in the cluster. The necessary profiles are expected to be provided via a `ConfigMap` called `seccomp-profiles`. An inline shell script copies the files to the default location (`/var/lib/kubelet/seccomp`) on each node. Afterwards, the DaemonSet sleeps infinitely.

In order to function, the DaemonSet needs access to the node filesystem. Therefore, it is highly recommended to deploy it within a namespace that restricts access to administrative roles.

## Using custom seccomp profiles

To use one of the custom seccomp profiles, you can reference it in your deployment:

  ```yaml
  securityContext:
    seccompProfile:
      type: Localhost
      localhostProfile: duckling.json
  ```

### Creating custom seccomp profiles

Here are some tools that can assist you in building custom seccomp profiles:

* [Inspektor Gadget](https://github.com/inspektor-gadget/inspektor-gadget)
* [Kubernetes Security Profiles Operator](https://github.com/kubernetes-sigs/security-profiles-operator)

When creating seccomp profiles, it is important to ensure that all relevant functions of the application are invoked. This guarantees that all necessary system calls made by the application are captured. Failing to invoke certain functions may lead to a mismatch between the seccomp profile and the actual system calls required by the application, potentially causing startup issues or application crashes.