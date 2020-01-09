# edu-image

1. Burn the latest standard Raspbian image

1. Boot Pi from card and skip the setup.

1. Connect to the internet

1. Open a terminal and run the edu-image.sh script on the Pi

    ```bash
    wget --no-check-certificate -O - http://rpf.io/picademy-image | bash
    ```
    
    or
    
    ```bash
    wget --no-check-certificate -O - http://rpf.io/bytes-image | bash
    ```
    
1. Remove the card and place in **linux** laptop, mount both boot and main partitions 

1. Clone this repo to the linux machine

    ```bash
    git clone git@github.com:raspberrypilearning/edu-image.git
    ```
    
1. Unmount both partitions.

1. Make sure you have a `backups` directory in your homedir. Create one if necessary with `mkdir ~/backups`

1. Run `resize.sh` to reduce partition size.

    ```bash
    cd edu-image
    ./resize.sh 
    ```
    
1. A backup of the image will be created in `~/backups` that can be used to create new cards if needed.
