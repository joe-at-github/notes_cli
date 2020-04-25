homeflow or my_notes are workspaces
my_notes/docker is a notebook
my_notes/docker/intro.md is a note

set your default workspace
```bash
notes -w homeflow
"You're now in homeflow workspace"
```

check which workspace you're in
```bash
notes -w?
```

adding a note
```bash
notes -n notebook 'note name'
```
- should create the notebook if not present
- should create the note in the notebook

adding a note in a subdirectory
```bash
notes -n notebook/subdirectory 'note name'
```