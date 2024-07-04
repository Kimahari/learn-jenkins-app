FROM node:22-alpine
WORKDIR /app
RUN npm i serve -g
EXPOSE 3000
COPY ./build .
CMD [ "serve" ]