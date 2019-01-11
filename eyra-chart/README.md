Notes
-----

When adding charts to requirements.yaml, retrieve the charts by calling::

    helm dependency update

To update google social api keys:
    helm upgrade eyra ./eyra-chart -f ./eyra-chart/values.yaml --set "SOCIAL_AUTH_GOOGLE_OAUTH2_SECRET=<GOOGLE_API_SECRET>,SOCIAL_AUTH_GOOGLE_OAUTH2_KEY=<GOOGLE_API_CLIENT_ID>"