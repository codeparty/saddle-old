util = require './util'


class Item
  doc = document

  constructor: (el)->
    @el = el
    @svg = svg = !!el.ownerSVGElement || el.tagName is 'svg'
    @svgRoot = if svg
      el.ownerSVGElement || el
    else null

  _svgFrag: (html)->
    util.createFragment @svgRoot, html

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

    if @svg
      el = @el
      children = el.childNodes
      while child = el.firstChild
        el.removeChild child
      @append html
    else
      el.innerHTML = html
    return


  append: (html)->
    el = @el

    if @svg
      el.appendChild @_svgFrag html
    else
      el.insertAdjacentHTML 'beforeend', html

    return

  insert: (html, index)->
    el = @el
    # handling rage overflow
    before = el.childNodes[index]
    if before
      if @svg
        el.insertBefore @_svgFrag(html), before
      else
        before.insertAdjacentHTML 'beforebegin', html
    else
      @append html
    return

  remove: (index)->
    util.rmChild @el, index
    return

  move: (from, to, howMany = 1)->
    util.move @el, from, `to >= from ? to + howMany : to`, howMany
    return

require('./Item-attr-shim')(Item)

module.exports = Item