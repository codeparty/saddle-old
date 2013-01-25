expect = require 'expect.js'
Saddle = require '../lib'

saddle = new Saddle

beforeEach ->
  saddle.clear()
  document.body.innerHTML =
    '''
    <!--$0-->
    <div id=$1><p>1</p></div>
    <div id=$2 class=test>
    <p>2-1</p>
    <!--$$0-->
    <p>2-2</p>
    </div>
    <div id=$3 class=test>
    <p>3-1</p>
    <p>3-2</p>
    <!--$4-->
    <p>4-3</p>
    <p>4-4</p>
    <p>4-5</p>
    <!--$$4-->
    </div>
    <input id=$5 value=test>
    <input id=$6 type=checkbox checked>
    '''


describe 'Saddle', ->
  describe '#getAttr()', ->
    it 'should get attribute', ->
      expect(saddle.getAttr '$2', 'class').to.be 'test'
      expect(saddle.getAttr '$2', 'class').to.be 'test'
      expect(saddle.getAttr '$5', 'value').to.be 'test'
      expect(saddle.getAttr '$6', 'checked').to.be ''
      expect(saddle.getAttr '$6', 'absent').to.be null


  describe '#setAttr()', ->
    it 'should set attribute', ->
      $2 = $ document.getElementById '$2'
      saddle.setAttr '$2', 'class', 'saddle'
      expect($2.attr 'class').to.be 'saddle'
      saddle.setAttr '$2', 'name', 'derby'
      expect($2.attr 'name').to.be 'derby'


  describe '#getProp()', ->
    it 'should get property', ->
      expect(saddle.getProp '$5', 'value').to.be 'test'
      expect(saddle.getProp '$6', 'checked').to.be true
      expect(saddle.getProp '$6', 'absent').to.be undefined

    it 'should get property after user iteration', ->
      $5 = $ document.getElementById '$5'
      $5.attr 'value', 'derbyjs'
      expect(saddle.getProp '$5', 'value').to.be 'derbyjs'

      $6 = $ document.getElementById '$6'
      $6.trigger 'click'
      expect(saddle.getProp '$6', 'checked').to.be false

      # TODO: simulate keyboard press into text field
      return


  describe '#setProp()', ->
    it 'should set property', ->
      saddle.setProp '$5', 'value', 'coolness'
      $5 = $ document.getElementById '$5'
      expect($5.prop('value')).to.be 'coolness'

      saddle.setProp '$6', 'checked', false
      $6 = $ document.getElementById '$6'
      expect($6.prop('checked')).to.be false


  describe '#getHtml()', ->
    it 'should get HTML', ->
      expect(saddle.getHtml '$1').to.be '<p>1</p>'


  describe '#setHtml()', ->
    it 'should set HTML for element', ->
      saddle.setHtml '$1', '<div>123</div>'
      $1 = $ document.getElementById '$1'
      expect($1.html()).to.be '<div>123</div>'

      saddle.setHtml '$1', '<b>321</b>'
      $1 = $ document.getElementById '$1'
      expect($1.html()).to.be '<b>321</b>'

    it 'should set HTML for crooked range', ->
      saddle.setHtml '$0', 'test'
      $2 = $ document.getElementById '$2'
      expect($2.html().replace /\s+/g, '').to.be '<!--$$0--><p>2-2</p>'
      expect(document.getElementById '$1').to.be null

    it 'should set HTML for normal range', ->
      saddle.setHtml '$4', 'test<i></i>'
      $3 = $ document.getElementById '$3'
      expect($3.html().replace /\s+/g, '').to.be '<p>3-1</p><p>3-2</p><!--$4-->test<i></i><!--$$4-->'

      saddle.setHtml '$4', ''
      $3 = $ document.getElementById '$3'
      expect($3.html().replace /\s+/g, '').to.be '<p>3-1</p><p>3-2</p><!--$4--><!--$$4-->'


  describe '#append()', ->
    it 'should append html to div', ->
      $1 = $ document.getElementById '$1'

      saddle.append '$1', '<p>2</p>'
      expect($1.html()).to.be '<p>1</p><p>2</p>'

      saddle.append '$1', '<p>3</p>'
      expect($1.html()).to.be '<p>1</p><p>2</p><p>3</p>'


    it 'should append html to crooked renge', ->
      $2 = $ document.getElementById '$2'

      saddle.append '$0', '<p>0-1</p>'
      expect($2.html().replace /\s+/g, '').to.be '<p>2-1</p><p>0-1</p><!--$$0--><p>2-2</p>'

      saddle.append '$0', '<p>0-2</p>'
      expect($2.html().replace /\s+/g, '').to.be '<p>2-1</p><p>0-1</p><p>0-2</p><!--$$0--><p>2-2</p>'


