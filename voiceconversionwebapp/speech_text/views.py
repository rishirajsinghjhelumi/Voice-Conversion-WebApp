from pyramid.response import Response
from pyramid.view import view_config, forbidden_view_config
from pyramid.security import remember,authenticated_userid, forget, Authenticated

from pyramid.httpexceptions import HTTPFound

from sqlalchemy import and_

from .models import DBSession
from .models import Paragraph
from ..user.models import User, UserParagraph, UserProperty
from .models import NUM_PARAGRAPHS

@view_config(
	route_name='paragraphs',
	renderer='json',
	request_method='GET',
	permission='__no_permission_required__'
)
def paragraphs(request):

	paragraphQuery = DBSession.query(Paragraph)
	paragraphs = []
	for paragraph in paragraphQuery.all():
		paragraphs.append(paragraph.getJSON())

	return {'paragraphs' : paragraphs}

@view_config(
	route_name='userParagraphs',
	renderer='json',
	request_method='GET'
)
def userParagraphs(request):

	currentUser = int(authenticated_userid(request))

	paragraphQuery = DBSession.query(UserParagraph).\
	filter(UserParagraph.user_id == currentUser).\
	all()

	paragraphs = []
	for paragraph in paragraphQuery:
		paragraphs.append(paragraph.paragraph_id)

	return {'paragraphs' : paragraphs}

@view_config(
	route_name='userParagraphUpdate',
	renderer='json',
	request_method='POST'
)
def userParagraphUpdate(request):

	currentUser = int(authenticated_userid(request))
	paragraphId = request.POST['paragraph_id']

	userParagraph = DBSession.query(UserParagraph).\
	filter(and_(UserParagraph.user_id == currentUser, UserParagraph.paragraph_id == paragraphId)).\
	first()

	if userParagraph:
		return {'status' : 'false'}

	# saveUserParagrph(request) # TODO

	userParagraph = UserParagraph(currentUser, paragraphId)
	DBSession.add(userParagraph)

	userProperty = DBSession.query(UserProperty).filter(UserProperty.user_id == currentUser).first()
	userProperty.paragraph_read_count += 1
	if userProperty.paragraph_read_count == NUM_PARAGRAPHS:
		userProperty.completed_training = True

	DBSession.flush()

	return {'status' : 'true'}