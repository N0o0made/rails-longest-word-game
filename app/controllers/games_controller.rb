require 'net/http'
require 'json'
class GamesController < ApplicationController

  def new
    @letters = ('A'..'Z').to_a.sample(10)
  end

  def score
  @word = params[:word]
  @letters = params[:letters].split(' ')
  
      if word_in_grid?(@word, @letters.dup)
        if valid_english_word?(@word)
          @result = "Congratulations! #{@word} is a valid English word!"
        else
          @result = "Sorry, #{@word} is not a valid English word"
        end
      else
        @result = "Sorry, #{@word} cannot be formed with those letters"
      end
  end

  private

  def word_in_grid?(word, letters)
    word.upcase.chars.each do |letter|
      if letters.include?(letter)
        letters.delete_at(letters.index(letter))
      else
        return false
      end
    end
    true
  end

  def valid_english_word?(word)
    url = "https://dictionary.lewagon.com/#{word}"
    uri = URI(url)
    response = Net::HTTP.get_response(uri)
    
    if response.code == "200"
      data = JSON.parse(response.body)
      return data["found"]
    else
      return false
    end
  end
end
