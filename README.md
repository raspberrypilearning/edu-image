1. Burn the latest standard Raspian image
1. Boot Pi from card and run the edu-image.sh script on the Pi
    ```
    wget --no-check-certificate -O - https://goo.gl/8LwA0I | bash
    ```
1. Remove the card and place in **linux** laptop, mount both boot and main partitions 
1. Clone this repo to the linux machine
    ```
    git clone git@github.com:raspberrypilearning/edu-image.git
    ```
1. Unmount both partitions. 
1. Run resize.sh to reduce partition size.
    ```
    cd edu-image
    ./resize.sh
    ```
1. A backup of the image will be created in ~/backups that can be used to create new cards if needed.
