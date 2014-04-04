from pyramid.response import Response
from pyramid.view import view_config, forbidden_view_config
from pyramid.security import remember,authenticated_userid, forget, Authenticated

from pyramid.httpexceptions import HTTPFound

from sqlalchemy import and_

from .models import DBSession
from .models import TrainedCouple
from ..user.models import User, UserParagraph, UserProperty

from ..voice_conversion.util import trainCouple

@view_config(
	route_name='trainWith',
	renderer='json',
	request_method='GET'
)
def trainWith(request):

	currentUser = int(authenticated_userid(request))
	userId = int(request.matchdict['user_id'])

	trained = DBSession.query(TrainedCouple).\
	filter(and_(TrainedCouple.user1_id == currentUser, TrainedCouple.user2_id == userId)).\
	first()

	if trained:
		return {'status' : 'Already Trained' }

	currentUserTrainingComplete = DBSession.query(UserProperty.completed_training).\
	filter(UserProperty.user_id == currentUser).\
	first()

	if currentUserTrainingComplete == False:
		return {'status' : 'You have not completed training. Please do it first!!!!'}

	userTrainingComplete = DBSession.query(UserProperty.completed_training).\
	filter(UserProperty.user_id == userId).\
	first()

	if userTrainingComplete == False:
		return {'status' : 'The other user has not yet completed training!!!!'}

	# trainCouple(currentUser, userId) #TODO

	trainedCouple = TrainedCouple(currentUser, userId)
	DBSession.add(trainedCouple)
	DBSession.flush()

	return {'status' : 'Training Complete'}