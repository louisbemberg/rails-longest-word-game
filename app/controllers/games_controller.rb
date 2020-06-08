# Hello there
class GamesController < ApplicationController
  require 'json'
  require 'open-uri'

  def new
    @alphabet_array = ('A'..'Z').to_a # array of the 26 alphabet letters
    @letters = []
    10.times do
      @letters << @alphabet_array.sample
    end
  end

  def score
    @word = params[:word]
    @letters = params[:letters] # <= This is a string for some ungodly reason
    @result = establish_result(@word, @letters)
  end

  # Checks if the user's word uses the correct letters, and not too many times.
  def first_condition?(word, letters)
    word.split('').all? { |letter| word.count(letter) <= letters.count(letter) }
  end

  # Checks if the user's word is part of the Le Wagon dictionary.
  def second_condition?(word)
    response = open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    json['found']
  end

  def establish_result(word, letters)
    result = ''
    if first_condition?(word.upcase, letters)
      if second_condition?(word)
        result = "Nicely done! #{word} is an english word!"
      else
        result = "#{word} isn't part of the english dictionary mate"
      end
    else
      result = "Nope. #{word} can't be built out of #{letters}"
    end
    result
  end
end
