if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Base 						= "weapon_vj_npccontroller"
SWEP.PrintName					= "Possessor"
SWEP.Author 					= "Cpt. Hazama + Silverlan"
SWEP.Contact					= "http://steamcommunity.com/groups/vrejgaming"
SWEP.Purpose					= "This weapon is made to control NPCs. Mostly VJ SNPCs"
SWEP.Instructions				= "Press Fire to control the NPC you are looking at."
SWEP.Category					= "VJ Base"
	-- Client Settings ---------------------------------------------------------------------------------------------------------------------------------------------
if CLIENT then
SWEP.Slot						= 0 -- Which weapon slot you want your SWEP to be in? (1 2 3 4 5 6) 
SWEP.SlotPos					= 5 -- Which part of that slot do you want the SWEP to be in? (1 2 3 4 5 6)
SWEP.SwayScale 					= 1 -- Default is 1, The scale of the viewmodel sway
SWEP.CSMuzzleFlashes 			= false -- Use CS:S Muzzle flash?
SWEP.DrawAmmo					= false -- Draw regular Garry's Mod HUD?
SWEP.DrawCrosshair				= true -- Draw Crosshair?
SWEP.DrawWeaponInfoBox 			= true -- Should the information box show in the weapon selection menu?
SWEP.BounceWeaponIcon 			= true -- Should the icon bounce in the weapon selection menu?
SWEP.RenderGroup 				= RENDERGROUP_OPAQUE
SWEP.ViewModelFOV 				= 90
end
	-- Server Settings ---------------------------------------------------------------------------------------------------------------------------------------------
if SERVER then
SWEP.Weight						= 30 -- Decides whether we should switch from/to this
SWEP.AutoSwitchTo				= false -- Auto switch to this weapon when it's picked up
SWEP.AutoSwitchFrom				= false -- Auto switch weapon when the owner picks up a better weapon
end
	-- Main Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.ViewModel 					= "models/weapons/half-life/v_hgun.mdl"
SWEP.WorldModel 				= "models/weapons/half-life/w_hgun.mdl"
SWEP.HoldType 					= "crossbow"
SWEP.Spawnable					= true
SWEP.AdminSpawnable				= false
SWEP.UseHands 					= false

SWEP.Primary.Sound 				= {}
SWEP.WorldModel_UseCustomPosition = false
SWEP.DeploySound 				= {}