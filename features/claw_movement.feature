Feature: Claw movement
  In order to evaluate a given Cargo-bot script
  As a simulator
  I want the claw to move as it does in the original game

  Scenario: Claw should move left and right between stacks
    Given the bot is created with script "L R R R" and 10 stacks
    And the claw is in position 2
    When I activate the cargobot
    Then the number of moves should be 4
    And the claw should be in position 4
    
  Scenario: When the claw tries to move left of position 1, it should crash
    Given the bot is created with script "L R L L" and 10 stacks
    And the claw is in position 1
    When I activate the cargobot
    Then the claw should be in position 1
    And the number of crashes should be 2 
    
  Scenario: When the claw tries to move right of the rightmost stack, it should crash
    Given the bot is created with script "R R L R" and 3 stacks
    And the claw is in position 3
    When I activate the cargobot
    Then the claw should be in position 3
    And the number of crashes should be 2 
  
  Scenario: When the empty claw activates over a block, it should pick it up
    Given the bot is created with script "claw R" and 2 stacks
    And the claw is in position 1
    And the top box on stack 1 is blue
    When I activate the cargobot
    Then the claw should be in position 2
    And the claw should contain a blue box
    And the number of boxes in stack 1 should be 0
  
  Scenario: When the claw containing a block activates, it should put it down on that stack
    Given the bot is created with script "claw R claw" and 2 stacks
    And the claw is in position 1
    And the top box on stack 1 is blue
    And the top box on stack 2 is red
    When I activate the cargobot
    Then the claw should be in position 2
    And the claw should be empty
    And the number of boxes in stack 1 should be 0
    And stack 2 should be [:red, :blue]