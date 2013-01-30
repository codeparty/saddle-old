util = require './util'

class ItemRange
#private static properties
  doc = document


  constructor: (@start, @end)->
    @el = start
    @range = util.createRange()
    @_ranged = false
    @_updateRange()

  _createFrag: (html)->
    util.createFragment(@el.ownerSVGElement || @range, html)

  _updateRange: ->
    # startOffset and endOffset might be messed
    # after dom manipulation in dom
    range = @range
    range.setStartAfter @start
    range.setEndBefore @end
    return


  setHtml: (html)->
    @_updateRange()
    range = @range
    range.deleteContents()
    fragment =
    range.insertNode @_createFrag html
    return


  append: (html)->
    # insert to the end. `index = undefined` triggers range overflow
    @insert html
    return

  insert: (html, index)->
    @_updateRange()
    range = @range

    # handling range overflow
    containerIndex = `range.endOffset - range.startOffset > index ? range.startOffset + index : range.endOffset`

    startContainer = range.startContainer
    nodeInsertBefore = startContainer.childNodes[containerIndex]
    startContainer.insertBefore  @_createFrag(html), nodeInsertBefore
    return

  remove: (index)->
    @_updateRange()
    range = @range
    util.rmChild range.startContainer, range.startOffset + index
    return

  move: (from, to, howMany = 1)->
    @_updateRange()
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
