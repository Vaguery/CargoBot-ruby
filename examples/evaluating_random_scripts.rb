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


def cleanup_distance(config,target)
  error = 0
  target.each_with_index do |stack, stack_idx|
    stack.each_with_index do |box, box_idx|
      # puts "\nbox at #{stack_idx}, #{box_idx}:"
      case config[stack_idx][box_idx]
      when box
        # match!
      when nil
        # config needs more blocks for support
        missing_supports = box_idx
        error += missing_supports
        # puts "missing support(s) #{missing_supports}"
        replacement_cost = min_moves_to_replace(box,config)
        # puts "new box costs #{replacement_cost}"
        error += replacement_cost
      else
        # this block is the wrong color;
        # count moves to remove this box...
        need_to_remove = (config[stack_idx].length - box_idx)
        # puts "wrong color, shifted off #{need_to_remove}"
        # count moves to add correct box
        replacement_cost = min_moves_to_replace(box,config)
        # puts "new box costs #{replacement_cost}"
        error += replacement_cost
      end
    end
    
    if config[stack_idx].length > stack.length
      config[stack_idx].each_with_index do |extra_block,x_idx|
        extras = (config[stack_idx].length - x_idx)
        # puts "Extra box cleanup #{extras}"
        error += extras
      end
    end
    
    if config.flatten.length != target.flatten.length
      error += 100
      # puts "Missing box in claw #{100}"
    end
  end
  return error
end


def min_moves_to_replace(wanted_color,config,missing_penalty=100)
  topmost_replacements = []
  config.each_with_index do |stack,stack_idx|
    top_match = stack.rindex(wanted_color)
    topmost_replacements.push (stack.length-top_match) unless top_match.nil?
  end
  topmost_replacements.empty? ? missing_penalty : topmost_replacements.min
end



# Let's see how this error measure does at finding "close" solutions
setup = [[:b, :r, :b, :b], [], [], [:r, :b, :r, :r]]
target = [[],[:b, :b, :b, :r],[:r, :r, :r, :b],[]]


guesses = 10000.times.collect do
  dude = random_token_array(30).join(" ")
  c = CargoBot.new(dude, stacks:setup.collect {|stack| stack.clone}, goal:target, fragile_claw:true)
  c.activate
  
  puts "#{cleanup_distance(c.stacks, c.goal)},#{c.steps},#{c.moves},#{c.crashes},#{c.stack_trace.length}"
  {error:cleanup_distance(c.stacks, c.goal),moves:c.moves,dude:c}
end

range = guesses.collect {|g| g[:error]}.minmax
puts "min and max errors found: #{range.inspect}\n\nbest:\n"
best =  guesses.find_all {|g| g[:error] == range[0]}

best.each do |good_one|
  good_one[:dude].show_off
  puts "\n"
end