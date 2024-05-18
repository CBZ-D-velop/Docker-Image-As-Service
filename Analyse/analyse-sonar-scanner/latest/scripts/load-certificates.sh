#!/bin/bash

# Function to download and install certificates
download_and_install_certificates() {
    local WEBSITE_URI="${1}"

    echo "Downloading certificate for $WEBSITE_URI..."
    openssl s_client -showcerts -verify 20 -connect $WEBSITE_URI < /dev/null | awk '/-----BEGIN CERTIFICATE-----/, /-----END CERTIFICATE-----/' > /usr/local/share/ca-certificates/${WEBSITE_URI%%:*}.pem.crt  && \
    sudo update-ca-certificates  && \
    echo "Checking if the certificate is added to the system..."  && \
    openssl verify "/usr/local/share/ca-certificates/${WEBSITE_URI%%:*}.pem.crt" && \
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
