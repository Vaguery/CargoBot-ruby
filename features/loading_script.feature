Feature: Loading script
  In order to evaluate a Cargo-bot script
  As a simulator
  I want to be able to load tokens into the emulator registers

  Scenario: Script tokens are added to the end of the 1st subroutine by default
    Given the bot is created with script "L L R claw"
    Then the bot's program should have 1 subroutine
    And subroutine 1 should have 4 tokens
  
  Scenario: Where script tokens are added is controlled by the 'prog_X' token
    Given the bot is created with script "R prog_2 L prog_1 R prog_4 L"
    Then the bot's program should have 4 subroutines
    And subroutine 1 should have 2 tokens
    And subroutine 2 should have 1 token
    And subroutine 3 should have 0 tokens
    And subroutine 4 should have 1 token
    
  Scenario: All tokens added to a subroutine are appended, even after a break
    Given the bot is created with script "R prog_2 L L L L prog_1 R R"
    Then the bot's program should have 2 subroutines
    And subroutine 1 should have tokens [:R, :R, :R]
    And subroutine 2 should have tokens [:L, :L, :L, :L]
  
  
  