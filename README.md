# eyra-k8s
Kubernetes configuration for EYRA deployment

- Create a Kubernetes cluster
- Allow ports 80 and 443 in the firewall for the cluster
- Add the kubectl config for the cluster to your ~/.kube/config
- Run preparation/setup.sh
- Create secret for postgres (see preparation/create_secret.txt for the command)
- helm install --name eyra ./eyra-chart

