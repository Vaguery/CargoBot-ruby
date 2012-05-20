require_relative '../lib/cargobot'

@program_tokens = %w{ R L claw } * 10 + %w{ call1 call2 call3 call4} 
@meta_tokens = %w{ prog_1 prog_2 prog_3 prog_4}
@modifiers = %w{ r g b y any none}


def random_token_array(length)
  length.times.collect do
    token = (@program_tokens+@meta_tokens).sample
    token = "#{token}_#{@modifiers.sample}" if @program_tokens.include?(token) && rand < 0.2
    token
  end
end



# Let's see how this error measure does at finding "close" solutions
setup = [[:b, :b, :b, :b], [], [], [:r, :r, :r, :r]]
target = [[],[:b, :b, :b, :b],[:r, :r, :r, :r],[]]


guesses = 10000.times.collect do
  dude = random_token_array(30).join(" ")
  c = CargoBot.new(dude, stacks:setup.collect {|stack| stack.clone}, goal:target, fragile_claw:true)
  c.activate
  
  err_1 = CrateStacks.new(c.stacks).cleanup_error(CrateStacks.new c.goal)
  err_2 = CrateStacks.new(c.stacks).teardown_distance(CrateStacks.new c.goal)
  puts "#{err_1},#{err_2},#{c.steps},#{c.moves},#{c.crashes}"
  {error_1:err_1,error_2:err_2,moves:c.moves,dude:c}
end

range_1 = guesses.collect {|g| g[:error_1]}.minmax
range_2 = guesses.collect {|g| g[:error_2]}.minmax

puts "\n\nmin and max cleanup errors found: #{range_1.inspect}"
puts "min and max teardown distances found: #{range_2.inspect}\n\nbest:\n"

best =  guesses.find_all {|g| g[:error_1] == range_1[0] || g[:error_2] == range_2[0]}

best.each do |good_one|
  puts "\ncleanup: #{good_one[:error_1]}, teardown: #{good_one[:error_2]}"
  
  good_one[:dude].show_off
end