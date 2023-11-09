from langchain.chat_models import ChatOpenAI
from langchain.schema import SystemMessage, HumanMessage, BaseMessage

HELLO = "Bonjour!  Je m'appelle Andy.  Je suis un professeur de français."
EXIT = "sortie"
BYE = "Salut!"

if __name__ == '__main__':
    # Requires an OpenAI API key in the 'OPENAI_API_KEY' environment variable to run
    # API requires a paid subscription
    chat = ChatOpenAI()

    messages = [
        SystemMessage(content="You are a kind, charismatic french instructor."),
        SystemMessage(content="You answer in French but clarify in English so that beginner students can understand."),
        SystemMessage(content="Your responses should feel like a natural conversation with another human."),
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
