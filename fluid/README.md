# Fluid Apps

[**Fluid** apps](http://fluidapp.com) are wonderful single-site-browser
applications that wrap up a website as a standalone Mac application. The
**Fluid** application itself is not at all scriptable, so there is no good way
to automate the creation and installation of these applications. The best
solution is to copy each app from the old machine to the new machine.

There are three `rake` tasks for working with Fluid apps:

* `fluid:install` - Install missing Fliud apps and their preferences
* `fliud:backup` - Backup Fluid apps to iCloud Drive
* `fliud:clobber` - Delete all backup files from iCloud Drive

The rake tasks use iCloud Drive to store copies of the Fluid apps themselves and
the preferences files for each Fluid app. I went with iCloud Drive since it is
the lowest common denominator for online storage on the Mac platform, and it is
guaranteed to be setup on a new machine after the initial configuration.

These `rake` tasks rely on the Fluid apps being explicitly enumerated. Here is
my current list of Fluid apps.

* Coursera
* GitHub Mail
* Gmail
* Google Voice
* Instapaper
* Mint
* Pivotal Tracker
* Trello

