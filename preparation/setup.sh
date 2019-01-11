kubectl apply -f rbac-tiller.yaml
helm init --service-account tiller
sleep 60
helm install --name nginx-ingress stable/nginx-ingress --namespace kube-system --set controller.hostNetwork=true,controller.kind=DaemonSet,controller.service.type=ClusterIP
helm install --name cert-manager --namespace kube-system stable/cert-manager --set createCustomResource=false
helm upgrade --install --namespace kube-system cert-manager stable/cert-manager --set createCustomResource=true
kubectl apply -f ClusterIssuer-letsencrypt.yaml
