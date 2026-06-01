FROM quay.io/argoproj/argocd:v3.4.3

USER root

RUN apt-get update && \
    apt-get install -y wget && \
    rm -rf /var/lib/apt/lists/*

RUN wget -O /usr/local/bin/sops \
    https://github.com/getsops/sops/releases/download/v3.9.0/sops-v3.9.0.linux.amd64 && \
    chmod +x /usr/local/bin/sops

ENV HELM_PLUGINS=/home/argocd/.local/share/helm/plugins

RUN helm plugin install \
    https://github.com/jkroepke/helm-secrets \
    --version 4.6.2 && \
    sed -i '/platformCommand:/,+3 d' \
    /home/argocd/.local/share/helm/plugins/helm-secrets/plugin.yaml && \
    cat /home/argocd/.local/share/helm/plugins/helm-secrets/plugin.yaml

USER 999