class Cargobot
  attr_accessor :claw_position
  attr_accessor :claw_holding
  attr_accessor :program
  attr_accessor :stack_trace
  attr_accessor :moves
  attr_accessor :steps
  attr_accessor :script
  attr_accessor :crashes
  attr_accessor :stacks
  attr_accessor :step_limit
  
  Pointer = Struct.new(:subroutine,:step)
  
  
  def initialize(script="", args = {})
    @script = script
    reset_state(args)
  end
  
  
  def reset_state(args)
    @pointer = args[:pointer] || Pointer.new(0,0)
    @stacks = args[:stacks] || [[]]
    @claw_position = args[:claw_position] || 0
    @claw_holding = args[:claw_holding] || nil
    @moves = args[:moves] || 0
    @steps = args[:steps] || 0
    @crashes = args[:crashes] || 0
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
  
  
  def activate
    until @done
      next_token = @program[@pointer.subroutine][@pointer.step]
      case next_token
      when nil
        if @stack_trace.empty?
          @done = true
        else
          @pointer = @stack_trace.pop
        end
      when :R
        unless @claw_position < @stacks.length-1
          @claw_position = @stacks.length-1
          @crashes += 1
        else
          @claw_position += 1
        end
        @moves += 1
      when :L
        if @claw_position <= 0
          @claw_position = 0
          @crashes += 1
        else
          @claw_position -= 1
        end
        @moves += 1
      when :claw
        if @claw_holding.nil?
          @claw_holding = @stacks[@claw_position].pop
        else
          @stacks[@claw_position].push @claw_holding
          @claw_holding = nil
        end
        @moves += 1
      when /call(\d)/
        @stack_trace.push @pointer.clone
        @pointer.subroutine = $1.to_i-1
        @pointer.step = -1
      else
      end
      
      @pointer.step += 1
      @steps += 1
      @done = true if @steps >= @step_limit
    end
  end
end