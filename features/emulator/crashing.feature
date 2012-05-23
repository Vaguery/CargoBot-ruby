Feature: Cargo-bot emulator crashing

Background: a bot exists
  Given I have a new cargobot

Scenario: Crash when hitting left wall
  Given subroutine 1 is "L R R R"
  And the pallets are [[], [], []]
  And the claw is in position 1
  When I activate the cargobot
  Then the claw should be over pallet 1
  And the step count should be 1
  And the claw should be crashed

Scenario: Crash when hitting right wall
  Given subroutine 1 is "R R R R"
  And the pallets are [[], [], []]
  And the claw is in position 1
  When I activate the cargobot
  Then the claw should be over pallet 3
  And the step count should be 3
  And the claw should be crashed
