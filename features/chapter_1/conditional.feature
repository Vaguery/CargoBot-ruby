Feature: Chapter 1 conditionals

Background: a bot exists
  Given I have a new cargobot

Scenario: Color filters
  Given subroutine 1 is "claw claw_green call2_red call3_blue call1_none"
  And subroutine 2 is "L claw R"
  And subroutine 3 is "R claw L"
  And the claw is over pallet 2
  And the pallets are [[],[green,red,blue,blue,red,red],[]]
  When I activate the cargobot
  Then the pallets should be [[red,red,red],[green],[blue,blue]]

Scenario: 'any' filters
  Given subroutine 1 is "claw call2_red call3_any call1"
  And subroutine 2 is "L claw R"
  And subroutine 3 is "R claw L"
  And the claw is over pallet 2
  And the pallets are [[],[green,red,purple,blue,red,red],[]]
  When I activate the cargobot
  Then the pallets should be [[red,red,red],[],[blue,purple,green]]

Scenario: 'none' filters
  Given subroutine 1 is "claw R_none L_any call1_none claw_any"
  And the claw is over pallet 1
  And the pallets are [[],[red],[],[blue,red]]
  When I activate the cargobot
  Then the pallets should be [[red], [], [], [blue,red]]
  And the claw will not be crashed