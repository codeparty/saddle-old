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

    if before = childNodes[toIndex]
      insert = (node)->
        el.insertBefore node, before
        return
    else
      insert = (node)->
        el.appendChild node
        return

    if howMany is 1
      insert child
    else
      frag = doc.createDocumentFragment()
      while howMany--
        next = child.nextSibling
        frag.appendChild child
        child = next
      insert frag
    return
