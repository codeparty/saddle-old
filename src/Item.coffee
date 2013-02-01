util = require './util'


class Item
  doc = document

  constructor: (el)->
    @el = el
    @svgRoot = util.svgRoot el

  _createFrag: (html)->
    util.createFragment(@svgRoot || @el, html)

  getAttr: (name)->
    @el.getAttribute name

  setAttr: (name, val)->
    @el.setAttribute name, val
    return


  getProp: (name)->
    @el[name]

  setProp: (name, val)->
    @el[name] = val
    return


  getHtml: ->
    @el.innerHTML

  setHtml: (html)->
    el = @el

    if @svgRoot
      el = @el
      children = el.childNodes
      while child = el.firstChild
        el.removeChild child
      @append html
    else
      el.innerHTML = html
      util.fixWhitespace el, html
    return


  append: (html)->
    # insert to the end. `index = undefined` insert before `null`
    @insert html
    return

  insert: (html, index)->
    # can't use insertAdjustmentHTML anymore. It's not working for text nodes
    el = @el
    before = (index? and el.childNodes[index]) or null
    # If before is null, new element is inserted at the end of the list of child nodes
    # https://developer.mozilla.org/en-US/docs/DOM/Node.insertBefore
    el.insertBefore @_createFrag(html), before
    return

  remove: (index)->
    util.remove @el, index
    return

  move: (from, to, howMany = 1)->
    util.move @el, from, `to >= from ? to + howMany : to`, howMany
    return

require('./Item-attr-shim')(Item)

module.exports = Item