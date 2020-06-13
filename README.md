# Getting started
Set `notes` as an alias to your bash profile.
```bash
alias notes='ruby path/to/notes_cli/notes.rb'
```

Run the inital setup command.
```bash
notes --notes_folder path/to/where/you/will/store/notes
```

Define your first workspace.
```bash
notes -w workspace_name
```

# DSL
## Notes folder
Where you will store all notes, including your workspaces and notebooks as the top layers.

## Workspace
Where you will store notebooks.

## Notebook
Where you will store notes.

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
## Create a note in the current workspace
```bash
notes -n notebook note_title
```

## Switching workspaces
```bash
notes -w workspace_name
```

## Checking which workspace you are currently in
```bash
notes
'Current workspace is ...'
```

## Switching workspace and creating a note there
```bash
notes -w workspace_name -n notebook note_title
```

## Creating a note in a nested notebook
```bash
notes -n path/to/notebook note_title
```
e.g
```bash
notes -n saving_the_world/doing_charity_work list_of_charities
```

will produce
```bash
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
