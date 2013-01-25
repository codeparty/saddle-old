Item = require './Item'
ItemRange = require './ItemRange'


class Saddle
  constructor: (options = {})->
    # TODO: figure out better config sharing
    @prefix = ItemRange.prefix = options.prefix || '$'
    @useTags = ItemRange.useTags = !!options.useTags

    @_id = 0

  clear: ->
    Item.clear()
    ItemRange.clear()

  uid: ()-> @prefix + (@_id++).toString(36)

  getMarkerTpl = ->
    if @useTags
      (id)-> ["<comment id=#{id}/>", "<comment id=#{@prefix + id}/>"]
    else
      (id)-> ["<!--#{id}-->", "<!--#{@prefix + id}-->"]

for own methodName of (Item::)
  Saddle::[methodName] = do (methodName = methodName)->
    (id, arg1, arg2, arg3)->
      Item.get(id)?[methodName](arg1, arg2, arg3)


module.exports = Saddle