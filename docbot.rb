require 'discordrb'
require './markovchat'

bot = Discordrb::Bot.new token: 'MjAxOTIzMDg0NTc4NTg2NjMz.CmS4vw.fnv8LQOetPNgS684ZzKeSWNzU7U', application_id: 201910521111379968
m = MarkovChat.new

puts "This bot's invite URL is #{bot.invite_url}."
puts 'Click on it to invite it to your server.'

bot.message(in: "docs", with_text: 'Ping!') do |event|
    event.respond 'Pong!'
end

bot.run

