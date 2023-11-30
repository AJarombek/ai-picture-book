.PHONY: install run test

install:
	poetry install

run:
	poetry run uvicorn ai_picture_book.main:app --reload

test:
	poetry run pytest
