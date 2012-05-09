Feature: Conditional tokens
  In order to permit conditional execution
  As a Cargo-bot programmer
  I want tokens to be conditioned by what the claw is holding when they're executed

  Scenario: Color annotations act as filters on tokens
    Given the bot is created with script "claw R_red R_blue R_blue claw L L call1" and 3 stacks
    And stack 1 contains [:blue, :red, :blue, :red, :blue]
    And the goal is '[[], [:red, :red], [:blue, :blue, :blue]]'
    When I activate the cargobot
    Then the stacks should be [[], [:red, :red], [:blue, :blue, :blue]]
    And the number of moves should be 24
    
    
  Scenario: Generic 'any' annotations filter on whether a block is held
    Given the bot is created with script "claw R_any R_red claw L L call1" and 3 stacks
    And stack 1 contains [:blue, :red, :green, :red, :yellow]
    And the goal is '[[], [:yellow, :green, :blue], [:red, :red]]'
    When I activate the cargobot
    Then the stacks should be [[], [:yellow, :green, :blue], [:red, :red]]
    And the number of moves should be 23
    
    
  Scenario: Generic 'none' annotations filter on whether a block is held
    Given the bot is created with script "R claw_none L_any claw_any call1" and 3 stacks
    And stack 2 contains [:blue, :red, :green, :red, :yellow]
    And the goal is '[[:yellow, :red, :green, :red, :blue], [], []]'
    When I activate the cargobot
    Then the stacks should be [[:yellow, :red, :green, :red, :blue], [], []]
    And the number of moves should be 20
