require_relative '../lib/cargobot'

# convenience function for fancy display
class CargoBot
  def show_off
    puts "           script: #{@script}"
    puts "   starting state: #{@old_stacks}"
    puts "        end state: #{@stacks}"
    puts "            steps: #{@steps}"
    puts "            moves: #{@moves}"
    puts "          crashes: #{@crashes}"
    puts "          topples: #{@topples}"
    puts "stack_trace_depth: #{@stack_trace.length}"
  end
end


# Cargo-Bot Tutorial 4

c = CargoBot.new "call2 call2 call2 call2 R call1 prog_2 claw R claw L",
  :stacks => [[:b, :r, :g, :y],[],[],[],[],[]],
  :goal => [[], [], [], [], [], [:y, :g, :r, :b]]

c.activate
c.show_off