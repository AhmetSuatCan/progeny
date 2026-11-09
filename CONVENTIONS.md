# Conventions

Write once, follow forever.

## Naming

| What | Style | Example |
|---|---|---|
| Files & folders | `snake_case` | `player_movement.gd`, `scenes/test_room.tscn` |
| Nodes & classes | `PascalCase` | `PlayerBody`, `class_name GeneLoom` |
| Variables & functions | `snake_case` | `max_speed`, `apply_gravity()` |
| Constants | `SCREAMING_SNAKE_CASE` | `MAX_HEALTH` |
| Input actions | `snake_case` verbs | `move_left`, `jump` |

## Exported tuning variables

- Group them with `@export_group("Name")` so they're easy to find in the inspector.
- Give each a trailing comment with its unit and what it feels like to change it.

```gdscript
@export_group("Horizontal")
@export var max_speed: float = 150.0       # px/s top speed
@export var acceleration: float = 1000.0   # px/s^2 when pushing toward the input direction
```

## Input

- Define actions by name in Project Settings -> Input Map.
- Always reference actions by name in code (`Input.is_action_pressed("jump")`). Never hardcode keys.

## Folders

- `scenes/` — `.tscn` files
- `scripts/` — `.gd` files
- `assets/` — models, sprites (incl. `placeholder/`), audio, backgrounds
- `pipeline/` — 3D->2D render tooling, kept separate from game code (has a `.gdignore`, so Godot doesn't import it)
- `docs/` — GDD and design docs

Organized by type for now; expect a reorganization by feature in Phase 2.

## Git

- Commit early, commit often. Never leave the build broken more than a day.
- Commit `*.uid` and `*.import` files; never commit `.godot/`.
