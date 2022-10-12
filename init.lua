-- Meta
function reloadConfig(files)
  doReload = false
  for _,file in pairs(files) do
      if file:sub(-4) == ".lua" then
          doReload = true
      end
  end
  hs.console.printStyledtext("saw FS change, going to reload: " .. tostring(doReload))
  if doReload then
      hs.reload()
  end
end
hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig):start()
hs.notify.new({title="Hammerspoon", informativeText="Config loaded"}):send()


-- Utils
function dumbFrame(frameToMock)
  return {
    x = frameToMock.x,
    y = frameToMock.y,
    w = frameToMock.w,
    h = frameToMock.h
  }
end

-- Focused window movement
-- Focused window movement -- Left half
hs.hotkey.bind({"cmd", "alt"}, "Left", function()
  local win = hs.window.focusedWindow()
  if win then
    local f = dumbFrame(win:screen():frame())
    f.w = f.w / 2
    win:setFrame(f)
  end
end)

-- Focused window movement -- Right half
hs.hotkey.bind({"cmd", "alt"}, "Right", function()
  local win = hs.window.focusedWindow()
  if win then
    local f = dumbFrame(win:screen():frame())
    f.x = f.x + (f.w / 2)
    f.w = f.w / 2
    win:setFrame(f)
  end
end)

-- Focused window movement -- Full screen
hs.hotkey.bind({"cmd", "alt"}, "F", function()
  local win = hs.window.focusedWindow()
  if win then
    local f = dumbFrame(win:screen():frame())
    win:setFrame(f)
  end
end)

-- Focused window movement -- 1/3 screen, left
hs.hotkey.bind({"cmd", "alt"}, "1", function()
  local win = hs.window.focusedWindow()
  if win then
    local f = dumbFrame(win:screen():frame())
    f.w = f.w / 3
    win:setFrame(f)
  end
end)

-- Focused window movement -- 1/3 screen, center
hs.hotkey.bind({"cmd", "alt"}, "2", function()
  local win = hs.window.focusedWindow()
  if win then
    local f = dumbFrame(win:screen():frame())
    f.x = f.x + (f.w / 3)
    f.w = f.w / 3
    win:setFrame(f)
  end
end)

-- Focused window movement -- 1/3 screen, right
hs.hotkey.bind({"cmd", "alt"}, "3", function()
  local win = hs.window.focusedWindow()
  if win then
    local f = dumbFrame(win:screen():frame())
    f.x = f.x + (2 * (f.w / 3))
    f.w = f.w / 3
    win:setFrame(f)
  end
end)

-- Focused window movement -- 2/3 screen, left
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "1", function()
  local win = hs.window.focusedWindow()
  if win then
    local f = dumbFrame(win:screen():frame())
    f.w = 2 * f.w / 3
    win:setFrame(f)
  end
end)

-- Focused window movement -- 2/3 screen, center
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "2", function()
  local win = hs.window.focusedWindow()
  if win then
    local f = dumbFrame(win:screen():frame())
    f.x = f.x + (f.w / 6)
    f.w = 2 * f.w / 3
    win:setFrame(f)
  end
end)

-- Focused window movement -- 2/3 screen, right
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "3", function()
  local win = hs.window.focusedWindow()
  if win then
    local f = dumbFrame(win:screen():frame())
    f.x = f.x + (f.w / 3)
    f.w = 2 * f.w / 3
    win:setFrame(f)
  end
end)


-- Terminal visor
-- Terminal visor -- Opening and closing
hs.hotkey.bind({"alt"}, "space", function()
  local app = hs.appfinder.appFromName("Terminal")

  if not app or not app:isRunning() then
    local screens = hs.screen.allScreens()
    local laptopFrame = screens[1]:frame()
    local f = dumbFrame(laptopFrame)
    placeAppAtFrame("Terminal", f, true)
    return
  end

  if app:isHidden() then
    app:unhide()
    app:activate()
  else
    local focusedTerminalWindow = app:focusedWindow()
    local focusedGlobalWindow = hs.window.focusedWindow()
    local terminalIsFocused = focusedTerminalWindow == focusedGlobalWindow
    if terminalIsFocused then
      app:hide()
    else
      app:activate()
    end
  end
end)

-- Terminal visor -- Pinning
-- (blocked on Hammerspoon)


-- Show all Finder windows when focusing on Finder
function applicationWatcher(appName, eventType, appObject)
  if (eventType == hs.application.watcher.activated) then
    if (appName == "Finder") then
      -- Bring all Finder windows forward when one gets activated
      appObject:selectMenuItem({"Window", "Bring All to Front"})
    end
  end
end
local appWatcher = hs.application.watcher.new(applicationWatcher)
appWatcher:start()


