from langchain.chat_models import ChatOpenAI
from langchain.schema import SystemMessage, HumanMessage, BaseMessage

if __name__ == '__main__':
    # Requires an OpenAI API key in the 'OPENAI_API_KEY' environment variable to run
    # API requires a paid subscription
    chat = ChatOpenAI()

    messages = [
        SystemMessage(content="You are a kind, charismatic french instructor."),
        SystemMessage(content="You answer in French but clarify in English so that beginner students can understand."),
        HumanMessage(content="How do I say 'I'm sorry, I don't speak French very well' in French?"),
    ]
    response: BaseMessage = chat(messages)
    print(response.content)
