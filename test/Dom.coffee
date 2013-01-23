expect = require 'expect.js'
Dom = require '../lib'

describe 'Dom', ->
  describe '#setHtml()', ->
    it 'should set HTML', ->
      dom = new Dom
      body = document.body
      $body = $ body

      dom.setHtml body, '<div>123</div>'

      expect($body.html()).to.be '<div>123</div>'
      expect($body.text()).to.be '123'
