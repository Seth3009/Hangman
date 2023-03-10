require_relative 'words'
require_relative 'hangman'

def load_game
  if File.exists?('hangman_save.yml')
    game_data = YAML.load(File.read('hangman_save.yml'))
    Hangman.new(game_data[:word], game_data[:guessed_letters], game_data[:guesses_left])
  else
    Hangman.new(select_word(load_words))
  end
end

def start_game
  puts 'Welcome to Hangman! You have 6 incorrect guesses before you lose.'
  puts "Enter 'new' to start a new game, 'load' to load a saved game, or 'exit' to quit."
  puts '-'*80
    
  game = nil
  words = Words.new
  loop do
    response = gets.chomp.downcase
    
    case response
    when 'new'
      game = Hangman.new(words.instance_variable_get(:@words))
      break
    when 'load'
      if File.exists?('hangman_save.yml')
        game = load_game
        break
      else
        puts "No saved game found. Please start a new game or enter 'exit' to quit."
      end
    when 'exit'
      puts 'Goodbye!'
      exit
    else
      puts "Invalid response. Please enter 'new', 'load', or 'exit'."
    end
  end

  while !game.game_over?
    game.play_turn
  end

  if game.instance_variable_get(:@guesses_left) == 0
    puts "\nSorry, you ran out of guesses. The word was #{game.instance_variable_get(:@word)}."
  else
    puts "\nCongratulations, you guessed the word #{game.instance_variable_get(:@word)}!"
  end
  
  puts "\nEnter 'save' to save the game, 'play' to start a new game, or 'exit' to quit."
  loop do
    response = gets.chomp.downcase
    
    case response
    when 'save'
      game.save_game
      puts '\nGame saved. See you soon!'
      exit
    when 'play'
      start_game
    when 'exit'
      puts 'Goodbye!'
      exit
    else
      puts "Invalid response. Please enter 'save', 'play', or 'exit'."
    end
  end
end

start_game