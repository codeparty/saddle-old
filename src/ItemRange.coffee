class ItemRange
#static properties
  @prefix = '$'
  @useTags = false
  #private static properties
  doc = document
  createRange = -> doc.createRange()

  commentsMap = {}

  #static method
  @get: (id)->
    # TODO: DRY
    if (comment = commentsMap[id]) and doc.contains comment
      return new ItemRange comment, id

    commentsMap = {}
    # NodeFilter.SHOW_COMMENT == 128
    commentIterator = doc.createTreeWalker(doc.body, 128, null, false)
    while comment = commentIterator.nextNode()
      commentsMap[comment.data] = comment

    if comment = commentsMap[id]
      new ItemRange comment, id

  @clear: ->
    commentsMap = {}

  constructor: (@el, id)->
    end = commentsMap[ItemRange.prefix + id]

    @range = range = createRange()
    range.setStartAfter(el)
    range.setEndBefore(end)


  setHtml: (html)->
    range = @range
    range.deleteContents()
    range.insertNode range.createContextualFragment(html)
    return


  append: (html)->
    # TODO: check for simple insertBefore range.end
    range = @range
    endContainer = range.endContainer
    console.log closingMarker = endContainer.childNodes[range.endOffset]
    #TODO: check. Might not work if there no nodes after
    endContainer.insertBefore range.createContextualFragment(html), closingMarker
    return

  insert: (html, index)->
    range = @range
    indexNode = range.startContainer.childNodes[range.startOffset + index];
    indexNode.insertAdjacentHTML 'beforebegin', html
    return

  remove: (index)->
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
