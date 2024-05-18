#!/bin/bash

# Function to download and install certificates
download_and_install_certificates() {
    local WEBSITE_URI="${1}"
    local CERT_CHAIN_FILE="./tmp/${WEBSITE_URI%%:*}_chain.pem"
    mkdir -p ./tmp

    echo "Downloading certificate for $WEBSITE_URI..."
    echo -n | openssl s_client -showcerts -verify 20 -connect $WEBSITE_URI 2>/dev/null | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > $CERT_CHAIN_FILE
    csplit -f "./tmp/cert_" -b "%02d.pem.crt" "$CERT_CHAIN_FILE" '/-BEGIN CERTIFICATE-/' '{*}'
    rm ./tmp/cert_00.pem.crt
    sudo cat ./tmp/cert_*.pem.crt >> /etc/ssl/certs/ca-certificates.crt
    echo "Checking if the certificate is added to the system..."
    openssl verify $CERT_CHAIN_FILE
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
