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

## Database Schema

This repository contains the database schema for the User Management Service, Group Management Service, Poll Management Service, and Voting Service.

### User Management Service Schema

#### Users Table

The `users` table stores information about the users of the application.
- `user_id`: A unique identifier for each user (UUID).
- `username`: A unique username for each user (VARCHAR 255, NOT NULL).
- `password_hash`: The hashed password for the user (VARCHAR 255, NOT NULL).
- `email`: The email address of the user (VARCHAR 255).
- `created_at`: The timestamp when the user was created (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP).

#### Roles Table

The `roles` table defines different roles that can be assigned to users.
- `role_id`: A unique identifier for each role (UUID).
- `role_name`: The name of the role (VARCHAR 50, UNIQUE, NOT NULL).

#### User Roles Table

The `user_roles` table manages the many-to-many relationship between users and roles.
- `group_id`: The identifier for the group to which the user belongs (VARCHAR 255, NOT NULL).
- `user_id`: The identifier for the user (UUID, NOT NULL).
- `role_id`: The identifier for the role (UUID, REFERENCES roles(role_id) ON DELETE CASCADE).
- Primary Key: Combination of `group_id` and `user_id`.
- Foreign Key: `user_id` references `users(user_id)` ON DELETE CASCADE.
- Foreign Key: `group_id` references `groups(group_id)` ON DELETE CASCADE.

### Group Management Service Schema

#### Groups Table

The `groups` table stores information about the different groups within the application.
- `group_id`: A unique identifier for each group (VARCHAR 255, PRIMARY KEY).
- `group_name`: The name of the group (VARCHAR 255).

#### Group Memberships Table

Links users with groups.

The `group_memberships` table manages the many-to-many relationship between users and groups.
- `user_id`: The identifier for the user (UUID, REFERENCES users(user_id) ON DELETE CASCADE, NOT NULL).
- `group_id`: The identifier for the group (VARCHAR 255, REFERENCES groups(group_id) ON DELETE CASCADE, NOT NULL).
- Primary Key: Combination of `group_id` and `user_id`.

### Poll Management Service Schema

#### Polls Table

The `polls` table stores information about the different polls created within the application.
- `poll_id`: A unique identifier for each poll (UUID, PRIMARY KEY).
- `title`: The title of the poll (VARCHAR 255).
- `description`: The description of the poll (TEXT).
- `nof_answers_allowed`: The number of answers allowed for the poll (INT).
- `creator_id`: The identifier for the user who created the poll (UUID).
- `group_id`: The identifier for the group to which the poll belongs (VARCHAR 255).
- `time_created`: The timestamp when the poll was created (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP).
- `time_updated`: The timestamp when the poll was last updated (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP).
- `deadline`: The deadline for the poll (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP).

#### Answer Options Table

The `voting_item_options` table stores the different options available for voting in each poll.
- `voting_item_id`: A unique identifier for each voting item (UUID, PRIMARY KEY).
- `poll_id`: The identifier for the poll to which the voting item belongs (UUID, REFERENCES polls(poll_id)).
- `ordinal`: The order of the voting item in the poll (INT).
- `description`: The description of the voting item (TEXT).
- `vote_count`: The number of votes received by the voting item (INT).

### Voting Service Schema

#### Votes Table

The `votes` table stores information about the votes cast by users.
- `vote_id`: A unique identifier for each vote (UUID, PRIMARY KEY).
- `user_id`: The identifier for the user who cast the vote (UUID, REFERENCES users(user_id) ON DELETE CASCADE, NOT NULL).
- `voting_item_id`: The identifier for the voting item that was voted on (UUID, REFERENCES voting_item_options(voting_item_id) ON DELETE CASCADE, NOT NULL).
- `vote_datetime`: The timestamp when the vote was cast (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP).