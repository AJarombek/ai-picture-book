######################
# DOCUMENTATION
######################

install:
	cd research/langchain && poetry install

lint_python:
	cd research/langchain && poetry run ruff check

spell_check:
	cd research/langchain && poetry run codespell --toml pyproject.toml

format_python:
	cd research/langchain && poetry run ruff format