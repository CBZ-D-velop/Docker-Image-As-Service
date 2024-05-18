#!/bin/bash

# Function to download and install certificates
download_and_install_certificates() {
    local WEBSITE_URI="${1}"
    local COMMAND="/BEGIN/,/END/{ if(/BEGIN/){a++}; out=\"./tmp_certs/${WEBSITE_URI%%:*}-cert\"a\".pem.crt\"; print >out}"

    echo "Downloading certificate for $WEBSITE_URI..."
    mkdir -p ./tmp_certs
    openssl s_client -showcerts -verify 20 -connect $WEBSITE_URI < /dev/null | awk "$COMMAND"
    cp ./tmp_certs/*.pem.crt /usr/local/share/ca-certificates/
    # Update system certificates
    sudo update-ca-certificates
    rm -rf ./tmp_certs
    echo "Checking if the certificate is added to the system..."
    curl -sI https://$WEBSITE_URI | grep -i "HTTP/1.1 200 OK" > /dev/null
    echo "Certificate downloaded and added to the system for $WEBSITE_URI."
}

# Function to show help
show_help() {
    echo "Usage: $0 --uri <website_uri>"
    echo "Options:"
    echo "  --uri <website_uri>   Specify the FULL website URI for downloading the certificate"
    echo "  --help                Show this help message"
}

# Main function
main() {
    # Check if --help option is provided
    if [[ "${1}" == "--help" ]]; then
        show_help
        exit 0
    fi

    # Check if --uri option is provided
    if [[ "${1}" == "--uri" ]]; then
        WEBSITE_URI="${2}"
    else
        echo "Error: Please specify the website URI using the --uri option."
        exit 1
    fi

    # Download and install certificates
    download_and_install_certificates "$WEBSITE_URI"
}

# Call the main function with command line arguments
main "$@"
