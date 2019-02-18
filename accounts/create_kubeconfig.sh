#!/usr/bin/env bash
NAMESPACE=kube-system
SERVER=$(kubectl config view -o jsonpath='{.clusters[0].cluster.server}')
SECRET_NAME=$(kubectl get -n kube-system serviceAccounts $1 -o jsonpath='{.secrets[0].name}')
TOKEN=$(kubectl get -n kube-system secret/$SECRET_NAME -o jsonpath='{.data.token}' | base64 -d)
CA=$(kubectl get -n kube-system secret/$SECRET_NAME -o jsonpath='{.data.ca\.crt}')
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