-- Workspace
-- Workspace -- Utils
function placeAppAtFrame(appName, dumbFrame, launchIfNotRunning)
  local app = hs.appfinder.appFromName(appName)
  if not app or not app:isRunning() then
    if launchIfNotRunning then
      local attempts = 0
      while (not app or not app:isRunning()) and attempts < 3 do
        hs.application.launchOrFocus(appName)
        -- TODO: this next line never works :(
        app = hs.appfinder.appFromName(appName)
        hs.console.printStyledtext("launched "..hs.inspect.inspect(app).." from name "..appName)
        attempts = attempts + 1
      end
      if not app or not app:isRunning() then
        hs.console.printStyledtext("failed to launch "..appName)
        return
      else
      end
    else
      hs.console.printStyledtext("doing nothing for "..appName)
      return
    end
  end
  local windows = app:allWindows()
  for _,window in pairs(windows) do
    window:setFrame(dumbFrame)
  end
end

function sleep(n)
  os.execute("sleep " .. tonumber(n))
end

-- Workspace -- Work
-- Workspace -- Work -- One Wide Screen
function setupWorkWideWorkspace()
  local screen = hs.screen.allScreens()[1]:frame()
  -- Left side
  local leftHalf = dumbFrame(screen)
  leftHalf.w = leftHalf.w / 2
  for _,appName in pairs({"Slack"}) do
    placeAppAtFrame(appName, leftHalf, true)
  end
  for _,appName in pairs({"Evernote"}) do
    placeAppAtFrame(appName, leftHalf, false)
  end

  -- Right side
  local rightHalf = dumbFrame(screen)
  rightHalf.x = rightHalf.w / 2
  rightHalf.w = rightHalf.w / 2
  for _,appName in pairs({"Code", "GitX", "Firefox Developer Edition", "", "PyCharm", "Xcode", "Safari"}) do
    placeAppAtFrame(appName, rightHalf, false)
  end

  -- Left third
  local leftThird = dumbFrame(screen)
  leftThird.w = leftThird.w / 3
  for _,appName in pairs({"Terminal"}) do
    placeAppAtFrame(appName, leftThird, true)
  end
  for _,appName in pairs({"Google Chrome"}) do
    placeAppAtFrame(appName, leftThird, false)
  end

  -- Right 2/3s
  local rightTwoThirds = dumbFrame(screen)
  rightTwoThirds.x = rightTwoThirds.w / 3
  rightTwoThirds.w = (2 * rightTwoThirds.w / 3)
  for _,appName in pairs({"Code", "PyCharm", "Xcode"}) do
    placeAppAtFrame(appName, rightTwoThirds, false)
  end

  -- Center 2/3s
  local centerTwoThirds = dumbFrame(screen)
  centerTwoThirds.x = centerTwoThirds.w / 6
  centerTwoThirds.w = (2 * centerTwoThirds.w / 3)
  for _,appName in pairs({"zoom.us"}) do
    placeAppAtFrame(appName, centerTwoThirds, false)
  end
end

-- Workspace -- Work -- Two Screens
function setupWorkDoubleWorkspace()
  local screens = hs.screen.allScreens()
  -- laptop
  local laptopFrame = screens[1]:frame()
  local laptopDumbFrame = dumbFrame(laptopFrame)
  for _,appName in pairs({"Terminal", "Slack"}) do
    placeAppAtFrame(appName, laptopDumbFrame, true)
  end
  for _,appName in pairs({"Evernote"}) do
    placeAppAtFrame(appName, laptopDumbFrame, false)
  end

  -- monitor 1
  -- TODO: make a fn to determine screens by x pos, not pos in array
  local monitor1Frame = screens[2]:frame()
  local monitor1DumbFrame = dumbFrame(monitor1Frame)
  -- for _,appName in pairs({}) do
  --   placeAppAtFrame(appName, monitor1DumbFrame, true)
  -- end
  for _,appName in pairs({"Code", "GitX", "Firefox Developer Edition", "zoom.us", "PyCharm", "Xcode", "Google Chrome", "Safari"}) do
    placeAppAtFrame(appName, monitor1DumbFrame, false)
  end
end

-- Workspace -- Work -- One Screen
function setupWorkSingleWorkspace()
  local screens = hs.screen.allScreens()
  local laptopFrame = dumbFrame(screens[1]:frame())

  -- other windows
  local windows = hs.window.allWindows()
  for _,window in pairs(windows) do
    window:setFrame(laptopFrame)
  end
end

-- Workspace -- Work -- Screen Watcher
local prevNumScreens = 0
local prevFirstScreenName = ""
function screenWatcher(forceReload)
  local screens = hs.screen.allScreens()
  hs.console.printStyledtext("have " .. (# screens) .. " screens")
  for _,screen in pairs(screens) do
    hs.console.printStyledtext(screen:name())
  end
  local appz = hs.application.runningApplications()
  for _,appy in pairs(appz) do
    hs.console.printStyledtext("have app " .. appy:name())
  end
  local firstScreenName = nil
  if ((# screens) > 0) then
    firstScreenName = screens[1]:name()
  end
  if ((# screens) == prevNumScreens and firstScreenName == prevFirstScreenName and not forceReload) then
  else
    prevNumScreens = (# screens)
    prevFirstScreenName = firstScreenName
    if ((# screens) == 1) then
      if firstScreenName == "Built-in Retina Display" then
        setupWorkSingleWorkspace()
      else
        setupWorkWideWorkspace()
      end
    elseif ((# screens) == 2 and screens[2]:name() == "iMac") then
      setupWorkDoubleWorkspace()
    end
  end
end
local workspaceScreenWatcher = hs.screen.watcher.new(screenWatcher)
workspaceScreenWatcher:start()
screenWatcher()

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "space", function()
screenWatcher(true)
end)

hs.console.printStyledtext("reloaded config")
