Feature: Cargo-bot emulator loading scripts

Background: a bot exists
  Given I have a new cargobot

Scenario: Start with subroutine 1
  Given the script is "L R R R"
  When I load the script into the bot
  Then subroutine 1 should be "L R R R"
  And subroutine 2 should be empty
  
Scenario: Add tokens as indicated by prog_N
  Given the script is "R prog_2 L prog_1 R prog_4 L"
  When I load the script into the bot
  Then subroutine 1 should be "R R"
  And subroutine 2 should be "L"
  And subroutine 3 should be empty
  And subroutine 4 should be "L"
  
Scenario: Return to subroutine as indicated
  Given the script is "R prog_2 L L L L prog_1 R R"
  When I load the script into the bot
  Then subroutine 1 should be "R R R"
  And subroutine 2 should be "L L L L"