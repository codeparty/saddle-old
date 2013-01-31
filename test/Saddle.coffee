expect = require 'expect.js'
Saddle = require '../lib'

saddle = new Saddle

unless testDiv = document.getElementById('saddle-test')
  document.body.insertAdjacentHTML 'beforeend', '<div id=saddle-test></div>'
  testDiv = document.getElementById('saddle-test')

beforeEach ->
  saddle.clear()
  testHtml = [
    '<!--$0-->'
    '<div id=$1>'
    '' + '<p>1</p>'
    '</div>'
    '<div id=$2 class=test>'
    '' + '<p>2-1</p>'
    '' + '<!--$$0-->'
    '' + '<p>2-2</p>'
    '</div>'
    '<div id=$3 class=test>'
    '' + '<p>3-1</p>'
    '' + '<p>3-2</p>'
    '' + '<!--$4-->'
    '' + '<p>3-3</p>'
    '' + '<!--$$4-->'
    '</div>'
    '<div id=$5 class=test>'
    '' + '<p>5-1</p>'
    '' + '<p>5-2</p>'
    '' + '<p>5-3</p>'
    '' + '<p>5-4</p>'
    '' + '<p>5-5</p>'
    '' + '<p>5-6</p>'
    '' + '<!--$6-->'
    '' + '<p>5-7</p>'
    '' + '<p>5-8</p>'
    '' + '<p>5-9</p>'
    '' + '<p>5-10</p>'
    '' + '<p>5-11</p>'
    '' + '<p>5-12</p>'
    '' + '<!--$$6-->'
    '</div>'
    '<input id=$7 value=test>'
    '<input id=$8 type=checkbox checked>'
    '<p id=$9>one <!--$10-->two <!--$$10-->three</p>'
    '<svg id=$11 height=200 width=200 xmlns=http://www.w3.org/2000/svg>'
    '' + '<rect id=$12 x=1></rect>'
    '' + '<circle></circle>'
    '' + '<!--$13-->'
    '' + '<rect></rect>'
    '' + '<circle></circle>'
    '' + '<!--$$13-->'
    '</svg>'
  ].join ''

  if !document.createTreeWalker
    testHtml = testHtml.replace /<!--([^-]*)-->/g, '<comment id=$1></comment>'

  testDiv.innerHTML = testHtml
  return

normalize = (html)->
  html.toLowerCase().replace(/\r\n/g, '').replace(/<comment id=([^>]*)><\/comment>/g, '<!--$1-->')

normalizedHtml = ($node)->
  normalize $node.html()

