Feature: Cargo-bot emulator tutorial examples

Background: a bot exists
  Given I have a new cargobot

Scenario: Tutorial 1
  Given subroutine 1 is "claw R claw"
  And the pallets are [[yellow],[]]
  And the goal is [[], [yellow]]
  When I activate the cargobot
  Then the pallets should be [[], [yellow]]
  And the step count should be 3
  And the claw should not be crashed
  And no stacks should be toppled

Scenario: Tutorial 2
  Given subroutine 1 is "claw R R R claw"
  And the pallets are [[yellow],[],[],[]]
  And the goal is [[],[],[],[yellow]]
  When I activate the cargobot
  Then the pallets should be [[],[],[],[yellow]]
  And the step count should be 5
  And the claw should not be crashed
  And no stacks should be toppled
  
Scenario: Tutorial 4
  Given subroutine 1 is "call2 call2 call2 call2 R call1"
  And subroutine 2 is "claw R claw L"
  And the pallets are [[blue,red,green,yellow],[],[],[],[],[]]
  And the goal is [[],[],[],[],[],[yellow,green,red,blue]]
  When I activate the cargobot
  Then the pallets should be [[],[],[],[],[],[yellow,green,red,blue]]
  And the step count should be 107
  And the claw should not be crashed
  And no stacks should be toppled
