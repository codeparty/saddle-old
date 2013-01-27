util = require './util'

class ItemRange
#static properties
  @prefix = '$'
  @useTags = false
  #private static properties
  doc = document

  commentsMap = {}

  #static method
  @get: (id)->
    # TODO: DRY
    if (comment = commentsMap[id]) and doc.contains comment
      return new ItemRange comment, commentsMap[ItemRange.prefix + id], id

    commentsMap = {}
    # NodeFilter.SHOW_COMMENT == 128
    commentIterator = doc.createTreeWalker(doc.body, 128, null, false)
    while comment = commentIterator.nextNode()
      commentsMap[comment.data] = comment

    if comment = commentsMap[id]
      # TODO: DRY
      new ItemRange comment, commentsMap[ItemRange.prefix + id], id

  @clear: ->
    commentsMap = {}


  constructor: (@start, @end, id)->
    @el = start
    @range = doc.createRange()
    @_ranged = false
    @_updateRange()


  _updateRange: ->
    # startOffset and endOffset might be messed
    # after dom manipulation in dom
    unless @_ranged
      range = @range
      range.setStartAfter @start
      range.setEndBefore @end
      @_ranged = true
    return


  setHtml: (html)->
    range = @range
    range.deleteContents()
    range.insertNode range.createContextualFragment(html)
    @_ranged = false
    return


  append: (html)->
    @_updateRange()
    util.rangeIns @range, html
    @_ranged = false
    return

  insert: (html, index)->
    @_updateRange()
    range = @range
    # handling rage overflow
    if range.endOffset - range.startOffset < index
      @append html
    else
      util.rangeIns @range, html, index
      @_ranged = false
    return

  remove: (index)->
    @_updateRange()
    range = @range
    util.rmChild range.startContainer, range.startOffset + index
    return

  move: (from, to, howMany = 1)->
    range = @range
    offset = range.startOffset
    endOffset = range.endOffset

    indexTo = offset + `(to >= from ? to + howMany : to)`
    #handle overflow
    if indexTo > endOffset
      indexTo = endOffset

    util.move range.startContainer, offset + from, indexTo, howMany
    return


module.exports = ItemRange
