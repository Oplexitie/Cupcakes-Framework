# Hellish Nights - Setup Guide

This guide explains how to set up the new character systems in Godot.

## Quick Setup Checklist

### 1. Add Core Systems to Scene

In `nights.tscn`, add these nodes under the root:

```
Nights (Node2D)
├── GameManager (Node) - attach: game_manager.gd
├── Systems (Node)
│   ├── AudioDisruption (Node) - attach: Systems/audio_disruption_system.gd
│   ├── Corruption (Node) - attach: Systems/corruption_system.gd
│   ├── Rage (Node) - attach: Systems/rage_system.gd
│   ├── CameraInterference (Node) - attach: Systems/camera_interference_system.gd
│   └── DoorSystem (Node) - attach: Systems/door_system.gd
├── ErrorOverlay (CanvasLayer) - attach: Systems/error_overlay_system.gd
└── ... (rest of scene)
```

### 2. Wire Up the AI Manager

Select `CharacterAI` node and in the Inspector:
- Set `Game Manager` → drag the GameManager node
- Set `Corruption System` → drag Systems/Corruption
- Set `Audio Disruption` → drag Systems/AudioDisruption
- Set `Rage System` → drag Systems/Rage

### 3. Replace Red/Green with Tony

Delete the old nodes:
- CharacterAI/Red
- CharacterAI/Green

Add Tony:
```
CharacterAI (Node)
└── Tony (Node) - attach: AI/Characters/tony_ai.gd
    └── TonyTimer (Timer) - wait_time: 4.0, autostart: true
```

Connect the timer:
- TonyTimer.timeout → Tony.move_check()

### 4. Update Camera Setup

On `CameraElements` node:
- Change script from `default_setup.gd` to `hellish_setup.gd`
- Update the `rooms` export to: `[[0], [0], [0], [0]]`
  (Single value per room for Tony's state, index 0 = Tony)

Wait, actually Tony uses index 2. Update rooms to:
`[[0, 0, 0], [0, 0, 0], [0, 0, 0], [0, 0, 0]]`

Or just initialize Tony at index 0 in Tony's script and update TONY_INDEX in hellish_setup.gd.

### 5. Set Up Room Sprites for Tony

Each room sprite needs frames:
- Frame 0: Empty room
- Frame 1: Tony present (normal pose)
- Frame 2: Tony tantrum pose (optional)

Update your room PNGs to include Tony variants as a vertical sprite sheet.

### 6. Add Audio (Optional)

Add AudioStreamPlayer nodes for Tony's sounds:
```
Tony (Node)
├── TonyTimer (Timer)
├── ScreamSound (AudioStreamPlayer) - load tony_scream.ogg
└── MovementSound (AudioStreamPlayer) - load tony_movement.ogg
```

Then connect the `screamed` signal from Tony to play the sound.

---

## Tony AI Settings (Inspector)

| Setting | Default | Description |
|---------|---------|-------------|
| `Min Scream Interval` | 20.0 | Minimum seconds between screams |
| `Max Scream Interval` | 40.0 | Maximum seconds between screams |
| `Disruption Duration` | 12.0 | How long audio is blocked |
| `Tantrum Chance` | 0.2 | 20% chance to tantrum instead of move |
| `Tantrum Scream Interval` | 5.0 | Screams every 5 sec during tantrum |

## Testing Tony

1. Set `tony_level` in AIManager to 20 (always moves)
2. Run the game
3. Tony should:
   - Move through rooms every few seconds
   - Scream randomly (check console or add print statements)
   - Sometimes tantrum (stays put, screams more often)

## Adding Light Flash for Tantrums

To end Tony's tantrum, player needs to flash light. Add a button/area in the office that calls:
```gdscript
$CharacterAI/Tony.flash_light()
```
