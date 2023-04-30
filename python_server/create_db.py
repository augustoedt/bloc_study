from database import Base, engine
from model import Item

print("Creating database ...")

Base.metadata.create_all(engine)