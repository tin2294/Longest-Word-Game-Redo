require 'open-uri'

class GamesController < ApplicationController
  def eng_word(att_arr, grid)
    if att_arr.all? { |i| grid.include?(i) && (grid.count(i) >= att_arr.count(i)) }
      @message = "Congratulations! #{params[:word]} is a valid English word!"
    else
      clean_grid = params[:grid][1..-2]
      @message = "Sorry but #{att_arr.join} can't be built out of #{clean_grid}."
    end
  end

  def new
    @letters = 10.times.map { ('A'..'Z').to_a.sample }
  end

  def score
    url = "https://wagon-dictionary.herokuapp.com/#{params[:word]}"
    @attempt_arr = params[:word].upcase.chars
    wagon_api = URI.open(url).read
    @search_hash = JSON.parse(wagon_api)
    @letters = JSON.parse(params[:grid])
    if @search_hash['found'] == true
      eng_word(@attempt_arr, @letters)
    else
      @message = "Sorry but #{params[:word]} doesn't seem to be an English word..."
    end
  end
end
