# Postgres Database Docker Image

This repository contains a Dockerfile and an init.sql file for building a Docker image of PostgreSQL with a specified database structure.

## Dockerfile Details

- The Dockerfile pulls an image of PostgreSQL version 16.2 and copies the init.sql file into it to initialize all tables.
- Any edit to the init.sql file will change the structure of the PostgreSQL container.

## Automated Workflow

- On push to the main branch, a workflow is triggered to automate the building of the container and pushing of its image to our GitHub Packages.
- The versioning of the containers is according to the dates at which they were published to the packages.

## Approval Process

- Any push to the main branch requires at least one member of the organization to approve.
