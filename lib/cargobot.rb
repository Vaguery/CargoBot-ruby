class CargoBot
  attr_accessor :script, :program
  attr_accessor :stacks, :starting_stacks, :execution_stack
  attr_accessor :claw_position, :claw_holding
  attr_accessor :moves, :crashes, :steps, :topples, :broken
  attr_accessor :step_limit, :height_limit, :goal, :unstable, :fragile
  
  
  def initialize(script="", args={})
    @script = script
    load_program(script)
    load_args(args)
    setup_stacks(args[:stacks])
    @execution_stack = []
  end
  
  
  def load_args(args)
    @claw_position = args[:claw_position] || 1
    @step_limit = args[:step_limit] || 200
    @goal = args[:goal] || [[:no, :goal, :was, :set]]
    @height_limit = args[:height_limit] || 6
    @unstable = args[:unstable] || false
    @fragile = args[:fragile] || false
  end
  
  
  def setup_stacks(arg_stacks)
    @stacks = arg_stacks.nil? ? [[]] : arg_stacks
    @starting_stacks = @stacks.collect {|stack| stack.clone}
  end
  
  
  def load_program(script)
    @program = [[]]
    tokens = script.scan(/\w+/)
    subroutine = 0
    until tokens.empty?
      next_token = tokens.shift
      if next_token =~ /prog_(\d)/
        subroutine = $1.to_i-1
        while @program.length <= subroutine
          @program.push []
        end
      else
        @program[subroutine].push next_token.intern
      end
    end
  end
  
  
  def activate
    @claw_holding = nil
    @moves = 0
    @crashes = 0
    @topples = 0
    @steps = 0
    @broken = false
    @execution_stack = @program[0] + @execution_stack
    
    until finished?
      @steps += 1
      interpret_token(@execution_stack.shift)
    end
  end
  
  
  def finished?
    @steps >= @step_limit ||
    @broken ||
    @stacks.inspect == @goal.inspect ||
    @execution_stack.empty?
  end
  
  
  def handle_L
    @claw_position -= 1
    @claw_position < 1 ? record_crash(1) : @moves += 1
    check_for_topple if @stacks[@claw_position-1].length > @height_limit
  end
  
  
  def handle_R
    @claw_position += 1
    right_edge = @stacks.length
    @claw_position > right_edge ? record_crash(right_edge) : @moves += 1
    check_for_topple 
  end
  
  
  def check_for_topple
    return unless @stacks[@claw_position-1].length > @height_limit
    @topples += 1
    @broken = true if @unstable
  end
  
  
  def record_crash(where)
    @claw_position = where
    @crashes += 1
    @broken = true if @fragile
  end
  
  
  def handle_claw
    @claw_holding.nil? ? pick_up_crate : put_down_crate
    @moves += 1
  end
  
  
  def pick_up_crate
    @claw_holding = @stacks[@claw_position-1].pop
  end
  
  
  def put_down_crate
    @stacks[@claw_position-1].push @claw_holding
    @claw_holding = nil
  end
  
  
  def handle_call(subroutine)
    return if subroutine > @program.length
    @execution_stack = @program[subroutine-1] + @execution_stack
  end
  
  
  def constraint_satisfied?(condition)
    return case 
    when condition.nil?
      true
    when condition == "any"
      @claw_holding.nil? ? false : true
    when condition == "none"
      @claw_holding.nil? ? true : false
    else
      @claw_holding == condition.intern ? true : false
    end
  end
  
  
  def interpret_token(token)
    case token
    when /L(_)?(.+)?/
      handle_L if constraint_satisfied?($2)
    when /R(_)?(.+)?/      
      handle_R if constraint_satisfied?($2)
    when /claw(_)?(.+)?/
      handle_claw if constraint_satisfied?($2)
    when /call(\d)(_)?(.+)?/
      handle_call($1.to_i) if constraint_satisfied?($3)
    else
      # ignore tokens I don't recognize
    end
  end
  
  def show_off
    puts "           script: #{@script}"
    puts "   starting state: #{@starting_stacks}"
    puts "        end state: #{@stacks}"
    puts "             goal: #{@goal}"
    puts "            steps: #{@steps}"
    puts "            moves: #{@moves}"
    puts "          crashes: #{@crashes}"
    puts "          topples: #{@topples}"
  end
end



class CrateStacks
  attr_accessor :stacks
  
  def initialize(arrangement = [[]])
    @stacks = arrangement
  end
  
  def crate_cleanup_error(target, stack_number, box_number)
    stack = stack_number - 1
    box = box_number - 1
    
    expected_box = target.stacks[stack][box]
    observed_box = @stacks[stack][box]
    
    
    if expected_box == observed_box
      return 0 
    else
      possible_replacements = topmost_matches(expected_box)
      return 100 if possible_replacements.empty?
      
      this_stack_replacement = @stacks[stack].rindex(expected_box).nil? ?
        nil :
        @stacks[stack].length - @stacks[stack].rindex(expected_box)
      adding_missing_boxes = @stacks[stack].length-1 < box ? (box + 1 - @stacks[stack].length) : 0
      shifting_extra_boxes = @stacks[stack].length-1 > box ? (@stacks[stack].length - box) : 0
      grabbing_a_replacement = possible_replacements.min
      
      grabbing_a_replacement = adding_missing_boxes if grabbing_a_replacement < adding_missing_boxes
      if this_stack_replacement == grabbing_a_replacement
        if this_stack_replacement < shifting_extra_boxes
          return shifting_extra_boxes + 1
        else
          return 2*this_stack_replacement - (@stacks[stack].length-box) + 1
        end
      else
        return shifting_extra_boxes + grabbing_a_replacement + adding_missing_boxes 
      end
    end
  end
  
  
  def stack_cleanup_error(target, stack_number)
    stack = stack_number-1
    
    extra_boxes = [0,@stacks[stack].length - target.stacks[stack].length].max
    extras_error = extra_boxes*(extra_boxes+1)/2
    
    matches_errors = target.stacks[stack].each_with_index.inject(0) do |sum,(crate,idx)|
      crate = crate_cleanup_error(target,stack_number,idx+1)
      sum + crate
    end
    
    extras_error + matches_errors
  end
  
  
  def cleanup_error(target)
    target.stacks.each_with_index.inject(0) do |sum,(stack,idx)|
      sum + stack_cleanup_error(target,idx+1)
    end
  end
  
  def topmost_matches(crate)
    @stacks.collect {|s| (s.length - s.rindex(crate)) unless s.rindex(crate).nil?}.compact
  end
  
end