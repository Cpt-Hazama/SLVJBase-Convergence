/*--------------------------------------------------
	=============== Autorun File ===============
	*** Copyright (c) 2023 by Cpt. Hazama, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
------------------ Addon Information ------------------
local AddonName = "SLVJBase"
local PublicAddonName = "SLVJBase - A Convergence of Two Bases"
local AddonType = "Base"
local AutorunFile = "autorun/!vj_slvbase_autorun.lua"
-------------------------------------------------------
local VJExists = file.Exists("lua/autorun/vj_base_autorun.lua","GAME")
if VJExists == true then
	include('autorun/vj_controls.lua')

    game.AddParticles("particles/centaur_spit.pcf")
    game.AddParticles("particles/slv_explosion.pcf")
    for _, particle in pairs({
            "svl_explosion",
            "blood_impact_red_01",
            "blood_impact_yellow_01",
            "blood_impact_green_01",
            "blood_impact_blue_01"
        }) do
        PrecacheParticleSystem(particle)
    end

    HITBOX_GENERIC = 100
    HITBOX_HEAD = 101
    HITBOX_CHEST = 102
    HITBOX_STOMACH = 103
    HITBOX_LEFTARM = 104
    HITBOX_RIGHTARM = 105
    HITBOX_LEFTLEG = 106
    HITBOX_RIGHTLEG = 107
    HITBOX_GEAR = 108
    HITBOX_ADDLIMB = 109
    HITBOX_ADDLIMB2 = 110

    NPC_STATE_LOST = 8

    local TaskList = {
        ["TASK_INVALID"] = 0,
        ["TASK_RESET_ACTIVITY"] = 1,
        ["TASK_WAIT"] = 2,
        ["TASK_ANNOUNCE_ATTACK"] = 3,
        ["TASK_WAIT_FACE_ENEMY"] = 4,
        ["TASK_WAIT_FACE_ENEMY_RANDOM"] = 5,
        ["TASK_WAIT_PVS"] = 6,
        ["TASK_SUGGEST_STATE"] = 7,
        ["TASK_TARGET_PLAYER"] = 8,
        ["TASK_SCRIPT_WALK_TO_TARGET"] = 9,
        ["TASK_SCRIPT_RUN_TO_TARGET"] = 10,
        ["TASK_SCRIPT_CUSTOM_MOVE_TO_TARGET"] = 11,
        ["TASK_MOVE_TO_TARGET_RANGE"] = 12,
        ["TASK_MOVE_TO_GOAL_RANGE"] = 13,
        ["TASK_MOVE_AWAY_PATH"] = 14,
        ["TASK_GET_PATH_AWAY_FROM_BEST_SOUND"] = 15,
        ["TASK_SET_GOAL"] = 16,
        ["TASK_GET_PATH_TO_GOAL"] = 17,
        ["TASK_GET_PATH_TO_ENEMY"] = 18,
        ["TASK_GET_PATH_TO_ENEMY_LKP"] = 19,
        ["TASK_GET_CHASE_PATH_TO_ENEMY"] = 20,
        ["TASK_GET_PATH_TO_ENEMY_LKP_LOS"] = 21,
        ["TASK_GET_PATH_TO_ENEMY_CORPSE"] = 22,
        ["TASK_GET_PATH_TO_PLAYER"] = 23,
        ["TASK_GET_PATH_TO_ENEMY_LOS"] = 24,
        ["TASK_GET_FLANK_RADIUS_PATH_TO_ENEMY_LOS"] = 25,
        ["TASK_GET_FLANK_ARC_PATH_TO_ENEMY_LOS"] = 26,
        ["TASK_GET_PATH_TO_RANGE_ENEMY_LKP_LOS"] = 27,
        ["TASK_GET_PATH_TO_TARGET"] = 28,
        ["TASK_GET_PATH_TO_TARGET_WEAPON"] = 29,
        ["TASK_CREATE_PENDING_WEAPON"] = 30,
        ["TASK_GET_PATH_TO_HINTNODE"] = 31,
        ["TASK_STORE_LASTPOSITION"] = 32,
        ["TASK_CLEAR_LASTPOSITION"] = 33,
        ["TASK_STORE_POSITION_IN_SAVEPOSITION"] = 34,
        ["TASK_STORE_BESTSOUND_IN_SAVEPOSITION"] = 35,
        ["TASK_STORE_BESTSOUND_REACTORIGIN_IN_SAVEPOSITION"] = 36,
        ["TASK_REACT_TO_COMBAT_SOUND"] = 37,
        ["TASK_STORE_ENEMY_POSITION_IN_SAVEPOSITION"] = 38,
        ["TASK_GET_PATH_TO_COMMAND_GOAL"] = 39,
        ["TASK_MARK_COMMAND_GOAL_POS"] = 40,
        ["TASK_CLEAR_COMMAND_GOAL"] = 41,
        ["TASK_GET_PATH_TO_LASTPOSITION"] = 42,
        ["TASK_GET_PATH_TO_SAVEPOSITION"] = 43,
        ["TASK_GET_PATH_TO_SAVEPOSITION_LOS"] = 44,
        ["TASK_GET_PATH_TO_RANDOM_NODE"] = 45,
        ["TASK_GET_PATH_TO_BESTSOUND"] = 46,
        ["TASK_GET_PATH_TO_BESTSCENT"] = 47,
        ["TASK_RUN_PATH"] = 48,
        ["TASK_WALK_PATH"] = 49,
        ["TASK_WALK_PATH_TIMED"] = 50,
        ["TASK_WALK_PATH_WITHIN_DIST"] = 51,
        ["TASK_WALK_PATH_FOR_UNITS"] = 52,
        ["TASK_RUN_PATH_FLEE"] = 53,
        ["TASK_RUN_PATH_TIMED"] = 54,
        ["TASK_RUN_PATH_FOR_UNITS"] = 55,
        ["TASK_RUN_PATH_WITHIN_DIST"] = 56,
        ["TASK_STRAFE_PATH"] = 57,
        ["TASK_CLEAR_MOVE_WAIT"] = 58,
        ["TASK_SMALL_FLINCH"] = 59,
        ["TASK_BIG_FLINCH"] = 60,
        ["TASK_DEFER_DODGE"] = 61,
        ["TASK_FACE_IDEAL"] = 62,
        ["TASK_FACE_REASONABLE"] = 63,
        ["TASK_FACE_PATH"] = 64,
        ["TASK_FACE_PLAYER"] = 65,
        ["TASK_FACE_ENEMY"] = 66,
        ["TASK_FACE_HINTNODE"] = 67,
        ["TASK_PLAY_HINT_ACTIVITY"] = 68,
        ["TASK_FACE_TARGET"] = 69,
        ["TASK_FACE_LASTPOSITION"] = 70,
        ["TASK_FACE_SAVEPOSITION"] = 71,
        ["TASK_FACE_AWAY_FROM_SAVEPOSITION"] = 72,
        ["TASK_SET_IDEAL_YAW_TO_CURRENT"] = 73,
        ["TASK_RANGE_ATTACK1"] = 74,
        ["TASK_RANGE_ATTACK2"] = 75,
        ["TASK_MELEE_ATTACK1"] = 76,
        ["TASK_MELEE_ATTACK2"] = 77,
        ["TASK_RELOAD"] = 78,
        ["TASK_SPECIAL_ATTACK1"] = 79,
        ["TASK_SPECIAL_ATTACK2"] = 80,
        ["TASK_FIND_HINTNODE"] = 81,
        ["TASK_FIND_LOCK_HINTNODE"] = 82,
        ["TASK_CLEAR_HINTNODE"] = 83,
        ["TASK_LOCK_HINTNODE"] = 84,
        ["TASK_SOUND_ANGRY"] = 85,
        ["TASK_SOUND_DEATH"] = 86,
        ["TASK_SOUND_IDLE"] = 87,
        ["TASK_SOUND_WAKE"] = 88,
        ["TASK_SOUND_PAIN"] = 89,
        ["TASK_SOUND_DIE"] = 90,
        ["TASK_SPEAK_SENTENCE"] = 91,
        ["TASK_WAIT_FOR_SPEAK_FINISH"] = 92,
        ["TASK_SET_ACTIVITY"] = 93,
        ["TASK_RANDOMIZE_FRAMERATE"] = 94,
        ["TASK_SET_SCHEDULE"] = 95,
        ["TASK_SET_FAIL_SCHEDULE"] = 96,
        ["TASK_SET_TOLERANCE_DISTANCE"] = 97,
        ["TASK_SET_ROUTE_SEARCH_TIME"] = 98,
        ["TASK_CLEAR_FAIL_SCHEDULE"] = 99,
        ["TASK_PLAY_SEQUENCE"] = 100,
        ["TASK_PLAY_PRIVATE_SEQUENCE"] = 101,
        ["TASK_PLAY_PRIVATE_SEQUENCE_FACE_ENEMY"] = 102,
        ["TASK_PLAY_SEQUENCE_FACE_ENEMY"] = 103,
        ["TASK_PLAY_SEQUENCE_FACE_TARGET"] = 104,
        ["TASK_FIND_COVER_FROM_BEST_SOUND"] = 105,
        ["TASK_FIND_COVER_FROM_ENEMY"] = 106,
        ["TASK_FIND_LATERAL_COVER_FROM_ENEMY"] = 107,
        ["TASK_FIND_BACKAWAY_FROM_SAVEPOSITION"] = 108,
        ["TASK_FIND_NODE_COVER_FROM_ENEMY"] = 109,
        ["TASK_FIND_NEAR_NODE_COVER_FROM_ENEMY"] = 110,
        ["TASK_FIND_FAR_NODE_COVER_FROM_ENEMY"] = 111,
        ["TASK_FIND_COVER_FROM_ORIGIN"] = 112,
        ["TASK_DIE"] = 113,
        ["TASK_WAIT_FOR_SCRIPT"] = 114,
        ["TASK_PUSH_SCRIPT_ARRIVAL_ACTIVITY"] = 115,
        ["TASK_PLAY_SCRIPT"] = 116,
        ["TASK_PLAY_SCRIPT_POST_IDLE"] = 117,
        ["TASK_ENABLE_SCRIPT"] = 118,
        ["TASK_PLANT_ON_SCRIPT"] = 119,
        ["TASK_FACE_SCRIPT"] = 120,
        ["TASK_PLAY_SCENE"] = 121,
        ["TASK_WAIT_RANDOM"] = 122,
        ["TASK_WAIT_INDEFINITE"] = 123,
        ["TASK_STOP_MOVING"] = 124,
        ["TASK_TURN_LEFT"] = 125,
        ["TASK_TURN_RIGHT"] = 126,
        ["TASK_REMEMBER"] = 127,
        ["TASK_FORGET"] = 128,
        ["TASK_WAIT_FOR_MOVEMENT"] = 129,
        ["TASK_WAIT_FOR_MOVEMENT_STEP"] = 130,
        ["TASK_WAIT_UNTIL_NO_DANGER_SOUND"] = 131,
        ["TASK_WEAPON_FIND"] = 132,
        ["TASK_WEAPON_PICKUP"] = 133,
        ["TASK_WEAPON_RUN_PATH"] = 134,
        ["TASK_WEAPON_CREATE"] = 135,
        ["TASK_ITEM_PICKUP"] = 136,
        ["TASK_ITEM_RUN_PATH"] = 137,
        ["TASK_USE_SMALL_HULL"] = 138,
        ["TASK_FALL_TO_GROUND"] = 139,
        ["TASK_WANDER"] = 140,
        ["TASK_FREEZE"] = 141,
        ["TASK_GATHER_CONDITIONS"] = 142,
        ["TASK_IGNORE_OLD_ENEMIES"] = 143,
        ["TASK_DEBUG_BREAK"] = 144,
        ["TASK_ADD_HEALTH"] = 145,
        ["TASK_ADD_GESTURE_WAIT"] = 146,
        ["TASK_ADD_GESTURE"] = 147,
        ["TASK_GET_PATH_TO_INTERACTION_PARTNER"] = 148,
        ["TASK_PRE_SCRIPT"] = 149,
    }

    GetTaskList = function(name) return TaskList[name] or TaskList[0] end
    GetTaskID = GetTaskList

    local ENTITY = FindMetaTable("Entity")
    local NPC = FindMetaTable("NPC")
    local WEAPON = FindMetaTable("Weapon")
    local PLAYER = FindMetaTable("Player")
    local VECTOR = FindMetaTable("Vector")
    local ANGLE = FindMetaTable("Angle")

    function table.refresh(tbl)
        table.MakeSequential(tbl)
    end

    function table.MakeSequential(tbl)
        local i = 1
        for ind, _ in pairs(tbl) do
            if ind > i then tbl[i] = tbl[ind]; tbl[ind] = nil end
            i = i +1
        end
    end

    function util.IsInWater(vecPos)
        return util.TraceLine({start = vecPos +Vector(0,0,32768), endpos = vecPos, mask = MASK_WATER}).Hit
    end

    function ENTITY:GetCenter()
        return self:GetPos() +self:OBBCenter()
    end

    function ENTITY:GetAngleToPos(pos, _ang, bDontClamp)
        local _pos
        if self:IsPlayer() then
            _pos = self:GetShootPos()
            if !_ang then
                _ang = self:GetAimVector():Angle()
            end
        else
            _ang = _ang || self:GetAngles()
            _pos = self:GetPos()
        end
        local ang = _ang -(pos -_pos):Angle()
        if !bDontClamp then ang:Clamp() end
        return ang
    end

    function ENTITY:FindInCone(deg,dist,filter)
        local pos = self.GetShootPos && self:GetShootPos() || (self:GetPos() +self:OBBCenter())
        local dir = self.GetAimVector && self:GetAimVector() || self:GetForward()
        local ang = dir:Angle()
        local tbEnts = {}
        for _, ent in ipairs(ents.FindInSphere(pos,dist)) do
            if(ent:IsValid() && !filter || filter(ent)) then
                local posTgt = ent:NearestPoint(pos)
                local ang = ang -(posTgt -pos):Angle()
                while(ang.p < 0) do ang.p = ang.p +360 end
                while(ang.y < 0) do ang.y = ang.y +360 end
                while(ang.p > 360) do ang.p = ang.p -360 end
                while(ang.y > 360) do ang.y = ang.y -360 end
                if(ang.p <= deg || ang.p >= 360 -deg) && (ang.y <= deg || ang.y >= 360 -deg) then
                    table.insert(tbEnts,ent)
                end
            end
        end
        return tbEnts
    end

    function ANGLE:Normalize()
        return Angle(math.NormalizeAngle(self.p), math.NormalizeAngle(self.y), math.NormalizeAngle(self.r))
    end

    function ANGLE:Clamp()
        while self.p < 0 do self.p = self.p +360 end
        while self.y < 0 do self.y = self.y +360 end
        while self.r < 0 do self.r = self.r +360 end
        
        while self.p > 360 do self.p = self.p -360 end
        while self.y > 360 do self.y = self.y -360 end
        while self.r > 360 do self.r = self.r -360 end
    end

    function VECTOR:ClampToDir(dirTgt,flTolerance)
        self.x = math.Clamp(self.x,dirTgt.x -flTolerance,dirTgt.x +flTolerance)
        self.y = math.Clamp(self.y,dirTgt.y -flTolerance,dirTgt.y +flTolerance)
        self.z = math.Clamp(self.z,dirTgt.z -flTolerance,dirTgt.z +flTolerance)
    end

    function util.CalcArcVelocity(ent,vecSpot1,vecSpot2,flSpeed,flTolerance,bIgnoreObstacles)
        flTolerance = flTolerance || 0
        flSpeed = math.max(flSpeed,1)
        local flGravity = GetConVar("sv_gravity"):GetInt()
        local vecVel = (vecSpot2 -vecSpot1)
        local time = vecVel:Length() /flSpeed
        vecVel = vecVel *(1 /time)
        vecVel.z = vecVel.z +flGravity *time *0.5
        
        local vecApex = vecSpot1 +(vecSpot2 -vecSpot1) *0.5
        vecApex.z = vecApex.z +0.5 *flGravity *(time *0.5) *(time *0.5)
        
        if(!bIgnoreObstacles) then
            local filter = {ent,ent:GetOwner()}
            local tr = util.TraceLine({
                start = vecSpot1,
                endpos = vecApex,
                mask = MASK_SOLID,
                filter = filter
            })
            if(tr.Fraction <= 0.9) then return vector_origin end
            local tr = util.TraceLine({
                start = vecApex,
                endpos = vecSpot2,
                mask = MASK_SOLID_BRUSHONLY,
                filter = filter
            })
            if(tr.Fraction <= 0.8) then
                local bFail = true
                if(flTolerance > 0) then
                    local flNearness = (tr.endpos -vecSpot2):LengthSqr()
                    if(flNearness < flTolerance ^2) then
                        bFail = false
                    end
                end
                if(bFail) then return vector_origin end
            end
        end
        return vecVel
    end

    function ENTITY:OBBDistance(ent)
        local posTarget = ent:NearestPoint(self:GetPos() +ent:OBBCenter())
        local posSelf = self:NearestPoint(ent:GetPos() +self:OBBCenter())
        posTarget.z = ent:GetPos().z
        posSelf.z = self:GetPos().z
        return posSelf:Distance(posTarget)
    end

    local tblEntsNoCollide = {}
    local tblEntsNoCollideByClass = {}
    hook.Add("OnEntityCreated", "HLR_Collisions_EntCheckForClass", function(entA)
        timer.Simple(0, function()
            if IsValid(entA) then
                local sClass = entA.ClassName || entA:GetClass()
                for entB, tbl in pairs(tblEntsNoCollideByClass) do
                    if IsValid(entB) then
                        if tbl[sClass] then
                            entB:NoCollide(entA)
                        end
                    else tblEntsNoCollideByClass[entB] = nil end
                end
            end
        end)
    end)

    function ENTITY:NoCollide(ent)
        tblEntsNoCollide[self] = tblEntsNoCollide[self] || {}
        if type(ent) != "string" then
            if tblEntsNoCollide[self][ent] then return end
            tblEntsNoCollide[self][ent] = true
            
            if CLIENT then return end
            local rp = RecipientFilter()
            rp:AddAllPlayers()
            
            umsg.Start("HLR_EntsCollide", rp)
                umsg.Entity(self)
                umsg.Entity(ent)
                umsg.Bool(false)
            umsg.End()
            return
        end
        if tblEntsNoCollideByClass[self] && tblEntsNoCollideByClass[self][ent] then return end
        for _, ent in pairs(ents.FindByClass(ent)) do
            tblEntsNoCollide[self][ent] = true
        end
        for ent, _ in pairs(tblEntsNoCollide[self]) do if !IsValid(ent) then tblEntsNoCollide[self][ent] = nil end end
        if table.Count(tblEntsNoCollide[self]) == 0 then tblEntsNoCollide[self] = nil end
        tblEntsNoCollideByClass[self] = tblEntsNoCollideByClass[self] || {}
        tblEntsNoCollideByClass[self][ent] = true
        
        if CLIENT then return end
        umsg.Start("HLR_EntsCollideClass")
            umsg.Entity(self)
            umsg.String(ent)
            umsg.Bool(false)
        umsg.End()
    end

    function ENTITY:Collide(ent)
        if type(ent) == "string" then
            if tblEntsNoCollide[self] then
                for _ent, _ in pairs(tblEntsNoCollide[self]) do
                    if IsValid(_ent) && _ent:GetClass() == ent then
                        tblEntsNoCollide[self][_ent] = nil
                    end
                end
                for ent, _ in pairs(tblEntsNoCollide[self]) do if !IsValid(ent) then tblEntsNoCollide[self][ent] = nil end end
                if table.Count(tblEntsNoCollide[self]) == 0 then tblEntsNoCollide[self] = nil end
            end
            if tblEntsNoCollideByClass[self] then
                tblEntsNoCollideByClass[self][ent] = nil
                if table.Count(tblEntsNoCollideByClass[self]) == 0 then tblEntsNoCollideByClass[self] = nil end
            end
            if CLIENT then return end
            umsg.Start("HLR_EntsCollideClass")
                umsg.Entity(self)
                umsg.String(ent)
                umsg.Bool(true)
            umsg.End()
            return
        end
        if tblEntsNoCollide[self] then for ent, _ in pairs(tblEntsNoCollide[self]) do if !IsValid(ent) then tblEntsNoCollide[self][ent] = nil end end end
        if tblEntsNoCollide[self] && tblEntsNoCollide[self][ent] then
            tblEntsNoCollide[self][ent] = nil
            if SERVER then
                umsg.Start("HLR_EntsCollide")
                    umsg.Entity(self)
                    umsg.Entity(ent)
                    umsg.Bool(true)
                umsg.End()
            end
            if table.Count(tblEntsNoCollide[self]) == 0 then tblEntsNoCollide[self] = nil end
        elseif tblEntsNoCollide[ent] && tblEntsNoCollide[ent][self] then
            tblEntsNoCollide[ent][self] = nil
            if SERVER then
                umsg.Start("HLR_EntsCollide")
                    umsg.Entity(self)
                    umsg.Entity(ent)
                    umsg.Bool(true)
                umsg.End()
            end
            if table.Count(tblEntsNoCollide[ent]) == 0 then tblEntsNoCollide[ent] = nil end
        end
    end

    function ENTITY:CanCollide(ent)
        if(type(ent) != "string" && ((self.ShouldCollide && self:ShouldCollide(ent) == false) || (ent.ShouldCollide && ent:ShouldCollide(self) == false))) then return false end
        return (!tblEntsNoCollide[self] || !tblEntsNoCollide[self][ent]) && (!tblEntsNoCollide[ent] || !tblEntsNoCollide[ent][self])
    end

    function ENTITY:IsPhysicsEntity()
        return !self:IsNPC() && !self:IsPlayer() && !self:IsWorld() && IsValid(self:GetPhysicsObject())
    end

    if SERVER then
        hook.Add("PlayerInitialSpawn", "SLV_UpdateCollisions", function(ply)
            if !IsValid(ply) then return end
            timer.Simple(0.5, function() -- Let the entities initialize clientside
                if !IsValid(ply) then return end
                for entA, dat in pairs(tblEntsNoCollide) do
                    if !IsValid(entA) then tblEntsNoCollide[entA] = nil
                    else
                        for entB, _ in pairs(dat) do if(!entB:IsValid()) then tblEntsNoCollide[entA][entB] = nil end end
                    end
                end
                for ent, dat in pairs(tblEntsNoCollideByClass) do
                    if !IsValid(ent) then tblEntsNoCollide[ent] = nil end
                end
                
                umsg.Start("SLV_UpdateCollisions", ply)
                    umsg.Short(table.Count(tblEntsNoCollide))
                    for entA, dat in pairs(tblEntsNoCollide) do
                        umsg.Entity(entA)
                        umsg.Short(table.Count(dat))
                        for entB, _ in pairs(dat) do
                            umsg.Entity(entB)
                        end
                    end
                    umsg.Short(table.Count(tblEntsNoCollideByClass))
                    for ent, dat in pairs(tblEntsNoCollideByClass) do
                        umsg.Entity(ent)
                        umsg.Short(table.Count(dat))
                        for class, _ in pairs(dat) do
                            umsg.String(class)
                        end
                    end
                umsg.End()
            end)
        end)

        function PLAYER:Irradiate(ent,RAD)
            local dmg = DamageInfo()
            dmg:SetDamageType(DMG_RADIATION)
            dmg:SetDamage(RAD)
            dmg:SetAttacker(self)
            dmg:SetInflictor(self)
            dmg:SetDamagePosition(ent:GetPos() +ent:OBBCenter())
            ent:TakeDamageInfo(dmg)
        end

        function PLAYER:GetPossessedNPC()
            return self.VJ_TheControllerEntity.VJCE_NPC
        end

        function PLAYER:GetPossessionEyeTrace()
            local tracedata = {}
            tracedata.start = self:EyePos()
            tracedata.endpos = tracedata.start +self:GetAimVector() *32768
            tracedata.filter = {self, self:GetPossessedNPC()}
            return util.TraceLine(tracedata)
        end

        function ENTITY:SetArcVelocity(vecStart,vecEnd,speed,dirRef,tolerance,dirOffset)
            local phys = self:GetPhysicsObject()
            if(!phys:IsValid()) then return false end
            local dirTgt = (vecEnd -vecStart):GetNormal()
            if(dirOffset) then dirTgt = dirTgt +dirOffset end
            if(tolerance) then dirTgt:ClampToDir(dirRef,tolerance) end
            vecEnd = vecStart +dirTgt *vecStart:Distance(vecEnd)
            local vecToss = util.CalcArcVelocity(self,vecStart,vecEnd,speed)
            local bObstacle = vecToss == vector_origin
            if(bObstacle) then vecToss = self:GetForward() *speed *0.8 +self:GetUp() *speed *0.2
            end/*elseif(tolerance) then
                local dir = self:GetForward()
                local dirVel = vecToss:GetNormal()
                dirVel:ClampToDir(dir,tolerance)
                vecToss = dirVel *vecToss:Length()
            end*/
            local vecToTarget = (vecEnd -vecStart):GetNormal()
            local flVelocity = vecToss:GetNormal():Length2D()
            local flCosTheta = vecToTarget:DotProduct(vecToss)
            local flTime = (vecStart -vecEnd):Length2D() /(flVelocity *flCosTheta)
            phys:SetVelocity(vecToss)
            return flTime,bObstacle
        end

        function ENTITY:TurnDegree(iDeg, posAng, bPitch, iPitchMax)
            if posAng then
                local sType = type(posAng)
                local angTgt
                if sType == "Vector" then angTgt = (posAng -self:GetPos()):Angle()
                else angTgt = posAng end
                local ang = self:GetAngles()
                if !iDeg then ang.y = angTgt.y; if bPitch then ang.p = angTgt.p end
                else
                    while angTgt.y < 0 do angTgt.y = angTgt.y +360 end
                    while angTgt.y > 360 do angTgt.y = angTgt.y -360 end
                    local _ang = ang -angTgt
                    _ang.y = math.floor(_ang.y)
                    while _ang.y < 0 do _ang.y = _ang.y +360 end
                    while _ang.y > 360 do _ang.y = _ang.y -360 end
                    local _iDeg = iDeg
                    if _ang.y > 0 && _ang.y <= 180 then
                        if _ang.y < _iDeg then _iDeg = _ang.y end
                        ang.y = ang.y -_iDeg
                    elseif _ang.y > 180 then
                        if 360 -_ang.y < _iDeg then _iDeg = 360 -_ang.y end
                        ang.y = ang.y +_iDeg
                    end
                    
                    if bPitch then
                        iPitchMax = iPitchMax || 360
                        _ang.p = math.floor(_ang.p)
                        while _ang.p < 0 do _ang.p = _ang.p +360 end
                        while _ang.p > 360 do _ang.p = _ang.p -360 end
                        if _ang.p > 0 then
                            local _iDeg = iDeg
                            if _ang.p < 180 then
                                if ang.p > -iPitchMax then
                                    if _ang.p < _iDeg then _iDeg = _ang.p end
                                    ang.p = ang.p -_iDeg
                                end
                            else
                                if ang.p < iPitchMax then
                                    if 360 -_ang.p < _iDeg then _iDeg = 360 -_ang.p end
                                    ang.p = ang.p +_iDeg
                                end
                            end
                        end
                    end
                    self:SetAngles(ang)
                end
                return
            end
            local ang = self:GetAngles()
            ang.y = ang.y +iDeg
            self:SetAngles(ang)
        end

        function ENTITY:DoExplode(dmg, radius, owner, bDontRemove)
            util.CreateExplosion(self:GetPos(),dmg,radius,self,owner)
            if !bDontRemove then self:Remove() end
        end

        function util.BlastDmg(inflictor, attacker, pos, radius, dmg, TFilter, dmgType, bReduce)
            return util.VJ_SphereDamage(attacker, inflictor, pos, radius, dmg, dmgType, true, bReduce)
        end

        function util.DealBlastDamage(pos,radius,dmg,force,attacker,inflictor,bReduce,dmgType,TFilter,fcOnHit)
            return util.VJ_SphereDamage(attacker, inflictor, pos, radius, dmg, dmgType, true, bReduce, nil, fcOnHit)
        end

        function util.CreateExplosion(pos,dmg,radius,inflictor,attacker)
            radius = radius || 260
            dmg = dmg || 85
            local ang = Angle(0,0,0)
            local entParticle = ents.Create("info_particle_system")
            entParticle:SetKeyValue("start_active", "1")
            entParticle:SetKeyValue("effect_name", "dusty_explosion_rockets")//svl_explosion")
            entParticle:SetPos(pos)
            entParticle:SetAngles(ang)
            entParticle:Spawn()
            entParticle:Activate()
            timer.Simple(1, function() if IsValid(entParticle) then entParticle:Remove() end end)
            sound.Play("weapons/explode" .. math.random(7,9) .. ".wav", pos, 110, 100)
            util.BlastDmg(inflictor, attacker || inflictor, pos, radius, dmg)
            util.ScreenShake(pos, 5, dmg, math.Clamp(dmg /100, 0.1, 2), radius *2)
            
            local iDistMin = 26
            local tr
            for i = 1, 6 do
                local posEnd = pos
                if i == 1 then posEnd = posEnd +Vector(0,0,25)
                elseif i == 2 then posEnd = posEnd -Vector(0,0,25)
                elseif i == 3 then posEnd = posEnd +Vector(0,25,0)
                elseif i == 4 then posEnd = posEnd -Vector(0,25,0)
                elseif i == 5 then posEnd = posEnd +Vector(25,0,0)
                elseif i == 6 then posEnd = posEnd -Vector(25,0,0) end
                local tracedata = {
                    start = pos,
                    endpos = posEnd,
                    filter = {inflictor,attacker}
                }
                local trace = util.TraceLine(tracedata)
                local iDist = pos:Distance(trace.HitPos)
                if trace.HitWorld && iDist < iDistMin then
                    iDistMin = iDist
                    tr = trace
                end
            end
            if tr then
                util.Decal("Scorch",tr.HitPos +tr.HitNormal,tr.HitPos -tr.HitNormal)  
            end
        end

        local iParticleTracers = 0
        function util.ParticleEffectTracer(name, posStart, TCPoints, ang, ent, att, flRemoveDelay)
            iParticleTracers = iParticleTracers +1
            local iCheckpoint = 0
            local tblEnts = {}
            local function CreateCheckpoint(TPoint, att)
                iCheckpoint = iCheckpoint +1
                local _ent = ent
                local ent = ents.Create("obj_target")
                if type(TPoint) == "Vector" then ent:SetPos(TPoint)
                else ent:SetPos(TPoint:GetCenter()); ent:SetParent(TPoint) end
                ent:Spawn()
                ent:Activate()
                if att then ent:Fire("SetParentAttachment", att, 0) end
                table.insert(tblEnts, ent)
                
                local cName = "ParticleEffectTracer" .. iParticleTracers .. "_checkpoint" .. iCheckpoint
                ent:SetName(cName)
                if IsValid(_ent) then _ent:DeleteOnRemove(ent) end
                return ent, cName
            end

            local entParticle = ents.Create("info_particle_system")
            entParticle:SetKeyValue("start_active", "1")
            entParticle:SetKeyValue("effect_name", name)
            local cpoints
            if TCPoints then
                local sType = type(TCPoints)
                if sType == "Vector" || sType == "Entity" || sType == "Player" || sType == "NPC" then
                    local ent, cName = CreateCheckpoint(TCPoints)
                    cpoints = ent
                    entParticle:SetKeyValue("cpoint1", cName)
                else
                    cpoints = {}
                    for k, v in pairs(TCPoints) do
                        local TPoint, att
                        if type(v) == "table" then
                            TPoint = v.ent
                            att = v.att
                        else TPoint = v end
                        local ent, cName = CreateCheckpoint(TPoint, att)
                        table.insert(cpoints, ent)
                        entParticle:SetKeyValue("cpoint" .. k, cName)
                    end
                end
            end
            entParticle:SetAngles(ang)
            entParticle:SetPos(posStart)
            entParticle:Spawn()
            entParticle:Activate()
            if IsValid(ent) then
                entParticle:SetParent(ent)
                ent:DeleteOnRemove(entParticle)
                if att then entParticle:Fire("SetParentAttachment", att, 0) end
            end
            if flRemoveDelay != false then
                flRemoveDelay = flRemoveDelay || 1
                timer.Simple(flRemoveDelay, function()
                    if IsValid(entParticle) then
                        entParticle:Remove()
                    end
                    for k, v in pairs(tblEnts) do
                        if IsValid(v) then v:Remove() end
                    end
                end)
            end
            return entParticle,cpoints
        end

        function util.ParticleEffect(name, pos, ang, ent, att, flRemoveDelay)
            local entParticle = ents.Create("info_particle_system")
            entParticle:SetKeyValue("start_active", "1")
            entParticle:SetKeyValue("effect_name", name)
            entParticle:SetAngles(ang)
            entParticle:SetPos(pos)
            entParticle:Spawn()
            entParticle:Activate()
            if IsValid(ent) then
                entParticle:SetParent(ent)
                ent:DeleteOnRemove(entParticle)
                if att then entParticle:Fire("SetParentAttachment", att, 0) end
            end
            if flRemoveDelay != false then
                flRemoveDelay = flRemoveDelay || 1
                timer.Simple(flRemoveDelay, function()
                    if IsValid(entParticle) then
                        entParticle:Remove()
                    end
                end)
            end
            return entParticle
        end
    end
	
