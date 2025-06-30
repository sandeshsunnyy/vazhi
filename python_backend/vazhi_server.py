import os
import uvicorn
from  fastapi import FastAPI, HTTPException, Body
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
import google.generativeai as genai
from dotenv import load_dotenv

load_dotenv()

GOOGLE_API_KEY = os.getenv("GOOGLE_API_KEY")
if not GOOGLE_API_KEY:
    raise ValueError("API key is not specified in the .env file.")
genai.configure(api_key=GOOGLE_API_KEY)

app = FastAPI(
    title="Gemini Integration API",
    description="An API for Vazhi app to interact with gemini API",
    version="0.1.0",
)

origins = [
    "http://localhost", 
    "http://localhost:8000",
    "http://localhost:8080",
]

app.add_middleware(
    CORSMiddleware,
    allow_origins = origins,
    allow_credentials = True,
    allow_methods = ["*"],
    allow_headers = ["*"],
)

class PromptRequest(BaseModel):
    prompt: str

class GeminiResponse(BaseModel):
    generated_text: str

model = genai.GenerativeModel('gemini-1.5-flash-latest')

@app.post('/gemini', response_model=GeminiResponse)
async def generate_text(request_body: PromptRequest):
    try:
        response = model.generate_content(request_body.prompt)

        if response and response.text:
            print(response.text)
            return(GeminiResponse(generated_text=response.text))
        else:
            print(f"Gemini API response: {response} stop reason {response.candidates[0].finish_reason.name}")

            if response.prompt_feedback and response.prompt_feedback.block_reason:
                raise HTTPException(
                    status_code=400,
                    detail=f"Prompt block due to: {response.prompt_feedback.block_reason.name}",
                )
            if response.candidates and response.candidates[0].finish_reason.name != "STOP":
                raise HTTPException(
                    status_code=500,
                    detail=f"Server-side failuer due to: {response.candidates[0].finish_reason.name}. Safety ratings: {response.candidates[0].safety_ratings}"
                )
            raise HTTPException(
                status_code=500,
                detail = "Failed to get a valid response from Gemini"
            )
    except Exception as e:
        print(f"Error!! {e}")
        
@app.get('/health')
async def health_check():
    return {"status": "healthy"}

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)