require_relative '../lib/cargobot'

@program_tokens = %w{ R L claw } * 10 + %w{ call1 call2 call3 call4} 
@meta_tokens = %w{ prog_1 prog_2 prog_3 prog_4}
@modifiers = %w{ r g b y any none}

# Lay It Out (medium)
# setup = [[:g,:g,:g,:g,:g,:g],[],[],[],[],[]]
# target = [[:g],[:g],[:g],[:g],[:g],[:g]]
# claw_position = 1
# Successful programs:
# claw call2 R claw L claw R R R claw L R_any L L call1 R L
# claw call2 R claw L claw R R call2 R claw L R_any L L call1 L_r R call4
# claw L_r R claw L claw R R call2 R claw L R_any L L call1 L_r R call4
# claw L_r R claw L claw R call2 R claw L R_any L call1 L_r R call4
# claw L_r R claw L claw R call2 R claw L R_any L call1 L_r L_y call4
# claw L_r R claw L claw R call2 R claw L R_any L call1 R L_y call4
# claw L_r R claw L claw R call2 R claw L R_any L call1 R L call4
# claw L_r R claw L claw R call4_r R claw L R_any L call1 R L call4
# claw L_r R claw L claw R call4_r R claw L R_any L call1 R L call2_none
# claw L_r R claw L claw R call4_r R claw L R_any L call1 R claw call2_none
# claw L_r R claw L claw R call4_r R claw L R_any L call1 L_none claw call2_none
# claw L_r R claw L claw R R claw L R_any L call1 claw call2_none
# claw R claw L claw R_r R R claw L R_any L call1 claw call2_none
# claw R claw L claw R_r R R claw L R_any L call1 claw claw
# claw R claw L claw R_r R R claw L R_any L call1 L
# claw R claw L claw R_r R R claw L R_any L call1 R_b
# claw R claw L claw R_r R R claw L L R_any call1 R_b
# claw R claw L claw R_r R R claw L L R_any call1 call2_none
# claw R claw L claw R R claw L L R_any call1 call2_none
# claw R claw L claw R R claw L L R_any call1 L_b
# claw R claw L claw R R claw call4_none L_none L prog_1 call1 L_b


# # Mirror (medium)
# setup = [[:y, :y, :y, :y],[:g, :g],[:g],[:g],[:g, :g],[]]
# target = [[],[:g, :g],[:g],[:g],[:g, :g],[:y, :y, :y, :y]]
# claw_position = 1
# Successful programs:
# R_y claw_none claw_g R claw L call1 R call2 R R R L R_any claw
# R_y claw_none claw_g R claw L call1 R call2 R R R L R_any claw_r
# R_y claw_none claw_g R claw L call1 R R R R L R_any
# R_y claw_none claw_g R claw L call1 R R L R L R_any
# R_y claw_none claw_g R claw L call1 R call4 R L R L L
# R_y claw_none claw_g R claw L call1 R call4 R L claw L L
# R_y claw_none claw_g R claw L call1 R call4 R claw_none L L
# R_y claw_none claw_g R claw L call1 R call4 prog_4 claw_none L L
# R_y claw_none claw_g R claw L call1 R_g call3 claw_none L
# R_y claw_none claw_g R claw L call1 call2_any call3 claw_none L
# R_y claw_none claw_g R claw L call1 claw call2_any call3 claw_none L
# R_y claw_none claw_g R claw L call1 claw prog_2 call3 claw_none L
# R_y claw_none claw_g R claw L call1 R_r prog_2 call3 claw_none
# R_y claw_none claw_g R claw L call1 R_r prog_2 claw_none
# R_y claw_none claw_g R claw L claw_g call1 R_r prog_2 claw_none
# R_y claw_none claw_g R claw L claw_g call1 prog_4 prog_2 claw_none
# R_y claw_none claw_g R claw L call1 claw prog_2 claw_none
# R_y claw_none claw_g R claw L call1 claw R claw_none
# R_y claw_none claw_g R claw L call1 claw R claw
# R_y claw_none claw_g R claw L call1 claw claw claw
# R_y claw_none claw_g R claw L call1 claw claw L


