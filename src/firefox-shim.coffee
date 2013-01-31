util = require './util'

unless document.body.contains
  HTMLElement.prototype.contains = (node) ->
    !!(@compareDocumentPosition(node) & 16)



unless document.body.insertAdjacentHTML
  HTMLElement.prototype.insertAdjacentHTML = (position, html) ->
    position = position.toLowerCase()
    node = this
    parent = node.parentNode

    switch position
      when 'beforeend'
        node.appendChild util.createFragment(node, html)
      when 'beforebegin'
        parent.insertBefore util.createFragment(parent, html), node
      when 'afterend'
        parent.insertBefore util.createFragment(parent, html), node.nextSibling
      when 'afterbegin'
        node.insertBefore util.createFragment(node, html), node.firstChild