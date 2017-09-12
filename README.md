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

## Bootstrapping a New Machine

Download the `strap` script:

```
curl -s -XGET 'https://raw.githubusercontent.com/TwP/dotfiles/master/script/strap' > strap
```

Run the `strap` script:

```
chmod 755 strap
./strap
```

This will download dotfiles, symlink files into place, install homebrew, and
install apps from the Brewfile. The next step is to apply default MacOS settings
to the machine:

```
cd ~/.dotfiles
macos/setup
```

After this step you will need to reboot the machine for all of these new
settings to be applied.

After the machine has rebooted it is time to finish installing all the other
things:

```
cd ~/.dotfiles
rake secrets:install vim:install docker:install fluid:install launchbar:install
rake install
```

Now it is time to go and apply license files and log back in to all the
applications. Enjoy the new machine!

### Messages

Here is how you can preserve your **Messages** history when upgrading to a new
machine. Copy the `~/Library/Messages` folder from the old machine to the new
machine. Viola - you're done. Just make sure that the **Messages** app is not
running on either machine when you copy the folder.

