FROM node
ARG DIR/var/node
WORKDIR $DIR
COPY weather-app $DIR
RUN npm install
CMD ./bin/www

