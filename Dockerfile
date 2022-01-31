FROM node:16.13.1-alpine as build

WORKDIR /app
ENV PATH /path/node_modules/.bin:$PATH
COPY package.json ./
COPY package-lock.json ./
RUN npm install --silent
RUN npm install react-scripts -g --silent
COPY . ./
RUN npm run build

FROM nginx:stable-alpine
COPY --from=build /app/docs /usr/share/nginx/html
COPY nginx.template /etc/nginx/templates/default.conf.template

ENV NGINX_PORT 80

CMD ["nginx", "-g", "daemon off;"]