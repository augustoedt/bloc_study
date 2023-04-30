import uuid

from sqlalchemy import Boolean, Column, Integer, String, Text, text
from sqlalchemy.dialects.postgresql import UUID

from database import Base


class Item(Base):
    __tablename__ = 'item'
    id = Column(UUID(as_uuid=True),primary_key=True, server_default=text("gen_random_uuid()"))
    name = Column(String(255), nullable=False, unique=True)
    description = Column(Text)
    price = Column(Integer, nullable=False)
    on_offer = Column(Boolean, default=False)

    def __repr__(self):
        return f"<Item name={self.name}\n\tid={self.id}\n\tprice={self.price}\n\ton_offer={self.on_offer}\n>"
