from pyramid.response import Response
from pyramid.view import view_config, forbidden_view_config
from pyramid.security import remember,authenticated_userid, forget, Authenticated

from pyramid.httpexceptions import HTTPFound

import hashlib

from .models import DBSession
from .models import User, UserProperty
from ..training.models import TrainedCouple

from ..voice_conversion.util import initUserDirectories

from sqlalchemy import and_

_DEFAULT_PROFILE_PIC = "static/img/profile_pic.jpg"

@view_config(
	route_name='register',
	renderer='json',
	request_method='POST',
	permission='__no_permission_required__'
)
def register(request):

	name = request.POST['name']
	email = request.POST['email']
	password = hashlib.sha256(request.POST['password']).hexdigest()
	# profile_pic = request.POST['profile_pic']

	dbFoundUser = DBSession.query(User).filter(User.email == email).first()
	if dbFoundUser:
		return {'status' : 'false'}

	dbFoundUser = User(name, email, password, _DEFAULT_PROFILE_PIC)
	DBSession.add(dbFoundUser)
	DBSession.flush()

	userProperty = UserProperty(dbFoundUser.id)
	DBSession.add(userProperty)
	DBSession.flush()

	initUserDirectories(dbFoundUser.id)

	request.session['user'] = dbFoundUser.getJSON()
	headers = remember(request, dbFoundUser.id)

	return HTTPFound(location = request.route_url('home'), headers = headers)

@view_config(
	route_name='login',
	renderer='json',
	request_method='POST',
	permission='__no_permission_required__'
)
def login(request):

	email = request.POST['email']
	password = hashlib.sha256(request.POST['password']).hexdigest()

	dbFoundUser = DBSession.query(User).\
	filter(and_(User.email == email, User.password == password)).\
	first()

	if dbFoundUser is None:
		return {'status' : 'false'}

	request.session['user'] = dbFoundUser.getJSON()
	headers = remember(request,dbFoundUser.id)

	return HTTPFound(location = request.route_url('home'), headers = headers)

@view_config(
	route_name='logout',
	renderer='json'
)
def logout(request):
    
    currentUser = int(authenticated_userid(request))
    headers = forget(request)
    request.session.invalidate()

    return HTTPFound(location = request.route_url('home'), headers = headers)


@view_config(
	route_name='getAllTrainedUsers',
	renderer='json',
	request_method='GET'
)
def getAllTrainedUsers(request):

	currentUser = int(authenticated_userid(request))

	query = DBSession.query(UserProperty).\
	filter(UserProperty.completed_training == True).\
	filter(UserProperty.user_id != currentUser)

	users = []
	for userProperty in query.all():
		users.append(userProperty.user.getJSON())

	return {'users' : users}

@view_config(
	route_name='getUsersTrainedWith',
	renderer='json',
	request_method='GET'
)
def getUsersTrainedWith(request):

	currentUser = int(authenticated_userid(request))

	trainedCouples = DBSession.query(TrainedCouple).\
	filter(TrainedCouple.user1_id == currentUser)

	users = []
	for trainedCouple in trainedCouples.all():
		users.append(trainedCouple.user2.getJSON())

	return {'users' : users}