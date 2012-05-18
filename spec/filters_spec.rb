require 'spec_helper'

describe "color filters" do
  it "should not move if the claw is holding the wrong block color" do
    c = CargoBot.new("claw R_red", stacks:[[:blue],[],[]])
    c.activate
    c.claw_position.should == 1
  end
  
  it "should move if the claw is holding the right block color" do
    c = CargoBot.new("claw R_red", stacks:[[:red],[],[]])
    c.activate
    c.claw_position.should == 2
  end
  
end