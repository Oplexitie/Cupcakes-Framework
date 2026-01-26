# CLAUDE.md - AI Assistant Guide for Cupcakes Framework

## Project Overview

**Cupcakes Framework** is a lightweight Five Nights at Freddy's (FNAF) game framework built with Godot 4.5 using GDScript. The project is intentionally minimal, providing only essential features for FNAF-style games without unnecessary complexity.

**Key Philosophy:** The framework avoids features that are easy to implement, unnecessary for FNAF games, or would make the project convoluted.

## Quick Reference

| Item | Value |
|------|-------|
| Engine | Godot 4.5 (GL Compatibility renderer) |
| Language | GDScript |
| Resolution | 1920x1080 (fixed, non-resizable) |
| Main Scene | `res://Scenes/Nights/nights.tscn` |
| License | MIT |

## Running the Project

```bash
# Open in Godot 4.5 and press F5, or run from command line:
godot --path /path/to/project
```

No external dependencies or build steps required - pure GDScript implementation.

## Directory Structure

```
/
├── AnimationTree/          # Animation tree configurations (.tres)
├── Graphics/               # All visual assets
│   ├── CamRooms/          # Camera feed room images
│   ├── HUD/               # UI elements (buttons, maps)
│   ├── Office/            # Office background sprites
│   ├── Static/            # Static effect animation frames
│   └── Tablet/            # Tablet UI animation frames
├── Scenes/
│   └── Nights/
│       └── nights.tscn    # Main game scene
├── Scripts/
│   └── Nights/
│       ├── AI/            # Character AI system
│       │   ├── ai.gd              # Abstract base class
│       │   ├── ai_manager.gd      # AI initialization
│       │   └── Characters/        # Character-specific AI
│       │       ├── red_ai.gd
│       │       └── green_ai.gd
│       ├── Camera/
│       │   ├── camera.gd          # Abstract camera base class
│       │   └── Setups/
│       │       └── default_setup.gd
│       └── Office/
│           ├── office_manager.gd
│           ├── office_scrolling.gd
│           └── button_scroll.gd
├── Shaders/
│   ├── crtwave_shader.gdshader              # CRT scanline effect
│   └── equirectangular_perspective.gdshader # 360-degree perspective
├── project.godot           # Godot project configuration
├── README.md
└── LICENSE
```

## Core Systems Architecture

### 1. AI System (`Scripts/Nights/AI/`)

The AI uses a difficulty-scaled system (0-20 levels) faithful to the original FNAF games.

**Base Class (`ai.gd`):**
- Abstract class with `@abstract` decorator
- `has_passed_check()` - Randomized difficulty check (`ai_level >= randi_range(1,20)`)
- `move_to(target_room, new_state, move_step)` - Handles room transitions
- `move_options()` - Override in subclasses for character-specific behavior
- State enum: `ABSENT`, `PRESENT`, `ALT_1`, `ALT_2`

**Adding New Characters:**
1. Create a new script in `Scripts/Nights/AI/Characters/`
2. Extend the `AI` class
3. Override `move_options()` with character-specific movement logic
4. Add a corresponding node in `nights.tscn` with a Timer

### 2. Camera System (`Scripts/Nights/Camera/`)

**Base Class (`camera.gd`):**
- Manages multiple camera feeds (rooms) and UI buttons
- Handles camera switching with static effect transitions
- Uses AnimationTree for static animations

**Key Variables:**
- `rooms: Array[Array]` - 2D array tracking character states per room
- `feeds: Array[TextureRect]` - Camera feed display nodes
- `buttons: Array[Button]` - Camera selection buttons

### 3. Office System (`Scripts/Nights/Office/`)

**Scrolling (`office_scrolling.gd`):**
- Mouse-proximity-based scrolling with 3 detection zones
- Smooth lerping with configurable `SCROLL_SMOOTHING` constant
- Clamp values prevent over-scrolling

**Button Offset (`button_scroll.gd`):**
- Compensates for equirectangular shader distortion
- Dynamically adjusts button hitboxes as office scrolls

### 4. Shaders (`Shaders/`)

