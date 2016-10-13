requestRetry = require 'requestretry'
queue = require 'block-queue'

# Create a queue for HTTP requests.
#
# Only one request is carried at every moment.
# Each request is retried until it succeeds or maxAttempts is passed.
#
# To add request task call push(options) on the result of createRequestQueue()
# Example:
#	requestQueue = require 'requestqueue'
# 	q = requestQueue()
#	q.push( { url: "http://example.org", method: "get" } )
module.exports = exports = (queueOpts = {}) ->
	queue 1, (opts, done) ->
		opts.maxAttempts ?= queueOpts.maxAttempts
		opts.retryDelay ?= queueOpts.retryDelay
		opts.retryStrategy ?= queueOpts.retryStrategy

		requestRetry opts, (err, response, body) ->
			done()
			if err
				try
					opts.callback?(err)
				catch e
					# make sure queueOpts error handler gets called
					console.error("requestqueue callback error", e, e.stack)
				queueOpts.errorHandler?(err)
				return
			opts.callback?(err, response, body)
