# Dot Files

My dot files for MacOS based machines.

## Installation

Clone this repository to `$HOME/.dotfiles` and then run `rake` to symlink all
the dot files into place.

Any files with a `.symlink` extension will be symlinked into your home folder
with the extension removed and a leading `.` added. This words for folders, too.
So you can have a `vim.symlink` folder and it will be symlinked to `~/.vim`.
These `.symlink` files can be at any depth in the dot files hierarchy, too.

I've arranged all my dot files into folders grouped by application. So all of my
vim configurations are located in the `vim` folder. This means that my
`vim/vim.symlink` folder lives there as well.

A few folders contain `.rake` files for doing a bit of extra setup. You can find
all the available rake tasks via the `rake -T` command.

## Checklist

Dot files can do a lot, but they can't do everything quite yet. Here are a few
things to remember when moving to a new machine.

### Messages

Here is how you can preserve your **Messages** history when upgrading to a new
machine. Copy the `~/Library/Messages` folder from the old machine to the new
machine. Viola - you're done. Just make sure that the **Messages** app is not
running on either machine when you copy the folder.

### SSH Configuration

You know where your keys are hidden. Go find them and install them in `~/.ssh`
and then you can play on the internet again.

