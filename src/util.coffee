doc = document

module.exports =
  rangeIns: (range, html, index)->
    startContainer = range.startContainer
    nodeInsertBefore = startContainer.childNodes[`index!=null ? range.startOffset + index : range.endOffset`]
    startContainer.insertBefore range.createContextualFragment(html), nodeInsertBefore
    return

  rmChild: (el, index)->
    el.removeChild el.childNodes[index]
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
