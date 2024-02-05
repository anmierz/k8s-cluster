# Klaster K8S na libvirt i Archlinuxie


## Test klastra
```
kubectl --kubeconfig /tmp/admin.conf create namespace proba
kubectl --kubeconfig /tmp/admin.conf create -n proba deployment nginx --image=docker.io/nginx --port=80
kubectl --kubeconfig /tmp/admin.conf expose -n proba deployment/nginx --type="LoadBalancer" --port 80
kubectl --kubeconfig /tmp/admin.conf get -n proba services
```