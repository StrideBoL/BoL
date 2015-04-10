local ScriptVersion = "1.1"

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

--|Automatic On-Load Script|--
function OnLoad()
	Update(ScriptVersion)
end

--|Automatic Update Check|--
-- Credits to @Skeem for Template --
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
				local ServerVersion = string.match(ServerData, "ScriptVersion = \"%d.%d\"")
				if ServerVersion and ScriptVersion ~= ServerVersion then
					print("<font color=\"#000000\">[</font><font color=\"#424242\">Heavy Metal Mordekaiser</font><font color=\"#000000\">]</font> <font color=\"##585858\">Found Latest Version </font> <font color=\"#FB3636\">v"..ServerVersion.."</font>")
 	           		self.needUpdate = true
				end
			end
			self.ranUpdater = true
		end
		if self.needUpdate then
			DownloadFile(self.downloadPath, self.path, function()
                if FileExist(self.path) then
                    print("<font color=\"#000000\">[</font><font color=\"#424242\">Heavy Metal Mordekaiser</font><font color=\"#000000\">]</font> <font color=\"##585858\">Script Updated! Press F9 twice to reload the new version!</font>")
                end
            end)
            self.needUpdate = false
		end
	end
