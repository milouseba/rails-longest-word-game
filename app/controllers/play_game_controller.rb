# require 'open-uri'
# require 'json'

class PlayGameController < ApplicationController

  def ask
    @grid = generate_grid(9)
    @letters = make_grid_string(@grid)
  end

  def result
    @grid = params[:grid]
    @start_time = DateTime.parse(params[:start_time])
    @end_time = Time.now
    @word = params[:word]
    @time = calc_time(@start_time, @end_time)
    @score = calc_score(@word, @grid, @start_time, @end_time)
    @message = le_message(@word.upcase, @grid)
  end

  def generate_grid(grid_size)
    # TODO: generate random grid of letters
    array_letter = []
    i = 1
    while i <= grid_size
      array_letter << ("A".."Z").to_a.sample
      i += 1
    end
    return array_letter
  end

  def make_grid_string(word)
    # TODO: generate random grid of letters
    result = ""
    word.each { |letter| result += " #{letter}" }
    return result
  end

  def test_lettres_mot?(attempt, grid)
    # p attempt
    # p grid
    attempt.upcase.split('').all? { |letter| attempt.count(letter) <= grid.count(letter) }
  end

  def test_mot_dico?(attempt)
    url = 'https://wagon-dictionary.herokuapp.com/' + attempt.downcase
    user_serialized = open(url).read
    user = JSON.parse(user_serialized)

    user["found"]
  end

  def calc_time(start_time, end_time)
    return end_time - start_time
  end

  def le_message(attempt, grid)
    if test_lettres_mot?(attempt, grid) && test_mot_dico?(attempt)
      return "well done"
    elsif test_mot_dico?(attempt)
      return "not in the grid"
    else
      return "not an english word"
    end
  end

  def calc_score(attempt, grid, start_time, end_time)
    if test_lettres_mot?(attempt.upcase, grid) == false
      return 0
    elsif test_mot_dico?(attempt.upcase) == false
      return 0
    else
      return attempt.length * (1 - calc_time(start_time, end_time) / 60)
    end
  end

  def run_game(attempt, grid, start_time, end_time)
    # TODO: runs the game and return detailed hash of result
    return {
      time: calc_time(start_time, end_time),
      translation: "plus tard",
      score: calc_score(attempt, grid, start_time, end_time),
      message: le_message(attempt.upcase, grid)
    }
  end

end


