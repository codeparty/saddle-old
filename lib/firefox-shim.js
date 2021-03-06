// Generated by CoffeeScript 1.4.0
var util;

util = require('./util');

if (!document.body.contains) {
  HTMLElement.prototype.contains = function(node) {
    return !!(this.compareDocumentPosition(node) & 16);
  };
}

if (!document.body.insertAdjacentHTML) {
  HTMLElement.prototype.insertAdjacentHTML = function(position, html) {
    var node, parent;
    position = position.toLowerCase();
    node = this;
    parent = node.parentNode;
    switch (position) {
      case 'beforeend':
        node.appendChild(util.createFragment(node, html));
        break;
      case 'beforebegin':
        parent.insertBefore(util.createFragment(parent, html), node);
        break;
      case 'afterend':
        parent.insertBefore(util.createFragment(parent, html), node.nextSibling);
        break;
      case 'afterbegin':
        node.insertBefore(util.createFragment(node, html), node.firstChild);
    }
  };
}
