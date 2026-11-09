# progeny

2D side-view platformer in **Godot 4.7 / GDScript**. Currently in **Phase 0**: a tunable, hardcoded movement capsule in an empty two-level test room. The full brief is in `initial.md`; naming and style rules are in `CONVENTIONS.md`.

## The rule for this phase

**Build less structure than feels right.** Game feel is found by fast, messy iteration.
- One `CharacterBody2D`, one script (`scripts/player.gd`). Hardcode things. Ugly is fine. The camera has its own tiny script (`scripts/camera.gd`).
- **Do NOT build:** state machines, component/entity systems, input abstraction layers, controller frameworks, or any architecture. Real architecture comes in Phase 2.
- **Out of scope:** attack/combat/Neural Overload, enemies, second/third body, Gene Loom/Cauls/breeding/lineage, real art (grey placeholders only), 3D-to-sprite pipeline work.

## Build order (no skipping; the user tunes by feel between steps)

1. [x] Horizontal movement only (accel / decel / turn-around)
2. [x] Jump: bare height + gravity (single `gravity`, no forgivenesses)
3. [x] Forgivenesses, **one per sitting**:
   - [x] variable jump height (`jump_cut`: not holding jump while rising multiplies upward velocity, once per jump via `can_cut`)
   - [x] asymmetric gravity (`gravity_up` / `gravity_down`, plus `max_fall_speed` cap)
   - [x] coyote time (`coyote_time`)
   - [x] jump buffering (`jump_buffer`; a buffered tap released before landing still gives a hop)
4. [x] Camera2D: simple follow, light smoothing, a little look-ahead (`scripts/camera.gd`, child of Player in main.tscn; limits = room edges)
5. [ ] **The gate** (user's job): the ten-minute test below

**Gate:** ten minutes of moving around the empty room is quietly satisfying. Don't move past Phase 0 until the user says so.

Add only the next step when asked. Don't jump ahead. Keep the step list above up to date.

## Project facts

- Base resolution 640x360, `viewport` stretch, `keep` aspect, integer scaling, window 1280x720, nearest texture filter. Movement values are sized for this resolution. Physics interpolation is on (smooth on high-refresh monitors).
- Input actions (always use them by name): `move_left` (A / Left / D-pad / left stick), `move_right` (D / Right / D-pad / left stick), `jump` (Space / W / Up / gamepad A).
- Main scene: `scenes/main.tscn`. Room is 1920x360 (3 screens). Floor top at y=340, walls at x 0-10 and 1910-1920. Two levels: low platforms top y=285, high platforms top y=225, all 120 wide, in pairs with 50px gaps: Low 140-260 / High 310-430, Low2 760-880 / High2 930-1050, High3 1380-1500 / Low3 1550-1670 (mirrored). Max horizontal air reach low->high is ~80px at current values. Player capsule is 14x28.
- All tuning values are `@export` vars grouped with `@export_group` and commented with units.

## Commands

```sh
godot --path . --editor                       # open the editor
godot --path .                                # run the game
godot --headless --path . --import            # reimport; also generates .uid files
godot --headless --path . --check-only --script scripts/player.gd   # parse-check a script
godot --headless --path . --quit-after 120    # run ~2s headless; look for errors
```

Editing `.tscn` / `project.godot` by hand is fine for structural changes. Leave tuning values to the user in the inspector.
