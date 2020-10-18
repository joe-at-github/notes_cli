# About
Easily create, delete, list and open all your notes.  
NotesCli lets you create workspaces and notebooks in which you can store notes.  
Notes are created as md files for ease of storing code snippets.

# Installation
```bash 
gem install notes_cli
```

# Getting started

Tell notes_cli where your notes will be stored
```bash
notes --notes_folder path/to/where/you/will/store/notes
```

Define your first workspace
```bash
notes -w workspace_name
```

Set your default editor
```bash
notes -e subl
```

# DSL
## Notes folder
Where you will store all notes, including your workspaces and notebooks as the top layers

## Workspace
Where you will store notebooks

## Notebook
Where you will store notes

## Example
Basic case scenario, where:  
- `notes_folder` is where we decided to store notes  
- `personal_projects` and `work` are workspaces  
- `social_media_apps` and `features` are notebooks   
- `twitter_clone.md` and `requirements.md` are notes  

```bash
notes_folder/
├── personal_projects
│   └── social_media_apps
│       └── twitter_clone.md
└── work
    └── features
        └── voice_chat
            └── requirements.md
```

# Usage
## Check
Checking which workspace you are currently in
```bash
notes
'Current workspace is ...'
```

## Create
Create a note in the current workspace
```bash
notes -n notebook note_title
```

Creating a note in a nested notebook
```bash
notes -n path/to/notebook note_title
```
```bash
# e.g
notes -n saving_the_world/doing_charity_work list_of_charities

# will produce
notes_folder/
├── personal_projects
│   ├── saving_the_world
│   │   └── doing_charity_work
│   │       └── list_of_charities.md
│   └── social_media_apps
│       └── twitter_clone.md
└── work
    └── features
        └── voice_chat
            └── requirements.md
```

## Delete
Delete a note
```bash
notes -d notebook note_title
```

## List
Listing all notebooks in your workspace
```bash
notes -l .
```

Listing all notes in a given notebook
```bash
notes -l notebook
```

## Open
Open a notebook in the context of your favourite editor
```bash
notes -o notebook
```

## Switch
Switching workspace
```bash
notes -w workspace_name
```

Switching workspace and creating a note there
```bash
notes -w workspace_name -n notebook note_title
```

## Help
Display available commands

```bash
notes --help
```
