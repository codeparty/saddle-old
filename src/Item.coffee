util = require './util'


class Item
  doc = document

  constructor: (el)->
    @el = el
    @svg = svg = !!el.ownerSVGElement || el.tagName is "svg"
    @svgRoot = if svg
      el.ownerSVGElement || el
    else null


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
      i = children.length
      while i--
        el.removeChild children[i]
      el.appendChild util.createFragment el, html
    else
      el.innerHTML = html
    return


  append: (html)->
    @el.insertAdjacentHTML 'beforeend', html
    return

  insert: (html, index)->
    # handling rage overflow
    if (childNodes = @el.childNodes).length <= index
      @append html
    else
      childNodes[index].insertAdjacentHTML 'beforebegin', html
    return

  remove: (index)->
    util.rmChild @el, index
    return

  move: (from, to, howMany = 1)->
    util.move @el, from, `to >= from ? to + howMany : to`, howMany
    return


module.exports = Item