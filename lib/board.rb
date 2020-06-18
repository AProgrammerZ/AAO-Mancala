require "byebug"

class Board
  attr_accessor :cups

  def initialize(name1, name2)
    @name1 = name1
    @name2 = name2

    @cups = Array.new(14) {Array.new(4)}
    @cups[6], @cups[13] = [], []    
    self.place_stones
  end

  def place_stones
    # helper method to #initialize every non-store cup with four stones each
    @cups.map! do |cup| 
      cup.map! { |stone| :stone }
    end
  end

  def valid_move?(start_pos)
    raise "Invalid starting cup" if @cups[start_pos].nil?
    raise "Starting cup is empty" if @cups[start_pos].empty?
  end

  def make_move(start_pos, current_player_name)        
    stones = @cups[start_pos]
    @cups[start_pos] = []    
    ending_cup_idx = 0    

    i = start_pos+1
    until stones.empty?
      unless self.opponent_points_store?(@cups[i], current_player_name)        
        @cups[i] << stones.pop
      end
      
      if stones.empty?
        ending_cup_idx = i 
        break
      end

      i == 13 ? i = 0 : i += 1      
    end    
    
    self.render
    
    self.next_turn(ending_cup_idx)
  end

  def opponent_points_store?(cup, current_player_name)
    # my helper method to determine if this cup is the opponent's points store
    if current_player_name == @name1
      return cup.object_id == @cups[13].object_id
    elsif current_player_name == @name2
      return cup.object_id == @cups[6].object_id
    end
  end

  def next_turn(ending_cup_idx)
    # helper method to determine whether #make_move returns :switch, :prompt, or ending_cup_idx
    if ending_cup_idx == 6 || ending_cup_idx == 13  
      return :prompt    
    elsif @cups[ending_cup_idx].length == 1
      return :switch
    elsif !@cups[ending_cup_idx].empty?
      return ending_cup_idx      
    end
  end

  def render
    print "      #{@cups[7..12].reverse.map { |cup| cup.count }}      \n"
    puts "#{@cups[13].count} -------------------------- #{@cups[6].count}"
    print "      #{@cups.take(6).map { |cup| cup.count }}      \n"
    puts ""
    puts ""
  end

  def one_side_empty?
    @cups[0..5].all?(&:empty?) || @cups[7..12].all?(&:empty?)
  end

  def winner
  end
end
