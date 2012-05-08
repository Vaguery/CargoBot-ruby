Given /^the bot is created with script "([^"]*)"$/ do |arg1|
  @bot = Cargobot.new(arg1)
end


Given /^the claw is initially in position (\d+)$/ do |arg1|
  @bot = Cargobot.new
  @bot.claw_position = arg1.to_i
end


Given /^the subscript "([^"]*)" is loaded into Prog(\d+)$/ do |arg1, arg2|
  arg1.scan(/w+/) do |word|
    @bot.script[arg2.to_i - 1] = word.intern
  end
end


When /^I activate the cargobot$/ do
  @bot.activate
end


Then /^the bot's program should have (\d+) subroutines?$/ do |arg1|
  @bot.program.length.should == arg1.to_i
end


Then /^the number of moves should be (\d+)$/ do |arg1|
  @bot.moves.should == arg1
end


Then /^subroutine (\d+) should have (\d+) tokens?$/ do |arg1, arg2|
  @bot.program[arg1.to_i-1].length.should == arg2.to_i
end

