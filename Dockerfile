FROM node:16-alpine

# 安装 bash
RUN apk add --no-cache bash

# 设置工作目录
WORKDIR /app

# 设置生产环境变量
ENV NODE_ENV=production

# 拷贝并安装依赖（仅 package*.json）
COPY src/package*.json ./
RUN npm install --omit=dev

# 拷贝应用源码与脚本
COPY src/ ./
COPY wait-for-it.sh ./
RUN chmod +x wait-for-it.sh

# 暴露端口
EXPOSE 3000

# 启动命令：等待 PostgreSQL 就绪后运行服务
CMD ["sh","-c","./wait-for-it.sh ${PGHOST:-postgres-postgresql}:${PGPORT:-5432} -- npm start"]