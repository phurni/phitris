# PHITRIS

![tetrominos](http://upload.wikimedia.org/wikipedia/commons/thumb/5/50/All_5_free_tetrominoes.svg/200px-All_5_free_tetrominoes.svg.png)

A Tetris clone written in Ruby with the Gosu and Chingu libraries.

It aims to be as concise as possible with a maximum of **Ruby idioms** but still be easily extendable.

Copyright (C) 2014-2015 Pascal Hurni <[https://github.com/phurni](https://github.com/phurni)>

Licensed under the [MIT License](http://opensource.org/licenses/MIT).


## Pluggable behaviours

As Tetris has several variants, I chose to let all those different behaviours be easily plugged-in or out.

Pluggable behaviours (✔ Implemented, ✘ Not implemented):

 - Rotators
  - ✔ [SRS](http://tetris.wikia.com/wiki/SRS)
  - ✘ [DTET](http://tetris.wikia.com/wiki/DTET)
 - Randomizers
  - ✔ [Random Generator](http://tetris.wikia.com/wiki/Random_Generator)
  - ✘ [TGM](http://tetris.wikia.com/wiki/TGM_randomizer)
 - Line clearers
  - ✔ [Naive](http://tetris.wikia.com/wiki/Line_clear#Naive)
  - ✘ [Sticky](http://tetris.wikia.com/wiki/Line_clear#Sticky)
  - ✘ [Cascade](http://tetris.wikia.com/wiki/Line_clear#Cascade)

**Plug your own, fork me**


## Customization

All game graphics and position may be customized through a YAML config file.

Running the game with the following command line will use pre-defined configuration

    ruby main.rb
    
Try running the game by passing a config file:

    ruby main.rb phitris_example.yml

**Enjoy!**


## To Do

- The board internal representation of the playfield matrix should not be exposed
  to the pluggables. Refactor this.
  
- Implement a real Welcome screen

- Implement a configuration screen

- Add SFX
