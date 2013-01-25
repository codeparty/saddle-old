Item = require './Item'

module.exports = ItemRange

class ItemRange extends Item
#static properties
  @prefix = '$'
  @useTags = false
  #private static properties
  doc = document
  createRange = -> doc.createRange()
  createContextualFragment = (html)-> doc.createContextualFragment(html)

  commentsMap = {}

  #static method
  @get: (id)->
    if item = commentsMap[id]
      unless doc.contains item
        return
      return item

    commentsMap = {}
    # NodeFilter.SHOW_COMMENT == 128
    commentIterator = doc.createTreeWalker(doc.body, 128, null, false)
    while comment = commentIterator.nextNode()
      commentsMap[comment.data] = comment

    if comment = commentsMap[id]
      new ItemRange comment, id


  constructor: (start, id)->
    end = commentsMap[ItemRange.prefix + id]

    @el = range = createRange()
    range.setStartAfter(start)
    range.setEndBefore(end)


  setHtml: (html)->
    range = @el
    range.deleteContents()
    range.insertNode createContextualFragment html
    @









