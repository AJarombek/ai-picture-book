.PHONY: install run test

llama_file := llava-v1.5-7b-q4.llamafile
llama_file_url := https://huggingface.co/jartine/llava-v1.5-7B-GGUF/resolve/main/llava-v1.5-7b-q4.llamafile?download=true

$(llama_file):
	if [ ! -e $(llama_file) ]; then \
		curl -LO $(llama_file_url); \
	fi

install:
	poetry install

run:
	chmod +x $(llama_file)
	(trap 'kill 0' SIGINT; ./llava-v1.5-7b-q4.llamafile & poetry run uvicorn ai_picture_book.main:app --reload)

test:
	poetry run pytest

main: install $(llama_file) test run 
	@echo "All dependencies installed and file downloaded successfully!"

.DEFAULT_GOAL := main