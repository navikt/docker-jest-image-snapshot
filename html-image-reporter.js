const fs = require('fs');

const baselinePath = './baseline/__diff_output__';
const reportPath = './reports/jest-image-snapshot/';

const createImgTags = (files) => {
    return files.map(value =>
        `<div>
            <h4>${value}</h4>
            <img style="width: 100%" src="./${value}">
        </div>`
    );
};

function createHtml(files) {
    return `
<html>
    <head>
        <title>soknad-docker-jest-image-snapshot</title>
    </head>
    <body>
        <h1>Results</h1>
        ${createImgTags(files)}
    </body>
</html>
`;
}

function mkReportDir() {
    if(fs.existsSync(reportPath)) {
        const files = fs.readdirSync(reportPath);
        files.forEach(file => {
            fs.unlinkSync(`${reportPath}/${file}`);
        });
        fs.rmdirSync(reportPath);
    }
    fs.mkdirSync(reportPath);

}

class HtmlImageReporter {
    constructor(globalConfig, options) {
        this._globalConfig = globalConfig;
        this._options = options;
    }

    onTestResult(test, testResult) {
        if (testResult.numFailingTests && testResult.failureMessage.match(/different from snapshot/)) {
            mkReportDir();
            const files = fs.readdirSync(baselinePath);
            files.forEach((value) => {
                fs.copyFileSync(`${baselinePath}/${value}`, `${reportPath}/${value}`);
                fs.unlinkSync(`${baselinePath}/${value}`);
            });
            if(fs.existsSync(baselinePath)) {
                fs.rmdirSync(baselinePath);
            }
            fs.writeFileSync(`${reportPath}/index.html`, createHtml(files));
        }
    }
}

module.exports = HtmlImageReporter;