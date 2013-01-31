saddle
======

DOM bindings for Derby

# API draft
internal API are not listed

* `clear()`: clear markers, components and event listeners
* `bind(eventName, id, listener)`:
* `item(id)`: get item by marker id
* `marker(name)`: get marker by name
* `update(el, method, ignore, value, property, index)`: magic box that does dom manipulations
* `nextUpdate(cb)`: on the next dom update exec callback
* `_emitUpdate()`: run pending updates from `nextUpdate()`. Subject to remove from API
* `addComponent(ctx, component)`: add components with its context to the Dom

* `fns`: helper functions. Subject to remove from API
  * `$forChildren(e, el, next, dom)`: trigger event for element's children
  * `$forName(e, el, next, dom)`: trigger event for elements with the same name

* `uid()`: get an unique id
* `getRangeMarker()`: return comment or script tag depending on what browser we are dealing with

# Testing

You need to install grunt globally:
```sh
$ npm i -g grunt
```

Run auto testing:
```sh
$ grunt test
```

For IE 6 open `test/mocha.ie6.html`


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