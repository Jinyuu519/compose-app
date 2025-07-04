FROM node:16-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
EXPOSE 3000
COPY wait-for-it.sh .
CMD ["./wait-for-it.sh", "db:5432", "--", "npm", "start"]
