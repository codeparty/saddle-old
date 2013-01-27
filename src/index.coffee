Item = require './Item'
ItemRange = require './ItemRange'

doc = document

class Saddle
  #private static props
  itemsMap = {}
  markersMap = {}
  prefix = ''


  #private static methods
  getCachedItem = (id, map)->
    if (item = map[id]) and doc.contains(item.el || item)
      return item

  updateMarkersMap = ->
    markersMap = {}

    # NodeFilter.SHOW_COMMENT == 128
    commentIterator = doc.createTreeWalker(doc.body, 128, null, false)
    while comment = commentIterator.nextNode()
      markersMap[comment.data] = comment

    return


  constructor: (options = {})->
    # TODO: figure out better config sharing
    prefix = @prefix = ItemRange.prefix = options.prefix || '$'
    @useTags = ItemRange.useTags = !!options.useTags

    @_id = 0


  get: (id)->
    # making sure that there is el or marker in doc
    if item = getCachedItem(id, itemsMap)
      return item

    if (el = doc.getElementById(id)) and el.tagName isnt 'COMMENT'
      return itemsMap[id] = new Item el

    unless comment = getCachedItem id, markersMap
      updateMarkersMap()
      comment = markersMap[id]

    if comment
      return itemsMap[id] = createItemRange id, comment

    return


  clear: ->
    itemsMap = {}
    markersMap = {}
    return


  uid: ()->
    @prefix + (@_id++).toString(36)


  getMarkerTpl: ->
    if @useTags
      (id)->
        ["<comment id=#{id}/>", "<comment id=#{@prefix + id}/>"]
    else
      (id)->
        ["<!--#{id}-->", "<!--#{@prefix + id}-->"]


  prepend: (id, html)->
    @insert id, html, 0
    return


for own methodName of (Item::)
  Saddle::[methodName] = do (methodName = methodName)->
    (id, arg1, arg2, arg3)->
      @get(id)?[methodName](arg1, arg2, arg3)


module.exports = Saddle