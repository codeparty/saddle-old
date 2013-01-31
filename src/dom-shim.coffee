util = require './util'

unless document.body.contains
  HTMLElement.prototype.contains = (node) ->
    !!(@compareDocumentPosition(node) & 16)


###
  Add support for insertAdjacentHTML for Firefox < 8
  Based on insertAdjacentHTML.js by Eli Grey, http://eligrey.com
###
unless document.body.insertAdjacentHTML
  HTMLElement.prototype.insertAdjacentHTML = (position, html) ->
    position = position.toLowerCase()
    ref = this
    parent = ref.parentNode

    switch position
      when 'beforeend'
        ref.appendChild util.createFragment ref, html
      when 'beforebegin'
        parent.insertBefore util.createFragment(parent, html), ref
      when 'afterend'
        parent.insertBefore util.createFragment(parent, html), ref.nextSibling
      when 'afterbegin'
        ref.insertBefore util.createFragment(ref, html), ref.firstChild