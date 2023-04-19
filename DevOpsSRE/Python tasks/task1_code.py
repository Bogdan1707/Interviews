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
