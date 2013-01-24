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
* `_emitUpdate()`: run on pending updates from `nextUpdate()`. Subject to remove from API
* `addComponent(ctx, component)`: adds components with its context to the Dom

* `fns`: helper functions. Subject to remove from API
  * `$forChildren(e, el, next, dom)`: trigger event for element's children
  * `$forName(e, el, next, dom)`: trigger event for elements with the same name

* `uid()`: get an unique id
* `getRangeMarker()`: returns comment or script tag depending on what browser we are dealing with

# Testing

You need to install grunt globally:
```sh
$ npm i -g grunt
```

Run auto testing:
```sh
$ grunt test
```