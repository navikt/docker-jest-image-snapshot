FROM buildkite/puppeteer:v1.9.0
COPY VERSION /
RUN mkdir /app
WORKDIR /app

COPY ./package.json /app/
RUN npm i

COPY ./jest.config.js ./jest.setupTestFramework.js ./html-image-reporter.js ./jest.setup.js /app/

ENTRYPOINT ["npm", "run"]