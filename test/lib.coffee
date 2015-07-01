http = require 'http'
{ expect } = require 'chai'
RequestQueue = require '../'

describe 'requestqueue', ->
	before ->
		@attempts = 0
		@succeedAfterAttempts = 2
		@urls = []
		# create an http server that will fail the first attempts
		server = http.createServer (req, res) =>
			@attempts += 1
			@urls.push(req.url)
			if @attempts > @succeedAfterAttempts
				res.writeHead(200, { 'Content-Type': 'text/plain' })
				res.end('OK')
			else
				res.writeHead(500, { 'Content-Type': 'text/plain' })
				res.end('FAIL')
		server.listen(8080)

	it 'should retry until succeeded, keeping order of requests', (done) ->
		queue = RequestQueue({ retryDelay: 5 })
		queue.push({
			url: 'http://127.0.0.1:8080/first'
			callback: (err, response, body) =>
				expect(body).to.equal('OK')
				expect(@attempts).to.equal(3)
				expect(@urls).to.eql(['/first', '/first', '/first'])
		})
		queue.push({
			url: 'http://127.0.0.1:8080/second'
			callback: (err, response, body) =>
				expect(body).to.equal('OK')
				expect(@urls).to.eql(['/first', '/first', '/first', '/second'])
				done()
		})
