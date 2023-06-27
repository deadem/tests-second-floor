@echo off
set SPRINT="sprint_3"
npx mocha --timeout 5000 "puppeteer/%SPRINT%.test.js"
