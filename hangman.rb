require 'yaml'


class Hangman
  FIGURES = [
    " _____\n |   |\n |\n |\n |\n_|_\n",
    " _____\n |   |\n |   o\n |\n |\n_|_\n",
    " _____\n |   |\n |   o\n |   |\n |\n_|_\n",
    " _____\n |   |\n |   o\n |  /|\n |\n_|_\n",
    " _____\n |   |\n |   o\n |  /|\\\n |\n_|_\n",
    " _____\n |   |\n |   o\n |  /|\\\n |  /\n_|_\n",
    " _____\n |   |\n |   o\n |  /|\\\n |  / \\\n_|_\n",
    "",
  ].freeze

  def initialize(word, guessed_letters = [], guesses_left = 6)
    @word = word
    @guessed_letters = guessed_letters
    @guesses_left = guesses_left
    @guessed_word = mask_word(word, guessed_letters)
  end

  

  def mask_word(word, guessed_letters)
    word.chars.map { |letter| guessed_letters.include?(letter) ? letter : "_" }.join(" ")
  end

  def game_over?
    @guesses_left == 0 || !@guessed_word.include?("_")
  end

  def play_turn
    puts "\n#{@guessed_word}"
    puts "Guesses left: #{@guesses_left}"
    puts "Incorrect letters: #{incorrect_letters}" unless @guessed_letters.empty?
    print "Guess a letter, or enter 'save' to save the game: "
    guess = gets.chomp

    if guess.downcase == "save"
      save_game
      puts "\nGame saved. See you soon!"
      exit
    elsif @guessed_letters.include?(guess)
      puts "You already guessed that letter. Try again."
    elsif @word.include?(guess)
      puts "Good guess!"
      @guessed_letters << guess
      @guessed_word = mask_word(@word, @guessed_letters)
    else
      puts "Sorry, that letter is not in the word."
      @guessed_letters << guess
      @guesses_left -= 1
      puts "#{FIGURES[6 - @guesses_left]}\n"
    end
  end

  def save_game
    game_data = YAML.dump({
      word: @word,
      guessed_letters: @guessed_letters,
      guesses_left: @guesses_left
    })

    File.open("hangman_save.yml", "w") do |file|
      file.write(game_data)
    end
  end

  def incorrect_letters
    @guessed_letters.select { |letter| !@word.include?(letter) }.join(", ")
  end
end