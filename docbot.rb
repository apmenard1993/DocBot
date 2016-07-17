require 'discordrb'
require './markovchat'

bot = Discordrb::Bot.new token: "MjAxOTIzMDg0NTc4NTg2NjMz.CmS4vw.fnv8LQOetPNgS684ZzKeSWNzU7U", application_id: 201910521111379968
m = MarkovChat.new("docChat.db")
m.load
response_chance = 6
response_threshold = 6

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
    if 1 + rand(response_chance) >= response_threshold
        event.respond(message)
    else
        nil
    end
end

bot.message(from: ["Naosyth", "apmenard1993"], containing: "!Chance") do |event|
    content = event.content
    list = content.split(/[^[[:word:]]]+/)
    if list.size == 3
        response_chance = list[1].to_i
        response_threshold = list[2].to_i
    end
end

bot.run

