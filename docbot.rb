require 'discordrb'
require './markovchat'

bot = Discordrb::Bot.new token: "MjAxOTIzMDg0NTc4NTg2NjMz.CmS4vw.fnv8LQOetPNgS684ZzKeSWNzU7U", application_id: 201910521111379968
p bot.profile
m = MarkovChat.new("docChat.db")
m.load
response_chance = 15

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
    m.background_save
    if rand * 100 < response_chance
        event.respond(message)
    else
        nil
    end
end

bot.message(from: ["Naosyth", "apmenard1993"], containing: "Chance") do |event|
    content = event.content
    list = content.split(/[^[[:word:]]]+/)
    if list.size == 2
        response_chance = list[1].to_i
        event.respond("Changing response frequency to #{response_chance} / 100")
    end
end

bot.run

