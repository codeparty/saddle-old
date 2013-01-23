module.exports = Dom

function Dom() {
}

Dom.prototype = {
  constructor: Dom,
  setHtml: setHtml
}

function setHtml(el, val) {
  el.innerHTML = val
}