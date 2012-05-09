require 'spec_helper'


describe "running branching scripts" do
  it "should visit the right tokens as it executes" do
    c = CargoBot.new("prog_2 R call3 R prog_1 call2 L L prog_3 claw claw")
    c.program.should == 
      [[:call2, :L, :L], [:R, :call3, :R], [:claw, :claw]] 
    c.stacks = [[:red],[],[]]
    c.activate
    c.steps.should == 8
  end
  
  it "should not branch if the called subroutine doesn't exist" do
    c = CargoBot.new("call4 R", stacks:[[:b],[]])
    lambda { c.activate }.should_not raise_error
  end
end