# The Swap (crazy)
# target = [[:g, :g, :g], [], [:r, :r, :r]]
# setup = [[:r, :r, :r], [],[:g, :g, :g]]
# claw_position = 2
# Successful programs:
# call2_none claw R claw L R_y L claw R call1 R call4
# claw R claw L R_y L claw R call1 R
# claw R claw L R_y L claw R call1 claw
# claw R claw L R_y L claw R prog_1 call1 prog_2
# claw R claw L R_y L claw R call1 call1 prog_2
# claw R claw L R_y L claw R call1 call1 R
# claw R claw L R_y L claw R call1 claw R
# claw R claw L R_y L claw R call1 R R
# claw R claw L R_y L claw R call1 R L
# claw R claw L R_y L claw R call1 prog_4 L
# claw R claw L R_y L claw R call1 L
# claw R claw L call4 R_y L claw R call1 L
# claw R claw L call4 R_y L claw R call1
# claw R claw L call2 R_y L claw R call1
# claw R claw L call2 prog_1 L claw R call1
# claw R claw L prog_4 prog_1 L claw R call1
# claw R claw L call4_none prog_1 L claw R call1
# claw R claw L R_r prog_1 L claw R call1
# claw R claw L R_r R_y L claw R call1
# claw R claw L R_r call3_y L claw R call1
# claw R claw L R_r R_b L claw R call1



# Walking Piles (easy)
target = [[],[],[],[],[:b,:b,:b,:b],[:b,:b,:b,:b],[:b,:b,:b,:b]]
setup = [[:b,:b,:b,:b],[:b,:b,:b,:b],[:b,:b,:b,:b],[],[],[],[]]
claw_position = 1
# Successful programs:
# call3 prog_3 R R claw L prog_3 L_none L claw_none R call3
# call3 call3 prog_3 R R claw L prog_3 L_none L claw_none R call3
# call3 claw prog_3 R R claw L prog_3 L_none L claw_none R call3
# call3 R_y prog_3 R R claw L prog_3 L_none L claw_none R call3
# call3 R prog_3 R R claw L prog_3 L_none L claw_none R call3
# call3 R prog_3 R R claw L L_none L claw_none R call3
# call3 L prog_3 R R claw L L_none L claw_none R call3
# call3 prog_3 R R claw L L_none L claw_none R call3
# call3 prog_3 R R claw L L_none L prog_3 claw_none R call3
# call3 prog_3 prog_3 R R claw L_none L L claw_none R call3
# call3 prog_3 R R claw L_none L L claw_none R call3
# call3 L_y prog_3 R R claw L_none L L claw_none R call3
# call3 claw_any prog_3 R R claw L_none L L claw_none R call3
# call3 R prog_3 R R claw L_none L L claw_none R call3
# call3 claw_b prog_3 R R claw L_none L L claw_none R call3
# call3 claw prog_3 R R claw L_none L L claw_none R call3
# call3 R_r prog_3 R R claw L_none L L claw_none R call3
# call3 L claw L prog_3 R R claw L_none L L claw_none R call3
# call3 call3 claw L prog_3 R R claw L_none L L claw_none R call3
# call3 claw L prog_3 R R claw L_none L L claw_none R call3
# call3 call1 L prog_3 R R claw L_none L L claw_none R call3
# claw R call3 R_any prog_3 L L_none claw_none R R R claw L call3
# R R call3 R_any prog_3 L L_none claw_none R R R_none R claw L call3
# claw R call3 call1 R_b claw_y L L L_none L prog_3 L_none L claw_none R R R claw L call3
# claw R call3 L_r R_b claw_y L L L_none L prog_3 L_none L claw_none R R R claw L call3
# claw R call3 R claw L claw_y R L prog_1 L prog_3 L_none L claw_none R R R claw L call3
# claw R call3 claw L call3_any claw_y R call3 prog_1 L prog_3 L_none L claw_none R R R claw L call3
# claw R call3 claw L call3_any claw_y R L prog_1 L prog_3 L_none L claw_none R R R claw L call3
# claw R call3 claw L R_none call3_any claw_y R L prog_1 L prog_3 L_none L claw_none R R R claw L call3
# claw R call3 claw L claw call3_any claw claw_y claw R L prog_1 L prog_3 L_none L claw_none R R R claw L call3
# call4 claw R call3 claw L claw call3_any claw_none claw_y claw L prog_1 L prog_3 L_none L claw_none R R R claw L call3
# claw R call3 claw call3 claw call3_any claw_none claw_y claw L prog_1 L prog_3 L_none L claw_none R R R claw L call3
# claw R call3 claw call3 claw L claw_none claw_y claw L R_r prog_1 L prog_3 L_none L claw_none R R R claw L call3
# claw R call3 claw call3 claw call1 claw_none claw_y claw L R_r prog_1 L prog_3 L_none L claw_none R R R claw L call3
# claw R call3 claw call3 claw call1 L claw_y claw L R_r prog_1 L prog_3 L_none L claw_none R R R claw L call3
# claw R_b call3 R prog_3 L_none L claw_none R R R claw L call3
# claw R call3 R prog_3 L_none L claw_none R R R claw L call3
# claw R call3 claw_any prog_3 L_none L claw_none R R R claw L call3
# R_y R R claw_any call3 prog_3 L_none L claw_none R R R claw L call3
# claw R R_b call3 prog_3 L_none L L claw_none R R R claw call3
# claw R R L call2_g R_b call3 prog_3 L_none L L claw_none R R R claw call3
# claw R R L call2 R_b call3 prog_3 L_none L L claw_none R R R claw call3

