
require "rubygems"
require "sinatra"
require "sinatra/json"
require "sinatra/activerecord"
require "newrelic_rpm"
require "open-uri"
require "uri"
require "json"
require "oauth"
require "oauth2"
require "omniauth"
require "omniauth-twitter"
require "omniauth-oauth2"
require "rest-client"
require "stripe"
require 'sinatra/assetpack'
require "./models"
load "./charge.rb"
load "./lib/mprinter.rb"
load "./lib/order_process.rb"
load "./lib/order_views.rb"
load "./lib/barkeeper.rb"
load "./lib/venue.rb"
load "./lib/liquor.rb"
load "./lib/food.rb"
load "./lib/admin.rb"

configure do
  set :public_folder, Proc.new { File.join(root, "static") }
  set :method_override, true
end

configure :development do
  set :database, "sqlite3:///orders.db"
end

configure :production do

  db_yml = YAML::load(File.read(File.join(File.dirname(__FILE__), "config", "database.yml")))
  settings = {
    :adapter    => db_yml["production"]["adapter"],
    :host       => db_yml["production"]["host"],
    :username   => db_yml["production"]["username"],
    :password   => db_yml["production"]["password"],
    :database   => db_yml["production"]["database"],
    :encoding   => db_yml["production"]["encoding"]
  }

  ActiveRecord::Base.establish_connection(settings)
end

use Rack::Session::Cookie, :key => 'rack.session',
                           :path => '/',
                           :expire_after => 14400, # In seconds
                           :secret => 'nPiOpaoyqcyeaABv2huEqlvZw6CxkC0Qo71hMlbwMbhmzWAjcndLD5piz9PqXt8'



helpers do
  def phone
    session[:phone] ? session[:phone] : 'No Phone'
  end

  def firstname
    session[:firstname] ? session[:firstname] : 'No Firstname'
  end

  def lastname
    session[:lastname] ? session[:lastname] : 'Hello Stranger'
  end
  
  def venue
    session[:venue] ? session[:venue] : 'No Venue'
  end

  def location
    session[:location] ? session[:location] : 'No Location'
  end

  # define a current_user method, so we can be sure if an user is authenticated
  def current_user
    !session[:uid].nil?
  end

  #def pretty_date(stamp)
  # now = Time.new
  # diff = now - stamp
  # day_diff = ((now - stamp) / 86400).floor
 
  # day_diff == 0 && (
  #   diff < 60 && "just now" ||
  #   diff < 120 && "1 minute ago" ||
  #   diff < 3600 && (diff / 60).floor.to_s + " minutes ago" ||
  #   diff < 7200 && "1 hour ago" ||
  #   diff < 86400 && (diff/3600).floor.to_s + " hours ago") ||
  # day_diff == 1 && "Yesterday" ||
  # day_diff < 7 && day_diff.to_s + " days ago" ||
  # day_diff < 31 && (day_diff.to_s / 7).ceil + " weeks ago";
  #end
end

ENV['SECRET_KEY'] = 'sk_live_vS8zCWvoE6vrqt0GV0heKPFK'
ENV['PUBLISHABLE_KEY'] = 'pk_live_4zkBWuo6HLSqUGNPSUhD29ex'

set :publishable_key, ENV['PUBLISHABLE_KEY']
set :secret_key, ENV['SECRET_KEY']

Stripe.api_key = settings.secret_key


# Starting routes
get '/' do
  @venues = Venue.order("created_at DESC").limit(20)
  erb :"index"
end

def index
  @line_items = LineItem.all
end

#get '/destroy' do
#  Order.where(id: 1..500).destroy_all
#  Customer.where(id: 1..500).destroy_all
#   OperatingTime.where(id: 8..14).destroy_all
#  LineItem.where(id: 1..500).destroy_all
#end


# Support for OAuth failure
get '/auth/failure' do
  flash[:notice] = params[:message] # if using sinatra-flash or rack-flash
  redirect '/'
end

