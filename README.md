# eyra-k8s

Kubernetes configuration for EYRA deployment.

# Deploying backend/frontend
Get the latest master build number from Travis (for frontend https://travis-ci.org/EYRA-Benchmark/eyra-frontend/builds).

Then, for frontend update `tag` line in `eyra-chart/values.staging.yaml`:

    eyra-frontend:
      image:
        repository: eyra/frontend
        tag: 456 # <- update with the latest Travis build number
        
To update the backend:

    web:
      debug: 'True'
      siteID: '2'
      imageName: 'eyra/comic:6' # <- update the number
      
After pushing to `master`, it should automatically update after 1 or 2 minutes.

# Setting up k8s initially

NOTE: The cluster has helm 2.12.0 installed: make sure your helm version matches this!

- Create a Kubernetes cluster
- Allow ports 80 and 443 in the firewall for the cluster
- Add the kubectl config for the cluster to your ~/.kube/config
- Run preparation/setup.sh
- helm install --name eyra ./eyra-chart
- ~~kubectl exec -it web-xxxxxx /bin/bash~~
- ~~python manage.py migrate~~
- ~~python manage.py check_permissions~~
- ~~python manage.py create_demo_benchmark~~

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
- Open the backend (comic) project
- Run the dev server in PyCharm (no environment variables set)

## Telepresence crash
One thing that can happen is that telepresence crashes (I haven't seen this), or that your machine falls off the network for any reason (bad wifi, laptop lid closed, etc.). Unfortunately, telepresence doesn't clean up in this case, leaving the original service unreachable. In this case you can do the following to restore the original deployment:
- kubectl delete svc,deploy -l telepresence
- kubectl scale --replicas=1 deploy [original deployment name]

## Notes

When adding charts to requirements.yaml, retrieve the charts by calling::

    helm dependency update

To update the helm configuration in the cluster after changing the helm chart (assuming you are in the root of this repo)::

    helm upgrade -f ./eyra-chart/values.dev-<your name>.yaml eyra-dev-<your name> ./eyra-chart
    
OR: Apply the auto-updater script, this polls this github repository for updates and applies them every minute:

    kubectl -n tiller create secret generic secrets-pass --from-literal=pass='secrets.zip_password'
    kubectl apply -f preparation/auto-updater.yaml`

Docker registry listing::

    curl -X GET https://docker-registry.roel.dev.eyrabenchmark.net/v2/_catalog
    curl -X GET https://docker-registry.roel.dev.eyrabenchmark.net/v2/rzi/blabla/tags/list
    
Push image to Docker registry::

    docker tag <image hash> docker-registry.roel.dev.eyrabenchmark.net/<repository>
    docker push docker-registry.roel.dev.eyrabenchmark.net/<repository>
    
Update secrets.yaml (use password from LastPass)::
    
    zip -e secrets.zip secrets.yaml

# Running locally
Install minikube: https://kubernetes.io/docs/setup/minikube/#installation

Start minikube: `minikube start`

Install helm:

    cd preparation
    export TILLER_NAMESPACE=tiller
    kubectl create namespace tiller
    kubectl apply -f rbac-tiller.yaml
    helm init --service-account tiller --tiller-namespace tiller
    minikube addons enable ingress

    cd ..
    helm install ./eyra-chart --name eyra-dev --namespace eyra-dev -f ./eyra-chart/values.dev.yaml
    # wait till done (might take a while, downloads images, prepares DB etc.

    # get minikube IP:
    minikube ip
    # remember IP, e.g. 192.168.99.100
    # add the following to /etc/hosts:
    192.168.99.100 eyra.local
    192.168.99.100 www.eyra.local
    192.168.99.100 api.eyra.local
    192.168.99.100 comic.eyra.local
    192.168.99.100 docker-registry.eyra.local
