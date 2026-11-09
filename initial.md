# Project Setup — Phase 0 Kickoff

> This brief covers the **initial Godot project setup only**. It stops at a
> tunable, hardcoded movement capsule in an empty test room. Nothing beyond
> that is in scope yet — see "Explicitly NOT doing yet" at the bottom.

---

## The one rule for this phase

**Build less structure than feels right.** Game feel is discovered by fast,
messy iteration, and premature architecture is friction against it. The movement
code should be something you can rewrite in an afternoon, not a system you're
committed to. Real architecture arrives in Phase 2, after the feel is proven and
the second body reveals what actually needs abstracting. For now: folder
hygiene, a few conventions, and one ugly script.

## Win condition for this setup

A grey capsule moves and jumps in an empty two-level room, tuned live via
inspector variables, under version control. Nothing more.

---

## Engine & project

- **Engine:** Godot 4.x (latest stable).
- **Language:** GDScript (fast iteration; no C# until there's a proven reason).
- **Renderer:** Forward+ or Mobile — pick Mobile if targeting lower-end hardware
  later; either is fine now.

## Step 1 — Version control first

- `git init` before anything else. First commit = the empty project.
- Add a Godot `.gitignore`:
  ```
  .godot/
  .import/
  export.cfg
  export_presets.cfg
  *.translation
  ```
- Commit early, commit often. Never leave the build broken more than a day.

## Step 2 — Folder skeleton

Organized by type now (clear for a small project), ready to reorganize by
feature in Phase 2. Keep the **art pipeline separate from game code** — it's a
different project that happens to share the repo.

```
/scenes                   # .tscn scene files
/scripts                  # .gd scripts
/assets
  /models                 # 3D source (.blend, .glb) for the render pipeline
  /sprites                # rendered sprite sheets (output)
  /sprites/placeholder    # grey-box / capsule stand-ins
  /audio
  /backgrounds
/pipeline                 # 3D->2D render tooling — kept SEPARATE from game code
/docs                     # GDD and design docs live in the repo
```

## Step 3 — Conventions (write once, follow forever)

Create `CONVENTIONS.md` with:

- **Files & folders:** `snake_case` (e.g. `player_movement.gd`).
- **Nodes & classes:** `PascalCase` (e.g. `PlayerBody`).
- **Variables & functions:** `snake_case`.
- **Exported tuning vars:** grouped and commented so they're easy to find in the
  inspector.

## Step 4 — Project settings that matter now

- **Base resolution + stretch:** set a fixed base resolution and `viewport`
  stretch mode so sprites/pixels stay crisp. Decide this early — it affects how
  everything reads. (A common starting point: 640x360 or 480x270, scaled up.)
- **Input Map:** define actions **by name** in Project Settings -> Input Map:
  - `move_left`, `move_right`, `jump`
  - (later: `attack`, `swap`, etc. — not now)
  - Always reference actions by name in code; never hardcode keys. This is the
    one abstraction worth having from day one.
- **Main scene:** set `main.tscn` as the entry scene (it just holds the test
  room for now).

## Step 5 — The test room

- `main.tscn` containing:
  - A `StaticBody2D` floor.
  - Two platforms at different heights (to test jump arcs and landings).
  - The player instance.
  - A simple follow `Camera2D` (build this AFTER movement feels good, not before).
- No art. Grey `ColorRect` / placeholder shapes only.

## Step 6 — The movement script (the anti-architecture part)

- **One `CharacterBody2D` with one script.** `player.tscn` + `player.gd`.
- **All tuning values as `@export` variables** so you tune live in the inspector
  without touching code. Example shape (values are placeholders to feel out):

  ```gdscript
  extends CharacterBody2D

  # --- Horizontal ---
  @export var max_speed: float = 300.0
  @export var acceleration: float = 2000.0
  @export var deceleration: float = 2500.0

  # --- Jump (add ONLY after walking feels good) ---
  @export var jump_velocity: float = -400.0
  @export var gravity_up: float = 900.0      # rising
  @export var gravity_down: float = 1400.0   # falling (asymmetric = weighty)
  @export var coyote_time: float = 0.1
  @export var jump_buffer: float = 0.1
  ```

- **Do NOT build:** a state machine, a component/entity system, an input
  abstraction layer, or a "player controller framework." Hardcode it. It will be
  ugly. The ugliness is fast to change, which is the only thing that matters
  while hunting feel.

---

## Build order within this phase (no skipping)

1. **Horizontal movement only.** Tune acceleration / deceleration / turn-around
   by hand until starting and stopping feel intentional. **No jump yet.**
2. **Jump — bare.** Just height and gravity. It will feel floaty and wrong.
3. **Layer the forgivenesses, one per sitting, feeling each:**
   - variable jump height (hold = higher, tap = hop)
   - asymmetric gravity (fall faster than rise)
   - coyote time
   - jump buffering
4. **Camera.** Simple follow with light smoothing, a little look-ahead. Only
   after movement is already good.

## The gate (do not pass until true)

**The ten-minute test:** can you move the capsule around the empty two-level room
for ten minutes and find it quietly satisfying with nothing to do? If no, go back
to the curves and the gravity — it's always the curves and the gravity. Do not
add an attack, an enemy, a second body, art, or architecture until this is yes.

---

## Explicitly NOT doing yet

- No attack, combat, or Neural Overload.
- No enemies.
- No second or third body (fork the proven one later, in Phase 2).
- No Gene Loom, Cauls, breeding, or any lineage system.
- No real art — grey placeholders only.
- No 3D-to-sprite pipeline work (that's the separate background/art track).
- No state machines, component systems, or any architecture framework.

The movement teaches you what to build. Let it. Architecture comes after the
feel is found — never before.
