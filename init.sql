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
    user_role_id UUID PRIMARY KEY,
    user_id UUID REFERENCES users(user_id) ON DELETE CASCADE NOT NULL,
    role_id UUID REFERENCES roles(role_id) ON DELETE CASCADE NOT NULL
);

-- Group Management Service Schema
CREATE TABLE groups (
    group_id UUID PRIMARY KEY,
    group_name VARCHAR(255)
);

CREATE TABLE group_memberships (
    membership_id UUID PRIMARY KEY,
    user_id UUID REFERENCES users(user_id) ON DELETE CASCADE NOT NULL,
    group_id UUID REFERENCES groups(group_id) ON DELETE CASCADE NOT NULL
);

-- Poll Management Service Schema
CREATE TABLE polls (
    poll_id UUID PRIMARY KEY,
    title VARCHAR(255),
    description TEXT,
    num_answers_allowed INT,
    creator_id UUID REFERENCES users(user_id) ON DELETE SET NULL NOT NULL,
    group_id UUID REFERENCES groups(group_id) ON DELETE SET NULL NOT NULL,
    time_created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    time_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deadline TIMESTAMP
);

CREATE TABLE answer_options (
    answer_id UUID PRIMARY KEY,
    poll_id UUID REFERENCES polls(poll_id) ON DELETE CASCADE,
    ordinal INT,
    answer_text TEXT,
    num_of_votes INT
);

CREATE TABLE voting_deadlines (
    deadline_id SERIAL PRIMARY KEY,
    poll_id UUID REFERENCES polls(poll_id) ON DELETE CASCADE NOT NULL,
    deadline_datetime TIMESTAMP
);

-- Voting Service Schema
CREATE TABLE votes (
    vote_id UUID PRIMARY KEY,
    user_id UUID REFERENCES users(user_id) ON DELETE CASCADE NOT NULL,
    answer_id UUID REFERENCES answer_options(answer_id) ON DELETE CASCADE NOT NULL,
    vote_datetime TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for Foreign Keys
CREATE INDEX idx_user_roles_user_id ON user_roles(user_id);
CREATE INDEX idx_user_roles_role_id ON user_roles(role_id);
CREATE INDEX idx_group_memberships_user_id ON group_memberships(user_id);
CREATE INDEX idx_group_memberships_group_id ON group_memberships(group_id);
CREATE INDEX idx_polls_creator_id ON polls(creator_id);
CREATE INDEX idx_polls_group_id ON polls(group_id);
CREATE INDEX idx_answer_options_poll_id ON answer_options(poll_id);
CREATE INDEX idx_voting_deadlines_poll_id ON voting_deadlines(poll_id);
CREATE INDEX idx_votes_user_id ON votes(user_id);
CREATE INDEX idx_votes_answer_id ON votes(answer_id);