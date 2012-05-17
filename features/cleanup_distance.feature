Feature: Cleanup distance
  In order to evaluate how well a particular outcome matches a target
  As a Cargo-Botter
  I want to count the number of moves needed to 'fix' each crate
  
  Scenario: score is +0 if the target and observed boxes are the same
    Given the target is [[:r],[]]
    And the observed is [[:r],[]]
    When I calculate the cleanup distance for box 1 of stack 1 of the state
    Then the score for that box should be 0
  
  Scenario: score is +1 when target wants box that's on top of some other stack
    Given the target is [[:r],[]]
    And the observed is [[],[:r]]
    When I calculate the cleanup distance for box 1 of stack 1 of the state
    Then the score for that box should be 2
    
    Given the target is [[:r,:b],[]]
    And the observed is [[:r],[:b]]
    When I calculate the cleanup distance for box 2 of stack 1 of the state
    Then the score for that box should be 2
    
  Scenario: score is +100 when target wants a box that's missing completely in the observed setup
    Given the target is [[:r]]
    And the observed is [[]]
    When I calculate the cleanup distance for box 1 of stack 1 of the state
    Then the score for that box should be 100
  
  Scenario: score is number of blocks moved when target lacks a box that's inside some other stack
    Given the target is [[:r], [:b,:b]]
    And the observed is [[],[:r,:b,:b]]
    When I calculate the cleanup distance for box 1 of stack 1 of the state
    Then the score for that box should be 4
  
  Scenario: score is MIN number of blocks moved when target lacks a box that's inside 2+ other stacks
    Given the target is [[:r], [:r, :b, :b], [:g, :r, :g]]
    And the observed is [[],[:r,:r,:b,:b], [:g,:r,:g]]
    When I calculate the cleanup distance for box 1 of stack 1 of the state
    Then the score for that box should be 3
  
  Scenario: score is TOTAL blocks moved to replace a block from within a stack
    Given the target is [[:g, :r, :r, :r]]
    And the observed is [[:r, :r, :r, :g]]
    When I calculate the cleanup distance for box 1 of stack 1 of the state
    Then the score for that box should be 5
  
  Scenario: score is MIN TOTAL blocks moved to replace a block from another stack
    Given the target is [[:g, :r, :r, :r], [:b, :b], [:g, :y, :y, :y]]
    And the observed is [[:b, :r, :r, :r], [:g, :b], [:g, :y, :y, :y]]
    When I calculate the cleanup distance for box 1 of stack 1 of the state
    Then the score for that box should be 6
  
  Scenario: score for a block missing supports
    Given the target is [[:r, :r, :b], []]
    And the observed is [[:r], [:b, :r]]
    When I calculate the cleanup distance for box 3 of stack 1 of the state
    Then the score for that box should be 4
  
  Scenario: score is number of blocks moved when target lacks a box that's inside some other stack
    Given the target is [[:y, :y, :y, :r], [:b, :b]]
    And the observed is [[], [:y, :y, :y, :r, :b, :b]]
    When I calculate the cleanup distance for box 4 of stack 1 of the state
    Then the score for that box should be 7
  
  Scenario: score for wrong position in same stack
    Given the target is [[:r, :r, :r, :r, :b, :r]]
    And the observed is [[:b, :r, :r, :r, :r, :r]]
    When I calculate the cleanup distance for box 5 of stack 1 of the state
    Then the score for that box should be 11
    
    Given the target is [[:r, :r, :b, :r, :r]]
    And the observed is [[:b, :r, :r, :r, :r]]
    When I calculate the cleanup distance for box 3 of stack 1 of the state
    Then the score for that box should be 8
    
    
    
  
  Scenario: score for a stack sums error for each crate 
    Given the target is [[:r, :r, :r, :r, :b, :r]]
    And the observed is [[:b, :r, :r, :r, :r, :r]]
    When I calculate the cleanup distance for stack 1 of the state
    Then the score for that stack should be 18
  
  Scenario: score for a stack counts cost to remove extra stuff 
    Given the target is [[], [:r, :r, :r, :r, :b, :r]]
    And the observed is [[:r, :r, :r, :r, :b, :r], []]
    When I calculate the cleanup distance for stack 1 of the state
    Then the score for that stack should be 21
  
  Scenario: stack scoring should just work
    Given the target is [[:y, :y, :y, :r], [:b, :b]]
    And the observed is [[], [:y, :y, :y, :r, :b, :b]]
    When I calculate the cleanup distance for box 1 of stack 1 of the state
    Then the score for that box should be 5
    
    When I calculate the cleanup distance for box 2 of stack 1 of the state
    Then the score for that box should be 6
    
    When I calculate the cleanup distance for box 3 of stack 1 of the state
    Then the score for that box should be 7
    
    When I calculate the cleanup distance for box 4 of stack 1 of the state
    Then the score for that box should be 7
    
    When I calculate the cleanup distance for stack 1 of the state
    Then the score for that stack should be 25
    
    When I calculate the cleanup distance for stack 2 of the state
    Then the score for that stack should be 23
  
  
  
  Scenario: full setup scoring should add all stack scores
    Given the target is [[:y, :y, :y, :r], [:b, :b]]
    And the observed is [[], [:y, :y, :y, :r, :b, :b]]
    When I calculate the cleanup distance
    Then the score should be 48
    
  Scenario: the error measure does not have to be symmetric
    Given the target is [[], [:y, :y, :y, :r, :b, :b]]
    And the observed is [[:y, :y, :y, :r], [:b, :b]]
    When I calculate the cleanup distance for stack 1 of the state
    Then the score for that stack should be 10
    
    When I calculate the cleanup distance for stack 2 of the state
    Then the score for that stack should be 23
    
    When I calculate the cleanup distance
    Then the score should be 33
  
  Scenario: it should work for many arrangements
    Given I have 100 arbitrary target:objective pairs with 5 stacks and 5 crates each
    When I calculate the cleanup distance for the random pairs
    Then the score should be a numerical value
  
  
  
  
