#Include <classMemory>
#Include <csgo offsets>
#NoEnv
#Persistent
#SingleInstance, Force
SetKeyDelay,-1, 1
SetControlDelay, -1
SetMouseDelay, -1
SendMode Input
SetBatchLines,-1
ListLines, Off

if !Read_csgo_offsets_from_hazedumper() {
	MsgBox, 48, Error!, Failed to get csgo offsets
    ExitApp
}

if (_ClassMemory.__Class != "_ClassMemory") {
    msgbox class memory not correctly installed. Or the (global class) variable "_ClassMemory" has been overwritten
    ExitApp
}

Process, Wait, csgo.exe
Global csgo := new _ClassMemory("ahk_exe csgo.exe", "", hProcessCopy)
Global client := csgo.getModuleBaseAddress("client.dll")
Global engine := csgo.getModuleBaseAddress("engine.dll")

SetFormat, integer, H
Loop {
	while IsInGame() {
		glowobj := GetGlowObj()
		LocalPlayer := new Entity(GetLocalPlayer())
		Loop 64 {
			dwEntity := new Entity(GetEntity(A_index))
			;msgbox % dwEntity.dwEntity
			if (dwEntity.dwEntity=0 || dwEntity.dwEntity=LocalPlayer.dwEntity || !dwEntity.IsAlive || dwEntity.Dormant)
				Continue

			if !LocalPlayer.Dormant {
				if (LocalPlayer.Team != dwEntity.Team)  {
					Glow(glowobj, dwEntity.GlowIndex, 240, 0, 0, 180)
				} else {
					Glow(glowobj, dwEntity.GlowIndex, 0, 0, 240, 180)
				}
			} else {
				Glow(glowobj, dwEntity.GlowIndex, 240, 240, 240, 180)
			}
		}
	}
	Sleep 10
}

Class Entity {
	__New(dwEntity) {
		this.dwEntity  := dwEntity
		this.Health    := csgo.read(dwEntity + m_iHealth, "Uint")
		this.Team      := csgo.read(dwEntity + m_iTeamNum, "Uint")
		this.GlowIndex := csgo.read(dwEntity + m_iGlowIndex, "Uint")
		this.Dormant   := csgo.read(dwEntity + m_bDormant, "Uint")
		this.IsAlive   := this.Health>0 && this.Health<=100
	}
}

GetLocalPlayer() {
	Return csgo.read(client + dwLocalPlayer, "Uint")
}

GetEntity(index) {
	Return csgo.read(client + dwEntityList + index * 0x10, "Uint")
}

GetGlowObj() {
	Return csgo.read(client + dwGlowObjectManager, "Uint")
}

IsInGame() {
	Return csgo.read(engine + dwClientState, "Uint", dwClientState_State)=6
}

Glow(glowObj, glowInd, r, g, b, a) {
	csgo.write(glowObj+(glowInd*0x38)+0x8, r/255, "Float")
	,csgo.write(glowObj+(glowInd*0x38)+0xC, g/255, "Float")
	,csgo.write(glowObj+(glowInd*0x38)+0x10, b/255, "Float")
	,csgo.write(glowObj+(glowInd*0x38)+0x14, a/255, "Float")
	,csgo.write(glowObj+(glowInd*0x38)+0x28, 1, "UChar")
	,csgo.write(glowObj+(glowInd*0x38)+0x29, 0, "UChar")
}
