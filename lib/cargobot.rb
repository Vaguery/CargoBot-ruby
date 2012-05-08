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
      @program[subroutine] << token.intern
    end
  end
  
  def activate
    
  end
end