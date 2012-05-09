require 'spec_helper'


describe "loading scripts" do
  describe "subroutines" do
    
    it "should add a new subroutine when it processes a 'prog_X' token" do
      CargoBot.new("prog_3 R").program.length.should == 3
    end
    
    it "should load each token into the specified subroutine" do
      CargoBot.new("prog_2 R R prog_1 L L prog_3 claw claw").program.should == 
        [[:L, :L], [:R, :R], [:claw, :claw]] 
    end
  end
end