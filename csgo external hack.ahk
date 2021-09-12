#Include classMemory.ahk
#Include csgo offsets.ahk
#Include imgui.ahk
#NoEnv
#Persistent
#InstallKeybdHook
#SingleInstance, Force
DetectHiddenWindows, On
SetKeyDelay,-1, -1
SetControlDelay, -1
SetMouseDelay, -1
SendMode Input
SetBatchLines,-1
ListLines, Off
Process, Priority, , H

if !Read_csgo_offsets_from_hazedumper() {
	MsgBox, 48, Error!, Failed to get csgo offsets
    ExitApp
}
if (_ClassMemory.__Class != "_ClassMemory") {
    msgbox class memory not correctly installed. Or the (global class) variable "_ClassMemory" has been overwritten
    ExitApp
}

;cl_grenadepreview              ;0xDAD3C8 152=off 151=on
;sv_showimpacts                 ;0xDA60C0 144=off 145=on
;weapon_debug_spread_show       ;0xDAF358 40=off 43=on
;weapon_recoil_view_punch_extra ;0xDA6534 822568200=off 208020134=on
;r_drawothermodels              ;0xD84C88 89=off 90=on
;mp_weapons_glow_on_ground      ;0xDA2F40 16=off 17=on
;mat_postprocess_enable         ;0xD98F40 16=off 17=on



Process, Wait, csgo.exe
Global csgo := new _ClassMemory("ahk_exe csgo.exe", "", hProcessCopy)
Global client := csgo.getModuleBaseAddress("client.dll")
Global engine := csgo.getModuleBaseAddress("engine.dll")

pattern := csgo.hexStringToPattern("A3 ?? ?? ?? ?? 57 8B CB")
Global smokecount := csgo.read(csgo.modulePatternScan("client.dll", pattern*)+0x1, "Uint")




DllCall("QueryPerformanceFrequency", "Int64*", freq)
ShootBefore := ShootAfter := 0


Global enable_glow := 0
Global enable_glow_enemy := 0
Global glow_enemy_color := 0xFFC22CCF
Global glow_enemy_color_a := 0
Global glow_enemy_color_r := 0
Global glow_enemy_color_g := 0
Global glow_enemy_color_b := 0
Global enable_glow_team := 0
Global glow_team_color := 0xFF00FF00 ;ARGB
Global glow_team_color_a := 0
Global glow_team_color_r := 0
Global glow_team_color_g := 0
Global glow_team_color_b := 0

Global enable_chams := 0
Global enable_chams_enemy := 0
Global chams_enemy_color := 0x00FFFFFF
Global chams_enemy_color_r := 0
Global chams_enemy_color_b := 0
Global chams_enemy_color_b := 0
Global enable_chams_team := 0
Global chams_team_color := 0x00FFFFFF
Global chams_team_color_r := 0
Global chams_team_color_g := 0
Global chams_team_color_b := 0
Global enable_chams_local := 0
Global chams_local_color := 0x00FFFFFF
Global chams_local_color_r := 0
Global chams_local_color_g := 0
Global chams_local_color_b := 0

Global fov_changer_value := 90

Global enable_dont_render := 1

Global Glow_Struct
VarSetCapacity(Glow_Struct, 16)

Global NewViewAngles := [0, 0]
Global OldPunchAngles := [0, 0]


