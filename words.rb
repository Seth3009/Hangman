#  Dictionary
class Words
  def initialize
    @words = select_word(load_words)
  end

  def load_words
    words = []
    File.open('google-10000-english-no-swears.txt', 'r') do |file|
      file.each_line do |line|
        words << line.chomp
      end
    end
    words
  end

  def select_word(words)
    loop do
      word = words.sample
      return word if word.length.between?(5, 12)
    end
  end
end
