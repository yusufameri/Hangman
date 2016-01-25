require 'yaml'
class Hangman

  def initialize
    @word = get_word(words)
    unless good_size?(5,12)
       @word = get_word(words)
    end
    @word_split = @word.split"" # example = ["F", "a", "n","t","a","s","t","i","c"]
    @dashes = Array.new(@word.length, "_") # ["_", "_", "_", "_", "_", "_", "_", "_", "_"]
    # loop while they still have not guessed or have guesses remainging
    @guesses_remaining = 10
  end

  def words
    dict = File.open("5desk.txt","r+")
    words = dict.read.split
    dict.close
    words
  end

  def get_word words
    words[rand * words.length]
  end

  def display_word
    @dashes.each {|letter| print "#{letter} "}
    puts
  end

  def replace_letter(letter)
    @word_split.each_with_index do |let,index|
      @dashes[index] = letter if let == letter
    end
  end

  def good_size?(min, max)
    @word.length >= min && @word.length <= max
  end

  def save_game
    yaml = YAML::dump(self)
    File.open("save.txt", 'w') {|f| f.write(yaml) }
  end

  def self.load_game(file)
    saved_game = File.open(file, 'r')
    yaml = saved_game.read
    YAML::load(yaml)
  end

  def play
    puts "Welcome!\n"
    while @dashes.include?("_") && @guesses_remaining > 0
        puts "Guesses remaining: #{@guesses_remaining}\n"
        puts "Guess a letter: "
        display_word
        guess = gets.chomp
        if guess == "save"
          save_game
          puts "\nGame successfully saved!\n\n"
        elsif guess == "load"
          puts "What is the file name? "
          file = gets.chomp
          load_game(file)
        end
        if @word_split.include?(guess)
          replace_letter(guess)
        else
          @guesses_remaining -=1
        end
    end
    puts result
  end

  def result
    if @dashes.include?("_")
      "You lost! The words was #{@word}"
    else
      "Congradulations! You guessed the word, #{@word}"
    end
  end

end

puts "Welcome to Hangman! Would you like to load a game? y/n"
if gets.chomp.downcase == "y"
  puts "What is the name of the file?"
  file_name = gets.chomp
  game = Hangman.load_game(file_name)
else
  game = Hangman.new
end

game.play