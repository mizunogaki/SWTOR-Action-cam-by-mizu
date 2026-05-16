#Requires AutoHotkey v2.0
#SingleInstance Force

CoordMode("Mouse", "Screen")  ; Координаты мыши считаем от экрана, а не окна

; ============ CONFIGURATION ============
; Edit the variables below to customize the script
; =======================================

SWTOR_EXE := "swtor.exe"      ; Game executable name - don't change unless needed

; Combat keybinds - change these to match your SWTOR keybinds
TARGET_KEY := "{NumpadSub}"   ; Key that targets the center enemy
PRIMARY_ATTACK := "9"         ; Your main attack ability
SECONDARY_ATTACK := "0"       ; Your secondary attack ability

; Utility keybinds - actions for Shift/Ctrl when pressed alone
SHIFT_ACTION := "{Up}"        ; Action when only Shift is pressed
CTRL_ACTION := "{Down}"       ; Action when only Ctrl is pressed

; Reticle position - adjust to move the entire reticle
RETICLE_X_OFFSET := 0         ; Positive = right, Negative = left
RETICLE_Y_OFFSET := 0         ; Positive = down, Negative = up

; Sound settings
SOUND_ENABLED := 0            ; 1 = sounds on, 0 = sounds off

; Activation sound (when turning ON action mode)
; Leave empty to disable, or provide full path to WAV/MP3 file
ACTIVATION_SOUND := ""        ; Example: "C:\Windows\Media\Windows Battery Low.wav"

; Deactivation sound (when turning OFF action mode)  
; Leave empty to disable, or provide full path to WAV/MP3 file
DEACTIVATION_SOUND := ""      ; Example: "C:\Windows\Media\Windows Balloon.wav"

; Reticle layers - customize appearance (0 = disabled, 1 = enabled)
; Each layer has: Enabled, Character, Size, Color, X-Offset, Y-Offset, Bold
; Note: Larger sizes may need negative Y offsets to appear centered

; Дополнительные клавиши движения (помимо WASD)
MOVEMENT_KEYS := ["w"]  ; Добавьте нужные, если используете

INTERACT_KEY := "MButton4"  ; MouseButton4 (первая боковая)

; ======== PVP TARGETING PROFILE ========
; 1 = enable PvP-style mouse buttons (no auto-retarget on click),
; 0 = behave like original PvE script (if you ever want that back).
PVP_MODE := 1

; ========== Crosshair settings ========

