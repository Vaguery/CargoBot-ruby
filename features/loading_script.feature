Feature: Loading script
  In order to evaluate a Cargo-bot script
  As a simulator
  I want to be able to load tokens into the emulator registers

  Scenario: load script tokens into Prog 1 by default
    Given the bot is created with script "L L R claw"
    Then the bot's program should have 1 subroutine
    And subroutine 1 should have 4 tokens
  
  Scenario: load a script with more than one subroutine
    Given the bot is created with script "R prog_2 L prog_1 R prog_4 L"
    Then the bot's program should have 4 subroutines
    And subroutine 1 should have 2 tokens
    And subroutine 2 should have 1 token
    And subroutine 3 should have 0 tokens
    And subroutine 4 should have 1 token
