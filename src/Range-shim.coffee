util = require './util'

class RangeShim
  constructor: ->
    @_start = @_end =
      @startContainer = @endContainer =
        @startOffset = @endOffset =
          null

  _getOffset: (offset, node)->
    while node = node.previousSibling
      offset++
    offset


  setStartAfter: (@_start)->
    @startContainer = _start.parentNode
    @startOffset = @_getOffset 1, _start
    return

  setEndBefore: (@_end)->
    @endContainer = _end.parentNode
    @endOffset = @_getOffset 0, _end
    return

  deleteContents: ->
    parent = @startContainer
    while (child = @_start.nextSibling) and child isnt @_end
      parent.removeChild child
    return

  insertNode: (node)->
    @startContainer.insertBefore node, @_end

  createContextualFragment: (html)->
    parent = @startContainer
    wrap = wrapMap[parent.tagName.toLowerCase()] || wrapMap._default
    depth = wrap[0]
    open = wrap[1]
    close = wrap[2]

    el = document.createElement('div')
    el.innerHTML = open + html + close

    fragment = document.createDocumentFragment()
    fragment.appendChild el
    fragment = util.extractChildren fragment, depth + 1

    return fragment


wrapMap =
  select: [ 1, '<select multiple="multiple">', '</select>' ]
  fieldset: [ 1, '<fieldset>', '</fieldset>' ]
  table: [ 1, '<table>', '</table>' ]
  tbody: [ 2, '<table><tbody>', '</tbody></table>' ]
  tr: [ 3, '<table><tbody><tr>', '</tr></tbody></table>' ]
  colgroup: [ 2, '<table><tbody></tbody><colgroup>', '</colgroup></table>' ]
  map: [ 1, '<map>', '</map>' ]
  _default: [ 0, '', '' ]


if window.Range
  unless Range::createContextualFragment
    Range::createContextualFragment = RangeShim::createContextualFragment
  module.exports = ->
    document.createRange()
else
  module.exports = RangeShim