LAYER1_ENABLED := 1           ; Main white dot
LAYER1_CHAR := "⊹"            ; Character to display
LAYER1_SIZE := 20             ; Font size
LAYER1_COLOR := "2DD117"      ; Hex color (no #)
LAYER1_X := 0                 ; Horizontal position offset
LAYER1_Y := 0                 ; Vertical position offset
LAYER1_BOLD := 0              ; 1 = Bold text, 0 = Normal text

LAYER2_ENABLED := 0           ; Dark outline
LAYER2_CHAR    := "◦"
LAYER2_SIZE    := 30
LAYER2_COLOR   := "ffffff"  ; almost black
LAYER2_X       := 0
LAYER2_Y       := -5       ; slight negative to visually center bigger symbol
LAYER2_BOLD    := 1

LAYER3_ENABLED := 0           ; Example: Red crosshair
LAYER3_CHAR := "⊹"            ; Character to display
LAYER3_SIZE := 20             ; Font size
LAYER3_COLOR := "2DD117"      ; Hex color (no #)
LAYER3_X := 0                 ; Horizontal position offset
LAYER3_Y := -5                ; Vertical position offset (negative to center)
LAYER3_BOLD := 1              ; 1 = Bold text, 0 = Normal text

LAYER4_ENABLED := 0           ; Example: Green square
LAYER4_CHAR := "■"            ; Character to display
LAYER4_SIZE := 8              ; Font size
LAYER4_COLOR := "00FF00"      ; Hex color (no #)
LAYER4_X := 0                 ; Horizontal position offset
LAYER4_Y := 2                 ; Vertical position offset (positive to center smaller font)
LAYER4_BOLD := 0              ; 1 = Bold text, 0 = Normal text

LAYER5_ENABLED := 0           ; Example: Blue circle
LAYER5_CHAR := "○"            ; Character to display
LAYER5_SIZE := 40             ; Font size
LAYER5_COLOR := "0000FF"      ; Hex color (no #)
LAYER5_X := 0                 ; Horizontal position offset
LAYER5_Y := -15               ; Vertical position offset (negative to center larger font)
LAYER5_BOLD := 0              ; 1 = Bold text, 0 = Normal text

; ============ DO NOT EDIT BELOW ============
; Unless you know AutoHotkey and understand the code
; ===========================================

global actionMode := false
global reticleGui := ""

CreateReticle() {
    global reticleGui
    reticleGui := Gui("+AlwaysOnTop -Caption +ToolWindow +E0x20")
    reticleGui.BackColor := "000000"
    
    ; Position reticle in center with user offsets
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
    
    WinSetTransColor("000000 255", reticleGui)
}

UpdateReticleVisibility() {
    global reticleGui, actionMode
    if (!actionMode || !reticleGui) {
        reticleGui.Hide()
        return
    }
    
    isMoving := false
    for key in MOVEMENT_KEYS {
        if GetKeyState(key, "P") {  ; "P" — физическое нажатие (игнорирует remap)
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
    SetTimer(UpdateReticleVisibility, 50)  ; Проверка 20 раз/сек — плавно и не нагружает CPU
}

HideReticle() {
    global reticleGui
    SetTimer(UpdateReticleVisibility, 0)  ; Останавливаем таймер
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
    for p in ComObjGet("winmgmts:").ExecQuery("SELECT ProcessId, Name FROM Win32_Process") {
        if (p.Name = SWTOR_EXE)
            return p.ProcessId
    }
    return 0
}

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
        ; Координаты центра экрана
        screenCenterX := A_ScreenWidth  // 2
        screenCenterY := A_ScreenHeight // 2

        ; Те же расчёты, что и для GUI ретикула (40x40)
        reticleX := screenCenterX - 20 + RETICLE_X_OFFSET
        reticleY := screenCenterY - 90 + RETICLE_Y_OFFSET

        ; Центр прямоугольника ретикула
        mouseX := reticleX + 20
        mouseY := reticleY + 20

        MouseMove(mouseX, mouseY, 0)  ; мгновенно

        Send "{RButton down}"
        ShowReticle()
        PlaySound(ACTIVATION_SOUND)
    } else {
        Send "{RButton up}"
        HideReticle()
        PlaySound(DEACTIVATION_SOUND)
    }
}

#HotIf actionMode && WinActive("ahk_exe swtor.exe") && PVP_MODE

; ======== PVP: COMBAT MOUSE BUTTONS ONLY ========

; In PvP we do NOT auto-retarget on click.
; LMB/RMB simply fire abilities on your current target.
; Targeting (Tab, Ctrl+Tab, Shift+Tab, mouse buttons) is handled directly by SWTOR.

LButton:: {
    Send PRIMARY_ATTACK   ; left mouse = main attack
}

RButton:: {
    Send SECONDARY_ATTACK ; right mouse = secondary attack
}

; Interact (side mouse button) and then stay in normal mouse mode
; Aim crosshair at NPC/object, press MButton to interact and exit action mode.
MButton:: {
    ; 1) Temporarily release held right mouse button
    Send "{RButton up}"
    Sleep 30

    ; 2) Perform a normal right-click at the crosshair position
    Click "Right"

    ; 3) Exit action mode (turn off crosshair, release RMB, play sound)
    Sleep 30
    DisableActionMode()

    return
}

#HotIf  ; reset context for the other hotkeys

; Esc: always behaves like "exit action mode if active, then send Esc to the game"
$Esc:: {
    DisableActionMode()
    Send "{Esc}"
}

*Shift:: {
    ; "P" means Physical state - don't remove the "P"!
    if !GetKeyState("LControl", "P") && !GetKeyState("RControl", "P") && !GetKeyState("LAlt", "P") && !GetKeyState("RAlt", "P") {
        if WinActive("ahk_exe swtor.exe")
            Send SHIFT_ACTION
    }
}

*Ctrl:: {
    ; "P" means Physical state - don't remove the "P"!
    if !GetKeyState("LShift", "P") && !GetKeyState("RShift", "P") && !GetKeyState("LAlt", "P") && !GetKeyState("RAlt", "P") {
        if WinActive("ahk_exe swtor.exe")
            Send CTRL_ACTION
    }
}
