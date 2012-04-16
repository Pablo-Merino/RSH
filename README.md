# RSH

#### What is RSH?
RSH is a UNIX and SH compliant shell built in Ruby. It features all the traditional Shell commands (basically anything in the `$PATH`) and evaluating ruby code:

- `eval puts "some ruby code can be put here"`

This is in alpha stage, it might contain bugs (it was built in a few hours :P)

#### How do I start it?

It's simple, get on Terminal, `cd` to he directory and run `ruby s.rb`. Your terminal screen will clear and the RSH prompt will appear.

#### How do I kill it?

If you didn't enabled debug mode just use `quit`. Else just use Ctrl-C.

If this doesn't works, open a new window and use `killall ruby`. That should kill it.

#### More info

- It doesn't needs any gems for now
- It uses [Colorize](https://github.com/fazibear/colorize) by [fazibear](https://github.com/fazibear/) but slighty modified for bright (bold) letters.- 
- It has a little config file (`.rsh`) in the script directory. It contains the version and the state of debug mode. (Debug mode shows the command and the arguments on every enter and makes it so you can Ctrl-C and quit it.)
- It has been only tested on Mac OS X Lion 10.7.3 and Ruby 1.9.3-p125