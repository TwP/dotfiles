# Setec Astronomy

The goal of "secrets" is to keep files accessible in iCloud Drive but safe from
prying eyes. We use an encrypted disk image stored in iCloud Drive to safely
keep backups of any secrets that are not suitable for storage in a git
repository.

### How Does It Work

At the heart of "secrets" is an encrypted disk image called `secrets.dmg` that
lives out on your iCloud Drive. This disk image is mounted as `/Volumes/Secrets`,
and any secret files you want to keep safe can be copied there. You can use this
volume for storing a copy of your SSH keys, your AWS access tokens for the
`aws-cli` tool, or your GitHub authentication token for Homebrew.

When the encrypted disk image is first created you are asked for a password to
secure the data. Each time you mount the disk image you will need this password
to decrypt the contents of the disk image. If you lose the password, then the
data in the disk image will be lost forever.

The advantage of using iCloud Drive is that your secrets will be available on
any MacOS computer you use. When you get a new machine, all your data will be
ready and waiting for you after you log into iCloud.

### Using Secrets

Secrets are managed via Ruby rake tasks. The rake tasks will create the
encrypted disk image if it does not exist, backup your secret files to the disk
image, and restore those secret files from the disk image.

To backup your secrets:

```sh
rake secrets:backup
```

To restore your secrets:

```sh
rake secrets:install
```

To remove the encrypted disk image from iCloud Drive:

```sh
rake secrets:clobber
```

You can define what gets backed up to the encrypted disk image by editing the
`FILES` list at the top of the `secrets.rake` file. The `FILES` list is a Ruby
Hash that maps a folder in the encrypted disk image to a local source folder and glob
pattern.

```ruby
FILES = {
  "ssh" => {
    local: "~/.ssh",
    glob:  "*"
  }
}
```

When a backup is performed, all files in the `:local` folder that match the
`:glob` patterns will be copied to the encrypted disk image. The `FILES` hash
key is used as the folder name in the disk image where the local files will be
copied to. In our example above all the files in your `~/.ssh` folder will be
backed up to the `/Volumes/Secrets/ssh` folder in the encrypted disk image.

Conversely, when an install is performed, all files in the encrypted disk image
folder will be copied to the `:local` folder. In our example above, all the
files in the `/Volumes/Secrets/ssh` folder will be installed to your local
`~/.ssh` folder.

The backup and install tasks are idempotent. The modification time of the files
are used to determine if a file needs to be copied or not. All paths will be
created if they do not already exist.

### About Encrypted Disk Images

Secrets relies on the `hdiutil` command line tool to create and manage the
encrypted disk image.

We create the encrypted disk image using AES 256 bit encryption and Journaled
HFS file system. The disk image is 10 MB in size - so if you are storing secrets
larger than this you will need to adjust the size accordingly. You can also
create a sparsebundle which will grow and shrink in size as required. I've not
fully tested sparsebundles on iCloud Drive - an interruption in synchronization
might corrupt the sparsebundle as some bands in the sparsebundle might be out of
sync if iCloud Drive synchronization fails.

```sh
hdiutil create         \
  -type UDIF           \
  -encryption AES-256  \
  -size 10m            \
  -fs "Journaled HFS+" \
  -volname "Secrets"   \
  -attach              \
  "${ICLOUD_DRIVE}/secrets.dmg"
```

Mounting the encrypted disk image is straightforward. You will be asked to type
in the password used when the image was created. Again, don't forget this
password otherwise all data in the encrypted disk image will be lost.

```sh
hdiutil attach "${ICLOUD_DRIVE}/secrets.dmg"
```

Un-mounting the volume is also straightforward.

```sh
hdiutil detach /Volumes/Secrets
```

What is this `ICLOUD_DRIVE` environment variable? This is something I've put in
my bash environment to make it simpler to work with documents in iCloud Drive
when using the command line. It is defined thusly:

```sh
export ICLOUD_DRIVE="$HOME/Library/Mobile Documents/com~apple~CloudDocs"
```

It is a bit of an odd location - hence the environment variable.

