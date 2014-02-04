require 'sinatra'
require 'active_record'
require 'pry'
require 'json'

###########################################################
# Configuration
###########################################################

set :public_folder, File.dirname(__FILE__) + '/public'

configure :development, :production do
  ActiveRecord::Base.establish_connection(
    :adapter => 'sqlite3',
    :database =>  'db/dev.sqlite3.db'
  )
end

# Handle potential connection pool timeout issues
after do
  ActiveRecord::Base.connection.close
end



###########################################################
# Models
###########################################################
# Models to Access the database through ActiveRecord.
# Define associations here if need be
# http://guides.rubyonrails.org/association_basics.html

class Link < ActiveRecord::Base
  has_many :clicks, dependent: :destroy
end

class Click < ActiveRecord::Base
  belongs_to :link
end


###########################################################
# Routes
###########################################################

get '/' do
  # @links = Link.all
  # @clicks = Click.all
  # # erb :index
  # content_type :json
  # @clicks.to_json

  @links = Link.all
  @clicks = @links.map do |link| link.clicks.last end
  erb :index
  
end

get '/new' do
  erb :form
end

get '/:id' do
  link = Link.find params[:id]
  link.visits += 1
  link.save

  #Add Click
  puts request.referer
  click = link.clicks.create source: request.referer
  puts click.to_json
  redirect link.url
end

post '/new' do
  if Link.exists? params
    link = Link.find_by params
  else
    link = Link.create url: params[:url], visits: 0
  end
  content_type :json
  link.to_json
end