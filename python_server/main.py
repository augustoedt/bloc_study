from fastapi import FastAPI

app = FastAPI()

@app.get("/")
async def root():
    return {"message": "Hello World"}

@app.get("/api/persons1")
async def root():
    return [
        {
            "name": "Foo 1",
            "age": 20
        },
        {
            "name": "Bar 1",
            "age": 23
        },
        {
            "name": "Baz 1",
            "age": 24
        },
    ]

@app.get("/api/persons2")
async def root():
    return [
        {
            "name": "Foo 2",
            "age": 20
        },
        {
            "name": "Bar 2",
            "age": 23
        },
        {
            "name": "Baz 2",
            "age": 24
        },
    ]

