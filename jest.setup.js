const screenshotOptions = { fullPage: true };

function matchOptions(name) {
    return {
        customSnapshotsDir: './baseline/',
        customSnapshotIdentifier: name,
    };
}

async function takeSnapshot(name, page) {
    await page.mouse.move(0, 0);
    const image = await page.screenshot(screenshotOptions);
    expect(image).toMatchImageSnapshot(matchOptions(name));
}

global.takeSnapshot = takeSnapshot;