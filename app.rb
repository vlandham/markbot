require 'sinatra'
require 'json'
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'lib/bot'

get '/' do
  bot = Bot.new
  output = bot.tweet
  output
  'you tweeted!'
end

