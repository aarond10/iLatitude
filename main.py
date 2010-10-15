#!/usr/bin/env python
# -*- coding: utf-8 -*-
from google.appengine.api import users,mail, urlfetch
from google.appengine.ext import db,webapp
from google.appengine.ext.webapp import template, util


import atom.url
import gdata.service
import gdata.gauth
import gdata.docs.client
import gdata.alt.appengine
import gdata.urlfetch
import settings

import cgi, os, datetime, time

class MainHandler(webapp.RequestHandler):

    def get(self, phone_id):

	access_token = None

	if phone_id:
		access_token = gdata.gauth.AeLoad('%s_accessToken' % phone_id)

	if phone_id and not access_token and users.get_current_user():
		self.redirect("/oauth/%s/request" % phone_id)
		return

	client = gdata.docs.client.DocsClient(auth_token=access_token, source='iphone-latitude-v1')

	#data = '{"data":{"kind":"latitude#location","timestampMs":%s,"latitude":34,"longitude":130}}' % (int(time.time()*1000))

	#http_request = atom.http_core.HttpRequest(uri=atom.http_core.Uri(scheme='https', host='www.googleapis.com', path='/latitude/v1/currentLocation'), method='POST')
    	#http_request.add_body_part(data, 'application/json')
    	#resp = client.request(http_request=http_request)

	#access_token.modify_request(req)

        path = os.path.join(os.path.dirname(__file__), 'templates/index.html')
        self.response.out.write(template.render(path, {
		"user": users.get_current_user(),
		"signin_url": users.create_login_url(str(atom.url.Url('http',settings.HOST_NAME, '/%s/' % phone_id))),
		"signout_url": users.create_logout_url(str(atom.url.Url('http',settings.HOST_NAME, '/%s/' % phone_id))),
		"phone_id":phone_id,

		#"curloc":access_token and client.Get("https://www.googleapis.com/latitude/v1/currentLocation").read(),#+"<br>"+resp.read(),
		"access_token":access_token,
	}))


class OAuthRequestHandler(webapp.RequestHandler):

    def get(self, phone_id):

	client = gdata.docs.client.DocsClient(source='iphone-latitude-v1')

	request_token = client.GetOAuthToken(("https://www.googleapis.com/auth/latitude",),
		atom.url.Url('http',settings.HOST_NAME, path='/oauth/%s/callback' % phone_id),
		settings.OAUTH_CONSUMER_KEY, settings.OAUTH_CONSUMER_SECRET)

	gdata.gauth.AeSave(request_token, '%s_reqKey' % users.get_current_user().user_id())

	self.redirect("%s&domain=iphone-latitude.appspot.com" % request_token.generate_authorization_url(
		google_apps_domain="iphone-latitude.appspot.com", 
		auth_server="https://www.google.com/latitude/apps/OAuthAuthorizeToken"))


class OAuthCallbackHandler(webapp.RequestHandler):

    def get(self, phone_id):

	client = gdata.docs.client.DocsClient(source='iphone-latitude-v1')

	saved_request_token = gdata.gauth.AeLoad('%s_reqKey' % users.get_current_user().user_id())
	request_token = gdata.gauth.AuthorizeRequestToken(saved_request_token, self.request.uri)

	access_token = client.GetAccessToken(request_token)

	gdata.gauth.AeSave(access_token, "%s_accessToken" % phone_id)

	self.redirect("/%s/" % phone_id)

class UpdateLocationHandler(webapp.RequestHandler):

    def get(self):

	phone_id = self.request.get("id")
	lat = float(self.request.get("lat"))
	lon = float(self.request.get("lon"))
	acc = float(self.request.get("acc"))

	access_token = gdata.gauth.AeLoad('%s_accessToken' % phone_id)

	self.response.out.write("u: %s, lat: %s, lon: %s, acc: %s" % ( phone_id, lat, lon, acc))

	data = '{"data":{"kind":"latitude#location","timestampMs":%s,"latitude":%f,"longitude":%f,"accuracy":%f}}' % (int(time.time()*1000), lat, lon, acc)

	client = gdata.docs.client.DocsClient(auth_token=access_token, source='iphone-latitude-v1')
	http_request = atom.http_core.HttpRequest(uri=atom.http_core.Uri(scheme='https', host='www.googleapis.com', path='/latitude/v1/currentLocation'), method='POST')
    	http_request.add_body_part(data, 'application/json')
	try:
    		resp = client.request(http_request=http_request)
	except Exception,e:
		self.response.out.write("Exception: %s" % e)
	
	


class PageNotFoundHandler(webapp.RequestHandler):
    def get(self):
	self.response.set_status(404)
        self.response.out.write('Whoops! Page doesn\'t seem to exist!')

def main():
    application = webapp.WSGIApplication([
		(r'/(?P<phone_id>[a-z0-9]+)/', MainHandler),
		(r'/oauth/(?P<phone_id>[a-z0-9]+)/request', OAuthRequestHandler),
		(r'/oauth/(?P<phone_id>[a-z0-9]+)/callback', OAuthCallbackHandler),
		(r'/update', UpdateLocationHandler),
		(r'.*', PageNotFoundHandler),
	], debug=True)
    util.run_wsgi_app(application)


if __name__ == '__main__':
    main()
