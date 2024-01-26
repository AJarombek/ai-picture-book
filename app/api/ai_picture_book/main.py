import inspect
import os
import logging

from fastapi import FastAPI, HTTPException, Request
from fastapi.responses import StreamingResponse
from fastapi.middleware.cors import CORSMiddleware
from dotenv import load_dotenv
from langchain_openai import ChatOpenAI
from langchain_core.messages import SystemMessage, HumanMessage, BaseMessage
from openai import OpenAI

load_dotenv()
app = FastAPI()

OPENAI_MODEL = "gpt-3.5-turbo"
OPENAI_API_KEY = os.environ.get("OPENAI_API_KEY")

origins = ["http://localhost:8080"]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


async def generate_response_stream(user_input: str):
    yield "data: {}\n\n".format(user_input)


async def openai_langchain_response_stream(user_input: str):
    chat = ChatOpenAI(openai_api_key=OPENAI_API_KEY, model_name=OPENAI_MODEL)

    messages = [
        SystemMessage(content="You are creating text for a picture book given a user's input."),
        SystemMessage(content="The picture book should be anywhere from 10 to 30 pages long."),
        SystemMessage(content="You should properly delineate the end of each page."),
        HumanMessage(content=user_input),
    ]

    response: BaseMessage = chat.invoke(messages)
    logging.info(response.content)
    yield "data: {}\n\n".format(response.content)


async def openai_response_stream(user_input: str):
    open_ai_client = OpenAI(api_key=OPENAI_API_KEY)

    stream = open_ai_client.chat.completions.create(
        model=OPENAI_MODEL,
        messages=[
            {
                "role": "user",
                "content": inspect.cleandoc(
                    f"""
                    Prompt:
                    You are creating text for a picture book given a user's input.  
                    The picture book should be anywhere from 10 to 30 pages long.
                    
                    The end of each page should be delineated with a special | character.
                    Whitespace between words should be delineated with a special _ character.
                    
                    Sample output (do not copy):
                    
                    Once_upon_a_time,_there_was_a_curious_cat_named_Whiskers.|Whiskers_loved_to_explore|
                    One_sunny_day,_Whiskers_was_strolling_in_the_park.
                    
                    User Input:
                    {user_input}
                    """
                )
            }
        ],
        stream=True,
    )

    for chunk in stream:
        content = chunk.choices[0].delta.content
        if content is not None:
            logging.info(content)
            yield "data: {}\n\n".format(content)


@app.get("/")
async def root_endpoint():
    return {"message": "AI Picture Book API"}


@app.get("/echo")
async def chat_endpoint(request: Request, user_input: str):
    if user_input == "":
        raise HTTPException(status_code=400, detail="user_input cannot be empty")

    return StreamingResponse(generate_response_stream(user_input), media_type="text/event-stream")


# Endpoint that calls the OpenAI API to generate text for a picture book based on the user's input.
# The endpoint should return a StreamingResponse response with the generated text.
@app.get("/generate")
async def generate_endpoint(request: Request, user_input: str):
    headers = {
        "Cache-Control": "no-cache",
        "Connection": "keep-alive",
        "Content-Type": "text/event-stream",
    }

    if user_input == "":
        raise HTTPException(status_code=400, detail="user_input cannot be empty")

    return StreamingResponse(openai_response_stream(user_input), headers=headers)
