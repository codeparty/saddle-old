util = require './util'


class Item
  doc = document

  constructor: (@el)->


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
    @el.innerHTML = html
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