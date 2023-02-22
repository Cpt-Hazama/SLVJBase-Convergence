AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2023 by Cpt. Hazama, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
local IsProp = VJ_IsProp
local CurTime = CurTime
local IsValid = IsValid
local GetConVar = GetConVar
local isstring = isstring
local isnumber = isnumber
local tonumber = tonumber
local math_clamp = math.Clamp
local math_rad = math.rad
local math_cos = math.cos
local math_angApproach = math.ApproachAngle
local math_angDif = math.AngleDifference
local destructibleEnts = {func_breakable=true, func_physbox=true, prop_door_rotating=true} // func_breakable_surf
local defPos = Vector(0, 0, 0)

ENT.HasMeleeAttack = false

ENT.sSoundDir = ""
ENT.fSoundPitch = 100
ENT.fSoundVolume = 100
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:EventHandle(...)
	//local event = select(1,...)
	//local arg1 = select(2,...)
	//local arg2 = select(3,...)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetNPCFaction(faction,class)
	self.VJ_NPC_Class = istable(class) && class or {class}
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnPreInitialize() -- Let's initialize SLVBase variables here and convert to VJ Base standards
	if self.OnPreInit then
		self:OnPreInit()
	end

	local skName = self.skName
	self.StartHealth = skName && GetConVar("sk_" .. skName .. "_health"):GetInt() or 1

	if self.sModel then
		self.Model = self.sModel
	end
	if self.CollisionBounds then
		self:SetCollisionBounds(self.CollisionBounds,Vector(self.CollisionBounds.x *-1,self.CollisionBounds.y *-1,0))
	end
	if self.bWander then
		self.DisableWandering = !self.bWander
	end
	if self.nHostileOnDamage then
		self.BecomeEnemyToPlayer = self.nHostileOnDamage > 0
		self.BecomeEnemyToPlayerLevel = self.nHostileOnDamage
	end
	if self.fHearDistance then
		self.InvestigateSoundDistance = self.fHearDistance /32
	end
	if self.fViewDistance then
		self.SightDistance = self.fViewDistance
	end
	if self.fViewAngle then
		self.SightAngle = self.fViewAngle
	end
	if self.iBloodType then
		local blood = self.iBloodType
		if blood == DONT_BLEED then
			self.Bleeds = false
		elseif blood == BLOOD_COLOR_RED then
			self.BloodColor = "Red"
		elseif blood == BLOOD_COLOR_YELLOW or blood == BLOOD_COLOR_ANTLION or blood == BLOOD_COLOR_ZOMBIE then
			self.BloodColor = "Yellow"
		elseif blood == BLOOD_COLOR_GREEN or blood == BLOOD_COLOR_ANTLION_WORKER then
			self.BloodColor = "Green"
		elseif blood == BLOOD_COLOR_MECH then
			self.BloodColor = "Oil"
		end
	end
	if self.bInvincible then
		self.GodMode = self.bInvincible
	end
	if self.bIgnitable then
		self.AllowIgnition = self.bIgnitable
	end
	if self.HullNav then
		self.HullType = self.HullNav
	end
	if self.tblIgnoreDamageTypes then
		self.ImmuneDamagesTable = self.tblIgnoreDamageTypes
	end
	if self.bFlinchOnDamage then
		self.CanFlinch = self.bFlinchOnDamage
	end
	if self.tblFlinchActivities then
		self.HitGroupFlinching_Values = {}
		for hitbox,anim in pairs(self.tblFlinchActivities) do
			table.insert(self.HitGroupFlinching_Values,{HitGroup = {hitbox}, Animation = {anim}})
		end
	end
	if self.bPlayDeathSequence then
		self.HasDeathAnimation = self.bPlayDeathSequence
	end
	if self.bFadeOnDeath then
		self.DeathCorpseFade = self.bFadeOnDeath
		self.DeathCorpseFadeTime = 0
	end
	if self.bRemoveOnDeath then
		self.HasDeathRagdoll = self.bRemoveOnDeath
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self.tblSounds = {}
	self.SoundTable = {}
	self.tblCSPStopOnDeath = {}

	if self.OnInit then
		self:OnInit()
	end

	for soundCategory, soundFile in pairs(self.m_tbSounds) do
		if istable(soundFile) then
			self.SoundTable[soundCategory] = self.SoundTable[soundCategory] or {}
			self.tblSounds[soundCategory] = self.tblSounds[soundCategory] or {}
			for _, soundFile in pairs(soundFile) do
				table.insert(self.SoundTable[soundCategory], soundFile)
			end
			continue
		end
		local patternStart, patternEnd, num1, num2 = string.find(soundFile, "%[(%d+)-(%d+)%]")
		if patternStart != nil and patternEnd != nil then
			local soundCount = tonumber(patternEnd - patternStart)
			local soundNameNoPattern = string.sub(soundFile, 1, patternStart-1)
			local soundExtension = string.sub(soundFile, patternEnd+1)
			for i=num1, num2 do
				local soundFileName = soundNameNoPattern .. i .. soundExtension
				self.SoundTable[soundCategory] = self.SoundTable[soundCategory] or {}
				self.tblSounds[soundCategory] = self.tblSounds[soundCategory] or {}
				table.insert(self.SoundTable[soundCategory], soundFileName)
			end
		else
			self.SoundTable[soundCategory] = self.SoundTable[soundCategory] or {}
			self.tblSounds[soundCategory] = self.tblSounds[soundCategory] or {}
			table.insert(self.SoundTable[soundCategory], soundFile)
		end
	end

	self:SetupSLVFactions()
	self:InitLimbs()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAcceptInput(cvar, activator)
	if(activator == self && string.Left(cvar,6) == "event_") then
		self:Event(string.sub(cvar,7))
		return true
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAlert(ent)
	if self.OnAlert then
		self:OnAlert(ent)
	end

	if self.tblAlertAct && #self.tblAlertAct > 0 && math.random(1,self.AlertChance or 4) == 1 then
		self:VJ_ACT_PLAYACTIVITY(self.tblAlertAct,true,false,true)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink_AIEnabled()
	self.entEnemy = self:GetEnemy()

	if self.OnThink then
		self:OnThink()
	end

	local cont = self.VJ_TheController
	if IsValid(cont) then
		self:RunAttack(IN_ATTACK, self._PossPrimaryAttack)
		self:RunAttack(IN_ATTACK2, self._PossSecondaryAttack)
		self:RunAttack(IN_RELOAD, self._PossReload)
		self:RunAttack(IN_JUMP, self._PossJump)
		self:RunAttack(IN_DUCK, self._PossDuck)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RunAttack(iKey, func)
	if !self.bInSchedule && self.VJ_TheController:KeyDown(iKey) && func then
		self.bInSchedule = true
		func(self, self.VJ_TheController, function(bFailed)
			self.bInSchedule = false
			if !bFailed && IsValid(self) then
				self:TaskComplete()
			end
		end)

		self:NextThink(CurTime() +0.02)
		return self.bInSchedule
	end
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoIdleAnimation(idleType)
	if self:GetState() == VJ_STATE_ONLY_ANIMATION_CONSTANT or self.Dead or self.VJ_IsBeingControlled or self.PlayingAttackAnimation == true or (self.NextIdleTime > CurTime()) or (self.AA_CurrentMoveTime > CurTime()) or (self.CurrentSchedule != nil && self.CurrentSchedule.Name == "vj_act_resetenemy") then return end
	idleType = idleType or 0 -- 0 = Random | 1 = Wander | 2 = Idle Stand
	
	if self.IdleAlwaysWander == true then idleType = 1 end
	
	-- Things that override can't bypass, Forces the NPC to ONLY idle stand!
	if self.DisableWandering == true or self.IsGuard == true or self.MovementType == VJ_MOVETYPE_STATIONARY or self.IsVJBaseSNPC_Tank == true or self.LastHiddenZone_CanWander == false or self.NextWanderTime > CurTime() or self.IsFollowing == true or self.Medic_Status then
		idleType = 2
	end
	
	if idleType == 0 then -- Random (Wander & Idle Stand)
		if math.random(1, 3) == 1 then
			self:VJ_TASK_IDLE_WANDER() else self:VJ_TASK_IDLE_STAND()
		end
	elseif idleType == 1 then -- Wander
		self:VJ_TASK_IDLE_WANDER()
	elseif idleType == 2 then -- Idle Stand
		self:VJ_TASK_IDLE_STAND()
		return -- Don't set self.NextWanderTime below
	end
	
	self.NextWanderTime = CurTime() +(self.iWanderDelay or math.Rand(3, 6))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CanSee(ent,yawMax,ang)
	local ang = self:GetAngleToPos(ent:GetPos(),ang)
	local yawMax = self.fViewAngle || yawMax || 90
	if(ang.y <= yawMax || ang.y >= 360 -yawMax) && self:Visible(ent) then return true end
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SLVPlayActivity(TAct,bFaceEnemy,fcDone,bDontResetAct,bDontStopMoving)
	self:VJ_ACT_PLAYACTIVITY(TAct, isbool(bDontResetAct) && !bDontResetAct or true, false, bFaceEnemy, 0,{OnFinish=fcDone})
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ChaseEnemy()
	self:VJ_TASK_CHASE_ENEMY()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Hide()
	if !self:IsBusy() then
		self:VJ_TASK_COVER_FROM_ORIGIN("TASK_RUN_PATH")
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomAttack(ene, eneVisible)
	if self.SelectScheduleHandle && !IsValid(self.VJ_TheController) then
		local dist = self.NearestPointToEnemyDistance
		self:SelectScheduleHandle(ene,dist,dist,self:Disposition(ene))
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_BeforeImmuneChecks(dmginfo, hitgroup)
	if self.OnTakeDamage_BeforeImmuneChecks then
		self:OnTakeDamage_BeforeImmuneChecks(dmginfo, hitgroup)
	end

	if self.DamageScales then
		local dmgType = dmginfo:GetDamageType()
		if self.DamageScales[dmgType] then
			if self.DamageScales[dmgType] < 0 then
				local hp = self:Health()
				local hpMax = self:GetMaxHealth()
				self:SetHealth(math.min(hp +dmginfo:GetDamage() *(self.DamageScales[dmgType] *-1),hpMax))
			end
			dmginfo:ScaleDamage(math.max(self.DamageScales[dmgType],0))
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_OnBleed(dmginfo, hitgroup)
	if self.OnTakeDamage_OnBleed then
		self:OnTakeDamage_OnBleed(dmginfo, hitgroup)
	end

	self:TakeLimbDamage(hitgroup, dmginfo:GetDamage(), dmginfo:GetAttacker())
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnPriorToKilled(dmginfo, hitgroup)
	if self.OnPriorToKilled then
		self:OnPriorToKilled(dmginfo, hitgroup)
	end

	if self.tblDeathActivities && self.HasDeathAnimation then
		local anim = self.tblDeathActivities[hitgroup]
		if anim then
			self:VJ_ACT_PLAYACTIVITY(anim,true,false,false)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetSoundEvents()
	return self.SoundTable
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetSoundLevel(vol)
	self.fSoundLevel = vol
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:slvPlaySound(sSound, bOver, bDontStop)
	if !self:GetSoundEvents()[sSound] then return end
	if !bOver then self:StopSounds() end
	self.m_tmLastSound = CurTime()
	local cspSound,_sSound = self:CreateSound(sSound,bDontStop)
	if self.fSoundLevel then
		cspSound:SetSoundLevel(self.fSoundLevel)
	end
	cspSound:Play()
	if self.fSoundPitch != 100 then cspSound:ChangePitch(self.fSoundPitch,0) end
	if self.fSoundVolume != 100 then cspSound:ChangeVolume(self.fSoundVolume,0) end
	return self.sSoundDir .. _sSound
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CreateSound(sSound,bDontStop)
	local sType = type(self:GetSoundEvents()[sSound])
	local _sSound
	if sType == "string" then _sSound = self:GetSoundEvents()[sSound]
	else _sSound = VJ_PICK(self:GetSoundEvents()[sSound]) end
	local csp = CreateSound(self, self.sSoundDir .. _sSound)
	if !bDontStop then table.insert(self.tblSounds[sSound],csp) end
	return csp,_sSound
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:EmitEventSound(sSound,vol,pitch)
	if (!self:GetSoundEvents()[sSound]) then return end
	local snd = self:GetSoundEvents()[sSound]
	self:EmitSound(self.sSoundDir .. (type(snd) == "string" && snd || snd[math.random(1,#snd)]), vol || self.fSoundVolume, pitch || self.fSoundPitch)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnRemove()
	self:CustomOnRemove()
	self.Dead = true
	if self.Medic_Status then self:DoMedicReset() end
	if self.VJTags[VJ_TAG_EATING] then self:EatingReset("Dead") end
	self:RemoveTimers()
	self:StopAllCommonSounds()
	self:StopParticles()
	self:StopSounds()
	for k, v in pairs(self.tblCSPStopOnDeath) do
		v:Stop()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:StopSoundOnDeath(csp)
	table.insert(self.tblCSPStopOnDeath, csp)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:StopSounds()
	for k, v in pairs(self.tblSounds) do
		if k != "Death" then
			for _k, _v in pairs(v) do
				_v:Stop()
			end
		end
		self.tblSounds[k] = {}
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:StopSoundPatch(sSound)
	if !self.tblSounds[sSound] then return end
	for k, v in pairs(self.tblSounds[sSound]) do
		v:Stop()
	end
	self.tblSounds[sSound] = {}
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetIdleActivity(act)
	self.bLastIdleAct = self.bLastIdleAct or nil
	if self.bLastIdleAct == act then
		return
	end
	self.bLastIdleAct = act
	self:SetIdleAnimation({act},true)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetWalkActivity(act)
	self.bLastWalkAct = self.bLastWalkAct or nil
	if self.bLastWalkAct == act then
		return
	end
	self.bLastWalkAct = act
	self.AnimTbl_Walk = {act}
	self.NextChaseTime = 0
	self.NextIdleTime = 0
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetRunActivity(act)
	self.bLastRunAct = self.bLastRunAct or nil
	if self.bLastRunAct == act then
		return
	end
	self.bLastRunAct = act
	self.AnimTbl_Run = {act}
	self.NextChaseTime = 0
	self.NextIdleTime = 0
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetMovementActivity(act)
	self:SetWalkActivity(act)
	self:SetRunActivity(act)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HandleDefaultEvents(...)
	local event = select(1,...)
	if(event == "getup") then
		return true
	end
	if(event == "play") then
		local sndEv = select(2,...)
		if(sndEv) then
			if(string.Right(sndEv,4) != ".wav") then self:slvPlaySound(sndEv)//,true,true)
			else
				local snd = self:GetSoundDir() .. sndEv
				sound.Play(snd,self:GetPos(),75,self:GetSoundPitch())
			end
		end
		return true
	end
	if(event == "emit") then
		local sndEv = select(2,...)
		if(!sndEv) then return true end
		local vol = select(3,...)
		local pitch = select(4,...)
		if(string.Right(sndEv,4) != ".wav") then
			local sndEvents = self:GetSoundEvents()
			if(!sndEvents[sndEv]) then return true end
			local sndType = type(sndEvents[sndEv])
			if(sndType == "string") then self:EmitSound(self:GetSoundDir() .. sndEvents[sndEv],vol || 75,pitch || self:GetSoundPitch())
			else self:EmitEventSound(sndEv,vol,pitch) end
		else self:EmitSound(self:GetSoundDir() .. sndEv,vol || 75,pitch || 100) end
		return true
	end
	if(event == "dropdead") then
		return true
	end
	if(event == "skin") then
		local skin = select(2,...)
		if(skin) then
			skin = tonumber(skin)
			if(skin) then self:SetSkin(skin) end
		end
		return true
	end
	if(event == "bodygroup") then
		local bgroup = select(2,...)
		local subgroup = select(3,...)
		if(bgroup && subgroup) then
			bgroup = tonumber(bgroup)
			subgroup = tonumber(subgroup)
			if(bgroup && subgroup) then
				self:SetBodygroup(bgroup,subgroup)
			end
		end
		return true
	end
	if(event == "run") then
		self:SetMovementActivity(ACT_RUN)
		return true
	end
	if(event == "activity") then
		local evAct = select(2,...)
		local act = tonumber(evAct) || _G[evAct]
		if(act) then self:SLVPlayActivity(act) end
		return true
	end
	if(event == "resetactivity") then
		self:ResetActivity()
		return true
	end
	if(event == "task") then
		local task = select(2,...)
		local act = select(3,...)
		self:StartEngineTask(GetTaskID(task),_G[act])
		return true
	end
	if(event == "stopparticles") then
		self:StopParticles()
		return true
	end
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
local argsDef = {}
function ENT:Event(strEv)
	local sp = string.find(strEv,"%s")
	local evEnd = sp || string.find(strEv,"$")
	local event = string.Left(strEv,evEnd -1)
	local args
	if(sp) then
		args = string.sub(strEv,sp +1)
		args = string.Explode(",",args)
	else args = argsDef end
	//print("Handling event '" .. event .. "'" .. (args && ("('" .. table.concat(args,"','") .. "')") || "") .. " for " .. tostring(self) .. "...")
	if(!self:EventHandle(event,unpack(args)) && !self:HandleDefaultEvents(event,unpack(args))) then
		MsgN("WARNING: Unhandled animation event '" .. event .. "'" .. (args && ("('" .. table.concat(args,"','") .. "')") || "") .. " for " .. tostring(self))
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetPredictedEnemyPosition(flDelta)
	if(!IsValid(self.entEnemy)) then return false end
	return self.entEnemy:GetCenter() +self.entEnemy:GetVelocity() *(flDelta || 0.5)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SLV_IsPossesed()
	return IsValid(self.VJ_TheController)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetPossessor()
	return self.VJ_TheController
end
---------------------------------------------------------------------------------------------------------------------------------------------
local math_cos = math.cos
local math_sin = math.sin
local math_rad = math.rad
--
function ENT:DealMeleeDamage(dist,dmg,viewPunch,force,dmgType,fcFilter,bDontPlayDefSounds,bFullRot,fcOnHit)
	if self.Dead or self.Flinching then return end
	local curEnemy = customEnt or self:GetEnemy()
	self:CustomOnMeleeAttack_BeforeChecks()
	local myPos = self:GetPos()
	local hitRegistered = false
	if force then
		local forward,right,up = self:GetForward(),self:GetRight(),self:GetUp()
		force = forward *force.x +right *force.y +up *force.z
	end
	for _, v in ipairs(ents.FindInSphere(self:GetMeleeAttackDamageOrigin(), dist)) do
		if (self.VJ_IsBeingControlled && self.VJ_TheControllerBullseye == v) or (v:IsPlayer() && v.IsControlingNPC == true) then continue end
		if v != self && v:GetClass() != self:GetClass() && (((v:IsNPC() or (v:IsPlayer() && v:Alive() && !VJ_CVAR_IGNOREPLAYERS)) && self:Disposition(v) != D_LI) or IsProp(v) == true or v:GetClass() == "func_breakable_surf" or destructibleEnts[v:GetClass()] or v.VJ_AddEntityToSNPCAttackList == true or (!fcFilter || fcFilter(v))) && self:GetSightDirection():Dot((Vector(v:GetPos().x, v:GetPos().y, 0) - Vector(myPos.x, myPos.y, 0)):GetNormalized()) > math_cos(math_rad(bFullRot && 180 or self.MeleeAttackDamageAngleRadius)) then
			local vProp = IsProp(v)
			if self:CustomOnMeleeAttack_AfterChecks(v, vProp) == true then continue end

			if vProp then
				local phys = v:GetPhysicsObject()
				if IsValid(phys) && self:DoPropAPCheck({v}, dist) then
					hitRegistered = true
					phys:EnableMotion(true)
					phys:Wake()
					constraint.RemoveConstraints(v, "Weld")
					if self.PushProps then
						phys:ApplyForceCenter((curEnemy != nil and curEnemy:GetPos() or myPos) + self:GetForward()*(phys:GetMass() * 700) + self:GetUp()*(phys:GetMass() * 200))
					end
				end
			end

			local applyDmg = DamageInfo()
			applyDmg:SetDamage(self:VJ_GetDifficultyValue(dmg))
			applyDmg:SetDamageType(dmgType or DMG_SLASH)
			applyDmg:SetDamagePosition(v:NearestPoint(self:GetCenter()))
			applyDmg:SetDamageForce(force or self:GetForward() * ((applyDmg:GetDamage() + 100) * 70))
			applyDmg:SetInflictor(self)
			applyDmg:SetAttacker(self)
			if(fcOnHit) then
				fcOnHit(v,dmgInfo)
			end
			v:TakeDamageInfo(applyDmg, self)
			if v:IsPlayer() then
				v:ViewPunch(viewPunch or Angle(math.random(-1, 1) *dmg, math.random(-1, 1) *dmg, math.random(-1, 1) *dmg))
			end
			VJ_DestroyCombineTurret(self,v)

			if !vProp then
				hitRegistered = true
			end
		end
	end
	if hitRegistered == true then
		self:PlaySoundSystem("MeleeAttack")
	else
		self:CustomOnMeleeAttack_Miss()
		self:PlaySoundSystem("MeleeAttackMiss", {}, VJ_EmitSound)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DealFlameDamage(dist,dmg,attacker,fcOnHit)
	local dist = dist or self.fRangeDistance
	local dmg = dmg or GetConVar("sk_" .. self.skName .. "_dmg_flame"):GetInt()
	local posDmg = self:GetPos() +(self:GetForward() *self:OBBMaxs().y)
	for _, v in ipairs(ents.FindInSphere(posDmg, dist)) do
		if (self.VJ_IsBeingControlled && self.VJ_TheControllerBullseye == v) or (v:IsPlayer() && v.IsControlingNPC == true) then continue end
		if v != self && v:GetClass() != self:GetClass() && (((v:IsNPC() or (v:IsPlayer() && v:Alive() && !VJ_CVAR_IGNOREPLAYERS)) && self:Disposition(v) != D_LI) or IsProp(v) == true or v:GetClass() == "func_breakable_surf" or destructibleEnts[v:GetClass()] or v.VJ_AddEntityToSNPCAttackList == true or (!fcFilter || fcFilter(v))) && self:GetSightDirection():Dot((Vector(v:GetPos().x, v:GetPos().y, 0) - Vector(myPos.x, myPos.y, 0)):GetNormalized()) > math_cos(math_rad(bFullRot && 180 or self.MeleeAttackDamageAngleRadius)) then
			if !v:IsOnFire() then
				v:Ignite(6,0)
			end
			local dmginfo = DamageInfo()
			dmginfo:SetDamageType(DMG_BURN)
			dmginfo:SetDamage(dmg)
			dmginfo:SetAttacker(attacker or self)
			dmginfo:SetInflictor(self)
			v:TakeDamageInfo(dmginfo)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Limbs = {
	[HITBOX_RIGHTARM] = "Right Arm",
	[HITBOX_LEFTLEG] = "Left Leg",
	[HITBOX_HEAD] = "Head",
	[HITBOX_RIGHTLEG] = "Right Leg",
	[HITBOX_LEFTARM] = "Left Arm",
	[HITBOX_STOMACH] = HITBOX_CHEST,
	[HITBOX_CHEST] = "Torso"
}
--
function ENT:InitLimbs()
	local limbs = self.Limbs
	self.Limbs = {}
	local hpMax = self:Health()
	local health = hpMax *math.Clamp((((2500 -hpMax) /2500) *0.25),0.1,0.25)
	for hitbox, limbName in pairs(limbs) do
		if type(limbName) == "number" then
			self.Limbs[hitbox] = {
				parent = limbName
			}
		else
			self.Limbs[hitbox] = {
				name = limbName,
				health = health
			}
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:LimbCrippled(hitbox)
	return self.Limbs[hitbox] && self.Limbs[hitbox].health == 0 && true || false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnLimbCrippled(hitbox, attacker)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CrippleLimb(hitgroup,attacker)
	local limb = self.Limbs[hitgroup]
	if(limb) then
		local hg = hitgroup
		if(limb.parent) then hg = limb.parent; limb = self.Limbs[limb.parent] end
		if(limb.health > 0) then
			limb.health = 0
			gamemode.Call("OnEntityLimbCrippled",self,hg,attacker)
			self:OnLimbCrippled(hg,attacker)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:TakeLimbDamage(hitgroup, dmg, attacker)
	local bCrippled
	local limb = self.Limbs[hitgroup]
	if limb then
		local hg = hitgroup
		if limb.parent then hg = limb.parent; limb = self.Limbs[limb.parent] end
		if limb.health > 0 then
			local health = math.max(limb.health -dmg, 0)
			self.Limbs[hg].health = health
			if health == 0 then
				gamemode.Call("OnEntityLimbCrippled",self,hg,attacker)
				bCrippled = true
				self:OnLimbCrippled(hg,attacker)
			end
		end
	end
	return bCrippled || false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetLimbName(hitgroup)
	return self.Limbs[hitgroup].name
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:TurnToTarget(ent,deg)
	self:FaceCertainEntity(ent, true)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnFlinch_AfterFlinch(dmginfo, hitgroup)
	if self.OnFlinch then
		self:OnFlinch(dmginfo, hitgroup)
	end

	self:Interrupt()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:_PossScheduleDone()
	self.bInSchedule = false
	self:StartEngineTask(GetTaskID("TASK_SET_ACTIVITY"),ACT_IDLE)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Interrupt()
	if self.actReset then
		self:SetMovementActivity(self.actReset)
		self.actReset = nil
	end
	if self:SLV_IsPossesed() then
		self:StartEngineTask(GetTaskID("TASK_SET_ACTIVITY"),ACT_IDLE)
	end
	self.bInSchedule = false
	if self.OnInterrupt then
		self:OnInterrupt()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Controller_Initialize(ply, controlEnt)
	if self.OnControlled then
		self:OnControlled(ply, controlEnt)
	end

	self:Interrupt()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetMovementVelocity()
	return self:GetMoveVelocity()
end