# # Vertical Sort (Impossible)
# target = [[],[:g, :g, :b, :b, :b],[:g, :b, :b],[:g, :g, :b, :b],[:g, :b],[:g, :g, :g, :b, :b],[]]
# setup =  [[],[:g, :b, :g, :b, :b],[:b, :g, :b],[:g, :b, :b, :g],[:b, :g],[:b, :g, :g, :g, :b],[]]
# claw_position = 2

# # Lay It Out REVERSE
# target = [[:g,:g,:g,:g,:g,:g],[],[],[],[],[]]
# setup = [[:g],[:g],[:g],[:g],[:g],[:g]]
# claw_position = 1

# # # Mirror REVERSE
# target = [[:y, :y, :y, :y],[:g, :g],[:g],[:g],[:g, :g],[]]
# setup = [[],[:g, :g],[:g],[:g],[:g, :g],[:y, :y, :y, :y]]
# claw_position = 1


# # The Swap REVERSE
# setup = [[:g, :g, :g], [], [:r, :r, :r]]
# target = [[:r, :r, :r], [],[:g, :g, :g]]
# claw_position = 2


# # Tozier's Bane (yes I made it up)
# setup = [[:g, :g, :g], [], [:r, :r, :r], [], [:b, :b, :b], [], [:y, :y, :y]]
# target = [[:g, :b, :r],[:y],[:r, :g, :b],[:y],[:b, :r, :g],[:y],[]]
# claw_position = 1


def random_token_array(length)
  length.times.collect do
    random_token
  end
end

def random_token
  token = (@program_tokens+@meta_tokens).sample
  token = "#{token}_#{@modifiers.sample}" if @program_tokens.include?(token) && rand < 0.2
  token
end


def mutate_token_array(array, max_length = 32)
  mutie = array.clone
  mutie[rand(mutie.length)] = random_token
  mutie = mutie.delete_if {rand < (1.0/mutie.length) && mutie.length > 10}
  mutie = mutie.each_with_index do |t,i|
    mutie.insert(i,random_token) if rand < 0.04 && mutie.length < max_length
  end
  mutie
end


File.open("hillclimbing.csv", "w+") do |results_file|
  wildtype_tokens = random_token_array(30)
  wildtype = CargoBot.new(
    wildtype_tokens.join(" "),
    stacks:setup.collect {|stack| stack.clone},
    goal:target, 
    claw_position:claw_position,
    step_limit:200)
  wildtype.activate
  wildtype_err = CrateStacks.new(wildtype.stacks).teardown_distance(CrateStacks.new target)
  
  results_file.puts "1,#{wildtype_err},#{wildtype.steps},#{wildtype.moves},#{wildtype.crashes},#{wildtype.topples},#{wildtype.script.inspect}"
    
  bests = {wildtype.script => [wildtype_err,wildtype.crashes]}
  until bests.values.count([0,0]) > 20 do
    mutant_tokens = mutate_token_array(wildtype_tokens)
    mutant = CargoBot.new(
      mutant_tokens.join(" "),
      stacks:setup.collect {|stack| stack.clone},
      goal:target,
      claw_position:claw_position,
      step_limit:200)
    mutant.activate
    mutant_err = CrateStacks.new(mutant.stacks).teardown_distance(CrateStacks.new target)
  
    if (mutant_err <= wildtype_err) && 
        (mutant.crashes <= wildtype.crashes) && 
        (bests[mutant.script].nil?)
      bests[mutant.script] = [mutant_err,mutant.crashes]
      wildtype_tokens = mutant_tokens
      wildtype = mutant
      wildtype_err = mutant_err
      results_file.puts "#{bests.length},#{mutant_err},#{mutant.steps},#{mutant.moves},#{mutant.crashes},#{mutant.topples}, #{mutant.script.inspect}"
      puts "#{bests.length},#{mutant_err},#{mutant.steps},#{mutant.moves},#{mutant.crashes},#{mutant.topples}"
    end
  end
  
  bests.each do |k,v|
    puts "# #{k.inspect}" if v[0]==0 && v[1]==0
  end
end