# Talk-to-Database

This project uses langchain and OpenAI's ChatGPT to generate a SQL query according to user's inputs, an SQL agent would run the query and reproduce the result in human understandable text.

## Preparation
An OpenAI account with available Credit Balance, this project will only use few cent but every charge is at least $5
1. Go to your profile
2. User API keys
3. Create a new secret key
4. Copy and paste a secret key into a .env file
```OPENAI_API_KEY=your_api_key```

## Run
1. Run the setup_PostgreSQL.sh to install PostgreSQL, initialize Postgre user, and import database tables
```./setup_PostgreSQL.sh```
2. Run the python script
```python3 talk_to_db.py```