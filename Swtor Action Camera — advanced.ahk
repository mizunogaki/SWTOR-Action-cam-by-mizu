#Requires AutoHotkey v2.0
#SingleInstance Force

; Use absolute screen coordinates for all mouse operations
; (0,0 is the top-left corner of the screen, not the game window).
CoordMode("Mouse", "Screen")  ; [web:73][web:72]

; ============ CONFIGURATION ============
; Edit the variables below to customize the script
; =======================================

; SWTOR process name – only change if your EXE is different
SWTOR_EXE := "swtor.exe"

; Combat keybinds – set these to match your SWTOR keybinds
TARGET_KEY := "{NumpadSub}"   ; Key used to target the closest/center enemy
PRIMARY_ATTACK := "9"         ; Main attack ability (left mouse in action mode)
SECONDARY_ATTACK := "0"       ; Secondary attack ability (right mouse in action mode)

; Utility keybinds – actions when Shift/Ctrl are pressed alone
SHIFT_ACTION := "{Up}"        ; Action sent when only Shift is pressed
CTRL_ACTION := "{Down}"       ; Action sent when only Ctrl is pressed

; Reticle position – offsets to move the entire crosshair on screen
RETICLE_X_OFFSET := 0         ; Positive = move right, negative = move left
RETICLE_Y_OFFSET := 0         ; Positive = move down, negative = move up

; Sound settings
SOUND_ENABLED := 0            ; 1 = play sounds, 0 = no sounds

; Sound played when turning ON action mode
; Leave empty to disable, or set full path to a WAV/MP3 file.
ACTIVATION_SOUND := ""        ; Example: "C:\\Windows\\Media\\Windows Battery Low.wav"

; Sound played when turning OFF action mode
; Leave empty to disable, or set full path to a WAV/MP3 file.
DEACTIVATION_SOUND := ""      ; Example: "C:\\Windows\\Media\\Windows Balloon.wav"

; Reticle layers – configure appearance (0 = disabled, 1 = enabled)
; Each layer has: Enabled, Character, Size, Color, X-Offset, Y-Offset, Bold
; Note: bigger font sizes may need a negative Y offset to appear visually centered.

; Extra movement keys for auto-hide logic (on top of WASD if you want)
MOVEMENT_KEYS := ["w"]        ; Add more keys here if needed (e.g. "a","s","d")

; Not used in this version, but kept for clarity – side mouse button alias
INTERACT_KEY := "MButton4"    ; Example: MouseButton4 (first side button)

