# Cargo-Bot emulator

The point of this project is to provide an evaluator for machine learning algorithms searching the space of Cargo-Bot problems and their solutions.

## Back-story

Game author Rui Viana and [TwoLivesLeft software](http://twolivesleft.com/) recently released an [excellent puzzle/programming game for iPad, called Cargo-Bot](http://twolivesleft.com/CargoBot/). I recommend it highly as a great little time-waster. More interesting: it's the first game written entirely *on* the iPad.

Yes, *on* the iPad. [Codea](http://twolivesleft.com/Codea/) is an all-iPad scripting and game design system. Very neat.

Meanwhile, I happen to be trying to [write a book on Genetic Programming](http://leanpub.com/pragmaticGP), and the chapter on Conway's Game of Life was just... well, kinda dry for a starter. When my wife showed me Cargo-Bot, I immediately saw how straightforward it would be to make it into a testbed for GP.

Not Rui's game *software*, I mean, but the puzzle itself. After all, you write code in a simple domain-specific language; your program is graded on how well it performs, how many tokens it uses, and whether it obeys the constraints.

So what I've done (with Rui's permission) is build this little emulator that *implements* Cargo-Bot's algorithm in Ruby.

Nothing fancy: no graphics, no special learning algorithms, nothing you couldn't do in a couple of hours yourself, having played his elegant but interesting little puzzle-game.

## Simulating Cargo-bot dynamics

### Parsing CargoBot scripts into structured programs

CargoBot scripts in this program are a single string. Tokens recognized by the CargoBot class include:
- `R`, `L` move the claw right or left one position
- `R_any`, `L_any` move the claw only if it has a box in it
- `R_none`, `L_none` move the claw only if it has no box
- `R_[color]`, `L_[color]` move the claw only if it has a box whose identifier is `[color]` (see below)
- `claw` activates the claw; if it's empty, it tries to pick up a box; if it's holding something, it puts it down
- `claw_any` only if it has a box
- `claw_none` only if it is empty
- `claw_[color]` only if it is holding that `[color]` box
- `call[N]` jump execution of the script to subroutine `[N]`, returning to the next register of the *calling* subroutine when done

There is also a special parser-control token:
- `prog_[N]` subsequent tokens are appended to subroutine `[N]`. The initial subroutine is 1; if the parser is asked to append tokens to a subroutine whose number doesn't already exist, it is created, and all missing subroutines are created as well. Subsequent calls to `prog_[N]`  return the parser's attention to that subroutine.

For example, parsing the script `R prog_4 L_red claw call3 prog_2 claw prog_1 R_any call2` would result in the following CargoBot program:

    subroutine 1: [:R, :R-any, :call2]
    subroutine 2: [:claw]
    subroutine 3: []
    subroutine 4: [:L_red, :claw, :call3]

Any other token not mentioned here will be placed in a subroutine, but ignored when interpreted.

### Stacks of Boxes

In Cargo-bot (the puzzle game), a single claw is controlled by your Program so that it moves left and right among a discrete and finite set of positions, each located above a pile of boxes of various colors. The claw can lift one box at a time, shift it left or right, and place it on top of a stack at its current position.

In this `CargoBot` representation, the available positions in the "dock" are represented as a simple Array, containing Arrays representing "stacks", containing boxes represented as Symbols naming their color. These are used for initial setup of a puzzle condition, internal representation of dynamic state, and storing the puzzle's goal.

For example, to set up a "factory" with six stacks, where stack 3 contains three blue and stack 4 two red boxes, you can use the Ruby code

    [[], [], [:b, :b, :b], [:r, :r], [], []]
    
I'll refer to the left stack as "stack 1", and the left/first item on a stack as being on the "bottom" (following the Ruby idiom of `Array#push` and `Array#pop` affecting the rightmost items on Array objects).

### Program Execution

The method `CargoBot#activate` resets various counters (used for evaluating the performance of a program) and flags, then operates *every simply*:

1. all the tokens in subroutine 1 are pushed onto the top of the **execution stack**
2. until a termination condition is achieved (see below), one token is popped from the execution stack and interpreted; if the token is a `call[N]` token, then every token in subroutine `N` is pushed immediately onto the execution stack; otherwise, the claw is moved and the state of the bot is updated accordingly

### Termination conditions

1. If the execution stack is empty, the program terminates.
1. Infinite loops are of course possible. A step counter limits the number of tokens interpreted (default=200).
1. If the CargoBot's `stacks` of boxes match its `goal` after any step, execution halts.
1. *If the `fragile` flag is set*, and the claw tries to leave the "box" at any point during execution, it breaks, and the program halts immediately.
1. *If the `unstable` flag is set*, and the claw tries to enter a position where a stack is higher than the `height_limit`, the stack topples and the program halts immediately.

### Differences from the iPad game

As you may have noticed, there are a few extensions of the `CargoBot` class compared with the implementation in Rui's game.

- The `fragile` flag determines whether the claw will crash into a wall, or merely "bump" and stay where it is. The instance variable `CargoBot#crashes` records the number of crashes if the flag isn't set.
- The `unstable` flag determines whether there's a height limit on stacks. If it's set, and the claw tries to enter a position where a stack is at (or over) the `CargoBot#height_limit`, execution ends. Otherwise, the variable `CargoBot#topples` records the number of times this constraint is violated.
- There is no *explicit* limit on the number of subroutines or tokens in each one
- Any symbol can be used as a block 'color' except `:any` or `none`. Any filtered instructions do simple string-matching to trigger, so the token `R_red` will only ever fire if the claw is holding a `:red` block, not one labeled `:r` 
- Infinite loops are cut off by `CargoBot#step_limit`
- The running `CargoBot` instance records the number of `steps` (tokens interpreted), `moves` (L, R and claw moves only), `crashes`, `topples`
- Any `CargoBot` created without a `#goal` has a *very* unlikely goal set as a default; it probably won't ever end successfully


## Creating and activating a CargoBot instance

As far as I can tell, all the game's mechanics are captured here, with arguments and instance variables controlling the behavior and state of the bot's execution:

`CargoBot.new("script")` is the basic call to create an instance, but it will have no blocks, and a very unlikely `goal`.

Everything but the script itself can be accessed via hash arguments:

- `:stacks` should be set to the initial set of piles of boxes; it should be an Array of Arrays, containing symbols indicating the colors of boxes. The 'top' of a stack is considered to be the last element, as in Ruby's stack-handling Array methods `Array#pop` and `Array#push`.
- `:goal` should also be an Array of Arrays of Symbols. Note that if the boxes in the `goal` don't match the `stacks`, your CargoBot might have a problem finishing the puzzle....
- `:claw_position` is an Integer indicating which stack the claw is above (0-based); default is 0
- `:fragile` is a toggle which determines whether the claw breaks (crashing the CargoBot) when it tries to "leave the box"
- `:unstable` is a toggle which determines whether the machine breaks down when it the claw knocks over a stack of blocks that's too high
- `:height_limit` the maximum height a stack is allowed to get before toppling when the claw bumps it
- `:step_limit` termination condition to avoid loops; defaults to 200

## Evaluating performance

I've included an evaluation method (in a separate class currently called `CrateStacks`) which estimates the number of crates which have to be moved to change an observed arrangement of crates into a target arrangement. This is an intentionally unrealistic heuristic, but (apparently) one useful for search.

## Examples

See http://github.com/Vaguery/CargoBot-ruby/tree/master/examples for some simple calls and demos (TBD). Run [the acceptance test cucumber file](http://github.com/Vaguery/CargoBot-ruby/blob/master/features/acceptance_tests.feature) to check to see that the Cargo-Bot tutorial examples are running.

I've also included a brief (and very kludgy) example that uses (multiobjective) hillclimbing to search for solutions to particular problems. Sometimes it works, sometimes it doesn't; don't treat it as anything but an experiment.

## Quirks

- There may be an inconsistency with the original game's notion of height limits and how they work. In particular, whether a box can be placed "one above" maximum height, as long as the claw "cradles it" and doesn't move away. That is, we know the claw can topple an overheight stack if it approaches from the side; I don't know if there are conditions where a claw is *over* an overheight stack, and will topple it if it moves *away* from it without grabbing the top block....

- It is possible to reach a goal *when a box is still in the claw*. As far as I can tell, this may be possible in the original game as well. So for instance you can make `[[:r, :y], [], []]` into `[[], [:r], []]` and "win".