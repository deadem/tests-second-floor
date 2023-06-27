const puppeteer = require('puppeteer');
const assert = require('assert');

describe('sprint 3', () => {
  before(async () => {
    browser = await puppeteer.launch({ headless: 'new', });
    page = await browser.newPage();
    await page.setViewport({ width: 1080, height: 1024 });
    await page.setDefaultTimeout(1000);
  });

  after(async () => {
    await browser.close();
  });

  it('open / page', async () => {
    await page.goto('http://localhost:3000/');
    await page.waitForSelector('body');

    const form = await page.waitForSelector('form');
    assert.notEqual(form, null, '<form> tag not found');

    const login = await form.$('input[name=login]');
    assert.notEqual(login, null, '<input name=login> not found. Login field required');

    const password = await form.$('input[name=password]');
    assert.notEqual(password, null, '<input name=password> not found. Password field required');

    const authSelectors = (await Promise.all([
      await form.$('::-p-text(Вход)'),
      await form.$('::-p-text(Sign in)'),
      await form.$('::-p-text(Войти)'),
      await form.$('::-p-text(Enter)'),
      await form.$('::-p-text(Авторизоваться)'),
    ])).flat().filter(Boolean).map(handle => handle.evaluate(node => node.closest('a[href],button')));

    const authButton = (await Promise.all(authSelectors)).filter(Boolean);
    assert.notEqual(authButton.length, 0, 'Authorize button not found. Check the button text');

    console.log(await Promise.all(authButton));
  });
});
