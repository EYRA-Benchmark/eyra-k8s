# eyra-k8s
Kubernetes configuration for EYRA deployment.

NOTE: The cluster has helm 2.12.0 installed: make sure your helm version matches this!

- Create a Kubernetes cluster
- Allow ports 80 and 443 in the firewall for the cluster
- Add the kubectl config for the cluster to your ~/.kube/config
- Run preparation/setup.sh
- helm install --name eyra ./eyra-chart
- kubectl exec -it web-xxxxxx /bin/bash
- python manage.py migrate
- python manage.py check_permissions
- python manage.py create_demo_benchmark

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

## Telepresence crash
One thing that can happen is that telepresence crashes (I haven't seen this), or that your machine falls off the network for any reason (bad wifi, laptop lid closed, etc.). Unfortunately, telepresence doesn't clean up in this case, leaving the original service unreachable. In this case you can do the following to restore the original deployment:
- kubectl delete svc,deploy -l telepresence
- kubectl scale --replicas=1 deploy [original deployment name]

## Notes

When adding charts to requirements.yaml, retrieve the charts by calling::

    helm dependency update

To update google social api keys::

    helm upgrade eyra ./eyra-chart -f ./eyra-chart/values.yaml --set "SOCIAL_AUTH_GOOGLE_OAUTH2_SECRET=<GOOGLE_API_SECRET>,SOCIAL_AUTH_GOOGLE_OAUTH2_KEY=<GOOGLE_API_CLIENT_ID>"

To update the helm configuration in the cluster after changing the helm chart (assuming you are in the root of this repo)::

    helm upgrade -f ./eyra-chart/values.dev-<your name>.yaml eyra-dev-<your name> ./eyra-chart

Docker registry listing::

    curl -X GET https://docker-registry.roel.dev.eyrabenchmark.net/v2/_catalog
    curl -X GET https://docker-registry.roel.dev.eyrabenchmark.net/v2/rzi/blabla/tags/list
    
Push image to Docker registry::

    docker tag <image hash> docker-registry.roel.dev.eyrabenchmark.net/<repository>
    docker push docker-registry.roel.dev.eyrabenchmark.net/<repository>
    
Update secrets.yaml (use password from LastPass)::
    
    zip -e secrets.zip secrets.yaml
