Feature: Chapter 1 subroutines

Background: a bot exists
  Given I have a new cargobot

Scenario: Called subroutines execute immediately
  Given subroutine 1 is "R call2 R R R call2"
  And subroutine 2 is "claw L claw R"
  And the pallets are [[], [red, blue], [], [], [red, blue]]
  And the claw is over pallet 1
  When I activate the cargobot
  Then the pallets should be [[blue], [red], [], [blue], [red]]
  And the claw should be over pallet 5

Scenario: Step limit halts loops
  Given subroutine 1 is "R L call1"
  And the pallets are [[], []]
  And the claw is over pallet 1
  And the step limit is 200 tokens
  When I activate the cargobot
  Then the step count should be 200
