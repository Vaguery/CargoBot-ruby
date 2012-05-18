require_relative '../lib/cargobot'

@program_tokens = %w{ R L claw } * 10 + %w{ call1 call2 call3 call4} 
@meta_tokens = %w{ prog_1 prog_2 prog_3 prog_4}
@modifiers = %w{ r g b y any none}


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
  mutie = mutie.each_with_index {|t,i| mutie.insert(i,random_token) if rand < 0.04 && mutie.length < max_length}
  mutie
end


# Lay It Out (medium)
# setup = [[:g,:g,:g,:g,:g,:g],[],[],[],[],[]]
# target = [[:g],[:g],[:g],[:g],[:g],[:g]]


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
# setup = [[:r, :r, :r], [], [:g, :g, :g]]
# claw_position = 2


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



wildtype_tokens = random_token_array(30)
wildtype = CargoBot.new(wildtype_tokens.join(" "), stacks:setup.collect {|stack| stack.clone}, goal:target, claw_position:claw_position)
wildtype.activate
wildtype_err = CrateStacks.new(wildtype.stacks).cleanup_error(CrateStacks.new target)

puts "#{wildtype_err},#{wildtype.steps},#{wildtype.moves},#{wildtype.crashes},#{wildtype.stack_trace.length}"


bests = {wildtype.script => [wildtype_err,wildtype.crashes]}
until bests.values.count([0,0]) > 20 do
  mutant_tokens = mutate_token_array(wildtype_tokens)
  mutant = CargoBot.new(mutant_tokens.join(" "),
    stacks:setup.collect {|stack| stack.clone}, goal:target, claw_position:claw_position)
  mutant.activate
  mutant_err = CrateStacks.new(mutant.stacks).cleanup_error(CrateStacks.new target)
  
  if (mutant_err <= wildtype_err) && (mutant.crashes <= wildtype.crashes) && (bests[mutant.script].nil?)
    bests[mutant.script] = [mutant_err,mutant.crashes]
    wildtype_tokens = mutant_tokens
    wildtype = mutant
    wildtype_err = mutant_err
    puts "#{bests.length},#{mutant_err},#{mutant.steps},#{mutant.moves},#{mutant.crashes},#{mutant.stack_trace.length}, #{mutant.script}"
  end
end

puts "\n\nSuccessful programs:"
bests.each do |k,v|
  puts k if v[0]==0 && v[1]==0
end