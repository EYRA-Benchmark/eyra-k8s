Notes
-----

When adding charts to requirements.yaml, retrieve the charts by calling::

    helm dependency update

To update google social api keys::

    helm upgrade eyra ./eyra-chart -f ./eyra-chart/values.yaml --set "SOCIAL_AUTH_GOOGLE_OAUTH2_SECRET=<GOOGLE_API_SECRET>,SOCIAL_AUTH_GOOGLE_OAUTH2_KEY=<GOOGLE_API_CLIENT_ID>"

To update the helm configuration in the cluster after changing the helm chart::

    helm upgrade -f ./eyra-chart/values.yaml eyra ./eyra-chart

Docker registry listing::

    curl -X GET https://docker-registry.roel.dev.eyrabenchmark.net/v2/_catalog
    curl -X GET https://docker-registry.roel.dev.eyrabenchmark.net/v2/rzi/blabla/tags/list
    
Push image to Docker registry::

    docker tag <image hash> docker-registry.roel.dev.eyrabenchmark.net/<repository>
    docker push docker-registry.roel.dev.eyrabenchmark.net/<repository>
    
Update secrets.yaml (use password from LastPass)::
    
    zip -e secrets.zip secrets.yaml