FROM node:22.12.0-bookworm-slim

WORKDIR /app

ENV CI=true

COPY package.json ./
RUN npm install

COPY . .

CMD ["npm", "test"]
