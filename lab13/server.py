from wsgiref.simple_server import make_server

def application(environ, start_response):

    start_response(
        '200 OK', 
        [('Content-type', 'text/html')]
    )

    response = "<html><body><p><b>Environment data:</b></p>"
    response += "<table><tr><th>Key</th><th>Value</th></tr>"
    for key, value in environ.items():
        response +=  "<tr><td>%s</td><td>%s</td></tr>" % ( key, value)
    response = response + "</table></body></html>"
    return [bytes(response, 'utf-8')]

print("Starting up")
httpd = make_server('', 8800, application)
httpd.serve_forever()
