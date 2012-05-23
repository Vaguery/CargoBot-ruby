Given /^I have a new cargobot$/ do
  @bot = CargoBot.new
  @bot.fragile = true
  @bot.unstable = true
end

Given /^subroutine (\d+) is "([^"]*)"$/ do |routine, script|
  subroutine_wanted = routine.to_i-1
  until !@bot.program[subroutine_wanted].nil?
    @bot.program << Array.new
  end
  @bot.program[routine.to_i-1] = script.split.collect {|token| token.intern}
end

Given /^the pallets are (\[.+\])$/ do |stacks|
  symbolized_stacks = stacks.gsub(/(\w+)/,':\1')
  @bot.stacks = eval(symbolized_stacks)
end

Given /^the goal is (\[.+\])$/ do |stacks|
  symbolized_stacks = stacks.gsub(/(\w+)/,':\1')
  @bot.goal = eval(symbolized_stacks)
end


Given /^the claw is over pallet (\d+)$/ do |which|
  @bot.claw_position = which.to_i
end

Given /^the step limit is (\d+) tokens$/ do |limit|
  @bot.step_limit = limit.to_i
end


Then /^the claw should be over pallet (\d+)$/ do |which|
  @bot.claw_position.should == which.to_i
end

Then /^the claw should hold a (\w+) box$/ do |color|
  @bot.claw_holding.should == color.intern
end

Then /^the pallets should be (\[.+\])$/ do |stacks|
  symbolized_stacks = stacks.gsub(/(\w+)/,':\1')
  @bot.stacks.should == eval(symbolized_stacks)
end

Then /^the step count should be (\d+)$/ do |steps|
  @bot.steps.should == steps.to_i
end

Then /^the claw will be crashed$/ do
  @bot.crashes.should_not == 0
end

Then /^the claw will not be crashed$/ do
  @bot.crashes.should == 0
end

Then /^a stack of crates will be toppled$/ do
  @bot.topples.should >= 1
end
