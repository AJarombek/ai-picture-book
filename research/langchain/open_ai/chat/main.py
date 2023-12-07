import os

from dotenv import load_dotenv
from langchain.chat_models import ChatOpenAI
from langchain.schema import BaseMessage, HumanMessage, SystemMessage

HELLO = "Bonjour!  Je m'appelle Andy.  Je suis un professeur de français."
EXIT = "sortie"
BYE = "Salut!"


OPENAI_MODEL = "gpt-3.5-turbo"
OPENAI_API_KEY = os.environ.get("OPENAI_API_KEY")

load_dotenv()

if __name__ == "__main__":
    # Requires an OpenAI API key in the 'OPENAI_API_KEY' environment variable to run
    # API requires a paid subscription
    chat = ChatOpenAI(openai_api_key=OPENAI_API_KEY, model_name=OPENAI_MODEL)

    messages = [
        SystemMessage(content="You are a kind, charismatic french instructor."),
        SystemMessage(
            content="You answer in French but clarify in English so that beginner students can understand."
        ),
        SystemMessage(
            content="Your responses should feel like a natural conversation with another human."
        ),
    ]

    print("Français Chatbot v1.0.0")
    print(HELLO)

    while True:
        user_input = input("> ")

        if user_input == EXIT:
            print(BYE)
            break
        else:
            messages.append(HumanMessage(content=user_input))
            response: BaseMessage = chat(messages)
            print(response.content)
            messages.append(response)
