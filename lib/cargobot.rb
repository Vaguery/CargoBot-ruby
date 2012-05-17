class CargoBot
  attr_accessor :script,:program,:stacks
  attr_accessor :goal
  attr_accessor :stack_trace
  attr_accessor :moves,:steps,:crashes,:topples
  attr_accessor :old_stacks
  attr_accessor :height_limit,:step_limit
  attr_accessor :fragile_crashes,:fragile_stacks
  attr_accessor :claw_position, :claw_holding
  
  
  Pointer = Struct.new(:subroutine,:step)
  
  
  def initialize(script="", args = {})
    @script = script
    reset_state(args)
  end
  
  
  def reset_state(args)
    @pointer = args[:pointer] || Pointer.new(0,0)
    @stacks = args[:stacks] || [[]]
    @old_stacks = [[]] 
    @old_stacks = args[:stacks].collect {|stack| stack.clone} if args[:stacks]
    @goal = args[:goal] || [[:no, :goal, :was, :set]]
    @claw_position = args[:claw_position] || 0
    @claw_holding = args[:claw_holding] || nil
    @moves = args[:moves] || 0
    @steps = args[:steps] || 0
    @crashes = args[:crashes] || 0
    @topples = args[:topples] || 0
    @fragile_crashes = args[:fragile_crashes] || false
    @fragile_stacks = args[:fragile_stacks] || false
    @height_limit = args[:height_limit] || 6
    @stack_trace = []
    @step_limit = args[:step_limit] || 200
    @done = false
    self.build_program
  end
  
  
  def build_program
    @program = [[]]
    subroutine = 0
    @script.split.each do |token|
      if token =~ /prog_(\d)/
        subroutine = $1.to_i-1
        add_subroutines_as_needed(subroutine)
      else
        @program[subroutine] << token.intern
      end
    end
  end
  
  
  def add_subroutines_as_needed(needed_subroutine)
    (0..needed_subroutine).each do |s|
      @program[s] = [] if @program[s].nil?
    end
  end
  
  
  def handle_nil
    if @stack_trace.empty?
      @done = true
    else
      @pointer = @stack_trace.pop
    end
    @steps -= 1
  end
  
  
  def handle_R
    unless @claw_position < @stacks.length-1
      @claw_position = @stacks.length-1
      handle_crash
    else
      handle_topple if @stacks[@claw_position+1].length >= @height_limit
      @claw_position += 1
      @moves += 1
    end
  end
  
  
  def handle_L
    if @claw_position <= 0
      @claw_position = 0
      handle_crash
    else
      @claw_position -= 1
      handle_topple if @stacks[@claw_position-1].length >= @height_limit
      @moves += 1
    end
  end
  
  
  def handle_crash
    @crashes += 1
    @done = true if @fragile_crashes
  end
  
  
  def handle_topple
    @topples += 1
    @done = true if @fragile_stacks
  end
  
  
  def handle_claw
    if @claw_holding.nil?
      @claw_holding = @stacks[@claw_position].pop
    else
      @stacks[@claw_position].push @claw_holding
      @claw_holding = nil
    end
    @moves += 1
  end
  
  
  def handle_call(which)
    return if which >= @program.length
    @stack_trace.push @pointer.clone
    @pointer.subroutine = which
    @pointer.step = -1
  end
  
  
  def willing?(filter)
    return true if filter.empty?
    return true if filter == @claw_holding.to_s
    return true if (filter == "any" && !@claw_holding.nil?)
    return true if (filter == "none" && @claw_holding.nil?)
    false
  end
  
  
  def activate
    until @done
      @steps += 1
      raw_token = @program[@pointer.subroutine][@pointer.step]
      if raw_token.nil?
        handle_nil
      else
        token,underscore,filter = raw_token.to_s.partition("_")
        if willing?(filter)
          case token.intern
          when :R
            handle_R
          when :L
            handle_L
          when :claw
            handle_claw
          when /call(\d)/
            handle_call($1.to_i - 1)
          else
            # ignore unknown tokens
          end
        end
      end
      @pointer.step += 1
      @done = true if @steps >= @step_limit
      @done = true if @stacks == @goal
    end
  end
  
  
  # convenience function for fancy display
  def show_off
    puts "           script: #{@script}"
    puts "   starting state: #{@old_stacks}"
    puts "        end state: #{@stacks}"
    puts "             goal: #{@goal}"
    puts "            steps: #{@steps}"
    puts "            moves: #{@moves}"
    puts "          crashes: #{@crashes}"
    puts "          topples: #{@topples}"
    puts "stack_trace_depth: #{@stack_trace.length}"
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
      if this_stack_replacement == grabbing_a_replacement
        if this_stack_replacement < shifting_extra_boxes
          return shifting_extra_boxes + 1
        else
          return 2*this_stack_replacement - (@stacks[stack].length-box) + 1
        end
      else
        return shifting_extra_boxes + adding_missing_boxes + grabbing_a_replacement
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