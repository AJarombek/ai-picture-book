from fastapi.testclient import TestClient
from ai_picture_book.main import app
import pytest


@pytest.fixture
def client():
    return TestClient(app)


def test_read_root(client: TestClient):
    response = client.get("/")
    assert response.status_code == 200
    assert response.json() == {"message": "AI Picture Book API"}


def test_chat_endpoint_valid_input(client: TestClient):
    user_input = "Hello"
    response = client.get(f"/echo?user_input={user_input}")
    assert response.status_code == 200
    assert response.text == 'data: Hello\n\n'


def test_chat_endpoint_empty_input(client: TestClient):
    response = client.get("/echo?user_input=")
    assert response.status_code == 400
    assert response.json() == {"detail": "user_input cannot be empty"}


def test_chat_endpoint_no_input(client: TestClient):
    response = client.get("/echo")
    assert response.status_code == 422
    assert response.json() == {
        "detail": [
            {
                "input": None,
                "loc": ["query", "user_input"],
                "msg": "Field required",
                "type": "missing",
                "url": "https://errors.pydantic.dev/2.5/v/missing",
            }
        ]
    }


def test_generate_endpoint_mock(client: TestClient, monkeypatch):
    def mock_openai_response_stream(user_input: str):
        yield f"data: {user_input} from open ai\n\n"

    monkeypatch.setattr("ai_picture_book.main.openai_response_stream", mock_openai_response_stream)
    sample_user_input = "Hello"
    response = client.get(f"/generate?user_input={sample_user_input}")
    assert response.status_code == 200
    assert response.text == 'data: Hello from open ai\n\n'
