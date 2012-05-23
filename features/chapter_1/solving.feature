Feature: Chapter 1 solving

Background: a bot exists
  Given I have a new cargobot

Scenario: Reaching the goal stops execution
  Given subroutine 1 is "claw R claw call1"
  And the pallets are [[red], [], [], []]
  And the goal is [[], [], [], [red]]
  And the claw is over pallet 1
  When I activate the cargobot
  Then the pallets should be [[], [], [], [red]]
  And the step count should be 11

  
