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

Stores information about the users of the system.

- **user_id** (UUID): Unique identifier for each user. It is the primary key.
- **username** (VARCHAR(255)): Unique username for the user. This field is required.
- **password_hash** (VARCHAR(255)): Encrypted password for the user. This field is required.
- **email** (VARCHAR(255)): Email address of the user. This field is optional.
- **created_at** (TIMESTAMP): The timestamp when the user was created. Defaults to the current timestamp.

#### Roles Table

Stores different roles that can be assigned to users.

- **role_id** (UUID): Unique identifier for each role. It is the primary key.
- **role_name** (VARCHAR(50)): Name of the role. This field is unique and required.

#### User Roles Table

Links users with roles.

- **user_role_id** (UUID): Unique identifier for each user-role relationship. It is the primary key.
- **user_id** (UUID): Foreign key referencing the `users` table. On delete, the associated user is also removed.
- **role_id** (UUID): Foreign key referencing the `roles` table. On delete, the associated role is also removed.

### Group Management Service Schema

#### Groups Table

Stores information about different groups.

- **group_id** (UUID): Unique identifier for each group. It is the primary key.
- **group_name** (VARCHAR(255)): Name of the group. This field is optional.

#### Group Memberships Table

Links users with groups.

- **membership_id** (UUID): Unique identifier for each group-membership relationship. It is the primary key.
- **user_id** (UUID): Foreign key referencing the `users` table. On delete, the associated user is also removed.
- **group_id** (UUID): Foreign key referencing the `groups` table. On delete, the associated group is also removed.

### Poll Management Service Schema

#### Polls Table

Stores information about polls.

- **poll_id** (UUID): Unique identifier for each poll. It is the primary key.
- **title** (VARCHAR(255)): Title of the poll.
- **description** (TEXT): Description of the poll.
- **num_answers_allowed** (INT): Number of answers allowed per poll.
- **creator_id** (UUID): Foreign key referencing the `users` table. On delete, sets this field to NULL.
- **group_id** (UUID): Foreign key referencing the `groups` table. On delete, sets this field to NULL.
- **time_created** (TIMESTAMP): The timestamp when the poll was created. Defaults to the current timestamp.
- **time_updated** (TIMESTAMP): The timestamp when the poll was last updated. Defaults to the current timestamp.
- **deadline** (TIMESTAMP): The deadline for the poll.

#### Answer Options Table

Stores the possible answers for each poll.

- **answer_id** (UUID): Unique identifier for each answer option. It is the primary key.
- **poll_id** (UUID): Foreign key referencing the `polls` table. On delete, removes associated answer options.
- **ordinal** (INT): The order of the answer option.
- **answer_text** (TEXT): The text of the answer option.
- **num_of_votes** (INT): The number of votes for this answer option.

#### Voting Deadlines Table

Stores deadlines related to voting.

- **deadline_id** (SERIAL): Unique identifier for each voting deadline. It is the primary key.
- **poll_id** (UUID): Foreign key referencing the `polls` table. On delete, removes associated deadlines.
- **deadline_datetime** (TIMESTAMP): The date and time of the voting deadline.

### Voting Service Schema

#### Votes Table

Stores the votes cast by users.

- **vote_id** (UUID): Unique identifier for each vote. It is the primary key.
- **user_id** (UUID): Foreign key referencing the `users` table. On delete, removes associated votes.
- **answer_id** (UUID): Foreign key referencing the `answer_options` table. On delete, removes associated votes.
- **vote_datetime** (TIMESTAMP): The timestamp when the vote was cast. Defaults to the current timestamp.

### Indexes for Foreign Keys

#### User Roles Indexes

- **idx_user_roles_user_id**: Index on `user_id` for fast lookups in the `user_roles` table.
- **idx_user_roles_role_id**: Index on `role_id` for fast lookups in the `user_roles` table.

#### Group Memberships Indexes

- **idx_group_memberships_user_id**: Index on `user_id` for fast lookups in the `group_memberships` table.
- **idx_group_memberships_group_id**: Index on `group_id` for fast lookups in the `group_memberships` table.

#### Polls Indexes

- **idx_polls_creator_id**: Index on `creator_id` for fast lookups in the `polls` table.
- **idx_polls_group_id**: Index on `group_id` for fast lookups in the `polls` table.

#### Answer Options Index

- **idx_answer_options_poll_id**: Index on `poll_id` for fast lookups in the `answer_options` table.

#### Voting Deadlines Index

- **idx_voting_deadlines_poll_id**: Index on `poll_id` for fast lookups in the `voting_deadlines` table.

#### Votes Indexes

- **idx_votes_user_id**: Index on `user_id` for fast lookups in the `votes` table.
- **idx_votes_answer_id**: Index on `answer_id` for fast lookups in the `votes` table.