from fastapi import FastAPI, HTTPException, Request
from fastapi.responses import StreamingResponse
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI()

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


@app.get("/")
async def root_endpoint():
    return {"message": "AI Picture Book API"}


@app.get("/chat")
async def chat_endpoint(request: Request, user_input: str):
    if user_input == "":
        raise HTTPException(status_code=400, detail="user_input cannot be empty")

    return StreamingResponse(generate_response_stream(user_input), media_type="text/event-stream")
