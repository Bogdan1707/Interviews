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

## Module 2: Docker 
### Task 1
**Python App - Compiled Library:** Create a Docker image for a Python app that uses a
C library. <br> The C library needs to be compiled from source, and the Python app needs to
be able to access the compiled library. <br><br>
1. Create Dockerfile 

Dockerfile 

    # Use an official Python runtime as a parent image
    FROM python:3.9-slim-buster

    # Set the working directory to /app
    WORKDIR /app

    # Install any needed packages specified in requirements.txt
    COPY requirements.txt ./
    RUN pip install -r requirements.txt

    # Install any necessary build tools
    RUN apt-get update && apt-get install -y build-essential

    # Copy the C library source code to the container
    COPY libsource /app/libsource

    # Compile the C library
    RUN cd libsource && make

    # Copy the Python application code to the container
    COPY app.py /app

    # Run the command to start the Python application
    CMD [ "python", "./app.py" ]

2. Create **requirements.txt** file with necessary python dependencies
3. Place the C library source code in a directory called **libsource** in the project directory.
4. In the Python application code, import the C library using **ctypes**. For example:

        import ctypes

        mylib = ctypes.CDLL('/app/libsource/libmylib.so')

5. Build the Docker image

        docker build -t myimage .

6. run Docker container

        docker run myimage


## Module 3: Terraform
### Task 1
**AWS Lambda:** Create a Terraform configuration that provisions an AWS Lambda function and an API Gateway endpoint that triggers the Lambda function.<br> The configuration should include appropriate IAM roles and permissions. <br>

This configuration creates the following resources:

1. An IAM role with an assume role policy that allows AWS Lambda to assume the role
2. An IAM policy with permissions for logging
3. An attachment of the IAM policy to the IAM role
4. An AWS Lambda function that uses the IAM role
5. An API Gateway REST API
6. An API Gateway resource for the Lambda function
7. An API Gateway method for the resource with the HTTP method POST
8. An API Gateway integration that integrates the method with the Lambda function

Find code in Terraform/main.tf 

## Module 4: Bash
### Task 1
**Scan Hosts:**: Write a Bash script that performs a network health check by pinging a list
of hosts and logging the results to a file. <br> The script should prompt the user for the name
of the file containing the list of hosts, <br> the number of ping packets to send, and the time
interval between ping packets. The script should output <br> a message for each host
indicating whether the ping was successful or not<br> and log the results to a file. The log file
should contain the timestamp, the host name or IP address,<br> the number of packets sent,
the number of packets received, and the percentage of packets lost <br><br>

Here is the code:

    #!/bin/bash

    # Prompt user for input
    read -p "Enter the file name containing the list of hosts: " file_name
    read -p "Enter the number of ping packets to send: " packet_count
    read -p "Enter the time interval between ping packets (in seconds): " interval

    # Get timestamp for log file
    timestamp=$(date +"%Y-%m-%d %H:%M:%S")

    # Create log file
    log_file="ping_log_${timestamp}.txt"
    touch $log_file

    # Loop through each host in file and ping it
    while read host; do
    # Ping host and get packet statistics
    ping_result=$(ping -c $packet_count -i $interval $host)
    packet_loss=$(echo "$ping_result" | awk '/packet loss/{print $6}' | cut -d "%" -f 1)
    packet_loss=${packet_loss:-0} # handle case where packet loss is not found
    packet_received=$(($packet_count - $packet_loss))

    # Write result to console and log file
    if [[ $packet_loss -eq 0 ]]; then
        echo "$host is up"
        echo "${timestamp},${host},${packet_count},${packet_received},0%" >> $log_file
    else
        echo "$host is down"
        echo "${timestamp},${host},${packet_count},${packet_received},${packet_loss}%" >> $log_file
    fi
    done < $file_name

    echo "Results logged to $log_file"

Here's how the script works:

1. It prompts the user for the file name containing the list of hosts, the number of ping packets to send, and the time interval between ping packets.
2. It gets the current timestamp to use in the log file name.
3. It creates a log file with the timestamp in the name.
4. It loops through each host in the file and pings it using the ping command.
5. It extracts the packet loss and packet received statistics from the ping command output.
6. It writes the result to the console and the log file, including the timestamp, host name or IP address, packet count, packet received count, and percentage of packets lost.
7. It repeats steps 4-6 for each host in the file.
8. It outputs a message indicating that the results have been logged to the log file.