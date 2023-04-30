from typing import Optional
from fastapi import FastAPI
from pydantic import BaseModel

app = FastAPI()


class Item(BaseModel):  # serializer
    id: str
    name: str
    description: str
    price: int
    on_offer: bool


@app.get('/greet')
def greet_optional_name(name:Optional[str]="user"):
    return {"message": f"Hello {name}"}

@app.put('/item/{item_id}')
def update_item(item_id: str, item: Item):
    return {
        'name': item.name,
        'description': item.description,
        'price': item.price,
        'on_offer': item.on_offer
    }

# @app.get("/api/persons1")
# async def root():
#     return [
#         {
#             "name": "Foo 1",
#             "age": 20
#         },
#         {
#             "name": "Bar 1",
#             "age": 23
#         },
#         {
#             "name": "Baz 1",
#             "age": 24
#         },
#     ]
#
# @app.get("/api/persons2")
# async def root():
#     return [
#         {
#             "name": "Foo 2",
#             "age": 20
#         },
#         {
#             "name": "Bar 2",
#             "age": 23
#         },
#         {
#             "name": "Baz 2",
#             "age": 24
#         },
#     ]
#
