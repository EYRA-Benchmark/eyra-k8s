kubectl apply -f rbac-tiller.yaml
helm init --service-account tiller
helm install --name nginx-ingress stable/nginx-ingress --namespace kube-system --set controller.hostNetwork=true,controller.kind=DaemonSet,controller.service.type=ClusterIP
# add firewall rules (80/443)
helm install --name cert-manager --namespace kube-system stable/cert-manager --set createCustomResource=false
helm upgrade --install --namespace kube-system cert-manager stable/cert-manager --set createCustomResource=true
kubectl apply -f ClusterIssuer-letsencrypt.yaml
kubectl apply -f test_ingress.yaml 
