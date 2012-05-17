Given /^the target is (\[.+\])$/ do |arg1|
  @target = CrateStacks.new eval(arg1)
end

Given /^the observed is (\[.+\])$/ do |arg1|
  @observed = CrateStacks.new eval(arg1)
end

When /^I calculate the cleanup distance for box (\d+) of stack (\d+) of the state$/ do |arg1, arg2|
  @distance = @observed.crate_cleanup_error(@target, arg2.to_i, arg1.to_i)
end

Then /^the score for that box should be (\d+)$/ do |arg1|
  @distance.should == arg1.to_i
end

When /^I calculate the cleanup distance for stack (\d+) of the state$/ do |arg1|
  @stackscore = @observed.stack_cleanup_error(@target, arg1.to_i)
end

Then /^the score for that stack should be (\d+)$/ do |arg1|
  @stackscore.should == arg1.to_i
end

When /^I calculate the cleanup distance$/ do
  @distance = @observed.cleanup_error(@target)
end

Then /^the score should be (\d+)$/ do |arg1|
  @distance.should == arg1.to_i
end



Given /^I have (\d+) arbitrary target:objective pairs with (\d+) stacks and (\d+) crates each$/ do |arg1, arg2, arg3|
  replicates = arg1.to_i
  stacks = arg2.to_i
  boxes = arg3.to_i
  
  @random_pairs = replicates.times.collect do
    target = stacks.times.collect do
      boxes.times.collect {[:r, :g, :b, :y].sample}
    end
    observed = target.collect {|stack| stack.shuffle}.shuffle
    {target:CrateStacks.new(target), observed:CrateStacks.new(observed)}
  end
end


When /^I calculate the cleanup distance for the random pairs$/ do
  @random_pair_errors = @random_pairs.collect {|pair| pair[:observed].cleanup_error(pair[:target])}
end

Then /^the score should be a numerical value$/ do
  @random_pair_errors.each {|score| score.should be_a_kind_of(Fixnum)}
end

