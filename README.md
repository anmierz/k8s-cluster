# Klaster K8S na libvirt i Archlinuxie


## Test klastra
```
kubectl --kubeconfig /tmp/admin.conf create namespace proba
kubectl --kubeconfig /tmp/admin.conf create -n proba deployment nginx --image=docker.io/nginx --port=80
kubectl --kubeconfig /tmp/admin.conf expose -n proba deployment/nginx --type="LoadBalancer" --port 80
kubectl --kubeconfig /tmp/admin.conf get -n proba services
```

# Test ingressa
```
kubectl --kubeconfig /tmp/admin.conf expose -n proba deployment/nginx --name=proba-2-svc --type="ClusterIP" --port 80
kubectl --kubeconfig /tmp/admin.conf create -n proba ingress proba --rule="alamakota.com/=proba-2-svc:80" --class=traefik
kubectl --kubeconfig /tmp/admin.conf get -A services
curl -H 'host: alamakota.com' http://192.168.105.200/
```