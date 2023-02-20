require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = []
    10.times do
      @letters.push(('A'..'Z').to_a.sample)
    end
    @start = Time.now
  end

  def score
    @end = Time.now
    @word = params[:word]
    @letters = params[:letters].split
    @score_text = score_response(@word, @letters)
    @score_attributes = score_attributes(params[:start].to_datetime, @word, Time.now) if valid_word?(@word) && word_include_letters?(@word, @letters)
  end

  private

  def word_include_letters?(word, letters)
    include = true
    word.chars.each { |letter| include = false unless letters.include?(letter.upcase) }
    include
  end

  def score_attributes(start_time, word, end_time)
    score = {}
    score[:time] = end_time - start_time
    score[:points] = (1 / score[:time]) * word.length * 10
    session[:score].nil? ? session[:score] = score[:points] : session[:score] += score[:points]
    score
  end

  def score_response(word, letters)
    if !word_include_letters?(word, letters)
      "Sorry, but #{word} can't be built out of #{letters.join(', ')}"
    elsif valid_word?(word)
      "Congratulation, #{word} is a valid English Word "
    else
      "Sorry but #{word} is not a valid English Word"
    end
  end

  def valid_word?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    JSON.parse(URI.open(url).read)['found']
  end

  # def current_session
  #   session[:session_id]
  # end
end
