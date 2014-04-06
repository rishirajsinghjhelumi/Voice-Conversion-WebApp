from pyramid.response import Response
from pyramid.view import view_config,forbidden_view_config
from pyramid.security import remember,authenticated_userid, forget, Authenticated
from pyramid.httpexceptions import HTTPFound

from models import DBSession
from user.models import User

@view_config(route_name='home',renderer='index.mako', permission='__no_permission_required__')
def homeView(request):
    return {}


@view_config(route_name='home',effective_principals=[Authenticated], renderer='dashboard.mako')
def dashboard(request):

	currentUser = int(authenticated_userid(request))

	if 'user' not in request.session:
		user = DBSession.query(User).\
		filter(User.id == currentUser).\
		first()
		request.session['user'] = user.getJSON()
	return {}


@view_config(route_name='profile',renderer='profile.mako')
def profile(request):
	return {}


@view_config(route_name='training',renderer='training.mako')
def training(request):
	return {}


@view_config(route_name='about',renderer='about.mako',permission='__no_permission_required__')
def about(request):
	return {}


@view_config(route_name='help',renderer='help.mako',permission='__no_permission_required__')
def help(request):
	return {}


@forbidden_view_config()
def forbidden(request):
    return Response('Not Allowed')


@view_config(context='pyramid.exceptions.NotFound', renderer='json', permission='__no_permission_required__')
def notFound_view(request):
    notFound404 = '404 Not Found'
    return {'error' : notFound404}