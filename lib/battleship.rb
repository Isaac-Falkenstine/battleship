require 'pry'

class Battleship
  def initialize
    @playing_grid = [["A1","A2","A3","A4"],["B1","B2","B3","B4"],["C1","C2","C3","C4"],["D1","D2","D3","D4"]]
  end

  def starting_game
    puts "\nWelcome to BATTLESHIP\n"
    puts "\nWould you like to (p)lay, read the (i)nstructions, or (q)uit?"
    @starting_input = gets.chomp
    works_with_input
  end

  def works_with_input
    if @starting_input == "i"
      puts "instructions"
    elsif @starting_input == "q"
      exit
    elsif @starting_input == "p"
      puts "YRN"
    else
      puts "\nI don't understand that input.\n"
      self.starting_game
    end
  end


  def generate_comp_ships
    comp_playing_grid = [["A1","A2","A3","A4"],["B1","B2","B3","B4"],["C1","C2","C3","C4"],["D1","D2","D3","D4"]]

    generate_random_point_1 = ["A1","B1","C1","D1","A2","B2","C2","D2","A3","B3","C3","D3","A4","B4","C4","D4",].to_a.sample
    generate_random_point_2 = ["A1","B1","C1","D1","A2","B2","C2","D2","A3","B3","C3","D3","A4","B4","C4","D4",].to_a.sample

    # generate_random_point_1 
  end
end


battleship = Battleship.new
battleship.starting_game
battleship.generate_comp_ships
