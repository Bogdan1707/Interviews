# Interviews 
## Module 1 Python 
### Task 1: 
<b>Create HTTPS server:</b> Create a Flask server that communicates over HTTPS. The
server should accept requests <br> from clients over HTTPS and respond with a JSON
payload containing a greeting message and the client's IP address.<br><br>


Here is the example of server code. <br>
    
    from flask import Flask, jsonify, request
    import ssl

    app = Flask(__name__)

    # generate SSL certificate and key
    context = ssl.SSLContext(ssl.PROTOCOL_TLSv1_2)
    context.load_cert_chain('cert.pem', 'key.pem')

    @app.route('/', methods=['GET'])
    def index():
    ip_address = request.remote_addr
    message = 'Hello, your IP address is {}!'.format(ip_address)
    return jsonify({'message': message, 'ip_address': ip_address})

    if __name__ == '__main__':
    app.run(host='0.0.0.0', port=443, ssl_context=context)

In this implementation, we create a Flask application and define a route for the root URL ('/'). <br> When a client sends a GET request to this URL, the server responds with a JSON payload containing a greeting message and the client's IP address. <br><br>

We also generate an SSL context using the SSL certificate and key files ('cert.pem' and 'key.pem'), and configure the Flask application to use this<br> SSL context when serving HTTPS requests. Finally, we start the server by calling the `run` method on the application instance, specifying the host ('0.0.0.0') <br> and port (443) to listen on.

### Task 2:
**AWS Lambda - Handle S3 bucket creation:** Write a Lambda function that triggers
when an S3 bucket object is created and performs a specific action. <br><br>

Here is example of implementation: <br>

    def lambda_handler(event, context):
        # Get the S3 bucket name and object key from the event
        s3_bucket = event['Records'][0]['s3']['bucket']['name']
        s3_key = event['Records'][0]['s3']['object']['key']
        
        # Specific action, for example, you can print the S3 bucket name and object key
        print(f"S3 bucket name: {s3_bucket}")
        print(f"S3 object key: {s3_key}")

