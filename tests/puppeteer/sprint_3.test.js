const puppeteer = require('puppeteer');
const assert = require('assert');

describe('sprint 3. page /', () => {
  before(async () => {
    browser = await puppeteer.launch({ headless: 'new', });
    page = await browser.newPage();
    await page.setViewport({ width: 1080, height: 1024 });
    await page.setDefaultTimeout(1000);
    await page.goto('http://localhost:3000/');
    await page.waitForSelector('body');
  });

  after(async () => {
    await browser.close();
  });

  it('Form tag presence', async () => {
    const form = await page.waitForSelector('form');
    assert.notEqual(form, null, '<form> tag not found');
  });

  it('Login field presence', async () => {
    const form = await page.$('form');
    const login = await form.$('input[name=login]');
    assert.notEqual(login, null, '<input name=login> not found. Login field required');
  });

  it('Password field presence', async () => {
    const form = await page.$('form');
    const password = await form.$('input[name=password]');
    assert.notEqual(password, null, '<input name=password> not found. Password field required');
  });

  it('Login button presence', async () => {
    const form = await page.$('form');
    const authButton = (
      await form.$$eval([
        '::-p-text(Вход)',
        '::-p-text(Sign in)',
        '::-p-text(Войти)',
        '::-p-text(Enter)',
        '::-p-text(Авторизоваться)',
      ].join(','), nodes => nodes.map(node => node.closest('a[href],button')))
    ).filter(Boolean);

    assert.notEqual(authButton.length, 0, 'Authorization button not found. Check the button text');
  });
});
