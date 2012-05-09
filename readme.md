# Cargo-Bot emulator

The point of this project is to provide an evaluator for machine learning algorithms searching the space of Cargo-Bot problems and their solutions.

## Back-story

Game author Rui Viana and [TwoLivesLeft software](http://twolivesleft.com/) recently released an [excellent puzzle/programming game for iPad, called Cargo-Bot](http://twolivesleft.com/CargoBot/). I recommend it highly as a great little time-waster. More interesting: it's the first game written entirely *on* the iPad.

Yes, *on* the iPad. [Codea](http://twolivesleft.com/Codea/) is an all-iPad scripting and game design system. Very neat.

Meanwhile, I happen to be trying to [write a book on Genetic Programming](http://leanpub.com/pragmaticGP), and the chapter on Conway's Game of Life was just... well, kinda dry for a starter. When my wife showed me Cargo-Bot, I immediately saw how straightforward it would be to make it into a testbed for GP.

Not Rui's game *software*, I mean, but the puzzle itself. After all, you write code in a simple domain-specific language; your program is graded on how well it performs, how many tokens it uses, and whether it obeys the constraints.

So what I've done (with Rui's permission) is build this little emulator that *implements* Cargo-Bot's algorithm in Ruby.

Nothing fancy: no graphics, no special learning algorithms, nothing you couldn't do in a couple of hours yourself, having played his elegant but interesting little puzzle-game.

## Creating and activating a CargoBot instance

As far as I can tell, all the game's mechanics are captured here, with arguments and instance variables controlling the behavior and state of the bot's execution:

`CargoBot.new("script")` is the basic call to create an instance

### Scripting language

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

### Execution

`CargoBot.activate` places the execution pointer at the first token of the first subroutine, executes it, and moves on. When a `call` token is interpreted, the current pointer is saved in a call stack, and the pointer jumps  to the first token in the called subroutine. When the last token in a called subroutine is executed, the call stack is popped to reset the execution pointer to just after the `call`.

### Termination conditions

1. If the pointer reaches the last token of the root subroutine, the program terminates.
1. Infinite loops are of course possible. A step counter limits the number of tokens interpreted.
1. If the CargoBot's `stacks` of boxes match the `target` at any point in execution, it halts.
1. *If the `fragile_claw` flag is set*, and the claw tries to leave the "box" at any point during execution, it breaks and the program halts immediately.
1. *If the `fragile_stacks` flag is set*, and the claw tries to enter a position where a stack is higher than the `height_limit`, the stack topples and the program halts immediately.

### Extensions

As you may have noticed, there are a few extensions of the `CargoBot` class compared with the implementation in Rui's game.

- The `fragile_claw` argument determines whether the claw will crash into a wall, or merely "bump" and stay where it is. The instance variable `CargoBot#crashes` records the number of crashes if the flag isn't set.
- The `fragile_stacks` toggle determines whether there's a height limit on stacks. If it's set, and the claw tries to enter a position where a stack is at (or over) the `CargoBot#height_limit`, execution ends. Otherwise, the variable `CargoBot#topples` records the number of times this constraint is violated.
- There is no *explicit* limit on the number of subroutines or tokens in each one
- Any symbol can be used as a block 'color' except `:any` or `none`. Any filtered instructions do simple string-matching to trigger, so the token `R_red` will only ever fire if the claw is holding a `:red` block, not a `:r` or some other one
- Infinite loops are cut off at the `CargoBot#step_limit`
- The running `CargoBot` instance records the number of `steps` (tokens interpreted), `moves` (L, R and claw moves only), `crashes`, `topples`
- Any `CargoBot` created without a `#target` has a *very*unlikely target set as a default; it probably won't ever end successfully
