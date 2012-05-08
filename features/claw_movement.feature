Feature: Claw movement
  In order to evaluate a given Cargo-bot script
  As a simulator
  I want the claw to move as it does in the original game

  Scenario: free left-right movement
    Given the claw is initially in position 2
    And the subscript "L R R R" is loaded into Prog1
    When I activate the cargobot
    Then the number of moves should be 4
    And the claw should be in position 4
  
  
  
