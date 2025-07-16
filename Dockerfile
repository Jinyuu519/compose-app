FROM jenkins/jenkins:lts

USER root

# 设置工作目录
WORKDIR /app

# 安装必要工具：Docker CLI、Node.js、npm、curl、git、Helm、kubectl
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        docker.io \
        nodejs \
        npm \
        curl \
        git \
        unzip && \
    rm -rf /var/lib/apt/lists/*

# 安装 Docker Compose v2（CLI 插件方式）
RUN mkdir -p /usr/lib/docker/cli-plugins && \
    curl -SL https://github.com/docker/compose/releases/download/v2.27.0/docker-compose-linux-x86_64 \
      -o /usr/lib/docker/cli-plugins/docker-compose && \
    chmod +x /usr/lib/docker/cli-plugins/docker-compose

# 安装 Helm CLI
RUN curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# 安装 kubectl（与 Helm 搭配部署）
RUN curl -LO "https://dl.k8s.io/release/$(curl -Ls https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl && \
    rm kubectl

# npm 缓存优化（非必须）
RUN npm config set cache /tmp/npm-cache --global

# 添加 Jenkins 用户到 Docker 组（避免权限问题）
RUN usermod -aG docker jenkins

USER jenkins
