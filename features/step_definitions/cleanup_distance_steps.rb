Given /^the target is (\[.+\])$/ do |arg1|
  @target = CrateStacks.new eval(arg1)
end

Given /^the observed is (\[.+\])$/ do |arg1|
  @observed = CrateStacks.new eval(arg1)
end

When /^I calculate the cleanup distance for box (\d+) of stack (\d+) of the target$/ do |arg1, arg2|
  @distance = @observed.crate_cleanup_distance(@target, arg2.to_i, arg1.to_i)
end

Then /^the score for that box should be (\d+)$/ do |arg1|
  @distance.should == arg1.to_i
end

