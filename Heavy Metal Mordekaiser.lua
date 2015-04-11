local ScriptVersion = "1.0"

--  _   _                          __  __      _        _  --
-- | | | |                        |  \/  |    | |      | | -- 
-- | |_| | ___  __ ___   ___   _  | .  . | ___| |_ __ _| | -- 
-- |  _  |/ _ \/ _` \ \ / / | | | | |\/| |/ _ \ __/ _` | | -- 
-- | | | |  __/ (_| |\ V /| |_| | | |  | |  __/ || (_| | | -- 
-- \_| |_/\___|\__,_| \_/  \__, | \_|  |_/\___|\__\__,_|_| -- 
--                          __/ |                          -- 
--                         |___/                           -- 
-- ___  ___              _      _         _                -- 
-- |  \/  |             | |    | |       (_)               -- 
-- | .  . | ___  _ __ __| | ___| | ____ _ _ ___  ___ _ __  -- 
-- | |\/| |/ _ \| '__/ _` |/ _ \ |/ / _` | / __|/ _ \ '__| -- 
-- | |  | | (_) | | | (_| |  __/   < (_| | \__ \  __/ |    --
-- \_|  |_/\___/|_|  \__,_|\___|_|\_\__,_|_|___/\___|_|    --
--                                                         --
--                       BY STRIDE                         --

--|Champion Check|--
if myHero.charName ~= "Mordekaiser" then return end 

--|SxOrbWalk|--
require 'SxOrbWalk'

--|Automatic On-Load Script|--
function OnLoad()
	Update(ScriptVersion)
	Mordekaiser = Mordekaiser()
	print("<font color=\"#000000\">[</font><font color=\"#A4A4A4\">Heavy Metal Mordekaiser</font><font color=\"#000000\">]</font> <font color=\"#BDBDBD\">Currently using </font><font color=\"#FB3636\">v"..ScriptVersion.."</font><font color=\"#BDBDBD\">!</font>")
end

--|Automatic Update Check|--
class 'Update'
	function Update:__init(version)
		--Update Variables--
		self.version     = version
		self.scriptLink  = "/StrideBoL/BoL/master/Heavy%20Metal%20Mordekaiser.lua"
		self.downloadPath = "https://raw.github.com/"..self.scriptLink
		self.path        = SCRIPT_PATH .. _ENV.FILE_NAME
		
		--Booleans--
		self.needUpdate  = false
		self.ranUpdater  = false
		
		AddTickCallback(function () self:Tick() end)
	end
	
	function Update:Tick()
		if not self.ranUpdater then
			local ServerData = GetWebResult("raw.github.com", self.scriptLink)
 	        if ServerData then
				local ServerVersion = string.match(ServerData, "local ScriptVersion = \"%d.%d\"")
				local NewVersion = string.match(ServerVersion and ServerVersion or "", "%d.%d")
				if NewVersion and NewVersion ~= ScriptVersion then
					print("<font color=\"#000000\">[</font><font color=\"#A4A4A4\">Heavy Metal Mordekaiser</font><font color=\"#000000\">]</font> <font color=\"#BDBDBD\">Found latest version </font><font color=\"#FB3636\">v"..NewVersion.."</font><font color=\"#BDBDBD\">. Updating...</font>")
 	           		self.needUpdate = true
				end
			end
			self.ranUpdater = true
		end
		if self.needUpdate then
			DownloadFile(self.downloadPath, self.path, function()
                if FileExist(self.path) then
                    print("<font color=\"#000000\">[</font><font color=\"#A4A4A4\">Heavy Metal Mordekaiser</font><font color=\"#000000\">]</font> <font color=\"#BDBDBD\">Script updated! Press F9 twice to reload the new version!</font>")
                end
            end)
            self.needUpdate = false
		end
	end
-- Credits to @Skeem for Template --
--|End of Autoupdate|--

--|Heavy Metal Mordekaiser|--
class 'Mordekaiser'
	function Mordekaiser:__init()
		--Spells--
		self.Spells = {
			Q = Spells(_Q, 250, 'Mace of Spades', 'none'),
			W =	Spells(_W, 750, 'Creeping Death', 'self'),
			E =	Spells(_E, 625, 'Siphon of Destruction', 'none'), 
			--Actual range is 630 but making it 625 to ensure hit--
			R =	Spells(_R, 850, 'Children of the Grave', 'targ')
		}
		
		--Other Inits--
		self:Menu()
		
		--Other Stuff--
		self.target = nil
		
		AddTickCallback(function() self:Tick() end)
		AddDrawCallback(function() self:Draw() end)
	end
	
	--Tick--
	function Mordekaiser:Tick()
		self.tar = self:GetTarget()
		if self.tar then
			if self.menu.Combo then
				self:Combo(self.tar)
			elseif self.menu.Harass then
				self:Harass(self.tar)
			end
		
		end
	end
	
	--Get Target--
	function Mordekaiser:GetTarget()
		self.Target:update()
        if _G.MMA_Target and _G.MMA_Target.type == myHero.type then 
        	return _G.MMA_Target 
	    elseif _G.AutoCarry and  _G.AutoCarry.Attack_Crosshair and _G.AutoCarry.Attack_Crosshair.target and _G.AutoCarry.Attack_Crosshair.target.type == myHero.type then 
	    	return _G.AutoCarry.Attack_Crosshair.target 
	    elseif self.Target.target and ValidTarget(self.Target.target) then
	    	return self.Target.target
	    end
	end
	
	--Menu--
	function Mordekaiser:Menu()
		self.menu = scriptConfig("Heavy Metal Mordekaiser v"..ScriptVersion, "Heavy Metal Mordekaiser")
			self.menu:addParam("DraA", "Draw Auto Attack Range", SCRIPT_PARAM_ONOFF, true)
			--Q--
			self.menu:addSubMenu(">> Q: "..self.Spells.Q.Name.." Settings", "Q")	
				self.menu.Q:addParam("LasQ", "Lasthit with "..self.Spells.Q.Name, SCRIPT_PARAM_ONOFF, true)
				self.menu.Q:addParam("ComQ", "Combo with "..self.Spells.Q.Name, SCRIPT_PARAM_ONOFF, true)
			--W--
			self.menu:addSubMenu(">> W: "..self.Spells.W.Name.." Settings", "W")	
				self.menu.W:addParam("DraW", "Draw "..self.Spells.W.Name.." Range", SCRIPT_PARAM_ONOFF, true)
				self.menu.W:addParam("ComW", "Use "..self.Spells.W.Name.." during Combo", SCRIPT_PARAM_ONOFF, true)
			--E--
			self.menu:addSubMenu(">> E: "..self.Spells.E.Name.." Settings", "E")	
				self.menu.E:addParam("DraE", "Draw "..self.Spells.E.Name.." Range", SCRIPT_PARAM_ONOFF, true)
				self.menu.E:addParam("HarE", "Harass with "..self.Spells.E.Name, SCRIPT_PARAM_ONOFF, true)
				self.menu.E:addParam("LasE", "Lasthit with "..self.Spells.E.Name, SCRIPT_PARAM_ONOFF, true)
				self.menu.E:addParam("ComE", "Combo with "..self.Spells.E.Name, SCRIPT_PARAM_ONOFF, true)
			--R--
			self.menu:addSubMenu(">> R: "..self.Spells.R.Name.." Settings", "R")	
				self.menu.R:addParam("DraR", "Draw "..self.Spells.R.Name.." Range", SCRIPT_PARAM_ONOFF, true)
				self.menu.R:addParam("KillR", "Use "..self.Spells.R.Name.." when killable", SCRIPT_PARAM_ONOFF, true)
			--OrbWalk--
			self.menu:addSubMenu('>> Hotkey Settings', 'orbwalk')
				SxOrb:LoadToMenu(self.menu.orbwalk, true)
				SxOrb:RegisterHotKey('fight',     self.menu, 'Combo')
				SxOrb:RegisterHotKey('harass',    self.menu, 'Harass')
				SxOrb:RegisterHotKey('laneclear', self.menu, 'LaneC')
				SxOrb:RegisterHotKey('lasthit',   self.menu, 'LastHit')
			--Activate Keys--
			self.menu:addParam('Combo', 'Full Combo Toggle', SCRIPT_PARAM_ONKEYDOWN, false, GetKey(' '))
			self.menu:addParam('Harass', 'Harass Toggle', SCRIPT_PARAM_ONKEYDOWN, false, GetKey('X'))
			self.menu:addParam('LaneC', 'Laneclear Toggle', SCRIPT_PARAM_ONKEYDOWN, false, GetKey('C'))

			--Side Menu
			self.menu:permaShow('Combo')
			self.menu:permaShow('Harass')
			self.menu:permaShow('LaneC')
			
			--Target Selector--
			self.Target = TargetSelector(TARGET_LESS_CAST, self.Spells.E.range, DAMAGE_MAGIC, true)
				self.Target.name = 'Mordekaiser'
				self.menu:addTS(self.Target)
	end
	
	--Combo--
	function Mordekaiser:Combo(target)
		if self.menu.Q.ComQ then
			self.Spells.Q:Cast(target)
		end
	end
	
	--Harass--
	function Mordekaiser:Harass(target)
		if self.menu.E.HarE then
			self.Spells.E:Cast(target)
		end
	end
	
	--Draw **Thanks Skeem for Funcs--
	function Mordekaiser:Draw()
		if myHero.dead then return end
		if self.menu.W.DraW then
			if self.Spells.W:Ready() then
				self:DrawCircle(myHero.x, myHero.y, myHero.z, self.Spells.W:Range(), RGB(204,0,204))
			else
				self:DrawCircle(myHero.x, myHero.y, myHero.z, self.Spells.W:Range(), RGB(255,153,255))
			end
		end
		if self.menu.E.DraE then
			if self.Spells.E:Ready() then
				self:DrawCircle(myHero.x, myHero.y, myHero.z, self.Spells.E:Range(), RGB(17,240,61))
			else
				self:DrawCircle(myHero.x, myHero.y, myHero.z, self.Spells.E:Range(), RGB(247,17,40))
			end
		end
		if self.menu.R.DraR then
			if self.Spells.R:Ready() then
				self:DrawCircle(myHero.x, myHero.y, myHero.z, self.Spells.R:Range(), RGB(17,240,61))
			else
				self:DrawCircle(myHero.x, myHero.y, myHero.z, self.Spells.R:Range(), RGB(247,17,40))
			end
		end
	end
	
	function Mordekaiser:DrawCircle(x, y, z, radius, color)
		local vPos1 = Vector(x, y, z)
		local vPos2 = Vector(cameraPos.x, cameraPos.y, cameraPos.z)
		local tPos = vPos1 - (vPos1 - vPos2):normalized() * radius
		local sPos = WorldToScreen(D3DXVECTOR3(tPos.x, tPos.y, tPos.z))
		
		if OnScreen({ x = sPos.x, y = sPos.y }, { x = sPos.x, y = sPos.y }) then
			self:DrawCircleNextLvl(x, y, z, radius, 1, color, 300) 
		end
	end
	
	function Mordekaiser:DrawCircleNextLvl(x, y, z, radius, width, color, chordlength)
		radius = radius or 300
		quality = math.max(8, self:Round(180 / math.deg((math.asin((chordlength / (2 * radius)))))))
		quality = 2 * math.pi / quality
		radius = radius * .92
		local points = {}
		
		for theta = 0, 2 * math.pi + quality, quality do
			local c = WorldToScreen(D3DXVECTOR3(x + radius * math.cos(theta), y, z - radius * math.sin(theta)))
			points[#points + 1] = D3DXVECTOR2(c.x, c.y)
		end
		DrawLines2(points, width or 1, color or 4294967295)
	end

	function Mordekaiser:Round(number)
		if number >= 0 then 
			return math.floor(number+.5) 
		else 
			return math.ceil(number-.5) 
		end
	end
	
--|Spells Configuration|--	
class 'Spells'
	function Spells:__init(slot, range, name, type)
		self.Slot = slot
		self.range = range
		self.Name = name
		self.Type = type
	end
	
	function Spells:Cast(unit)
		if self:Ready() and GetDistance(unit) <= self.range then
			if self.Type == 'targ' then
				CastSpell(self.Slot, unit)
			elseif self.Type == 'none' then
				CastSpell(self.Slot, unit)
			elseif self.Type == 'self' then
				CastSpell(self.Slot, myHero)
			end
		end
	end
	
	function Spells:Ready()
		return myHero:CanUseSpell(self.Slot) == READY
	end
	
	function Spells:Range()
		return self.range
	end

	

