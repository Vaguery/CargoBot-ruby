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
  
  err = CrateStacks.new(c.stacks).cleanup_error(CrateStacks.new c.goal)
  # puts "#{err},#{c.steps},#{c.moves},#{c.crashes},#{c.stack_trace.length}"
  {error:err,moves:c.moves,dude:c}
end

range = guesses.collect {|g| g[:error]}.minmax
puts "min and max errors found: #{range.inspect}\n\nbest:\n"
best =  guesses.find_all {|g| g[:error] == range[0]}

best.each do |good_one|
  good_one[:dude].show_off
  puts "\n"
end