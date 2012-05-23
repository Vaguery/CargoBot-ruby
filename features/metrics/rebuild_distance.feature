Feature: Rebuild distance
  In order to evaluate a stack of crates resulting from sorting
  As a Cargo-Bot simulator
  I want to measure the distance blocks are from where they're wanted

  Scenario: rebuild distance is number of blocks for correct solution
    Given the target is [[:r, :g, :b]]
    And the observed is [[:r, :g, :b]]
    When I calculate the rebuild distance
    Then the score should be 0

  Scenario: rd counts 'extra reaching' needed to reconstruct target from observed
    Given the target is [[:r, :r, :r, :g, :b]]
    And the observed is [[:r, :b, :r, :r, :g]]
    When I calculate the rebuild distance
    Then the score should be 3
    
  Scenario: rd counts 'extra reaching' needed to reconstruct target from observed
    Given the target is [[:r, :r, :g, :b], []]
    And the observed is [[:r, :r], [:g, :b]]
    When I calculate the rebuild distance
    Then the score should be 2
    
  Scenario: rd counts 'extra reaching' needed to reconstruct target from observed
    Given the target is [[], [:r, :r, :g, :b]]
    And the observed is [[:r, :r], [:g, :b]]
    When I calculate the rebuild distance
    Then the score should be 2
  
  Scenario: rd counts 'extra reaching' needed to reconstruct target from observed
    Given the target is [[:g],[:g],[:g],[:g],[:g],[:g]]
    And the observed is [[:g,:g,:g,:g,:g,:g],[],[],[],[],[]]
    When I calculate the rebuild distance
    Then the score should be 15
    
  Scenario: rd should rebuild using leftmost available blocks
    Given the target is [[:r, :r, :r], [:g, :g, :g], [:b, :b, :b]]
    And the observed is [[:r, :g, :b], [:r, :g, :g], [:b, :r, :b]]
    When I calculate the rebuild distance
    Then the score should be 7
    
  Scenario: rd should count 100 points for every missing block
    Given the target is [[:r, :r, :r]]
    And the observed is [[:r, :r]]
    When I calculate the rebuild distance
    Then the score should be 100
    
  Scenario: rd should count 100 points for every extra block
    Given the target is [[:r]]
    And the observed is [[:r, :g, :b]]
    When I calculate the rebuild distance
    Then the score should be 200
