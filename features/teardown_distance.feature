Feature: Teardown distance
  In order to compare different arrangements of stacked blocks
  As a Cargo-Bot simulator
  I want a metric that wipes out error and counts replacements

  Scenario: the teardown distance between two identical stacks is 0
    Given the target is [[:r, :g, :b, :y]]
    And the observed is [[:r, :g, :b, :y]]
    When I calculate the teardown distance
    Then the score should be 0
    
    Given the target is [[]]
    And the observed is [[]]
    When I calculate the teardown distance
    Then the score should be 0
    
    
  Scenario: the teardown distance between stacks with mismatched tops is 1
    Given the target is [[:r, :g, :b, :y], [:r, :x]]
    And the observed is [[:r, :g, :b, :x], [:r, :y]]
    When I calculate the teardown distance
    Then the score should be 2
    
    
  Scenario: td for a stack with a mismatched bottom is the stack height
    Given the target is [[:r, :g, :b, :y], [:r, :x]]
    And the observed is [[:x, :g, :b, :y], [:r, :r]]
    When I calculate the teardown distance
    Then the score should be 5
    
    
  Scenario: td for misplaced boxes should be the number removed, not replaced
    Given the target is [[:r, :b, :b, :b, :b, :b, :b],[]]
    And the observed is [[:r],[:b, :b, :b, :b, :b, :b]]
    When I calculate the teardown distance
    Then the score should be 6
    
  Scenario: should sum the teardowns for each stack
    Given the target is [[:r, :r], [:b, :b, :b], [], [:g, :g, :g, :g]]
    And the observed is [[:b, :r], [:b, :b, :g], [:r, :g], [:g, :g]]
    When I calculate the teardown distance
    Then the score should be 5
  
  Scenario: td for unexplained boxes should be 100 each
    Given the target is [[:r]]
    And the observed is [[:r, :b, :b, :b, :b, :b, :b]]
    When I calculate the teardown distance
    Then the score should be 600

  Scenario: td for missing boxes should be 100 each
    Given the target is [[:r, :b, :b, :b, :b, :b, :b]]
    And the observed is [[:r]]
    When I calculate the teardown distance
    Then the score should be 606
  