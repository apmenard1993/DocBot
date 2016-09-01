require 'discordrb'
require './markovchat'

bot = Discordrb::Bot.new token: "asdf", application_id: 0

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
    if targetWord.include?("-")
        targetWord = "nope"
    end
    message = m.chat(targetWord)
    m.add_sentence(content)
    m.background_save
    if rand * 100 < response_chance || content.include?("docbot") || content.include?("DB")
        event.respond(message)
    else
        nil
    end
end

bot.message(from: ["Naosyth", "apmenard1993", "Decosun"], containing: "Chance") do |event|
    content = event.content
    list = content.split(/[^[[:word:]]]+/)
    if list.size == 2
        response_chance = list[1].to_i
        event.respond("Changing response frequency to #{response_chance} / 100")
    elsif list.size == 1
        event.respond("Response chance is #{response_chance} / 100")
    end
end

bot.run

