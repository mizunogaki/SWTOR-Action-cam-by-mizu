# SWTOR Action Camera – Enhanced Version (AutoHotkey v2)

This is a customized version of **"Amor's Extensive SWTOR Action cam overhaul"** for Star Wars: The Old Republic.  
Original mod and full description: [Amor's Extensive SWTOR Action cam overhaul](https://www.nexusmods.com/starwarstheoldrepublic/mods/32) [web:125].

My version keeps all original features and adds several quality‑of‑life improvements for crosshair and interaction.

## Key Features

- **Action camera toggle (Alt)**  
  - Toggles a mouselook / action‑camera mode.  
  - Holds the right mouse button for you.  
  - Shows a configurable crosshair overlay.

- **Crosshair aligned to mouse cursor**  
  - When entering action mode, the script moves the hardware mouse cursor exactly under the crosshair.  
  - Any right‑click (including simulated clicks) hits where the crosshair is, not where the cursor used to be.

- **Auto‑hide crosshair while moving (W)**  
  - A small timer checks movement key (`W`).  
  - While moving forward, the crosshair is temporarily hidden to avoid clutter.  
  - When you stop pressing 'W', the crosshair reappears.

- **Side mouse button interact + auto exit to cursor mode (XButton2)**  
  - Aim the crosshair at an NPC, door, console, or any interactable.  
  - Press **XButton2**:
    - The script temporarily releases RMB,
    - performs a normal right‑click at the crosshair position,
    - then automatically disables action mode:
      - releases RMB,
      - hides the crosshair,
      - returns you to normal mouse cursor mode.
  - Result: one press on XButton2 = start dialogue / interact AND immediately be in UI/cursor mode.

- **Safe Escape handling**  
  - Pressing `Esc`:
    - cleanly disables action mode (if active),
    - then sends `Esc` to the game.  
  - Implemented with `$Esc` to avoid the classic `71 hotkeys have been received` warning from AutoHotkey.

## Controls (default)

- **Alt** – Toggle action camera on/off.  
- **Left Mouse Button** – Target + primary attack (while in action mode).  
- **Right Mouse Button** – Target + secondary attack (while in action mode).  
- **XButton2 (side mouse button)** – Interact with whatever is under the crosshair and switch to normal cursor mode.  
- **Esc** – Exit action mode (if active) and send Esc to SWTOR (close UI, back out of menus, etc.).

## Requirements

- **AutoHotkey v2** (this script is written for v2 syntax).  
- SWTOR running as `swtor.exe` (default executable; can be changed in config).

## Installation

1. Install **AutoHotkey v2** from the official website.  
2. Download the original script from the Nexus page and replace it with this modified version (or drop this file next to it).  
3. Adjust the configuration section at the top of the script:
   - Keybinds for targeting and attacks.
   - Crosshair appearance (font, color, offsets).
   - Movement keys for auto‑hide logic.
4. Run the `.ahk` script as Admin and then launch SWTOR.  
5. In‑game, press **Alt** to activate action camera mode.

## Notes

- The script only works while `swtor.exe` is the active window.  
- All enhancements are purely client‑side QoL and do not modify game files.  
- If you want different mouse buttons (e.g. use `XButton1`or `MButton` instead of `XButton2`), you can easily edit the hotkey section in the script.

Enjoy smoother action camera gameplay and one‑click interactions for NPCs and objects.
