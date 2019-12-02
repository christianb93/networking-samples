from wsgiref.simple_server import make_server

def application(environ, start_response):

    start_response(
        '200 OK', 
        [('Content-type', 'text/html')]
    )

    response = "<html><body><p>Hello!</p></body></html>"
    return [bytes(response, 'utf-8')]

print("Starting up")
httpd = make_server('', 8800, application)
httpd.serve_forever()
