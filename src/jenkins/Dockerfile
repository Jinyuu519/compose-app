FROM jenkins/jenkins:lts

USER root

# 安装 Docker CLI、Node.js、npm
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        docker.io \
        nodejs \
        npm && \
    rm -rf /var/lib/apt/lists/*

# 安装 Docker Compose v2 插件（官方推荐方式）
RUN mkdir -p /usr/lib/docker/cli-plugins && \
    curl -SL https://github.com/docker/compose/releases/download/v2.27.0/docker-compose-linux-x86_64 \
      -o /usr/lib/docker/cli-plugins/docker-compose && \
    chmod +x /usr/lib/docker/cli-plugins/docker-compose

# 添加 jenkins 用户到 docker 组
RUN usermod -aG docker jenkins

USER jenkins
