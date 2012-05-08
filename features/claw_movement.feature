Feature: Claw movement
  In order to evaluate a given Cargo-bot script
  As a simulator
  I want the claw to move as it does in the original game

  Scenario: free left-right movement
    Given the bot is created with script "L R R R" and 10 stacks
    And the claw is in position 2
    When I activate the cargobot
    Then the number of moves should be 4
    And the claw should be in position 4
    
  Scenario: bumping into the left wall
    Given the bot is created with script "L R L L" and 10 stacks
    And the claw is in position 1
    When I activate the cargobot
    Then the claw should be in position 1
    And the number of crashes should be 2 
    
  Scenario: bumping into the right wall
    Given the bot is created with script "R R L R" and 3 stacks
    And the claw is in position 3
    When I activate the cargobot
    Then the claw should be in position 3
    And the number of crashes should be 2 
  
  Scenario: picking up a block
    Given the bot is created with script "claw R" and 2 stacks
    And the claw is in position 1
    And the top box on stack 1 is blue
    When I activate the cargobot
    Then the claw should be in position 2
    And the claw should contain a blue box
    And the number of boxes in stack 1 should be 0
  
  Scenario: putting down a block
    Given the bot is created with script "claw R claw" and 2 stacks
    And the claw is in position 1
    And the top box on stack 1 is blue
    And the top box on stack 2 is red
    When I activate the cargobot
    Then the claw should be in position 2
    And the claw should be empty
    And the number of boxes in stack 1 should be 0
    And stack 2 should be [:red, :blue]
  
  
  
  
