const puppeteer = require('puppeteer');
const assert = require('assert');

describe('sprint 2', () => {
  before(async () => {
    browser = await puppeteer.launch({ headless: 'new', });
    page = await browser.newPage();
    await page.setViewport({ width: 1080, height: 1024 });
  });

  after(async () => {
    await browser.close();
  });

  it('open main page', async () => {
    await page.goto('http://localhost:3000/');

    const textSelector = await page.waitForSelector('body');
    const body = await textSelector?.evaluate(el => el.textContent);
    assert.notEqual(body, '');
  });
});
