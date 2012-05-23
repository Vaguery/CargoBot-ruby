Feature: Branching and recursive execution of programs
  In order to re-use code
  As a cargo-bot programmer
  I want the script to be partitioned into several subroutines

  Scenario: Execution should return to where it started when a subroutine was called
    Given the bot is created with script "R call2 claw call3 L prog_2 claw R prog_3 L" and 3 stacks
    And the claw is in position 1
    And the top box on stack 2 is blue
    And the top box on stack 3 is red
    When I activate the cargobot
    Then the number of moves should be 6
    And the claw should be in position 1
    And the claw should be empty
    And stack 2 should be empty
    And stack 3 should be [:red, :blue]
    
    
  Scenario: Recursion can create infinite loops, but they will terminate based on steps
    Given the bot is created with script "R call1" and 3 stacks
    And the step limit is 200
    And the claw is in position 1
    When I activate the cargobot
    Then the number of steps should be 200
    And the claw should be in position 3
  