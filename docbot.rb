require 'discordrb'
require './markovchat'

bot = Discordrb::Bot.new token: 'MjAxOTIzMDg0NTc4NTg2NjMz.CmS4vw.fnv8LQOetPNgS684ZzKeSWNzU7U', application_id: 201910521111379968
m = MarkovChat.new("docChat.db")
m.load

puts "This bot's invite URL is #{bot.invite_url}."
puts 'Click on it to invite it to your server.'

bot.message(with_text: 'Ping!') do |event|
    msg = event.respond 'Pong!'
    msg.edit "Pong! Time taken: #{Time.now - event.timestamp} seconds."
end

counter = 0

bot.message(in: "#docs") do |event|
    if counter > 6
        counter = 0
    if (counter + rand(6)) > 8
        content = event.content
        list = content.split(/[^[[:word:]]]+/)
        targetWord = list.sample
        message = m.chat(targetWord)
        m.add_sentence(content)
        msg = event.respond(message)
        counter = counter + 1
end

bot.run

