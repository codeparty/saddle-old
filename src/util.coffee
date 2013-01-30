RangeShim = require './RangeShim'
doc = document

RangeImplementation = null

module.exports =
  createRange: do ->
    if window.Range && Range.prototype.createContextualFragment
      RangeImplementation = Range
      return -> doc.createRange()
    else
      RangeImplementation = RangeShim
      return -> new RangeShim
    return

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
    if rangeOrParent instanceOf RangeImplementation
      range = rangeOrParent
    else
      range = @createRange()
      range.setStart parent
    range.createContextualFragment html