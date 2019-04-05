#Taint GPU Nodes:
kubectl get nodes "-o=custom-columns=NAME:.metadata.name,GPU:.status.allocatable.nvidia\.com/gpu" | awk '$2 == 1 { print $1 }' | xargs -I@ kubectl taint nodes @ nvidia\.com/gpu=true:NoSchedule

export TILLER_NAMESPACE=tiller
kubectl create namespace tiller
kubectl apply -f rbac-tiller.yaml
# note https://docs.helm.sh/using_helm/#securing-your-helm-installation
helm init --service-account tiller --tiller-namespace tiller

sleep 60
# ingress-controller (not needed if using managed load-balancer"
# helm install --name nginx-ingress stable/nginx-ingress --namespace kube-system --set controller.hostNetwork=true,controller.kind=DaemonSet,controller.service.type=ClusterIP
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/mandatory.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/provider/aws/service-l4.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/provider/aws/patch-configmap-l4.yaml


# cert manager: https://docs.cert-manager.io/en/latest/getting-started/install.html#installing-with-helm
kubectl apply -f https://raw.githubusercontent.com/jetstack/cert-manager/release-0.7/deploy/manifests/00-crds.yaml
kubectl create namespace cert-manager
kubectl label namespace cert-manager certmanager.k8s.io/disable-validation=true
helm repo add jetstack https://charts.jetstack.io
helm repo update
helm install \
  --name cert-manager \
  --namespace cert-manager \
  --version v0.7.0 \
  jetstack/cert-manager

kubectl apply -f ClusterIssuer-letsencrypt.yaml

echo "To setup logging, please run:"
echo "kubectl -n kube-system create secret generic fluent-bit --from-literal=loggly_token='my_loggly_token'"
echo "kubectl apply -f fluent-bit-rbac.yaml"
echo "kubectl apply -f fluent-bit-configmap-loggly.yaml"
echo "kubectl apply -f fluent-bit-daemonset-loggly.yaml"
