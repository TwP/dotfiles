# Dot Files

Dot files managed by [chezmoi](https://www.chezmoi.io) for all the machines.

## Bootstrapping a New Machine

Install Homebrew and 1Password

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

```sh
brew install --cask 1password
brew install --cask 1password-cli
```

Sign into your 1Password account and enable the SSH agent and CLI integration.

Install chezmoi and apply the configuration.

```sh
brew install chezmoi
chezmoi init --apply https://github.com/TwP/dotfiles.git
chezmoi get -- remote set-url origin git@github.com:TwP/dotfiles.git
```

Only on a work machine - this configure the upstream to use an alias that is
configured in ~/.ssh with work specific signing keys and git fetch keys.

```sh
chezmoi git -- remote set-url origin git@github-dotfiles:TwP/dotfiles.git
```

### Messages

Here is how you can preserve your **Messages** history when upgrading to a new
machine. Copy the `~/Library/Messages` folder from the old machine to the new
machine. Viola - you're done. Just make sure that the **Messages** app is not
running on either machine when you copy the folder.

## 🔁 Daily Workflow

| Task | Command |
| --- | --- |
| Edit a managed file | `chezmoi edit --apply ~/.FILE` |
| Edited the target directly (non-template) | `chezmoi re-add ~/.FILE` |
| See pending changes | `chezmoi status` / `chezmoi diff` |
| Commit and push | `chezmoi push` |
| Pull and apply on the other laptop | `chezmoi update` (pulls with rebase and autostash) |
| Add a new file | `chezmoi add ~/.FILE` |
| Stop managing a file | `chezmoi forget ~/.FILE` |
| Inspect template data | `chezmoi data` |
| Merge a conflict between source and target | `chezmoi merge ~/.FILE` |

## 🧯 Troubleshooting

- **`config file template has changed`**: run `chezmoi init` on that machine.
- **`op` errors during apply**: unlock 1Password. Check `op account list` and the `opAccount` value in `chezmoi data`.
- **Push from work is denied**: `ssh -T git@github-dotfiles` should reply `Hi TwP/dotfiles!`. If it says `Hi work_account!`, the alias isn't using `IdentitiesOnly yes` with `dotfiles_deploy.pub`.
- **Commit shows "Unverified" from work**: check `git config user.email` and `git config user.signingkey` inside `~/.local/share/chezmoi`. They must be the personal email and the dotfiles signing key, and the key must be registered on `twp` as a *Signing Key*.
- **chezmoi asks before overwriting a file it didn't write**: run `chezmoi diff ~/.FILE` first. This is expected the first time a symlink is replaced.
