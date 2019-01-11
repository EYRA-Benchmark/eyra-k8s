#!/usr/bin/env bash
NAMESPACE=default
SERVER=$(kubectl config view -o jsonpath='{.clusters[0].cluster.server}')
SECRET_NAME=$(kubectl get serviceAccounts travis -o jsonpath='{.secrets[0].name}')
TOKEN=$(kubectl get secret/$SECRET_NAME -o jsonpath='{.data.token}' | base64 -d)
CA=$(kubectl get secret/$SECRET_NAME -o jsonpath='{.data.ca\.crt}')
echo "
apiVersion: v1
kind: Config
clusters:
- name: default-cluster
  cluster:
    certificate-authority-data: ${CA}
    server: ${SERVER}
contexts:
- name: default-context
  context:
    cluster: default-cluster
    namespace: ${NAMESPACE}
    user: default-user
current-context: default-context
users:
- name: default-user
  user:
    token: ${TOKEN}
"
