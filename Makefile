######################
# DOCUMENTATION
######################

lint-python: 
	cd research/langchain && poetry run ruff check

spell_check:
	cd research/langchain && poetry run codespell --toml pyproject.toml

format-python: 
	cd research/langchain && poetry run ruff format