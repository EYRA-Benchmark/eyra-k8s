# eyra-k8s
Kubernetes configuration for EYRA deployment

- Create a Kubernetes cluster
- Allow ports 80 and 443 in the firewall for the cluster
- Add the kubectl config for the cluster to your ~/.kube/config
- Run preparation/setup.sh
- helm install --name eyra ./eyra-chart
- kubectl exec -it web-xxxxxx /bin/bash
- python manage.py migrate
- python manage.py check_permissions
- python manage.py initcomicdemo (this end with an error...)

# Creating a dev namespace

- kubectl create namespace tom-dev

# Use a local PyCharm dev server with the cluster

- ensure telepresence is installed
- telepresence --swap-deployment <name of your web deployment> --expose 8000 --run /bin/bash
- Start PyCharm from the new bash terminal
- Open the grandchallenge project
- Run the dev server in PyCharm (no environment variables set)

