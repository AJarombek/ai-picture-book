import os

from dotenv import load_dotenv
from langchain.chains import LLMChain
from langchain.prompts import PromptTemplate
from langchain_community.utilities.dalle_image_generator import DallEAPIWrapper
from langchain_openai import OpenAI
import requests

OPENAI_MODEL = "gpt-3.5-turbo"
OPENAI_API_KEY = os.environ.get("OPENAI_API_KEY")

load_dotenv()

if __name__ == "__main__":
    # Requires an OpenAI API key in the 'OPENAI_API_KEY' environment variable to run
    # temperature configures the randomness of the output
    llm = OpenAI(temperature=0.9, api_key=OPENAI_API_KEY)
    prompt = PromptTemplate(
        input_variables=["image_desc"],
        template="Generate a detailed prompt to generate an image based on the following description: {image_desc}",
    )
    chain = LLMChain(llm=llm, prompt=prompt)
    image_url = DallEAPIWrapper().run(
        chain.run("Stuffed animal horse galloping through a field")
    )
    print(image_url)

    response = requests.get(image_url)

    if response.status_code == 200:
        with open("horse.png", "wb") as f:
            f.write(response.content)
        print("Image saved to 'horse.png'")
    else:
        print(f"Failed to download image. Status code: {response.status_code}")
