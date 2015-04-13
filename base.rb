########################################################################
#
# Author: Brian Hood
#
# Description: QRCode Maker
#
# Application: base.rb
#
# Where it all happens
#
########################################################################


require 'rubygems' if RUBY_VERSION < "1.9"
require 'rqrcode'
require 'sinatra/base'

SINATRADEBUG = 0

# Yes i monkey patched Sinatra to add a get and post method

class Sinatra::Base

  class << self
  
    def getpost(path, opts={}, &block)
      get(path, opts, &block)
      post(path, opts, &block)
    end

    def tea(path, opts={}, &block)
      get(path, opts, &block)
    end
    
  end
  
end

class QRCodeMaker < Sinatra::Base

  set :server, :puma
  set :logging, :true if SINATRADEBUG == 1
	
  configure do
    enable :session
    if SINATRADEBUG == 1
      Log = Logger.new("sinatra.log")
      Log.level  = Logger::DEBUG 
    end
  end
    
  before do
	content_type :html
  end
	
  set :title, "QRCode Maker"
  set :port, 8080
  
  def qrcode(qrtext)
	@qr = RQRCode::QRCode.new("#{qrtext}")
  end
  
  getpost '/' do
	if params[:submit] != nil
	  @qrdata = qrcode("#{params[:qrtext]}")
	end
	
    # Process ERB template render
    puts "Process ERB"
  	erb :base
  end
  
  run!

end

QRCodeMaker.new