describe 'Saddle', ->
  describe '#getAttr()', ->
    it 'should get attribute', ->
      expect(saddle.getAttr '$2', 'class').to.be 'test'
      expect(saddle.getAttr '$2', 'class').to.be 'test'
      expect(saddle.getAttr '$7', 'value').to.be 'test'

      checked = saddle.getAttr '$8', 'checked'
      expect(checked is '' or checked is 'checked' or checked is true).to.be.ok()

      expect(saddle.getAttr '$8', 'absent').to.be null

    it 'should get svg atrribure', ->
      expect(saddle.getAttr '$11', 'height').to.be '200'
      expect(saddle.getAttr '$12', 'x').to.be '1'


  describe '#setAttr()', ->
    it 'should set attribute', ->
      $2 = $ document.getElementById '$2'
      saddle.setAttr '$2', 'class', 'saddle'
      expect($2.attr 'class').to.be 'saddle'
      saddle.setAttr '$2', 'name', 'derby'
      expect($2.attr 'name').to.be 'derby'

    it 'should set svg atrribure', ->
      saddle.setAttr '$11', 'height', 220
      saddle.setAttr '$12', 'y', 1
      expect(saddle.getAttr '$11', 'height').to.be '220'
      expect(saddle.getAttr '$12', 'x').to.be '1'
      expect(saddle.getAttr '$12', 'y').to.be '1'


  describe '#getProp()', ->
    it 'should get property', ->
      expect(saddle.getProp '$7', 'value').to.be 'test'
      expect(saddle.getProp '$8', 'checked').to.be true
      expect(saddle.getProp '$8', 'absent').to.be undefined

    it 'should get property after user iteration', ->
      $5 = $ document.getElementById '$7'
      $5.attr 'value', 'derbyjs'
      expect(saddle.getProp '$7', 'value').to.be 'derbyjs'

      $6 = $ document.getElementById '$8'
      $6.trigger 'click'
      expect(saddle.getProp '$8', 'checked').to.be false

      # TODO: simulate keyboard press into text field
      return


  describe '#setProp()', ->
    it 'should set property', ->
      saddle.setProp '$7', 'value', 'coolness'
      $5 = $ document.getElementById '$7'
      expect($5.prop('value')).to.be 'coolness'

      saddle.setProp '$8', 'checked', false
      $6 = $ document.getElementById '$8'
      expect($6.prop('checked')).to.be false


  describe '#getHtml()', ->
    it 'should get HTML', ->
      expect(normalize saddle.getHtml('$1')).to.be '<p>1</p>'


  describe '#setHtml()', ->
    it 'should set HTML for element', ->
      saddle.setHtml '$1', '<div>123</div>'
      $1 = $ document.getElementById '$1'
      expect(normalizedHtml $1).to.be '<div>123</div>'

      saddle.setHtml '$1', '<b>321</b>'
      $1 = $ document.getElementById '$1'
      expect(normalizedHtml $1).to.be '<b>321</b>'

    it 'should set HTML for svg element', ->
      saddle.setHtml '$11', '<circle x=10></circle>'
      svg11 = document.getElementById '$11'
      expect(svg11.firstChild.tagName).to.be 'circle'
      expect(svg11.childNodes.length).to.be 1

    it 'should set HTML for normal range', ->
      $3 = $ document.getElementById '$3'

      saddle.setHtml '$4', 'test<i></i>'
      expect(normalizedHtml $3).to.be '<p>3-1</p><p>3-2</p><!--$4-->test<i></i><!--$$4-->'

      saddle.setHtml '$4', ''
      expect(normalizedHtml $3).to.be '<p>3-1</p><p>3-2</p><!--$4--><!--$$4-->'

    it 'should set HTML for text range', ->
      $9 = $ document.getElementById '$9'

      saddle.setHtml '$10', ' 2 '
      expect(normalizedHtml $9).to.be 'one <!--$10--> 2 <!--$$10-->three'

      saddle.setHtml '$10', ''
      expect(normalizedHtml $9).to.be 'one <!--$10--><!--$$10-->three'

    it 'should set HTML for svg element', ->
      svg11 = document.getElementById '$11'

      saddle.setHtml '$13', '<circle></circle>'
      expect(svg11.childNodes[3].tagName).to.be 'circle'
      expect(svg11.childNodes.length).to.be 5

      saddle.setHtml '$13', ''
      expect(svg11.childNodes.length).to.be 4


  describe '#prepend()', ->
    it 'should prepend html to div', ->
      $1 = $ document.getElementById '$1'

      saddle.prepend '$1', '<p>0</p>'
      expect(normalizedHtml $1).to.be '<p>0</p><p>1</p>'

      saddle.prepend '$1', '<p>-1</p>'
      expect(normalizedHtml $1).to.be '<p>-1</p><p>0</p><p>1</p>'


    it 'should prepend html to normal range', ->
      $3 = $ document.getElementById '$3'

      saddle.prepend '$4', '<p>4-0</p>'
      expect(normalizedHtml $3).to.be '<p>3-1</p><p>3-2</p><!--$4--><p>4-0</p><p>3-3</p><!--$$4-->'

      saddle.prepend '$4', '<p>4--1</p>'
      expect(normalizedHtml $3).to.be '<p>3-1</p><p>3-2</p><!--$4--><p>4--1</p><p>4-0</p><p>3-3</p><!--$$4-->'


  describe '#append()', ->
    it 'should append html to div', ->
      $1 = $ document.getElementById '$1'

      saddle.append '$1', '<p>2</p>'
      expect(normalizedHtml $1).to.be '<p>1</p><p>2</p>'

      saddle.append '$1', '<p>3</p>'
      expect(normalizedHtml $1).to.be '<p>1</p><p>2</p><p>3</p>'


    it 'should append html to normal range', ->
      $3 = $ document.getElementById '$3'

      saddle.append '$4', '<p>4-1</p>'
      expect(normalizedHtml $3).to.be '<p>3-1</p><p>3-2</p><!--$4--><p>3-3</p><p>4-1</p><!--$$4-->'

      saddle.append '$4', '<p>4-2</p>'
      expect(normalizedHtml $3).to.be '<p>3-1</p><p>3-2</p><!--$4--><p>3-3</p><p>4-1</p><p>4-2</p><!--$$4-->'


  describe '#insert()', ->
    it 'should insert html to div', ->
      $1 = $ document.getElementById '$1'

      saddle.insert '$1', '<p>0</p>', 0
      expect(normalizedHtml $1).to.be '<p>0</p><p>1</p>'

      saddle.insert '$1', '<p>2</p>', 2
      expect(normalizedHtml $1).to.be '<p>0</p><p>1</p><p>2</p>'

      saddle.insert '$1', '<p>0.5</p>', 1
      expect(normalizedHtml $1).to.be '<p>0</p><p>0.5</p><p>1</p><p>2</p>'


    it 'should insert html to normal range', ->
      $3 = $ document.getElementById '$3'

      saddle.insert '$4', '<p>4-0</p>', 0
      expect(normalizedHtml $3).to.be '<p>3-1</p><p>3-2</p><!--$4--><p>4-0</p><p>3-3</p><!--$$4-->'

      saddle.insert '$4', '<p>4-2</p>', 2
      expect(normalizedHtml $3).to.be '<p>3-1</p><p>3-2</p><!--$4--><p>4-0</p><p>3-3</p><p>4-2</p><!--$$4-->'


    it 'should handle range overwlof', ->
      $3 = $ document.getElementById '$3'

      saddle.insert '$4', '<p>4-2</p>', 2
      expect(normalizedHtml $3).to.be '<p>3-1</p><p>3-2</p><!--$4--><p>3-3</p><p>4-2</p><!--$$4-->'

      saddle.insert '$4', '<p>4-9</p>', 9
      expect(normalizedHtml $3).to.be '<p>3-1</p><p>3-2</p><!--$4--><p>3-3</p><p>4-2</p><p>4-9</p><!--$$4-->'


  describe '#remove()', ->
    it 'should remove items from div', ->
      $1 = $ document.getElementById '$1'
      $3 = $ document.getElementById '$3'

      saddle.remove '$1', 0
      expect(normalizedHtml $1).to.be ''

      saddle.remove '$3', 3
      saddle.remove '$3', 1
      expect(normalizedHtml $3).to.be '<p>3-1</p><!--$4--><!--$$4-->'


    it 'should remove items from a normal range', ->
      $3 = $ document.getElementById '$3'

      saddle.append '$4', '<p>4-4</p>'
      saddle.append '$4', '<p>4-5</p>'
      saddle.append '$4', '<p>4-6</p>'
      expect(normalizedHtml $3).to.be '<p>3-1</p><p>3-2</p><!--$4--><p>3-3</p><p>4-4</p><p>4-5</p><p>4-6</p><!--$$4-->'

      saddle.remove '$4', 2
      expect(normalizedHtml $3).to.be '<p>3-1</p><p>3-2</p><!--$4--><p>3-3</p><p>4-4</p><p>4-6</p><!--$$4-->'

      saddle.remove '$4', 0
      expect(normalizedHtml $3).to.be '<p>3-1</p><p>3-2</p><!--$4--><p>4-4</p><p>4-6</p><!--$$4-->'

      saddle.remove '$4', 1
      expect(normalizedHtml $3).to.be '<p>3-1</p><p>3-2</p><!--$4--><p>4-4</p><!--$$4-->'


  describe '#move()', ->
    it 'should move items in div', ->
      $3 = $ document.getElementById '$3'
      $5 = $ document.getElementById '$5'

      saddle.move '$3', 0, 1
      expect(normalizedHtml $3).to.be '<p>3-2</p><p>3-1</p><!--$4--><p>3-3</p><!--$$4-->'

      saddle.move '$3', 0, 4, 2
      expect(normalizedHtml $3).to.be '<!--$4--><p>3-3</p><!--$$4--><p>3-2</p><p>3-1</p>'

      saddle.move '$5', 3, 1, 3
      expect(normalizedHtml $5).to.be '<p>5-1</p><p>5-4</p><p>5-5</p><p>5-6</p><p>5-2</p><p>5-3</p><!--$6--><p>5-7</p><p>5-8</p><p>5-9</p><p>5-10</p><p>5-11</p><p>5-12</p><!--$$6-->'

      saddle.move '$5', 7, 0, 6
      expect(normalizedHtml $5).to.be '<p>5-7</p><p>5-8</p><p>5-9</p><p>5-10</p><p>5-11</p><p>5-12</p><p>5-1</p><p>5-4</p><p>5-5</p><p>5-6</p><p>5-2</p><p>5-3</p><!--$6--><!--$$6-->'

    it 'should handle move index overflow in div', ->
      $3 = $ document.getElementById '$3'

      saddle.move '$3', 0, 1000, 2
      expect(normalizedHtml $3).to.be '<!--$4--><p>3-3</p><!--$$4--><p>3-1</p><p>3-2</p>'


    it 'should move items from a normal range', ->
      $5 = $ document.getElementById '$5'
      preHtml = '<p>5-1</p><p>5-2</p><p>5-3</p><p>5-4</p><p>5-5</p><p>5-6</p>'

      saddle.move '$6', 0, 1
      expect(normalizedHtml $5).to.be preHtml + '<!--$6--><p>5-8</p><p>5-7</p><p>5-9</p><p>5-10</p><p>5-11</p><p>5-12</p><!--$$6-->'

      saddle.move '$6', 1, 2, 2
      expect(normalizedHtml $5).to.be preHtml + '<!--$6--><p>5-8</p><p>5-10</p><p>5-7</p><p>5-9</p><p>5-11</p><p>5-12</p><!--$$6-->'

      saddle.move '$6', 4, 1, 2
      expect(normalizedHtml $5).to.be preHtml + '<!--$6--><p>5-8</p><p>5-11</p><p>5-12</p><p>5-10</p><p>5-7</p><p>5-9</p><!--$$6-->'

      saddle.move '$6', 0, 5
      expect(normalizedHtml $5).to.be preHtml + '<!--$6--><p>5-11</p><p>5-12</p><p>5-10</p><p>5-7</p><p>5-9</p><p>5-8</p><!--$$6-->'


    it 'should handle move index overflow in a normal range', ->
      $5 = $ document.getElementById '$5'
      preHtml = '<p>5-1</p><p>5-2</p><p>5-3</p><p>5-4</p><p>5-5</p><p>5-6</p>'

      saddle.move '$6', 0, 1000, 2
      expect(normalizedHtml $5).to.be preHtml + '<!--$6--><p>5-9</p><p>5-10</p><p>5-11</p><p>5-12</p><p>5-7</p><p>5-8</p><!--$$6-->'

