-- Loaded client-side and server-side.
--
-- Enable/disable modules (some may be required by others).
-- It's recommended to disable things from the modules configurations directly if possible.

local modules = {
  admin = false,
  group = false,
  gui = false,
  map = false,
  weather = false,
  misc = false,
  command = false,
  player_state = false,
  weapon = false,
  user = false,
  identity = true,
  logsystem = false,
  money = false
}

return modules