;_ImGui_EnableViewports()
hwnd := _ImGui_GUICreate("CS:GO Ahk External Hack Settings", 720, 540, (A_ScreenWidth-720)//2, (A_ScreenHeight-540)//2)
winshow, ahk_id %hwnd%
Global rc
VarSetCapacity(rc, 16)
DllCall("GetClientRect", "Uint", hwnd, "Uint", &rc)

SetFormat, integer, H
Loop {
	settings_gui()
	while IsInGame() {
		DllCall("QueryPerformanceCounter", "Int64*", LoopBefore)
		if !(enable_dont_render & !WinActive("CS:GO Ahk External Hack Settings"))
			settings_gui()
		MaxPlayer := GetMaxPlayer()
		,glowobj := GetGlowObj()
		,Global LocalPlayer := GetLocalPlayer()
		,LocalPlayerID := GetLocalPlayerID()
		,WeaponHandle := GetActiveWeapon(LocalPlayer)
		,WeaponEntity := GetWeaponEntity(WeaponHandle)
		,WeaponAmmo := GetWeaponAmmo(WeaponEntity)
		,WeaponIndex := GetWeaponIndex(WeaponEntity)
		,CrosshairID := GetCrosshairID(LocalPlayer)
		,LocalPlayer_Team := GetTeam(LocalPlayer)
		,LocalPlayer_Dormant := GetDormant(LocalPlayer)
		,LocalPlayer_Flags := GetFlags(LocalPlayer)
		,LocalPlayer_IsScoped := IsScoped(LocalPlayer)
		,csgo.readRaw(client + dwEntityList, EntityList, (MaxPlayer+1)*0x10)
		Loop % MaxPlayer {
			dwEntity := NumGet(EntityList, A_index*0x10, "Uint") ;GetEntity(A_index)
			,dwEntity_Team := GetTeam(dwEntity)
			,dwEntity_IsAlive := IsAlive(dwEntity)
			,dwEntity_Dormant := GetDormant(dwEntity)
			,dwEntity_GlowIndex := GetGlowIndex(dwEntity)
			,dwEntity_ClassId := GetClassId(dwEntity)


			if (dwEntity=0 || dwEntity=LocalPlayer || !dwEntity_IsAlive || dwEntity_Dormant)
				Continue

			if (LocalPlayer_Team != dwEntity_Team)  {
				if (enable_glow && enable_glow_enemy) {
					SplitARGBColor(glow_enemy_color, glow_enemy_color_a, glow_enemy_color_r, glow_enemy_color_g, glow_enemy_color_b)
					Glow(glowobj, dwEntity_GlowIndex, glow_enemy_color_r, glow_enemy_color_g, glow_enemy_color_b, glow_enemy_color_a)
				}
				if (enable_chams && enable_chams_enemy) {
					SplitRGBColor(chams_enemy_color, chams_enemy_color_r, chams_enemy_color_g, chams_enemy_color_b)
					chams(dwEntity, chams_enemy_color_r, chams_enemy_color_g, chams_enemy_color_b)
				} else {
					chams(dwEntity, 255, 255, 255)
				}
				if (enable_radar_reveal && GetSpotted(dwEntity)!=2) {
					csgo.write(dwEntity + m_bSpotted, 2, "UChar")
				}
			} else {
				if (enable_glow && enable_glow_team) {
					SplitARGBColor(glow_team_color, glow_team_color_a, glow_team_color_r, glow_team_color_g, glow_team_color_b)
					Glow(glowobj, dwEntity_GlowIndex, glow_team_color_r, glow_team_color_g, glow_team_color_b, glow_team_color_a)
				}
				if (enable_chams && enable_chams_team) {
					SplitRGBColor(chams_team_color, chams_team_color_r, chams_team_color_g, chams_team_color_b)
					chams(dwEntity, chams_team_color_r, chams_team_color_g, chams_team_color_b)
				} else {
					chams(dwEntity, 255, 255, 255)
				}
				if (enable_team_check && A_index=CrosshairID-1) || (enable_auto_reload && !WeaponAmmo)
					csgo.write(client + dwForceAttack, 4, "Uint")
			}
		}

		ViewModelHandler := csgo.read(LocalPlayer + m_hViewModel, "Uint")
		,CurrentViewModelEntity := GetEntity((ViewModelHandler & 0xFFF) - 1)
		if (enable_chams && enable_chams_local) {
			SplitRGBColor(chams_local_color, chams_local_color_r, chams_local_color_g, chams_local_color_b)
			chams(CurrentViewModelEntity, chams_local_color_r, chams_local_color_g, chams_local_color_b)
		} else {
			chams(CurrentViewModelEntity, 255, 255, 255)
		}

		csgo.write(client + 0xDA2F40, enable_weapon_glow ? 17:16, "UChar")

		SetModelBrightness(enable_model_brightness ? model_brightness_value:0)


		csgo.write(LocalPlayer + m_iDefaultFOV, enable_fov_changer ? fov_changer_value:90, "Uint") ;fov changer

		csgo.write(LocalPlayer + m_flFlashMaxAlpha, enable_anti_flash ? 0:255, "Float") ;anti flash

		csgo.write(smokecount, enable_no_smoke ? 0:, "Uint") ;no smoke

		csgo.write(LocalPlayer + 0x258, enable_remove_hands ? 0:340, "Uint") ;remove hands

		csgo.write(client + 0xDAF358, (enable_force_crosshair && !LocalPlayer_IsScoped) ? 43:40, "UChar") ;force crosshair

		csgo.write(client + 0xDAD3C8, enable_grenade_prediction ? 151:152, "UChar") ;grenade prediction

		csgo.write(client + 0xD98F40, enable_disable_Post_Processing ? 16:17, "UChar") ;disable Post-Processing

		csgo.write(client + 0xDA60C0, enable_bullet_impacts ? 145:144, "UChar") ;bullet impacts


		if (enable_auto_bhop && GetKeyState("Space") && WinActive("ahk_exe csgo.exe") && !IsMouseEnable()) { ;auto bhop
			csgo.write(client + dwForceJump, (LocalPlayer_Flags=257 || LocalPlayer_Flags=263) ? 5:4, "Uint")
		}

		DllCall("QueryPerformanceCounter", "Int64*", ShootAfter)
		if (enable_auto_pistol && GetKeyState("LButton") && WinActive("ahk_exe csgo.exe") && !IsMouseEnable() && (WeaponIndex=30 || WeaponIndex=36 || WeaponIndex=32 || WeaponIndex=4 || WeaponIndex=3 || WeaponIndex=2 || WeaponIndex=1 || WeaponIndex=61) && ((ShootAfter-ShootBefore)/freq*1000)>=30) {
			csgo.write(client + dwForceAttack, 6, "Uint")
			DllCall("QueryPerformanceCounter", "Int64*", ShootBefore)
		}

		if rcs_value
			RCS(LocalPlayer, rcs_value)




		DllCall("QueryPerformanceCounter", "Int64*", LoopAfter)
		LoopTimer := (LoopAfter - LoopBefore) / freq * 1000
	}
	Sleep 10
}



GetMaxPlayer() {
	Return csgo.read(engine + dwClientState, "Uint", dwClientState_MaxPlayer)
}

GetLocalPlayer() {
	Return csgo.read(client + dwLocalPlayer, "Uint")
}

GetLocalPlayerID() {
	Return csgo.read(engine + dwClientState, "Uint", dwClientState_GetLocalPlayer)
}

GetCrosshairID(dwEntity) {
	Return csgo.read(dwEntity + m_iCrosshairId, "Uint")
}

GetActiveWeapon(dwEntity) {
	Return csgo.read(dwEntity + m_hActiveWeapon, "Uint")
}

GetWeaponEntity(dwWeaponHandle) {
	Return GetEntity((dwWeaponHandle & 0xFFF) - 1)
}

GetWeaponIndex(dwEntity) {
	Return csgo.read(dwEntity + m_iItemDefinitionIndex, "Uint")
}

GetWeaponAmmo(dwEntity) {
	Return csgo.read(dwEntity + m_iClip1, "Uint")
}

GetViewAngles() {
	csgo.readRaw(engine + dwClientState, ViewAngles, 0x8, dwClientState_ViewAngles)
	Return [NumGet(ViewAngles, 0x0, "Float"), NumGet(ViewAngles, 0x4, "Float")]
}

GetPunchAngles(dwEntity) {
	csgo.readRaw(dwEntity + m_aimPunchAngle, PunchAngles, 0x8)
	Return [NumGet(PunchAngles, 0x0, "Float"), NumGet(PunchAngles, 0x4, "Float")]
}

GetShotsFired(dwEntity) {
	Return csgo.read(dwEntity + m_iShotsFired, "Uint")
}

GetFlags(dwEntity) {
	Return csgo.read(dwEntity + m_fFlags, "Uint")
}

GetEntity(index) {
	Return csgo.read(client + dwEntityList + index * 0x10, "Uint")
}

GetTeam(dwEntity) {
	Return csgo.read(dwEntity + m_iTeamNum, "Uint")
}

GetHealth(dwEntity) {
	Return csgo.read(dwEntity + m_iHealth, "Uint")
}

GetGlowIndex(dwEntity) {
	Return csgo.read(dwEntity + m_iGlowIndex, "Uint")
}

GetDormant(dwEntity) {
	Return csgo.read(dwEntity + m_bDormant, "Uint")
}

GetSpotted(dwEntity) {
	Return csgo.read(dwEntity + m_bSpotted, "UChar")
}

GetSpottedByMask(dwEntity) {
	Return csgo.read(dwEntity + m_bSpottedByMask, "UChar")
}

GetClassId(dwEntity) {
	Return csgo.read(dwEntity + 0x8, "Uint", 0x8, 0x1, 0x14)
}

IsAlive(dwEntity) {
	H := GetHealth(dwEntity)
	Return (H>0 && H<=100)
}

IsInGame() {
	Return csgo.read(engine + dwClientState, "Uint", dwClientState_State)=6
}

IsMouseEnable() {
	Return !((csgo.read(client + dwMouseEnablePtr + 0x30, "Uint") ^ dwMouseEnablePtr) & 0xF)
}

IsScoped(dwEntity) {
	Return csgo.read(dwEntity + m_bIsScoped, "Uint")
}

SetModelBrightness(value) {
	VarSetCapacity(brightness, 4)
	,NumPut(value, brightness, 0, "Float")
	,thisPtr := engine + model_ambient_min - 0x2C
	,xored := NumGet(brightness, 0, "Int") ^ thisPtr
	,csgo.write(engine + model_ambient_min, xored, "Uint")
}

GetGlowObj() {
	Return csgo.read(client + dwGlowObjectManager, "Uint")
}

Glow(glowObj, glowInd, r, g, b, a) {
	NumPut(r/255, Glow_Struct, 0x0, "Float")
	,NumPut(g/255, Glow_Struct, 0x4, "Float")
	,NumPut(b/255, Glow_Struct, 0x8, "Float")
	,NumPut(a/255, Glow_Struct, 0xC, "Float")
	,csgo.writeRaw(glowObj+(glowInd*0x38)+0x8, &Glow_Struct, 16)
	;,csgo.write(glowObj+(glowInd*0x38)+0x20, 1, "Float")
	,csgo.write(glowObj+(glowInd*0x38)+0x28, 1, "UChar")
	,csgo.write(glowObj+(glowInd*0x38)+0x29, 0, "UChar")
	;,csgo.write(glowObj+(glowInd*0x38)+0x30, 2, "Uint")
	;,csgo.write(glowObj+(glowInd*0x38)+0x23, 255, "Uint")
	;msgbox % csgo.read(glowObj+(glowInd*0x38)+0x1C, "Uint")
}

chams(dwEntity, r, g, b) {
	csgo.write(dwEntity + m_clrRender, (b<<16)+(g<<8)+r, "Uint")
}

RCS(dwEntity, value:=0) {
	PunchAngles := GetPunchAngles(dwEntity)
	,ShotsFired := GetShotsFired(dwEntity)
	if (ShotsFired>1) {
		CurrentViewAngles := GetViewAngles()
		,NewViewAngles[1] := (CurrentViewAngles[1] + OldPunchAngles[1] * 2 * (value/100)) - (PunchAngles[1] * 2 * (value/100))
	    ,NewViewAngles[2] := (CurrentViewAngles[2] + OldPunchAngles[2] * 2 * (value/100)) - (PunchAngles[2] * 2 * (value/100))

	    ,NewViewAngles[1] := (NewViewAngles[1]>89) ? 89:NewViewAngles[1]
	    ,NewViewAngles[1] := (NewViewAngles[1]<-89) ? -89:NewViewAngles[1]

	    while (NewViewAngles[2]>180)
	    	NewViewAngles[2] -= 360

	    while (NewViewAngles[2]<-180)
	    	NewViewAngles[2] += 360

	    OldPunchAngles[1] := PunchAngles[1]
	    ,OldPunchAngles[2] := PunchAngles[2]

	    ,VarSetCapacity(ViewAngles, 0x8)
	    ,NumPut(NewViewAngles[1], ViewAngles, 0x0, "Float")
	    ,NumPut(NewViewAngles[2], ViewAngles, 0x4, "Float")
	    ,csgo.writeRaw(engine + dwClientState, &ViewAngles, 0x8, dwClientState_ViewAngles)
	} else {
		OldPunchAngles[1] := PunchAngles[1]
		,OldPunchAngles[2] := PunchAngles[2]
	}
}

SendPacket(value) {
	csgo.write(engine + dwbSendPackets, value, "UChar")
}


SplitRGBColor(RGBColor, ByRef Red, ByRef Green, ByRef Blue) {
    Red    := RGBColor >> 16 & 0xFF
    ,Green := RGBColor >> 8 & 0xFF
    ,Blue  := RGBColor & 0xFF
}

SplitARGBColor(ARGBColor, ByRef Alpha, ByRef Red, ByRef Green, ByRef Blue) {
	Alpha := ARGBColor >> 24 & 0xFF
    ,Red    := ARGBColor >> 16 & 0xFF
    ,Green := ARGBColor >> 8 & 0xFF
    ,Blue  := ARGBColor & 0xFF
}

settings_gui() {
	Global
	if !_ImGui_PeekMsg()
		ExitApp
	_ImGui_BeginFrame()
	_ImGui_Begin("Setting")
	_ImGui_SetWindowPos(0, 0)
	_ImGui_SetWindowSize(NumGet(rc, 8, "int"), NumGet(rc, 12, "int"))

	_ImGui_BeginTabBar("setting tab")
	if _ImGui_BeginTabItem("visuals") {
		_ImGui_NewLine()
		_ImGui_Columns(2)

		_ImGui_Checkbox("Glow", enable_glow)
		_ImGui_SameLine(0, 30)
		_ImGui_Checkbox("Weapon Glow", enable_weapon_glow)
		_ImGui_BeginChild("glow_child", 320, 112, 1)
			_ImGui_Checkbox("Enemy", enable_glow_enemy)
			_ImGui_ColorEdit("enemy color", glow_enemy_color)

			_ImGui_Checkbox("Team", enable_glow_team)
			_ImGui_ColorEdit("team color", glow_team_color)
		_ImGui_EndChild()

		_ImGui_Checkbox("Chams", enable_chams)
		_ImGui_BeginChild("chams_child", 320, 162, 1)
			_ImGui_Checkbox("Enemy", enable_chams_enemy)
			_ImGui_ColorEdit("enemy color", chams_enemy_color)

			_ImGui_Checkbox("Team", enable_chams_team)
			_ImGui_ColorEdit("team color", chams_team_color)

			_ImGui_Checkbox("Local", enable_chams_local)
			_ImGui_ColorEdit("local color", chams_local_color)
		_ImGui_EndChild()

		_ImGui_Checkbox("Model Brightness", enable_model_brightness)
		_ImGui_BeginChild("model_brightness_child", 320, 37, 1)
			_ImGui_SliderFloat("brightness", model_brightness_value, 0, 100)
		_ImGui_EndChild()

		_ImGui_NextColumn()
		_ImGui_Checkbox("FOV Changer", enable_fov_changer)
		_ImGui_BeginChild("FOV_Changer_child", 320, 37, 1)
			_ImGui_SliderInt("FOV", fov_changer_value, 30, 150)
		_ImGui_EndChild()
		
		_ImGui_Checkbox("Anti Flash", enable_anti_flash)

		_ImGui_Checkbox("No Smoke", enable_no_smoke)

		_ImGui_Checkbox("Remove Hands", enable_remove_hands)

		_ImGui_Checkbox("Radar reveal", enable_radar_reveal)

		_ImGui_Checkbox("Force Crosshair", enable_force_crosshair)

		_ImGui_Checkbox("Grenade Prediction", enable_grenade_prediction)

		_ImGui_Checkbox("Disable Post-Processing", enable_disable_Post_Processing)

		_ImGui_Checkbox("Bullet Impacts", enable_bullet_impacts)

	_ImGui_EndTabItem()
	}
	_ImGui_Columns(1)
	if _ImGui_BeginTabItem("misc") {
		_ImGui_NewLine()
		_ImGui_Columns(2)
		
		_ImGui_Checkbox("Auto Bhop", enable_auto_bhop)

		_ImGui_Checkbox("Auto Pistol", enable_auto_pistol)

		_ImGui_Checkbox("Auto Reload", enable_auto_reload)

		_ImGui_Checkbox("CrosshairID Team Check", enable_team_check)

		_ImGui_SliderInt("RCS", rcs_value, 0, 100)


	_ImGui_EndTabItem()
	}
	_ImGui_Columns(1)
	if _ImGui_BeginTabItem("debug") {
		_ImGui_NewLine()
		_ImGui_Checkbox("Don't render the settings window when in the background", enable_dont_render)

		_ImGui_Text("LocalPlayer : " . LocalPlayer)
		_ImGui_Text("current weapon entity : " . WeaponEntity)
		_ImGui_Text("current weapon index : " . WeaponIndex)

		_ImGui_Text("Loop timer : " . LoopTimer . " ms")

		

		

	}
	_ImGui_EndTabBar()

	



	_ImGui_End()
	_ImGui_EndFrame(0xFF000000)
}
