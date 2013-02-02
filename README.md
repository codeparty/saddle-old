saddle
======

DOM bindings for Derby

# API

* `clear()`: clear markers, components and event listeners
* `uid()`: get an unique id
* `getMarkers()`: returns function, that templates <!--comment--> or <comment></comment> tags depending on what browser we are dealing with
* `getAttr(id, name)`: get attribute by element id
* `setAttr(id, name, val)`: set attribute by element id
* `getProp(id, name)`: get property by element id
* `setProp(id, name, val)`: set property by element id
* `getHtml(id)`: get inner html by element id
* `setHtml(id, html)`: set inner html by element/markers id
* `append(id, html)`: append html to element/markers by id
* `prepend(id, html)`: prepend html to element/markers by id
* `insert(id, html, index)`: insert html at index into element/markers by id
* `remove(id, index)`: remove node at index from element/markers by id
* `move(id, from, to, howMany = 1)`: move nodes at index within element/markers by id

## Not supporting yet
* IE 6-7 SVG manipulation
* IE < 9 `<script>` insertion into empty div [see metamorph](https://github.com/tomhuda/metamorph.js/blob/8a6745c6d6f19fcf2279b9ab4bdcc9300fbd37a5/lib/metamorph.js#L18)
* IE loosing some tags [see meteor](https://github.com/meteor/meteor/blob/4d98d8cb4e5a95e9e98953f44c872c9332a042a3/packages/domutils/domutils.js#L61) (mb the same thing as above)
* IE loosing comments in `<select>` and `<option>` [see meteor](https://github.com/meteor/meteor/blob/4d98d8cb4e5a95e9e98953f44c872c9332a042a3/packages/domutils/domutils.js#L64)
* IE `<select>` value from attribute [see meteor](https://github.com/meteor/meteor/blob/4d98d8cb4e5a95e9e98953f44c872c9332a042a3/packages/domutils/domutils.js#L66)

# Testing

You need to install grunt globally:
```sh
$ npm i -g grunt
```

Run auto testing:
```sh
$ grunt test
```
Test opens Chrome by default
You can open [localhost:8080](http://localhost:8080/) in any browser to run automated tests  
Open local file `test/mocha.browser.html` in IE 6

You can find borwser tests in `test/Saddle.coffee`


### Test status
IE 6.0: SVG fails

IE 7.0: SVG fails
IE 8.0: SUCCESS  
IE 9.0: SUCCESS  

Opera 11.50: SUCCESS  
Opera 12.11: SUCCESS  

Safari 5.1: SUCCESS  
Safari 6.0: SUCCESS  

Firefox 3.0: SUCCESS  
Firefox 12.0: SUCCESS  
Firefox 18.0: SUCCESS  

Chrome 24.0: SUCCESS  
Chrome 26.0: SUCCESS  

Android 4.x Browser: SUCCESS  
Android 4.x Chrome: SUCCESS  

iOS 6.x Safari: SUCCESS  
iOS 6.x Chrome: SUCCESS  
