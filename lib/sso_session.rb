require 'httparty'


class SsoSession
  class SsoException < StandardError; end

  include HTTParty

  def initialize sso_token
    # Setup server uri
    self.class.base_uri self.class.sso_server
    # Setup authentication
    self.class.digest_auth sso_token, self.class.secret
  end


  def id
    user_info[ __method__.to_s ]
  end


  def uuid
    user_info[ __method__.to_s ]
  end


  def username
    user_info[ __method__.to_s ]
  end


  def email
    user_info[ __method__.to_s ]
  end


  def user_info
    # Lazy get user info, returns a hash
    @user_info ||= get_user_info
  end


private
  def self.sso_server
    if ENV['sso_server'] 
      ENV['sso_server']
    else
      raise SsoException.new("ENV['sso_server'] not defined")
    end
  end


  def self.secret 
    if ENV['sso_secret'] 
      ENV['sso_secret'] 
    else
      raise SsoException.new("ENV['sso_secret'] not defined")
    end
  end


  def get_user_info
    res = self.class.get "#{self.class.sso_server}/sso_session"
    case res.response
    when Net::HTTPOK
      res.parsed_response['user']
    else
      raise SsoException.new("Could not fetch user info from sso server: #{res.response.code} #{res.message}")
    end
  end

end
