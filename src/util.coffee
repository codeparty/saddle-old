RangeImplementation = require './RangeShim'
doc = document

module.exports =
  createRange: ->
    new RangeImplementation

  rmChild: (el, index)->
    if child = el.childNodes[index]
      el.removeChild child
    return

  move: (el, from, toIndex, howMany = 1)->
    childNodes = el.childNodes
    child = childNodes[from]

    # If before is null, new element is inserted at the end of the list of child nodes
    # https://developer.mozilla.org/en-US/docs/DOM/Node.insertBefore
    before = childNodes[toIndex] || null

    if howMany is 1
      el.insertBefore child, before
    else
      frag = doc.createDocumentFragment()
      while howMany--
        next = child.nextSibling
        frag.appendChild child
        child = next
      el.insertBefore frag, before
    return

  createFragment: (rangeOrParent, html)->
    if rangeOrParent.nodeType
      range = @createRange()
      range.setStartAfter rangeOrParent
    else
      range = rangeOrParent

    range.createContextualFragment html