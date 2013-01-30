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

  createFragment: do ->
    if window.Range && Range.prototype.createContextualFragment

      createFragment = (rangeOrParent, html)->
        html ?= ''
        if rangeOrParent instanceOf Range
          range = rangeOrParent
        else
          range = doc.createRange()
          range.setStart parent
        range.createContextualFragment html
    else
      #fallback
      createFragment = (parent, html)->
        wrap = wrapMap[parent.tagName.toLowerCase()] || wrapMap._default
        depth = wrap[0]
        open = wrap[1]
        close = wrap[2]

        el = doc.createElement('div')
        el.innerHTML = open + html + close

        while depth--
          el = el.firstChild

        fragment = doc.createDocumentFragment()

        while node = el.firstChild
          fragment.appendChild node

        return fragment
      
    return createFragment


wrapMap =
  select: [ 1, '<select multiple="multiple">', '</select>' ]
  fieldset: [ 1, '<fieldset>', '</fieldset>' ]
  table: [ 1, '<table>', '</table>' ]
  tbody: [ 2, '<table><tbody>', '</tbody></table>' ]
  tr: [ 3, '<table><tbody><tr>', '</tr></tbody></table>' ]
  colgroup: [ 2, '<table><tbody></tbody><colgroup>', '</colgroup></table>' ]
  map: [ 1, '<map>', '</map>' ]
  _default: [ 0, '', '' ]
