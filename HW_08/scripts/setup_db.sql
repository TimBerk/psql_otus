-- Create the user
CREATE USER suser WITH PASSWORD 'spass';

-- Create the database
CREATE DATABASE stest owner suser;

-- Grant necessary permissions on the public schema
GRANT ALL ON SCHEMA public TO suser;
GRANT ALL ON ALL TABLES IN SCHEMA public TO suser;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO suser;