kubectl -n kube-system create configmap seccomp-profiles --from-file=../profiles
kubectl -n kube-system apply -f ../seccomp-profile-deploy.yaml