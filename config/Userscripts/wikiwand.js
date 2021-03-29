// ==UserScript==
// @name        wikiwand
// @namespace   maa
// @description redirect wikipedia links to wikiwand
// @include     https://*.wikipedia.org/wiki/*
// @exclude       http://*.wikipedia.org/wiki/*?oldformat=true
// @exclude       https://*.wikipedia.org/wiki/*?oldformat=true
// @run-at      document-start
// @version     1
// @grant       none
// @noframes
// ==/UserScript==

(function () {
    const domains = window.location.host.split(".");

    if (domains[0] === "www") {
        domains.shift();
    }

    const article = location.pathname.replace("/wiki/", ""),
        lang = domains.length <= 2 ? "en" : domains[0],
        base = `https://www.wikiwand.com/${lang}/`,
        { hash } = location,
        url = base + article + hash;

    location.href = url;
})();
