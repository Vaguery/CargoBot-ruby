require 'spec_helper'


describe "loading scripts" do
  describe "subroutines" do
    
    it "should add a new subroutine when it processes a 'prog_X' token" do
      Cargobot.new("prog_3 R").program.length.should == 3
    end
  end
end