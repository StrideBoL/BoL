--|Script Version|--
local ScriptVersion = 1.0

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
		self.scriptLink  = "https://raw.githubusercontent.com/SkeemBoL/BoL/master/Katarina%20Rework.lua"
		self.path        = SCRIPT_PATH .. _ENV.FILE_NAME
		
		--Booleans--
		self.needUpdate  = false
		self.ranUpdater  = false
		
		AddTickCallback(function () self:Tick() end)
	end
	
	function Update:Tick()
		if not self.ranUpdater then
			local ServerData = GetWebResult("raw.github.com", UPDATE_PATH)
 	           local onlineVersion = tonumber(data)
 	           if onlineVersion and onlineVersion > ScriptVersion then
 	           		print("<font color=\"#FF0000\">[Nintendo Katarina]:</font> <font color=\"#FFFFFF\">Found Update: </font> <font color=\"#FF0000\">"..KatarinaVersion.." > "..onlineVersion.." Updating... Don't F9!!</font>")
 	           		self.needUpdate = true
 	           end
 	        end)
			self.ranUpdater = true
		end
		if self.needUpdate then
			DownloadFile(self.scriptLink, self.path, function()
                if FileExist(self.path) then
                    print("<font color=\"#FF0000\">[Nintendo Katarina]:</font> <font color=\"#FFFFFF\">updated! Double F9 to use new version!</font>")
                end
            end)
            self.needUpdate = false
		end
	end
