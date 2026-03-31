# SO THAT I DO NOT FORGET (yeah, right...)
- stow -d ~/Documents/development/src/github.com/ful09003/dots/ -t . <name>, where <name> is the dir to add (reminder: run that from the root dir where I want symlinks!)
- stow -Dd to remove

# Per-thing notes

## Emacs -> `~/.emacs.mine.d`

And then used in a user-local SystemD desktop file like so:

```text
[Desktop Entry]
Name=Emacs (Mine)
GenericName=Text Editor
Comment=Emacs, with my own config
MimeType=text/english;text/plain;text/x-makefile;text/x-c++hdr;text/x-c++src;text/x-chdr;text/x-csrc;text/x-java;text/x-moc;text/x-pascal;text/x-tcl;text/x-tex;application/x-shellscript;text/x-c;text/x-c++;
Exec=emacs --init-dir ~/.emacs.mine.d %f
Icon=emacs
Type=Application
Terminal=false
Categories=Utility;TextEditor;
```

## Claude Code -> `~/.claude/`

https://unsloth.ai/docs/basics/claude-code#fixing-90-slower-inference-in-claude-code

Some other settings like enabled plugins are a result of not version-controlling
until after doing some local work.
