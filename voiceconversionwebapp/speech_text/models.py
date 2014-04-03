from sqlalchemy import Column,Integer,Boolean

from ..models import Base,DBSession

from sqlalchemy.types import String
from sqlalchemy.schema import ForeignKey
from sqlalchemy.orm import relationship

class Paragraph(Base):

    __tablename__ = 'paragraphs'

    id = Column(Integer,primary_key=True)
    text = Column(String(8192))

    def __init__(self, text):

    	self.text = text

    def getJSON(self):

    	jsonDict = {}
    	jsonDict['id'] = self.id
    	jsonDict['text'] = self.text

    	return jsonDict
