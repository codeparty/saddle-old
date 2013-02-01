doc = document

SVG_OPEN = '<svg xmlns=http://www.w3.org/2000/svg xmlns:xlink=http://www.w3.org/1999/xlink>'
SVG_CLOSE = '</svg>'


regex_leadingWhitespase = /^\s+/

test_killedWhitespace = do ->
  testDiv = document.createElement 'div'
  testDiv.innerHTML = ' <i></i>'
  testDiv.firstChild.nodeType isnt 3


module.exports =
  remove: (el, index)->
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


  extractChildren: (node, depth)->
    wrap = rootWrap = node.firstChild

    while --depth
      wrap = rootWrap.firstChild

    while child = wrap.firstChild
      node.appendChild child
    node.removeChild(rootWrap)

    node


  svgRoot: (el)->
    while el isnt doc.body
      if root = el.ownerSVGElement
        return root
      tagName = el.tagName
      if el.tagName and tagName.toLowerCase() is 'svg'
        return el
      el = el.parentNode
    return


  createRange: ->
    new RangeImplementation


  createFragment: (rangeOrParent, html)->
    if tagName = rangeOrParent.tagName
      range = @createRange()
      range.setStartAfter rangeOrParent
      if tagName.toLowerCase() is 'svg'
        isSVG = true
        html = SVG_OPEN + html + SVG_CLOSE
    else
      range = rangeOrParent

    fragment = range.createContextualFragment html

    if isSVG
      fragment = @extractChildren fragment, 1

    fragment

  fixWhitespace: (node, html)->
    if test_killedWhitespace
      html.replace regex_leadingWhitespase, (whitespaces)->
        node.insertBefore document.createTextNode(whitespaces), node.firstChild


RangeImplementation = require './Range-shim'
