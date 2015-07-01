requestqueue
------------

[![npm version](https://badge.fury.io/js/requestqueue.svg)](http://npmjs.org/package/requestqueue)
[![dependencies](https://david-dm.org/resin-io/requestqueue.png)](https://david-dm.org/resin-io/requestqueue.png)

[![npm](https://nodei.co/npm/requestqueue.png)](https://npmjs.org/package/requestqueue)

Run requests in sequence and retry them if they fail using [request-retry](https://www.npmjs.com/package/request-retry) module.

This is useful when requests need to be send in a guaranteed order, for example when sending status updates.

The response should not be expected to arrive immediately (nor soon), since there may be other requests in the queue or the response may arrive after several retries.

Installation
------------

```sh
$ npm install requestqueue
```

Example
-------

```js
RequestQueue = require('requestqueue');

// Set default maxAttempts and retryDelay for this queue
// Also sets an error handler in case a request exceeds maxAttempts
queue = RequestQueue({ 
	maxAttempts: 5, 
	retryDelay: 1000, 
	errorHandler: function (err) {
		console.error('A request could not be completed:', err.message)
	}
});

// Queue a request, the arguments are passed to request-retry module.
queue.push( {
	method: 'GET',
	url: 'http://www.google.com'
	maxAttempts: 3600,
	retryDelay: 1000,
	callback: function (err, response, body) {
		console.log('got response body', body);
	}
} );
```

Support
-------

If you're having any problem, please [raise an issue](https://github.com/resin-io/requestqueue/issues/new) on GitHub and the Resin.io team will be happy to help.

Tests
-----

Run the test suite by doing:

```sh
$ npm install && npm test
```

Contribute
----------

- Issue Tracker: [github.com/resin-io/requestqueue/issues](https://github.com/resin-io/requestqueue/issues)
- Source Code: [github.com/resin-io/requestqueue](https://github.com/resin-io/requestqueue)

Before submitting a PR, please make sure that you include tests, and that [coffeelint](http://www.coffeelint.org/) runs without any warning.

License
-------

The project is licensed under the MIT license.
