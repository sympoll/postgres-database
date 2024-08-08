-- User Management Service Schema
CREATE TABLE users (
    user_id UUID PRIMARY KEY,
    username VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    email VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE roles (
    role_id UUID PRIMARY KEY,
    role_name VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE user_roles (
    group_id VARCHAR(255) NOT NULL,
    user_id UUID NOT NULL,
    role_id UUID REFERENCES roles(role_id) ON DELETE CASCADE,
    PRIMARY KEY (group_id, user_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- Group Management Service Schema
CREATE TABLE groups (
    group_id VARCHAR(255) PRIMARY KEY,
    group_name VARCHAR(255),
);

CREATE TABLE group_memberships (
    user_id UUID REFERENCES users(user_id) ON DELETE CASCADE NOT NULL,
    group_id VARCHAR(255) REFERENCES groups(group_id) ON DELETE CASCADE NOT NULL PRIMARY KEY (group_id, user_id),
);

-- Poll Management Service Schema
CREATE TABLE polls (
    poll_id UUID PRIMARY KEY,
    title VARCHAR(255),
    description TEXT,
    nof_answers_allowed INT,
    creator_id UUID,
    group_id VARCHAR(255),
    time_created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    time_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deadline TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE voting_item_options (
    voting_item_id SERIAL PRIMARY KEY,
    poll_id UUID REFERENCES polls (poll_id),
    ordinal INT,
    description TEXT,
    vote_count INT
);

-- Voting Service Schema
CREATE TABLE votes (
    vote_id UUID PRIMARY KEY,
    user_id UUID REFERENCES users(user_id) ON DELETE CASCADE NOT NULL,
    voting_item_id UUID REFERENCES voting_item_options(voting_item_id) ON DELETE CASCADE NOT NULL,
    vote_datetime TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);