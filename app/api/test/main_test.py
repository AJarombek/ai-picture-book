from fastapi.testclient import TestClient
from main import app
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
    response = client.get(f"/chat?user_input={user_input}")
    assert response.status_code == 200
    assert response.text == 'data: Hello\n\n'


def test_chat_endpoint_empty_input(client: TestClient):
    response = client.get("/chat?user_input=")
    assert response.status_code == 400
    assert response.json() == {"detail": "user_input cannot be empty"}
