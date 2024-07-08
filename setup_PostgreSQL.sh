#!/bin/bash

# Prompt for PostgreSQL admin password and database user password
read -sp 'Enter PostgreSQL user (postgres) password: ' postgres_password
echo
read -sp 'Enter PostgreSQL user (gpt_user) password: ' user_password
echo

# Update the package index
sudo apt update

# Install PostgreSQL
sudo apt-get install -y postgresql postgresql-contrib

# Switch to the postgres user and create a new PostgreSQL user
sudo -u postgres psql -c "CREATE USER gpt_user WITH PASSWORD '$user_password';"

# Create a new PostgreSQL database and grant privileges to the user
sudo -u postgres psql -c "CREATE DATABASE gpt_db;"
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE gpt_db TO gpt_user;"

# Modify PostgreSQL authentication methods to use passwords
sudo sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/" /etc/postgresql/*/main/postgresql.conf
echo "host    all             all             0.0.0.0/0               md5" | sudo tee -a /etc/postgresql/*/main/pg_hba.conf > /dev/null

# Restart PostgreSQL for changes to take effect
sudo systemctl restart postgresql

# Output PostgreSQL connection parameters to .env file
if ! grep -q "POSTGRES_HOST=" .env; then
    echo "POSTGRES_HOST=localhost" >> .env
else
    sed -i 's/^POSTGRES_HOST=.*/POSTGRES_HOST=localhost/' .env
fi

if ! grep -q "POSTGRES_PORT=" .env; then
    echo "POSTGRES_PORT=5432" >> .env
else
    sed -i 's/^POSTGRES_PORT=.*/POSTGRES_PORT=5432/' .env
fi

if ! grep -q "POSTGRES_USER=" .env; then
    echo "POSTGRES_USER=gpt_user" >> .env
else
    sed -i 's/^POSTGRES_USER=.*/POSTGRES_USER=gpt_user/' .env
fi

if ! grep -q "POSTGRES_PASSWORD=" .env; then
    echo "POSTGRES_PASSWORD=$user_password" >> .env
else
    sed -i "s/^POSTGRES_PASSWORD=.*/POSTGRES_PASSWORD=$user_password/" .env
fi

if ! grep -q "POSTGRES_DB=" .env; then
    echo "POSTGRES_DB=gpt_db" >> .env
else
    sed -i 's/^POSTGRES_DB=.*/POSTGRES_DB=gpt_db/' .env
fi

# Print success message
echo "PostgreSQL connection parameters written to .env file."

# Import database.sql file
export PGPASSWORD=$user_password
psql -h localhost -U gpt_user -d gpt_db -f ./Chinook_PostgreSql.sql

# Check if the psql command was successful
if [ $? -eq 0 ]; then
    echo "Successfully imported Chinook_PostgreSql.sql"
else
    echo "Failed to import Chinook_PostgreSql.sql, Please see the error message above"
fi

# Install required Python packages
pip install --upgrade pip
pip install colorama langchain langchain-community langchain-openai python-dotenv # if pip doesn't work, try pip3

# Check if the psql command was successful
if [ $? -eq 0 ]; then
    echo "Python dependencies installed successfully"
else
    echo "Failed to install langchain, Please see the error message above"
fi

echo "Installation and configuration complete. You can now run this application."

echo -e "Run this command: \e[32mpython3 talk_to_db.py\e[0m" # if python doesn't work, try python3