; Main reticle layer (white dot)
LAYER1_ENABLED := 1           ; 1 = enabled, 0 = disabled
LAYER1_CHAR := "⊹"            ; Character used for the crosshair
LAYER1_SIZE := 20             ; Font size
LAYER1_COLOR := "2DD117"      ; Hex color (no #)
LAYER1_X := 0                 ; X offset relative to the 40x40 GUI
LAYER1_Y := 0                 ; Y offset relative to the 40x40 GUI
LAYER1_BOLD := 0              ; 1 = bold font, 0 = normal font

; Optional second layer (outline / background)
LAYER2_ENABLED := 0
LAYER2_CHAR := "◦"
LAYER2_SIZE := 30
LAYER2_COLOR := "030303"
LAYER2_X := 0
LAYER2_Y := -10               ; Negative to visually center larger fonts
LAYER2_BOLD := 1

; Example: red crosshair layer (disabled by default)
LAYER3_ENABLED := 0
LAYER3_CHAR := "+"
LAYER3_SIZE := 20
LAYER3_COLOR := "FF0000"
LAYER3_X := 0
LAYER3_Y := -5
LAYER3_BOLD := 1

; Example: green square layer (disabled by default)
LAYER4_ENABLED := 0
LAYER4_CHAR := "■"
LAYER4_SIZE := 8
LAYER4_COLOR := "00FF00"
LAYER4_X := 0
LAYER4_Y := 2
LAYER4_BOLD := 0

; Example: blue circle layer (disabled by default)
LAYER5_ENABLED := 0
LAYER5_CHAR := "○"
LAYER5_SIZE := 40
LAYER5_COLOR := "0000FF"
LAYER5_X := 0
LAYER5_Y := -15
LAYER5_BOLD := 0

; ============ DO NOT EDIT BELOW ============
; Unless you know AutoHotkey and understand the code
; ===========================================

global actionMode := false
global reticleGui := ""

CreateReticle() {
    global reticleGui
    ; Transparent, click-through GUI that holds the crosshair
    reticleGui := Gui("+AlwaysOnTop -Caption +ToolWindow +E0x20")
    reticleGui.BackColor := "000000"
    
    ; Position reticle in the center of the screen, plus user offsets
    reticleX := (A_ScreenWidth // 2) - 20 + RETICLE_X_OFFSET
    reticleY := (A_ScreenHeight // 2) - 90 + RETICLE_Y_OFFSET
    
    reticleGui.Show("w40 h40 x" reticleX " y" reticleY " NoActivate")
    WinSetTransparent(200, reticleGui)
    
    if (LAYER1_ENABLED) {
        layer1 := reticleGui.Add("Text", "x" LAYER1_X " y" LAYER1_Y " w40 h40 Center BackgroundTrans", LAYER1_CHAR)
        layer1.SetFont("s" LAYER1_SIZE " c" LAYER1_COLOR (LAYER1_BOLD ? " Bold" : ""))
    }
    
    if (LAYER2_ENABLED) {
        layer2 := reticleGui.Add("Text", "x" LAYER2_X " y" LAYER2_Y " w40 h40 Center BackgroundTrans", LAYER2_CHAR)
        layer2.SetFont("s" LAYER2_SIZE " c" LAYER2_COLOR (LAYER2_BOLD ? " Bold" : ""))
    }
    
    if (LAYER3_ENABLED) {
        layer3 := reticleGui.Add("Text", "x" LAYER3_X " y" LAYER3_Y " w40 h40 Center BackgroundTrans", LAYER3_CHAR)
        layer3.SetFont("s" LAYER3_SIZE " c" LAYER3_COLOR (LAYER3_BOLD ? " Bold" : ""))
    }
    
    if (LAYER4_ENABLED) {
        layer4 := reticleGui.Add("Text", "x" LAYER4_X " y" LAYER4_Y " w40 h40 Center BackgroundTrans", LAYER4_CHAR)
        layer4.SetFont("s" LAYER4_SIZE " c" LAYER4_COLOR (LAYER4_BOLD ? " Bold" : ""))
    }
    
    if (LAYER5_ENABLED) {
        layer5 := reticleGui.Add("Text", "x" LAYER5_X " y" LAYER5_Y " w40 h40 Center BackgroundTrans", LAYER5_CHAR)
        layer5.SetFont("s" LAYER5_SIZE " c" LAYER5_COLOR (LAYER5_BOLD ? " Bold" : ""))
    }
    
    ; Make black background fully transparent so only the text (crosshair) is visible
    WinSetTransColor("000000 255", reticleGui)
}

UpdateReticleVisibility() {
    global reticleGui, actionMode
    if (!actionMode || !reticleGui) {
        reticleGui.Hide()
        return
    }
    
    ; Auto-hide crosshair while movement keys are physically held down
    isMoving := false
    for key in MOVEMENT_KEYS {
        ; "P" = physical key state (ignores remaps) [web:22][web:137]
        if GetKeyState(key, "P") {
            isMoving := true
            break
        }
    }
    
    if (isMoving) {
        reticleGui.Hide()
    } else {
        reticleGui.Show("NoActivate")
    }
}

ShowReticle() {
    global reticleGui
    if (!reticleGui) {
        CreateReticle()
    }
    UpdateReticleVisibility()
    ; Check movement state 20 times per second – smooth and lightweight [web:138]
    SetTimer(UpdateReticleVisibility, 50)
}

HideReticle() {
    global reticleGui
    ; Stop the visibility timer
    SetTimer(UpdateReticleVisibility, 0)
    if (reticleGui) {
        reticleGui.Hide()
    }
}

DisableActionMode() {
    global actionMode

    if !actionMode
        return

    actionMode := false
    Send "{RButton up}"
    HideReticle()
    PlaySound(DEACTIVATION_SOUND)
}

PlaySound(soundFile) {
    if (SOUND_ENABLED && soundFile != "") {
        SoundPlay soundFile
    }
}

GetSWTORPID() {
    global SWTOR_EXE
    ; Find SWTOR process by executable name
    for p in ComObjGet("winmgmts:").ExecQuery("SELECT ProcessId, Name FROM Win32_Process") {
        if (p.Name = SWTOR_EXE)
            return p.ProcessId
    }
    return 0
}

; Periodically check if SWTOR is still running
SetTimer CheckSWTOR, 1000
CheckSWTOR() {
    if !GetSWTORPID() {
        HideReticle()
        ExitApp
    }
}

*Alt:: {
    if !WinActive("ahk_exe swtor.exe")
        return

    global actionMode
    actionMode := !actionMode

    if actionMode {
        ; Screen center
        screenCenterX := A_ScreenWidth  // 2
        screenCenterY := A_ScreenHeight // 2

        ; Same positioning as in CreateReticle() (40x40 GUI)
        reticleX := screenCenterX - 20 + RETICLE_X_OFFSET
        reticleY := screenCenterY - 90 + RETICLE_Y_OFFSET

        ; Center of the reticle rectangle
        mouseX := reticleX + 20
        mouseY := reticleY + 20

        ; Move real mouse cursor under the crosshair
        MouseMove(mouseX, mouseY, 0)

        ; Hold RMB for action camera
        Send "{RButton down}"
        ShowReticle()
        PlaySound(ACTIVATION_SOUND)
    } else {
        DisableActionMode()
    }
}

#HotIf actionMode && WinActive("ahk_exe swtor.exe")

; Left mouse: target + primary attack while in action mode
LButton:: {
    Send TARGET_KEY
    Send PRIMARY_ATTACK
}

; Right mouse: target + secondary attack while in action mode
RButton:: {
    Send TARGET_KEY
    Send SECONDARY_ATTACK
}

; Interact with side mouse button and then stay in normal mouse mode
XButton2:: {
    ; 1) Temporarily release held RMB
    Send "{RButton up}"
    Sleep 30

    ; 2) Perform a normal right-click at the crosshair position
    Click "Right"  ; [web:77]

    ; 3) Exit action mode (turn off crosshair, release RMB, play sound)
    Sleep 30
    DisableActionMode()

    return
}

#HotIf  ; reset context for the following hotkeys

; Esc: always behaves like "exit action mode if active, then send Esc to the game"
$Esc:: {
    DisableActionMode()
    Send "{Esc}"
}

*Shift:: {
    ; "P" = check the physical state of the keys (ignores remaps) [web:22][web:137]
    if !GetKeyState("LControl", "P")
     && !GetKeyState("RControl", "P")
     && !GetKeyState("LAlt", "P")
     && !GetKeyState("RAlt", "P") {
        if WinActive("ahk_exe swtor.exe")
            Send SHIFT_ACTION
    }
}

*Ctrl:: {
    ; Only trigger when Ctrl is pressed alone (no Shift/Alt)
    if !GetKeyState("LShift", "P")
     && !GetKeyState("RShift", "P")
     && !GetKeyState("LAlt", "P")
     && !GetKeyState("RAlt", "P") {
        if WinActive("ahk_exe swtor.exe")
            Send CTRL_ACTION
    }
}
