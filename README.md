# chezmoi config

## 🔁 Daily Workflow

| Task | Command |
| --- | --- |
| Edit a managed file | `chezmoi edit --apply ~/.FILE` |
| Edited the target directly (non-template) | `chezmoi re-add ~/.FILE` |
| See pending changes | `chezmoi status` / `chezmoi diff` |
| Commit and push | `chezmoi cd` → `git add -A && git commit && git push` |
| Pull and apply on the other laptop | `chezmoi update` (pulls with rebase and autostash) |
| Add a new file | `chezmoi add ~/.FILE` |
| Stop managing a file | `chezmoi forget ~/.FILE` |
| Inspect template data | `chezmoi data` |
| Merge a conflict between source and target | `chezmoi merge ~/.FILE` |

## 🧯 Troubleshooting

- **`config file template has changed`**: run `chezmoi init` on that machine.
- **`op` errors during apply**: unlock 1Password. Check `op account list` and the `opAccount` value in `chezmoi data`.
- **Push from Gelion is denied**: `ssh -T git@github-dotfiles` should reply `Hi TwP/dotfiles!`. If it says `Hi ionq_timpease!`, the alias isn't using `IdentitiesOnly yes` with `dotfiles_deploy.pub`.
- **Commit shows "Unverified" from Gelion**: check `git config user.email` and `git config user.signingkey` inside `~/.local/share/chezmoi`. They must be the personal email and the dotfiles signing key, and the key must be registered on `twp` as a *Signing Key*.
- **chezmoi asks before overwriting a file it didn't write**: run `chezmoi diff ~/.FILE` first. This is expected the first time a symlink is replaced.
