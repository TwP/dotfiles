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

### Fonts

Open up the **FontBook** application and select the `User` menu on the left.
This is the list of all the fonts you have installed on your system. If you
right-click on one of the font names you can select the "Show in Finder" option.
This will bring up a **Finder** window showing all the `.ttf` and `.otf` font
files you have previously installed.

Copy these files to your new machine (or put them on a shared drive). On the new
machine import the fonts using the **FontBook** application there. You can
import fonts by selecting the "Add Fonts..." submenu under the main "File" menu
of **FontBook**.

### Fluid Apps

[**Fluid** apps](http://fluidapp.com) are wonderfuil single-site-browser
applications that wrap up a website as a standalone Mac application. The
**Fluid** application itself is not at all scriptable, so there is no good way
to automate the creation and installation of these applications. The best
solution is to copy each app from the old machine to the new machine.

* Coursera
* GitHub Mail
* Gmail
* Google Voice
* Instapaper
* Mint
* Pivotal Tracker
* Trello

Along with the apps themselves, we'll also need to copy over the preferences
fils for each app. The preferences contain all the window preferences and browsa
plugin settings.

* `~/Library/Preferences/com.fluidapp.FluidApp.Coursera.plist`
* `~/Library/Preferences/com.fluidapp.FluidApp.GitHub Mail.plist`
* `~/Library/Preferences/com.fluidapp.FluidApp.Gmail.plist`
* `~/Library/Preferences/com.fluidapp.FluidApp.Google Voice.plist`
* `~/Library/Preferences/com.fluidapp.FluidApp.Instapaper.plist`
* `~/Library/Preferences/com.fluidapp.FluidApp.Mint.plist`
* `~/Library/Preferences/com.fluidapp.FluidApp.Pivotal Tracker.plist`
* `~/Library/Preferences/com.fluidapp.FluidApp.Trello.plist`

### Messages

Here is how you can preserve your **Messages** history when upgrading to a new
machine. Copy the `~/Library/Messages` folder from the old machine to the new
machine. Viola - you're done. Just make sure that the **Messages** app is not
running on either machine when you copy the folder.

### SSH Configuration

You know where your keys are hidden. Go find them and install them in `~/.ssh`
and then you can play on the internet again.

