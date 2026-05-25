# Amor’s SWTOR Action Camera – Enhanced AHK Version (AutoHotkey v2)

Based on **“Amor's Extensive SWTOR Action cam overhaul”**, this is an enhanced AutoHotkey script variant with a custom crosshair, movement hide, and an improved interaction flow.  
Original mod and full description: [Amor's Extensive SWTOR Action cam overhaul](https://www.nexusmods.com/starwarstheoldrepublic/mods/32) .

My version keeps all original features and adds several quality‑of‑life improvements for both PvE and PvP.  
With this script and Amor’s action cam setup, SWTOR’s gameplay starts to feel somewhat similar to playing **Guild Wars 2 with Action Camera enabled**: you aim with the crosshair, move and fight in mouselook, and interact directly with what’s under the reticle instead of constantly tab‑targeting.

---

## Key Features

- **Action camera toggle (Alt)**  
  - Toggles a mouselook / action‑camera mode.  
  - Holds the right mouse button for you.  
  - Shows a configurable crosshair overlay and centers the mouse cursor under it.

- **Auto‑hide crosshair while moving**  
  - A small timer checks your movement keys (e.g. `W`).  
  - While moving forward, the crosshair is temporarily hidden to avoid clutter.  
  - When you stop, the crosshair reappears.
 
- **Crosshair aligned to mouse cursor**
  - When you enter action mode, the script moves the hardware mouse cursor exactly under the crosshair.
  - A normal right‑click by itself will not trigger interaction in action mode.
  - Instead, use the configured interact button from the script (default: MButton via INTERACT_KEY) – it performs a right‑click at the crosshair position and then exits back to normal cursor mode.

- **Configurable interact + auto exit to cursor mode (default: MButton)**
  - Aim the crosshair at an NPC, door, console, or any interactable.
  - By default, press MButton (mouse wheel click) — or any mouse button you set in INTERACT_KEY in the script config:
  - The script temporarily releases RMB, performs a normal right‑click at the crosshair position, then automatically disables action mode: releases RMB, hides the crosshair, and returns you to normal mouse cursor mode. Result: one press on your interact button = start dialogue / interact AND immediately be in UI/cursor mode.

- **PvE‑ and PvP‑friendly mouse buttons**  
  - In action mode, **Left/Right Mouse** simply fire your primary/secondary abilities on the **current target**.  
  - The script does not auto‑retarget in PvP; targeting (Tab, Shift+Tab, XButton1/XButton2, etc.) is handled by SWTOR keybinds.  
  - This makes the script safe and predictable for both PvE and PvP play.

- **Safe Escape handling**  
  - Pressing `Esc`:
    - cleanly disables action mode (if active),  
    - then sends `Esc` to the game (close UI, back out of menus, etc.).  
  - Implemented with `$Esc` to avoid the classic `71 hotkeys have been received` warning from AutoHotkey.

---

## Controls (default)

- **Alt** – Toggle action camera on/off.  
- **Left Mouse Button** – Primary attack (while in action mode).  
- **Right Mouse Button** – Secondary attack (while in action mode).  
- **MButton (middle mouse button)** – Interact with whatever is under the crosshair and switch to normal cursor mode.  
- **Esc** – Exit action mode (if active) and send Esc to SWTOR (close UI, back out of menus, etc.).

You can freely configure additional targeting in SWTOR itself, for example:

- `Tab` – Target Center Screen Enemy.  
- `Shift+Tab` – Target Previous Enemy.  
- `Ctrl+Tab` – Target Nearest Friendly.  
- `XButton1 / XButton2` – Next/Previous enemy target (set directly in SWTOR).

The script does not override these — it only manages camera, crosshair, and interaction.

---

## Requirements

- **AutoHotkey v2** (this script is written for v2 syntax) [web:90].  
- SWTOR running as `swtor.exe` (default executable; can be changed in the config).

---

## Installation

1. Install **AutoHotkey v2** from the official website / Microsoft Store: https://apps.microsoft.com/detail/9plqfdg8hh9d?hl=en-US&gl=en
2. Download the script from this page.  
3. Adjust the configuration section at the top of the script:
   - Keybinds for primary/secondary attacks.  
   - Crosshair appearance (font, color, offsets).  
   - Movement keys for auto‑hide crosshair logic.
   - Interact key for interaction with NPC/objects.  
4. Optional: download and apply the **“SWTOR Action Keybinds”** and **“SWTOR Layout 1080p”** optional files from this page.  
5. Run the `.ahk` script (ideally as Admin) and then launch SWTOR.  
6. In‑game, press **Alt** to activate action camera mode.

---

## Recommended optional files

- **"SWTOR Action Keybinds"**  
- **"SWTOR Layout 1080p"**

These optional files:

- Apply the keybinds and UI layout that the script expects (advanced action camera profile).  
- Match the attack, targeting, and interaction keys used by the AutoHotkey script.

If you use different keybinds or layouts, you can still adapt the script, but with **"SWTOR Action Keybinds"** and **"SWTOR Action Layout"** installed, everything works almost out of the box with this enhanced version.

---

## Notes

- The script only works while `swtor.exe` is the active window.  
- All enhancements are purely client‑side QoL and do not modify game files.  
- If you want different mouse buttons (e.g. use `XButton1` or `XButton2` instead of `MButton` for interaction), you can easily edit the hotkey section in the script.

Enjoy smoother action camera gameplay and one‑click interactions for NPCs and objects — with a setup that is comfortable for both PvE and PvP.
