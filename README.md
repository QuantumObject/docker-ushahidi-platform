# docker-ushahidi-platform

Docker container for [Ushahidi Platform][3]

"Make smart decisions with a data management system that rapidly collects data from the crowd and visualizes what happened, when and where."

## Install dependencies

  - [Docker][2]

To install docker in Ubuntu 14.04 use the commands:

    $ sudo apt-get update
    $ wget -qO- https://get.docker.com/ | sh

 To install docker in other operating systems check [docker online documentation][4]

## Usage

To run container use the command below:

    $ docker run -d -p 80 quantumobject/docker-ushahidi-platform

## Accessing the Ushahidi Platform applications:

After that check with your browser at addresses plus the port assigined by docker:

  - **http://host_ip:port/**

To access the container from the server that the container is running :

    $ docker exec -it container_id /bin/bash

note: this is version 3 and in development at the moment client side of the application is not ready. Please use the container quantumobject/docker-ushahidi.

## More Info

About Ushahidi Platform: [www.ushahidi.com][1]

To help improve this container [quantumobject/docker-ushahidi-platform][5]

[1]:http://www.ushahidi.com/
[2]:https://www.docker.com
[3]:http://www.ushahidi.com/product/ushahidi/
[4]:http://docs.docker.com
[5]:https://github.com/QuantumObject/docker-ushahidi-platform