**Equirectangular Perspective:** Converts panoramic images to perspective view for 360-degree office effect.

**CRT Wave:** Adds retro CRT monitor effect with scanlines and chromatic aberration.

## Code Conventions

### GDScript Style

```gdscript
# Use @abstract for base classes
@abstract
class_name MyBaseClass
extends Node

# Type hints are required for function returns
func my_function() -> bool:
    return true

# Use @export for inspector-visible properties
@export_range(0, 20) var difficulty: int = 10

# Use @onready for node references
@onready var my_node: Node2D = $MyNode

# Constants for magic numbers
const SCROLL_SPEED: float = 600.0
const SCROLL_SMOOTHING: float = 12.0

# Enums for states
enum State {ABSENT, PRESENT, ALT_1, ALT_2}
```

### Naming Conventions

- **Scripts:** `snake_case.gd` (e.g., `office_scrolling.gd`)
- **Classes:** `PascalCase` (e.g., `class_name AI`)
- **Functions:** `snake_case` (e.g., `move_to()`)
- **Constants:** `SCREAMING_SNAKE_CASE` (e.g., `SCROLL_SPEED`)
- **Variables:** `snake_case` (e.g., `current_room`)
- **Enums:** `PascalCase` for enum name, `SCREAMING_SNAKE_CASE` for values

### Code Organization

1. Class declaration and extends
2. Enums
3. Exports
4. Constants
5. Variables (onready, then regular)
6. Built-in callbacks (`_ready`, `_process`, etc.)
7. Public methods
8. Private methods (prefix with `_`)

## Key Patterns

### Inheritance Pattern
```gdscript
# Base class (abstract)
@abstract
class_name Camera
extends Node

func switch_camera(target: int) -> void:
    # Base implementation
    pass

# Concrete implementation
extends Camera

func switch_camera(target: int) -> void:
    # Override with specific logic
    super.switch_camera(target)
    # Additional logic
```

### Signal Connections
- Prefer connecting signals in the `.tscn` file via the editor
- Use `@onready` for node references needed in signal handlers

### Timer-Based AI
- Each AI character has an associated Timer node
- Timer timeout triggers `move_check()` on the AI
- Timer intervals affect AI behavior timing

## Input Actions

| Action | Key/Button |
|--------|------------|
| `click_left` | Mouse Button 1 (Left Click) |

## Common Tasks

### Adding a New Camera Room

1. Add room image to `Graphics/CamRooms/`
2. Update `rooms` array in `camera.gd` subclass
3. Add corresponding feed TextureRect and button in scene
4. Update `set_feed()` logic in camera setup script

### Modifying AI Difficulty

AI difficulty is controlled via exports in `ai_manager.gd`:
- Range: 0-20
- Higher values = more likely to pass movement checks
- 20 = always passes, 0 = never passes

### Adjusting Office Scrolling

Modify constants in `office_scrolling.gd`:
- `SCROLL_SPEED` - Maximum scroll velocity
- `SCROLL_SMOOTHING` - Lerp smoothing factor
- `CLAMP_VALUE` - Maximum scroll offset

## Important Notes for AI Assistants

1. **Keep It Simple:** This framework intentionally avoids complexity. Don't over-engineer solutions.

2. **Respect the Philosophy:** Features should be:
   - Necessary for FNAF-style games
   - Not trivially implementable by users
   - Clean and maintainable

3. **Type Hints Required:** Always include return type hints on functions.

4. **No External Dependencies:** The project uses only Godot built-ins.

5. **Scene Structure:** Major changes should respect the existing node hierarchy in `nights.tscn`.

6. **Shader Modifications:** The equirectangular shader is mathematically precise - changes require understanding of projection math.

7. **Test in Godot 4.5:** Ensure compatibility with the GL Compatibility renderer.

## Git Workflow

- Main development branch: `main`
- Bug reports require video reproduction on unmodified framework
- Contributions via pull request

## Resources

- [Godot 4 Documentation](https://docs.godotengine.org/en/stable/)
- [GDScript Style Guide](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html)
- [Godot 3 Version](https://github.com/Oplexitie/Cupcakes-Framework/tree/godot3) (legacy)
