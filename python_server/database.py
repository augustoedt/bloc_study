from sqlalchemy import create_engine
from sqlalchemy.orm import declarative_base, sessionmaker

Base = declarative_base()

engine = create_engine("postgresql://root:secret@localhost:5432/item_db?sslmode=disable", echo=True)

SessionLocal = sessionmaker(bin=engine)
