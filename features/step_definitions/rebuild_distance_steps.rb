When /^I calculate the rebuild distance$/ do
  @distance = @observed.rebuild_distance(@target)
end

Then /^the score should be twice the teardown distance$/ do
  @distance.should == @observed.teardown_distance(@target)*2
end
