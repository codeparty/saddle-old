module.exports = (Item)->
  div = document.createElement 'div'
  div.setAttribute 'class', 't'
  if div.className isnt 't'
    Item::getAttr = (name)->
      el = @el
      name = propertyNameFix[name] || name

      if el.getAttribute
        attr = el.getAttribute name
      else
        attr = @getProp(name)

      if attr?
        if attr is true
          attr = name
        else
          attr += ''
      else
        attr = null


      return attr

    Item::setAttr = (name, val)->
      el = @el
      name = propertyNameFix[name] || name

      if el.setAttribute
        el.setAttribute name, val
      else
        @setProp name, val
      return

  propertyNameFix =
    tabindex: 'tabIndex'
    readonly: 'readOnly'
    'for': 'htmlFor'
    'class': 'className'
    maxlength: 'maxLength'
    cellspacing: 'cellSpacing'
    cellpadding: 'cellPadding'
    rowspan: 'rowSpan'
    colspan: 'colSpan'
    usemap: 'useMap'
    frameborder: 'frameBorder'
    contenteditable: 'contentEditable'

  return