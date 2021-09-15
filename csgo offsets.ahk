#NoEnv
#SingleInstance, Force
ListLines, Off

Global timestamp
Global cs_gamerules_data
Global m_ArmorValue
Global m_Collision
Global m_CollisionGroup
Global m_Local
Global m_MoveType
Global m_OriginalOwnerXuidHigh
Global m_OriginalOwnerXuidLow
Global m_SurvivalGameRuleDecisionTypes
Global m_SurvivalRules
Global m_aimPunchAngle
Global m_aimPunchAngleVel
Global m_angEyeAnglesX
Global m_angEyeAnglesY
Global m_bBombDefused
Global m_bBombPlanted
Global m_bBombTicking
Global m_bFreezePeriod
Global m_bGunGameImmunity
Global m_bHasDefuser
Global m_bHasHelmet
Global m_bInReload
Global m_bIsDefusing
Global m_bIsQueuedMatchmaking
Global m_bIsScoped
Global m_bIsValveDS
Global m_bSpotted
Global m_bSpottedByMask
Global m_bStartedArming
Global m_bUseCustomAutoExposureMax
Global m_bUseCustomAutoExposureMin
Global m_bUseCustomBloomScale
Global m_clrRender
Global m_dwBoneMatrix
Global m_fAccuracyPenalty
Global m_fFlags
Global m_flC4Blow
Global m_flCustomAutoExposureMax
Global m_flCustomAutoExposureMin
Global m_flCustomBloomScale
Global m_flDefuseCountDown
Global m_flDefuseLength
Global m_flFallbackWear
Global m_flFlashDuration
Global m_flFlashMaxAlpha
Global m_flLastBoneSetupTime
Global m_flLowerBodyYawTarget
Global m_flNextAttack
Global m_flNextPrimaryAttack
Global m_flSimulationTime
Global m_flTimerLength
Global m_hActiveWeapon
Global m_hBombDefuser
Global m_hMyWeapons
Global m_hObserverTarget
Global m_hOwner
Global m_hOwnerEntity
Global m_hViewModel
Global m_iAccountID
Global m_iClip1
Global m_iCompetitiveRanking
Global m_iCompetitiveWins
Global m_iCrosshairId
Global m_iDefaultFOV
Global m_iEntityQuality
Global m_iFOVStart
Global m_iGlowIndex
Global m_iHealth
Global m_iItemDefinitionIndex
Global m_iItemIDHigh
Global m_iMostRecentModelBoneCounter
Global m_iObserverMode
Global m_iShotsFired
Global m_iState
Global m_iTeamNum
Global m_lifeState
Global m_nBombSite
Global m_nFallbackPaintKit
Global m_nFallbackSeed
Global m_nFallbackStatTrak
Global m_nForceBone
Global m_nTickBase
Global m_nViewModelIndex
Global m_rgflCoordinateFrame
Global m_szCustomName
Global m_szLastPlaceName
Global m_thirdPersonViewAngles
Global m_vecOrigin
Global m_vecVelocity
Global m_vecViewOffset
Global m_viewPunchAngle
Global m_zoomLevel

Global anim_overlays
Global clientstate_choked_commands
Global clientstate_delta_ticks
Global clientstate_last_outgoing_command
Global clientstate_net_channel
Global convar_name_hash_table
Global dwClientState
Global dwClientState_GetLocalPlayer
Global dwClientState_IsHLTV
Global dwClientState_Map
Global dwClientState_MapDirectory
Global dwClientState_MaxPlayer
Global dwClientState_PlayerInfo
Global dwClientState_State
Global dwClientState_ViewAngles
Global dwEntityList
Global dwForceAttack
Global dwForceAttack2
Global dwForceBackward
Global dwForceForward
Global dwForceJump
Global dwForceLeft
Global dwForceRight
Global dwGameDir
Global dwGameRulesProxy
Global dwGetAllClasses
Global dwGlobalVars
Global dwGlowObjectManager
Global dwInput
Global dwInterfaceLinkList
Global dwLocalPlayer
Global dwMouseEnable
Global dwMouseEnablePtr
Global dwPlayerResource
Global dwRadarBase
Global dwSensitivity
Global dwSensitivityPtr
Global dwSetClanTag
Global dwViewMatrix
Global dwWeaponTable
Global dwWeaponTableIndex
Global dwYawPtr
Global dwZoomSensitivityRatioPtr
Global dwbSendPackets
Global dwppDirect3DDevice9
Global find_hud_element
Global force_update_spectator_glow
Global interface_engine_cvar
Global is_c4_owner
Global m_bDormant
Global m_flSpawnTime
Global m_pStudioHdr
Global m_pitchClassPtr
Global m_yawClassPtr
Global model_ambient_min
Global set_abs_angles
Global set_abs_origin

Read_csgo_offsets_from_hazedumper() {
	whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
	whr.Open("GET", "https://raw.githubusercontent.com/frk1/hazedumper/master/csgo.toml", true)
	whr.Send()
	whr.WaitForResponse(-1)
	
	CsgoOffsets := whr.ResponseText
	if InStr(CsgoOffsets, "Not Found")
		Return False

	SetFormat, integer, H
	Loop, parse, CsgoOffsets, `n,`r
	{
		item := A_LoopField
		if !InStr(item, "=")
			Continue
		n := 1
		Loop, parse, item, =
		{
			if (n=1) {
				Str = %A_LoopField%
				n += 1
			} Else if (n=2) {
				%Str% := A_LoopField<<0
			}
		}
	}
	Return True
}
