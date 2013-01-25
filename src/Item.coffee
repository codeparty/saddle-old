ItemRange = require './ItemRange'

module.exports = Item

class Item
  doc = document
  itemsMap = {}

  @get: (id)->
    if item = itemsMap[id]
      return item

    itemsMap[id] = if (el = doc.getElementById(id))
      new Item el
    else
      ItemRange.get id

  constructor: (@el)->


  getAttr: (name)->
    @el.getAttribute name

  setAttr: (name, val)->
    @el.setAttribute name, val
    @


  getProp: (name)->
    @el[name]

  setProp: (name, val)->
    @el[name] = val
    @


  getHtml: ->
    @el.innerHtml

  setHtml: (html)->
    @el.innerHtml = html
    @


  append: ->



