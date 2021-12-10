FROM node:10
WORKDIR myapp
COPY . .
RUN npm install
EXPOSE 80
ENTRYPOINT npm start