-- !!!!!! DON'T TOUCH ANYTHING BELOW THIS !!!!!! -------------------------------------------------------------------------------------------------------------------------
	AddCSLuaFile(AutorunFile)
	VJ.AddAddonProperty(AddonName,AddonType)
else
	if CLIENT then
		chat.AddText(Color(0, 200, 200), PublicAddonName, 
		Color(0, 255, 0), " was unable to install, you are missing ", 
		Color(255, 100, 0), "VJ Base!")
	end
	
	timer.Simple(1, function()
		if not VJBASE_ERROR_MISSING then
			VJBASE_ERROR_MISSING = true
			if CLIENT then
				// Get rid of old error messages from addons running on older code...
				if VJF && type(VJF) == "Panel" then
					VJF:Close()
				end
				VJF = true
				
				local frame = vgui.Create("DFrame")
				frame:SetSize(600, 160)
				frame:SetPos((ScrW() - frame:GetWide()) / 2, (ScrH() - frame:GetTall()) / 2)
				frame:SetTitle("Error: VJ Base is missing!")
				frame:SetBackgroundBlur(true)
				frame:MakePopup()
	
				local labelTitle = vgui.Create("DLabel", frame)
				labelTitle:SetPos(250, 30)
				labelTitle:SetText("VJ BASE IS MISSING!")
				labelTitle:SetTextColor(Color(255, 128, 128))
				labelTitle:SizeToContents()
				
				local label1 = vgui.Create("DLabel", frame)
				label1:SetPos(170, 50)
				label1:SetText("Garry's Mod was unable to find VJ Base in your files!")
				label1:SizeToContents()
				
				local label2 = vgui.Create("DLabel", frame)
				label2:SetPos(10, 70)
				label2:SetText("You have an addon installed that requires VJ Base but VJ Base is missing. To install VJ Base, click on the link below. Once\n                                                   installed, make sure it is enabled and then restart your game.")
				label2:SizeToContents()
				
				local link = vgui.Create("DLabelURL", frame)
				link:SetSize(300, 20)
				link:SetPos(195, 100)
				link:SetText("VJ_Base_Download_Link_(Steam_Workshop)")
				link:SetURL("https://steamcommunity.com/sharedfiles/filedetails/?id=131759821")
				
				local buttonClose = vgui.Create("DButton", frame)
				buttonClose:SetText("CLOSE")
				buttonClose:SetPos(260, 120)
				buttonClose:SetSize(80, 35)
				buttonClose.DoClick = function()
					frame:Close()
				end
			elseif (SERVER) then
				VJF = true
				timer.Remove("VJBASEMissing")
				timer.Create("VJBASE_ERROR_CONFLICT", 5, 0, function()
					print("VJ Base is missing! Download it from the Steam Workshop! Link: https://steamcommunity.com/sharedfiles/filedetails/?id=131759821")
				end)
			end
		end
	end)
end