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
    return


  getProp: (name)->
    @el[name]

  setProp: (name, val)->
    @el[name] = val
    return


  getHtml: ->
    @el.innerHtml

  setHtml: (html)->
    @el.innerHtml = html
    return


  append: (html)->
    @el.insertAdjacentHTML 'beforeend', html
    return

  insert: (html, index)->
    @el.childNodes[index].insertAdjacentHTML 'beforebegin', html
    return

  remove: (index)->
    el = @el
    el.removeChild el.childNodes[index]
    return

  move: (from, to, howMany = 1)->
    el = @el
    child = @el.childNodes[from]
    before = @el.childNodes[to]

    #TODO: check this
    if howMany is 1
      el.insertBefore(child, before);
    else
      frag = doc.createDocumentFragment()
      while howMany--
        frag.appendChild child
        child = child.nextSibling()
      el.insertBefore(frag, before)
    return
