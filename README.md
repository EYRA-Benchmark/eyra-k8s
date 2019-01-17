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

# Get a local shell connected to the cluster

- `telepresence --run-shell`
- If you want your env vars to be copied from a pods env, first copy the
  env, then export your local env back because it overwrites some values:
```
# run telepresence with sh, so that import/export is consistent
telepresence --run sh
OLD_ENV=$(export -p)
set -o allexport
$(kubectl exec eyra-dev-tom-web-5958f799b6-ng2cv sh -- -c env)
set +o allexport
eval $OLD_ENV
```
# Use a local PyCharm dev server with the cluster

- ensure telepresence is installed
- telepresence --swap-deployment <name of your web deployment> --expose 8000 --run /bin/bash
- Start PyCharm from the new bash terminal
- Open the grandchallenge project
- Run the dev server in PyCharm (no environment variables set)

