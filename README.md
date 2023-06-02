# VIDA Vector Tiler
Welcome to VIDA's Vector Tiler repository. This project is a PostGIS-based vector tiling solution built on top of the TiPG framework. It's designed to serve as a powerful, scalable solution for serving geospatial vector data directly from PostGIS. The repository includes the application code for a Python FastAPI application and Terraform infrastructure code for deploying the application to Google Cloud Platform (GCP) using the Cloud Run service.

## Project Structure
This project is structured into two main parts:

 - The `app/` directory contains the FastAPI application code which leverages the TiPG framework for vector tiling functionality.
 - The `terraform/` directory contains the Terraform code to deploy the application on GCP's Cloud Run service.

## Prerequisites
Before you get started, you'll need to have the following:

 - Python 3.10 or higher
 - Terraform v0.13 or higher
 - A GCP account with the necessary permissions to create resources
 - gcloud CLI installed and configured

Happy tiling!