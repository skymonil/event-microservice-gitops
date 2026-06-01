ARG ARGOCD_VERSION="v3.4.3"
FROM quay.io/argoproj/argocd:${ARGOCD_VERSION}

ARG SOPS_VERSION=3.13.1
ARG AGE_VERSION=1.3.1
ARG HELM_SECRETS_VERSION=4.7.6

ENV HELM_SECRETS_BACKEND="sops" \
    HELM_SECRETS_HELM_PATH=/usr/local/bin/helm \
    HELM_SECRETS_WRAPPER_ENABLED=false \
    HELM_PLUGINS=/gitops-tools/helm-plugins/ \
    HELM_SECRETS_SOPS_PATH=/gitops-tools/sops \
    HELM_SECRETS_AGE_PATH=/gitops-tools/age \
    PATH="$PATH:/gitops-tools"

USER root
RUN apt-get update && \
    apt-get install -y wget && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    mkdir -p /gitops-tools/helm-plugins

SHELL ["bash", "-c"]

RUN set -exuo pipefail \
    && wget -qO "${HELM_SECRETS_SOPS_PATH}" \
      "https://github.com/getsops/sops/releases/download/v${SOPS_VERSION}/sops-v${SOPS_VERSION}.linux.amd64" \
    && wget -qO- \
      "https://github.com/jkroepke/helm-secrets/releases/download/v${HELM_SECRETS_VERSION}/helm-secrets.tar.gz" \
      | tar -C "${HELM_PLUGINS}" -xzf- \
    && wget -qO- \
      "https://github.com/FiloSottile/age/releases/download/v${AGE_VERSION}/age-v${AGE_VERSION}-linux-amd64.tar.gz" \
      | tar -xzf- --strip-components=1 -C "${HELM_SECRETS_AGE_PATH%/*}" age/age \
    && chmod +x \
        "${HELM_SECRETS_SOPS_PATH}" \
        "${HELM_SECRETS_AGE_PATH}" \
    && ln -sf "${HELM_PLUGINS}/helm-secrets/scripts/wrapper/helm.sh" /usr/local/sbin/helm

USER 999