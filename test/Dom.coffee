expect = require 'expect.js'
Dom = require '../lib'

describe 'Dom', ->
  describe '#setHtml()', ->
    it 'should set HTML', ->
      dom = new Dom
      body = document.body

      dom.setHtml body, '<div>123</div>'

      expect(body.innerHTML).to.be '<div>123</div>'
      # textContent for firefox
      expect(body.innerText || body.textContent).to.be '123'
