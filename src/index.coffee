Item = require './Item'
ItemRange = require './ItemRange'

module.exports = Saddle

class Saddle
  constructor: (options)->
    # TODO: figure out better config sharing
    ItemRange.prefix = options.prefix || '$'
    ItemRange.useTags = !!options.useTags

    @_id = 0


for own methodName of (Item::)
  Saddle::[methodName] = do (methodName = methodName)->
    (id, arg1, arg2, arg3)->
      new Item(id)[methodName](arg1, arg2, arg3)