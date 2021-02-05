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

(function(){
    const domains = window.location.host.split('.'); // en.wikipedia.org
    if (domains[0] === "www") domains.shift();
    const lang = domains.length <= 2 ? 'en' : domains[0];

    const base = 'https://www.wikiwand.com/' + lang + '/';
    const article = location.pathname.replace('/wiki/','');
    const hash = location.hash;

    const url = (base + article + hash);
    location.href = url;
})();