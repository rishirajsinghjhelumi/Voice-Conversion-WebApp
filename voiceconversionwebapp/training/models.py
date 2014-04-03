from sqlalchemy import Column,Integer,Boolean

from ..models import Base,DBSession

from sqlalchemy.types import String
from sqlalchemy.schema import ForeignKey
from sqlalchemy.orm import relationship

from ..user.models import User

class TrainedCouple(Base):

    __tablename__ = 'trained_couples'

    id = Column(Integer,primary_key=True)
    user1_id = Column(Integer,ForeignKey('users.id'),default = 1)
    #user1 = relationship("User",foreign_keys=[user1_id])
    user2_id = Column(Integer,ForeignKey('users.id'),default = 1)
    #user2 = relationship("User",foreign_keys=[user2_id])

    def __init__(self, user1_id, user2_id):

    	self.user1_id = user1_id
    	self.user2_id = user2_id

    def getJSON(self):

    	jsonDict = {}
    	jsonDict['id'] = self.id
    	jsonDict['user1_id'] = self.user1_id
    	jsonDict['user2_id'] = self.user2_id

    	return jsonDict