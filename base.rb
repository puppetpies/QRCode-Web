########################################################################
#
# Author: Brian Hood
#
# Description: QRCode Maker
#
# Application: base.rb
#
# Where it all happens LinkedIn Example Application
#
########################################################################


require 'rubygems' if RUBY_VERSION < "1.9"
require 'rqrcode'
require 'sinatra/base'

# Yes i monkey patched Sinatra to add a get and post method

class Sinatra::Base

  class << self

    def getpost(path, opts={}, &block)
      get(path, opts, &block)
      post(path, opts, &block)
    end

  end

end

class QRCodeMaker < Sinatra::Base

  set :server, :puma
  set :logging, :true

  configure do
    enable :session
  end

  before do
    content_type :html
  end

  set :title, "QRCode Maker"
  set :port, 8080
  set :bind, "0.0.0.0"

  def qrcode(qrtext)
    @qr = RQRCode::QRCode.new("#{qrtext}")
  end

  getpost '/' do
    if params[:submit] != nil
      @qrdata = qrcode("#{params[:qrtext]}")
    end
    puts "Process ERB"
    erb :base
  end
  
  run!

end

QRCodeMaker.new
