#!/bin/bash

get_regions_for_provider() {
    case "$1" in
        aws)
            echo "us-east-1 us-east-2 us-west-1 us-west-2"
            ;;
        gcp)
            echo "us-central1 us-east1 us-west1 europe-west1"
            ;;
        azure)
            echo "eastus eastus2 westus westus2 westeurope"
            ;;
        *)
            echo "Unsupported cloud provider"
            return 1
            ;;
    esac
}
