#!/bin/bash




echo "*** update & upgrade ***"
yes Y | apt-get update && apt-get upgrade

echo "*** installing python3 ***"
yes Y | apt-get install python3-pip

sleep 3

echo "*** installing requests python package ***"
yes Y | python3 -m pip install requests

echo "all done!"
