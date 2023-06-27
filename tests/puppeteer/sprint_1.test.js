const puppeteer = require('puppeteer');

describe('Feature one...', () => {
  let browser;
  let page;

  before(async () => {
    browser = await puppeteer.launch({ headless: false, });
    page = await browser.newPage();
    await page.setViewport({ width: 1080, height: 1024 });
  });

  it('test 1', async () => {
    await page.goto('https://ya.ru/');

    // Type into search box
    await page.type('.search3__input', 'automate beyond recorder');
    await page.keyboard.press('Enter');

    // Wait and click on first result
    const searchResultSelector = 'a.path__item.link';
    await page.waitForSelector(searchResultSelector);
    await page.click(searchResultSelector);

    // Locate the full title with a unique string
    const textSelector = await page.waitForSelector(
      'text/Getting'
    );
    const fullTitle = await textSelector?.evaluate(el => el.textContent);

    // Print the full title
    console.log('The title of this blog post is "%s".', fullTitle);

    await browser.close();
  });
});
