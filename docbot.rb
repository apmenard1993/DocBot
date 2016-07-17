require 'discordrb'
require './markovchat'

bot = Discordrb::Bot.new token: "MjAxOTIzMDg0NTc4NTg2NjMz.CmS4vw.fnv8LQOetPNgS684ZzKeSWNzU7U", application_id: 201910521111379968
m = MarkovChat.new("docChat.db")
m.load
last_save = Time.now

puts "This bot's invite URL is #{bot.invite_url}."
puts "Click on it to invite it to your server."

bot.message(with_text: "Ping!") do |event|
    msg = event.respond "Pong!"
    msg.edit "Pong! Time taken: #{Time.now - event.timestamp} seconds."
end

bot.message(in: "#docs", with_text: not!("QuackSave")) do |event|
    content = event.content
    list = content.split(/[^[[:word:]]]+/)
    targetWord = list.sample
    message = m.chat(targetWord)
    m.add_sentence(content)
    1 + rand(6) == 6 ? msg = event.respond(message) : nil
end

bot.message(in: "#docs", with_text: "QuackSave") do |event|
    m.background_save
    event.respond("Saving database with entries from up to #{Time.now - last_save} seconds ago")
    last_save = Time.now
end

bot.run

