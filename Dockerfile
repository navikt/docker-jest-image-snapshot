FROM buildkite/puppeteer:v1.9.0
COPY VERSION /
RUN mkdir /app
WORKDIR /app

COPY ./package.json /app/
RUN npm i

COPY ./jest.config.js ./jest.setup.js ./html-image-reporter.js ./utils.js /app/

ENTRYPOINT ["npm", "run"]