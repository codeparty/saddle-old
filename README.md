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


# Testing

You need to install grunt globally:
```sh
$ npm i -g grunt
```

Run auto testing:
```sh
$ grunt test
```
Open local file `test/mocha.ie6.html` in IE 6


### Test status
IE 6.0: passes: 21  

IE 7.0: Executed 21 of 21 SUCCESS  
IE 8.0: Executed 21 of 21 SUCCESS  
IE 9.0: Executed 21 of 21 SUCCESS  

Opera 11.50: Executed 21 of 21 SUCCESS  
Opera 12.11: Executed 21 of 21 SUCCESS  

Safari 5.1: Executed 21 of 21 SUCCESS  
Safari 6.0: Executed 21 of 21 SUCCESS  

Firefox 3.0: Executed 21 of 21 SUCCESS  
Firefox 12.0: Executed 21 of 21 SUCCESS  
Firefox 18.0: Executed 21 of 21 SUCCESS  

Chrome 24.0: Executed 21 of 21 SUCCESS  
Chrome 26.0: Executed 21 of 21 SUCCESS  
