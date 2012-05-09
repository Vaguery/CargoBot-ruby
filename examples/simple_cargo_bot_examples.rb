require_relative '../lib/cargobot'



# Cargo-Bot Tutorial 4

c = CargoBot.new "call2 call2 call2 call2 R call1 prog_2 claw R claw L",
  :stacks => [[:b, :r, :g, :y],[],[],[],[],[]],
  :goal => [[], [], [], [], [], [:y, :g, :r, :b]]

c.activate
c.show_off