-- User Management Service Schema
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    email VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE roles (
    role_id SERIAL PRIMARY KEY,
    role_name VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE user_roles (
    user_role_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(user_id),
    role_id INT REFERENCES roles(role_id)
);

-- Group Management Service Schema
CREATE TABLE groups (
    group_id SERIAL PRIMARY KEY,
    group_name VARCHAR(255) UNIQUE NOT NULL
);

CREATE TABLE group_memberships (
    membership_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(user_id),
    group_id INT REFERENCES groups(group_id)
);

-- Poll Management Service Schema
CREATE TABLE polls (
    poll_id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    num_answers_allowed INT NOT NULL, 
    creator_id INT REFERENCES users(user_id) NOT NULL,
    group_id INT REFERENCES groups(group_id) NOT NULL,
    time_created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    time_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    time_ends TIMESTAMP DEFAULT CURRENT_TIMESTAMP

);

CREATE TABLE answer_options (
    answer_id SERIAL PRIMARY KEY,
    poll_id INT REFERENCES polls(poll_id),
    ordinal INT NOT NULL,
    answer_text TEXT
);

-- CREATE TABLE questions (
--     question_id SERIAL PRIMARY KEY,
--     poll_id INT REFERENCES polls(poll_id),
--     question_text TEXT,
--     question_type VARCHAR(50)
-- );

CREATE TABLE voting_deadlines (
    deadline_id SERIAL PRIMARY KEY,
    poll_id INT REFERENCES polls(poll_id),
    deadline_datetime TIMESTAMP
);

-- Voting Service Schema
CREATE TABLE votes (
    vote_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(user_id),
    poll_id INT REFERENCES polls(poll_id),
    option_id INT REFERENCES answer_options(option_id),
    vote_datetime TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
