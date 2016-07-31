require 'sinatra'
require 'sinatra/json'
require 'json'
require 'csv'

class Chat < Sinatra::Base
  before do
    response['Access-Control-Allow-Origin'] = '*'
  end

  get '/messages' do
    json = []
    CSV.foreach('messages.csv') do |row|
      json << {
        name: row[0],
        message: row[1],
        created_on: row[2]
      }
    end
    json json.reverse
  end

  post '/messages' do
    name = params[:name] || 'unknown'
    message = params[:message]
    created_on = Time.now
    CSV.open('messages.csv', 'a') do |csv|
      csv << [name, message, created_on]
    end
    json status: 'success'
  end

end
