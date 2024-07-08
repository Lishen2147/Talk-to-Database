from langchain.chains.sql_database.query import create_sql_query_chain
from langchain_community.agent_toolkits.sql.base import create_sql_agent
from langchain_community.agent_toolkits.sql.toolkit import SQLDatabaseToolkit
from langchain.agents.agent_types import AgentType
from langchain_openai import ChatOpenAI
from langchain_openai import OpenAI
from langchain_community.utilities import SQLDatabase

from dotenv import load_dotenv
import os

# Import colorama for colored output
from colorama import init, Fore, Style

# Initialize colorama
init()

# Load environment variables from .env file
load_dotenv()

# Get database credentials from environment variables
db_user = os.getenv('POSTGRES_USER')
db_password = os.getenv('POSTGRES_PASSWORD')
db_host = os.getenv('POSTGRES_HOST')
db_port = os.getenv('POSTGRES_PORT')
db_name = os.getenv('POSTGRES_DB')
openai_key = os.getenv('OPENAI_API_KEY')

db_uri = f"postgresql://{db_user}:{db_password}@{db_host}:{db_port}/{db_name}"
model_name = "gpt-3.5-turbo"

chain = create_sql_agent(
    llm=ChatOpenAI(
        temperature=0,
        model=model_name,
        openai_api_key=openai_key
    ),
    toolkit=SQLDatabaseToolkit(
        db=SQLDatabase.from_uri(db_uri),
        llm=OpenAI(temperature=0, api_key=openai_key, model=model_name)
    ),
    verbose=False,
    agent_type=AgentType.OPENAI_FUNCTIONS
)

sql_chain = create_sql_query_chain(
    llm = ChatOpenAI(
        temperature=0,
        model=model_name
    ),
    db=SQLDatabase.from_uri(db_uri)
)

print(f"{Fore.GREEN}What do you want to know about the database?{Style.RESET_ALL}")
user_question = input()

result = chain.invoke(user_question)
sql_query_result = sql_chain.invoke({"question":user_question})

print(f"\n{Fore.GREEN}Query:{Style.RESET_ALL}")
print(sql_query_result)
print(f"\n{Fore.GREEN}Response:{Style.RESET_ALL}")
print(result["output"])