class Cargobot
  attr_accessor :claw_position
  attr_accessor :program
  attr_accessor :moves
  attr_accessor :script
  
  def initialize(script="")
    @claw_position = 0
    @moves = 0
    @script = script
    build_program
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
    
  end
end