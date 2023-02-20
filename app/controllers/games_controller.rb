require 'json'
require 'open-uri'

class GamesController < ApplicationController

  def new
    @letters = []
    10.times do
      @letters.push(('A'..'Z').to_a.sample)
    end
  end

  def score
    @word = params[:word]
    @letters = params[:letters].split
    include = true
    @word.chars.each { |letter| include = false unless @letters.include?(letter.upcase) }
    if !include
      @score_text = "Sorry, but #{@word} can't be built out of #{@letters.join(', ')}"
    elsif valid_word?(@word)
      @score_text = "Congratulation, #{@word} is a valid English Word "
    else
      @score_text = "Sorry but #{@word} is not a valid English Word"
    end
  end

  private

  def valid_word?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    JSON.parse(URI.open(url).read)['found']
  end
end
