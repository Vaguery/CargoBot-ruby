Feature: Loading script
  In order to evaluate a Cargo-bot script
  As a simulator
  I want to be able to load tokens into the emulator registers

  Scenario: load script tokens into Prog 1 by default
    Given the bot is created with script "L L R claw"
    Then the bot's program should have 1 subroutine
    And subroutine 1 should have 4 tokens
  
  
  
