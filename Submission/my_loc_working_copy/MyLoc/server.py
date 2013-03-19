#!/usr/bin/python
from BaseHTTPServer import BaseHTTPRequestHandler,HTTPServer
from urlparse import urlparse

PORT_NUMBER = 8000
latitude = 0
longitude = 0


class myHandler(BaseHTTPRequestHandler):

	def do_GET(self):
		self.send_response(200)
		self.send_header('Content-type','text/html')
		self.end_headers()
		# Send the html message

		data = self.path
			
		print 'The Request {}'.format(data)

		qs = {}
		path = self.path
		if '?' in path:
			path, tmp = path.split('?', 1)
			if '?' in tmp:
				tmp, setmp = tmp.split('?', 1)
				print 'The Latitude {}'.format(tmp)
				print 'The Longitude{}'.format(setmp)
				global latitude
				latitude = tmp
				global longitude
				longitude = setmp

		if "arte" in self.path:
			self.wfile.write("<meta http-equiv=refresh content=5><img src=http://open.mapquestapi.com/staticmap/v4/getmap?size=600,600&type=map&imagetype=jpeg&zoom=15&mcenter=" + latitude + ',' + longitude + '>')


		return




	def log_request(self, code=None, size=None):
		print('Request')

	def log_message(self, format, *args):
		print('Message')


try:
	#Create a web server and define the handler to manage the
	#incoming request
	server = HTTPServer(('', PORT_NUMBER), myHandler)
	print 'Started httpserver on port ' , PORT_NUMBER
	
	#Wait forever for incoming htto requests
	server.serve_forever()

except KeyboardInterrupt:
	print '^C received, shutting down the web server'
	server.socket.close()
