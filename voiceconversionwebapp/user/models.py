from sqlalchemy import Column,Integer,Boolean

from ..models import Base,DBSession

from sqlalchemy.types import String
from sqlalchemy.schema import ForeignKey
from sqlalchemy.orm import relationship

from ..speech_text.models import Paragraph

class User(Base):
    
    __tablename__ = 'users'
    
    id = Column(Integer,primary_key=True)
    name = Column(String(256))
    email = Column(String(256),nullable = False)
    password = Column(String(256))
    profile_pic = Column(String(4096))
    
    def __init__(self, name, email, password, profile_pic):
        
        self.name = name
        self.email = email
        self.profile_pic = profile_pic
        self.password = password
        
    def getJSON(self):
        
        jsonDict = {}
        jsonDict['id'] = self.id
        jsonDict['name'] = self.name
        jsonDict['email'] = self.email
        jsonDict['profile_pic'] = self.profile_pic
        
        return jsonDict

class UserProperty(Base):

    __tablename__ = 'user_properties'

    id = Column(Integer,primary_key=True)
    user_id = Column(Integer,ForeignKey('users.id'),default = 1)
    user = relationship("User",foreign_keys=[user_id])

    completed_training = Column(Boolean)
    paragraph_read_count = Column(Integer)

    def __init__(self, user_id, completed_training = False, paragraph_read_count = 0):

        self.user_id = user_id
        self.completed_training = completed_training
        self.paragraph_read_count = paragraph_read_count

    def getJSON(self):

        jsonDict = {}
        jsonDict['user_id'] = self.user_id
        jsonDict['completed_training'] = self.completed_training
        jsonDict['paragraph_read_count'] = self.paragraph_read_count

        return jsonDict

class UserParagraph(Base):

    __tablename__ = 'user_paragraphs'

    id = Column(Integer,primary_key=True)
    user_id = Column(Integer,ForeignKey('users.id'),default = 1)
    #user = relationship("User",foreign_keys=[user_id])

    paragraph_id = Column(Integer,ForeignKey('paragraphs.id'),default = 1)
    #paragraph = relationship("Paragraph",foreign_keys=[paragraph_id])

    def __init__(self, user_id, paragraph_id):

        self.user_id = user_id
        self.paragraph_id = paragraph_id

    def getJSON(self):

        jsonDict = {}
        jsonDict['id'] = self.id
        jsonDict['user_id'] = self.user_id
        jsonDict['paragraph_id'] = self.paragraph_id

        return jsonDict

class UserConvertedSpeech(Base):

    __tablename__ = 'user_converted_speeches'

    id = Column(Integer,primary_key=True)
    user_id = Column(Integer,ForeignKey('users.id'),default = 1)
    #user = relationship("User",foreign_keys=[user_id])
    user_converted_id = Column(Integer,ForeignKey('users.id'),default = 1)
    #user_converted = relationship("User",foreign_keys=[user_converted_id])
    speech_file = Column(String(4096))

    def __init__(self, user_id, user_converted_id, speech_file):

        self.user_id = user_id
        self.user_converted_id = user_converted_id
        self.speech_file = speech_file

    def getJSON(self):

        jsonDict = {}
        jsonDict['id'] = self.id
        jsonDict['user_id'] = self.user_id
        jsonDict['user_converted_id'] = self.user_converted_id
        jsonDict['speech_file'] = self.speech_file

        return jsonDict