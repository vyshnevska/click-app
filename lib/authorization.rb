module Sinatra
  module Authorization

    def auth
      @auth ||= Rack::Auth::Basic::Request.new(request.env) 
    end

    def unauthorized!(realm = "Short URL Generator")
      headers "WWW-Authenticate" => %(Basic realm="#{realm}")
      throw :halt, [401, 'Authorization is rewuired']
    end

    def bad_request!
      throw :halt, [400, 'Bad request']
    end

    def authorized?
      request.env['REMOTE_USER']
    end

    def authorize(username, password)
      if (username =='topfunky' && password=='peepcode') then
        true
      else
        false
      end
    end

    def require_admin
      return if authorized?
      unauthorized! unless auth.provided?
      bad_request! unless auth.basic?
      unauthorized! unless authorize(*auth.credentials)
      request.env['REMOTE_USER'] = auth.username
    end

  end
end
