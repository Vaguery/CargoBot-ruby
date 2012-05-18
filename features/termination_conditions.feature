Feature: Termination conditions
  In order to evaluate a Cargo-bot script
  As a simulator
  I want evaluation to stop as soon as the target is found, or at some shutoff point
  
  
  Scenario: Execution should stop if it reaches the end of subroutine 1
    Given the bot is created with script "R R R"
    When I activate the cargobot
    Then the number of steps should be 3
    
    
  Scenario: Execution should stop immediately when the target state is found
    Given the bot is created with script "claw R claw R R R R" and 6 stacks
    And the claw is in position 1
    And the top box on stack 1 is blue
    And the goal is '[[], [:blue], [], [], [], []]'
    When I activate the cargobot
    Then the number of moves should be 3
    And the claw should be in position 2
    
    
  Scenario: Execution should stop immediately when the step limit is reached
    Given the bot is created with script a very long program and 3 stacks
    And the goal is '[[:yellow]]'
    And the step limit is 200
    And the claw is in position 1
    When I activate the cargobot
    Then the number of steps should be 200
    And the claw should be in position 3
    
    
  Scenario: Execution should stop if the bot is 'fragile' and it crashes
    Given the bot is created with script "L L L" and 1 stack
    And the bot has a fragile claw
    When I activate the cargobot
    Then the number of crashes should be 1
    And the number of steps should be 1
    
    
  Scenario: Execution should stop if the bot is 'unstable' and a stack topples
    Given the bot is created with script "claw R claw call1" and 2 stacks
    And the bot has a height limit of 4
    And the stacks topple the claw bumps them at their height limit
    And stack 1 contains [:red, :red]
    And stack 2 contains [:blue, :blue, :blue, :blue, :blue, :blue]
    When I activate the cargobot
    Then the number of topples should be 1
    And the number of steps should be 2
