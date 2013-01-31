Item = require './Item'
ItemRange = require './ItemRange'
require './firefox-shim'

doc = document

class Saddle
#private static methods
  getCachedItem = (id, map)->
    if (item = map[id]) and doc.body.contains(item.el || item)
      return item


  constructor: (options)->
    options ||= {}
    @prefix = options.prefix || '$'
    @useTags = options.useTags || !doc.createTreeWalker

    @itemsMap = {}
    @markersMap = {}
    @_id = 0


  _updateMarkers: ->
    @markersMap = markersMap = {}

    if @useTags
      comments = doc.getElementsByTagName('comment')
      for comment in comments
        markersMap[comment.id] = comment
    else
      # NodeFilter.SHOW_COMMENT == 128
      commentIterator = doc.createTreeWalker(doc.body, 128, null, false)
      while comment = commentIterator.nextNode()
        markersMap[comment.data] = comment

    markersMap


  get: (id)->
    itemsMap = @itemsMap
    markersMap = @markersMap
    # making sure that there is el or marker in doc
    if item = getCachedItem(id, itemsMap)
      return item

    if (el = doc.getElementById(id)) and el.tagName isnt 'COMMENT'
      return itemsMap[id] = new Item el

    unless comment = getCachedItem id, markersMap
      markersMap = @_updateMarkers()
      comment = markersMap[id]

    if comment
      return itemsMap[id] = new ItemRange comment, markersMap[@prefix + id]

    return


  clear: ->
    @itemsMap = {}
    @markersMap = {}
    @_id = 0
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
      if item = @get(id)
        item[methodName](arg1, arg2, arg3)


module.exports = Saddle