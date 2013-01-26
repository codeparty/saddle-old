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
    # TODO: check for simple insertBefore range.end
    range = @range
    endContainer = range.endContainer
    endContainer.insertBefore range.createContextualFragment(html), @end
    @_ranged = false
    return

  insert: (html, index)->
    @_updateRange()
    range = @range
    # handling rage overflow
    if range.endOffset - range.startOffset < index
      @append html
    else
      startContainer = range.startContainer
      nodeInsertBefore = startContainer.childNodes[range.startOffset + index]
      startContainer.insertBefore range.createContextualFragment(html), nodeInsertBefore
      @_ranged = false
    return

  remove: (index)->
    @_updateRange()
    range = @range
    startContainer = range.startContainer
    startContainer.removeChild startContainer.childNodes[range.startOffset + index]
    return

  move: (from, to, howMany = 1)->
    range = @range

    startContainer = range.startContainer
    offset = range.startOffset


    #TODO: cache childNodes
    child = startContainer.childNodes[from + offset]
    before = startContainer.childNodes[to + offset]

    #TODO: refactor DRY
    if howMany is 1
      startContainer.insertBefore(child, before);
    else
      frag = doc.createDocumentFragment()
      while howMany--
        frag.appendChild child
        child = child.nextSibling()
      startContainer.insertBefore(frag, before);
    return


module.exports = ItemRange
