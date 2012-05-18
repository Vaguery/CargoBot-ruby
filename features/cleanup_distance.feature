Feature: Cleanup distance
  In order to evaluate how well a particular outcome matches a target
  As a Cargo-Botter
  I want to count the number of moves needed to 'fix' each crate
  
  Scenario: +0 if the target and observed boxes are same
    Given the target is [[:r],[]]
    And the observed is [[:r],[]]
    When I calculate the cleanup distance for box 1 of stack 1
    Then the score for that box should be 0
  
  Scenario: +2 to retrieve a box from atop another stack
    Given the target is [[:r],[]]
    And the observed is [[],[:r]]
    When I calculate the cleanup distance for box 1 of stack 1
    Then the score for that box should be 2
    
    Given the target is [[:r,:b],[]]
    And the observed is [[:r],[:b]]
    When I calculate the cleanup distance for box 2 of stack 1
    Then the score for that box should be 2
    
  Scenario: +100 if target box is totally missing
    Given the target is [[:r]]
    And the observed is [[]]
    When I calculate the cleanup distance for box 1 of stack 1
    Then the score for that box should be 100
  
  Scenario: count boxes moved when retrieving replacement
    Given the target is [[:r], [:b,:b]]
    And the observed is [[],[:r,:b,:b]]
    When I calculate the cleanup distance for box 1 of stack 1
    Then the score for that box should be 4
  
  Scenario: count minimum moves when choosing a replacement
    Given the target is [[:r], [:r, :b, :b], [:g, :r, :g]]
    And the observed is [[],[:r,:r,:b,:b], [:g,:r,:g]]
    When I calculate the cleanup distance for box 1 of stack 1
    Then the score for that box should be 3
  
  Scenario: count all moved blocks and replaced blocks
    Given the target is [[:g, :r, :r, :r]]
    And the observed is [[:r, :r, :r, :g]]
    When I calculate the cleanup distance for box 1 of stack 1
    Then the score for that box should be 5
  
  Scenario: count minimum total moves when choosing a replacement
    Given the target is [[:g, :r, :r, :r], [:b, :b], [:g, :y, :y, :y]]
    And the observed is [[:b, :r, :r, :r], [:g, :b], [:g, :y, :y, :y]]
    When I calculate the cleanup distance for box 1 of stack 1
    Then the score for that box should be 6
  
  Scenario: keep track of replaced supporting blocks
    Given the target is [[:r, :r, :b], []]
    And the observed is [[:r], [:b, :r]]
    When I calculate the cleanup distance for box 3 of stack 1
    Then the score for that box should be 4
  
  Scenario: count every block moved
    Given the target is [[:y, :y, :y, :r], [:b, :b]]
    And the observed is [[], [:y, :y, :y, :r, :b, :b]]
    When I calculate the cleanup distance for box 4 of stack 1
    Then the score for that box should be 8
  
  Scenario: don't double-count shifting blocks in same stack
    Given the target is [[:r, :r, :r, :r, :b, :r]]
    And the observed is [[:b, :r, :r, :r, :r, :r]]
    When I calculate the cleanup distance for box 5 of stack 1
    Then the score for that box should be 11
    
    Given the target is [[:r, :r, :b, :r, :r]]
    And the observed is [[:b, :r, :r, :r, :r]]
    When I calculate the cleanup distance for box 3 of stack 1
    Then the score for that box should be 8
    
  Scenario: ensure a floating block has enough support
    Given the target is [[:r, :r, :r, :b], []]
    And the observed is [[:r], [:r, :b, :r]]
    When I calculate the cleanup distance for box 4 of stack 1
    Then the score for that box should be 6
  
  
  
    
  
  Scenario: score for a stack sums error for each crate 
    Given the target is [[:r, :r, :r, :r, :b, :r]]
    And the observed is [[:b, :r, :r, :r, :r, :r]]
    When I calculate the cleanup distance for stack 1
    Then the score for that stack should be 18
  
  Scenario: score for a stack counts cost to remove extra stuff 
    Given the target is [[], [:r, :r, :r, :r, :b, :r]]
    And the observed is [[:r, :r, :r, :r, :b, :r], []]
    When I calculate the cleanup distance for stack 1
    Then the score for that stack should be 21
  
  Scenario: stack score should be sum of box scores (plus extra charge)
    Given the target is [[:y, :y, :y, :r], [:b, :b]]
    And the observed is [[], [:y, :y, :y, :r, :b, :b]]
    When I calculate the cleanup distance for box 1 of stack 1
    Then the score for that box should be 5
    
    When I calculate the cleanup distance for box 2 of stack 1
    Then the score for that box should be 6
    
    When I calculate the cleanup distance for box 3 of stack 1
    Then the score for that box should be 7
    
    When I calculate the cleanup distance for box 4 of stack 1
    Then the score for that box should be 8
    
    When I calculate the cleanup distance for stack 1
    Then the score for that stack should be 26
    
    When I calculate the cleanup distance for stack 2
    Then the score for that stack should be 23
  
  
  Scenario: full setup scoring should add all stack scores
    Given the target is [[:y, :y, :y, :r], [:b, :b]]
    And the observed is [[], [:y, :y, :y, :r, :b, :b]]
    When I calculate the cleanup distance
    Then the score should be 49
    
  Scenario: the "distance" is not necessarily symmetric
    Given the target is [[], [:y, :y, :y, :r, :b, :b]]
    And the observed is [[:y, :y, :y, :r], [:b, :b]]
    When I calculate the cleanup distance for stack 1
    Then the score for that stack should be 10
    
    When I calculate the cleanup distance for stack 2
    Then the score for that stack should be 27
    
    When I calculate the cleanup distance
    Then the score should be 37
  
  
  Scenario: it should provide a numeric answer for arbitrary rearrangements
    Given I have 100 arbitrary target:objective pairs with 5 stacks and 5 crates each
    When I calculate the cleanup distance for the random pairs
    Then the score should be a numerical value
  
  
