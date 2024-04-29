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

## Using the container

### Login

In order for you to be able to pull the container image you must first connect your docker to your github account:

```bash
docker login -u {USERNAME} -p {TOKEN} ghcr.io
```

You can generate a token in Github->settings->developer settings->Personal access tokens->Tokens (classic)->Generate new token (classic).

Make sure to:

- name your token with a name indiacting its for your docker.
- Select the write:packages permission.

### Image pull

Once you have successfully connected your docker and github account, pull the image from Github packages.

```bash
docker pull ghcr.io/sympoll/postgres-database/sympoll-db:{TAG}
```

### Run a container instance

After pulling the image, you can now run a container instance.

```bash
docker run -d --name {CONTAINER_NAME} -p 5432:5432 -e POSTGRES_PASSWORD={PASSWORD} {IMAGE_HASH}
```

### Access your database

Use **DBeaver** to connect and interact with you DB.

1) Start a new connection.
2) Choose Postgresql as your DB.
3) Enter your chose password in the password field.
4) Test connection.
5) If a you get a popup to install drivers, install them.
6) Press finish

You should now be able to view your database.

## Schemas

The following are schemas for each of the tables in the tables in the DB:

### Polls Table

- `poll_id` (INTEGER): The unique identifier for each poll.
- `title` (VARCHAR(255)): The title of the poll.
- `description` (TEXT): A detailed description of the poll.
- `num_answers_allowed` (INTEGER): The number of answers allowed per user.
- `creator` (INTEGER): The ID of the user who created the poll.
- `group_id` (INTEGER): The ID of the group associated with the poll.
- `time_created` (TIMESTAMP): The timestamp when the poll was created.
- `time_updated` (TIMESTAMP): The timestamp when the poll was last updated.
- `time_ends` (TIMESTAMP): The timestamp when the poll ends.

### Answer Options Table

- `answer_id` (INTEGER): The unique identifier for each answer option.
- `poll_id` (INTEGER): The ID of the poll to which the answer option belongs.
- `ordinal` (INTEGER): The ordinal position of the answer option.
- `answer_text` (TEXT): The text of the answer option.
