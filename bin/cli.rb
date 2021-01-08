#!/usr/bin/env ruby

class CLI
    puts 'Enter your email:'
    email = gets.chomp
    current_user = User.find_by(email: email)

    puts 'What do you want to do?'
    puts '0. Create shortened URL'
    puts '1. Visit shortened URL'
    action = gets.chomp.to_i

    if action == 0
        puts 'Type in your long url'
        long_url = gets.chomp
        
        shortened_url = ShortenedUrl.create_for_user_and_long_url(current_user,long_url)

        puts "Short url is: #{shortened_url.short_url}"
        puts 'Goodbye!'
    end

    if action == 1
        puts 'Type in the shortened URL'
        short_url = gets.chomp

        shortened_url = ShortenedUrl.find_by(short_url: short_url)

        puts "Launching #{shortened_url.long_url} ..."
        puts 'Goodbye!'

        Visit.record_visit!(current_user,shortened_url)
        Launchy.open(shortened_url.long_url)    
    end
end

CLI.new
