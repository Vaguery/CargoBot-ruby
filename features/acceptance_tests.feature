Feature: Acceptance tests
  In order to verify the emulator's accuracy
  As a Cargo-bot runner
  I want to check the outcome against known Cargo-bot results

  Scenario: Tutorial 1
    Given the bot is created with script "claw R claw" and 2 stacks
      And stack 1 contains [:yellow]
      And the goal is '[[], [:yellow]]'
      When I activate the cargobot
      Then the stacks should be [[], [:yellow]]
      And the number of moves should be 3
      And the number of crashes should be 0
      And the number of topples should be 0

  Scenario: Tutorial 2
    Given the bot is created with script "claw R R R claw" and 4 stacks
      And stack 1 contains [:yellow]
      And the goal is '[[], [], [], [:yellow]]'
      When I activate the cargobot
      Then the stacks should be [[], [], [], [:yellow]]
      And the number of moves should be 5
      And the number of crashes should be 0
      And the number of topples should be 0
      

  Scenario: Tutorial 3
    Given the bot is created with script "claw R claw L call1" and 2 stacks
      And stack 1 contains [:y, :y, :y, :y]
      And the goal is '[[], [:y, :y, :y, :y]]'
      When I activate the cargobot
      Then the stacks should be [[], [:y, :y, :y, :y]]
      And the number of moves should be 15
      And the number of crashes should be 0
      And the number of topples should be 0
      

  Scenario: Tutorial 4
    Given the bot is created with script "call2 call2 call2 call2 R call1 prog_2 claw R claw L" and 6 stacks
      And stack 1 contains [:b, :r, :g, :y]
      And the goal is '[[], [], [], [], [], [:y, :g, :r, :b]]'
      When I activate the cargobot
      Then the stacks should be [[], [], [], [], [], [:y, :g, :r, :b]]
      And the number of moves should be 83
      And the number of crashes should be 0
      And the number of topples should be 0
  
  
  Scenario: "Double Sort"
    Given the bot is created with script "L claw_b R claw_none R claw_none call2 prog_2 R claw_y L L call1" and 4 stacks
      And stack 2 contains [:b, :b, :y, :y]
      And stack 3 contains [:y, :b, :y, :b]
      And the claw is in position 2
      And the goal is '[[:b,:b,:b,:b],[],[],[:y,:y,:y,:y]]'
      When I activate the cargobot
      Then the stacks should be [[:b, :b, :b, :b], [], [], [:y, :y, :y, :y]]
      And the number of moves should be 66
      And the number of crashes should be 0
      And the number of topples should be 0
