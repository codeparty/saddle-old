expect = require 'expect.js'
Dom = require '../../lib'

debugger

describe 'Dom', ->
  describe '#setHtml()', ->
    it 'should set HTML', ->
      dom = new Dom
      body = document.body

      dom.setHtml body, '<div>123</div>'

      expect(body.innerHTML).to.be '<div>123</div>'
      expect(body.innerText).to.be '123'
