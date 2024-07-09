# Talk-to-Database

This project uses `langchain` and OpenAI's ChatGPT to generate a SQL query according to the user's inputs, an SQL agent would run the query and reproduce the result in human-understandable text.
## Database
The database is a highly complicated management system for mocking cyber-shopping scenarios.
Here is an overview of the tables in the database.
![Database Overview](https://github.com/Lishen2147/Talk-to-Database/assets/65699767/39d94fc5-2a98-4b40-8aa0-d32454610d09)

## Preparation
An OpenAI account with an available Credit Balance, this project will only use a few cents but every charge is at least $5
1. Go to your profile
2. User API keys
3. Create a new secret key
4. Copy and paste a secret key into a .env file
```OPENAI_API_KEY=your_api_key```


## Run
1. Run the setup_PostgreSQL.sh to install PostgreSQL, initialize Postgre user, and import database tables
```./setup_PostgreSQL.sh```
2. Run the Python script
```python3 talk_to_db.py```
![Execution](https://github.com/Lishen2147/Talk-to-Database/assets/65699767/3dd29567-50d1-4f44-a7b3-39bc21a4a4d2)
