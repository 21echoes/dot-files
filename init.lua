-- Meta
function reloadConfig(files)
    doReload = false
    for _,file in pairs(files) do
        if file:sub(-4) == ".lua" then
            doReload = true
        end
    end
    if doReload then
        hs.reload()
    end
end
hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig):start()
hs.notify.new({title="Hammerspoon", informativeText="Config loaded"}):send()

-- Focused window movement
hs.hotkey.bind({"cmd", "alt"}, "Left", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x
  f.y = max.y
  f.w = max.w / 2
  f.h = max.h
  win:setFrame(f)
end)

hs.hotkey.bind({"cmd", "alt"}, "Right", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x + (max.w / 2)
  f.y = max.y
  f.w = max.w / 2
  f.h = max.h
  win:setFrame(f)
end)

hs.hotkey.bind({"cmd", "alt"}, "F", function()
  local win = hs.window.focusedWindow()
  win:setFrame(win:screen():frame())
end)


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
function placeAppAtFrame(appName, dumbFrame, launchIfNotRunning)
  local app = hs.appfinder.appFromName(appName)
  if not app or not app:isRunning() then
    if launchIfNotRunning then
      hs.application.launchOrFocus(appName)
      app = hs.appfinder.appFromName(appName)
    else
      return
    end
  end
  local windows = app:allWindows()
  for _,window in pairs(windows) do
    window:setFrame(dumbFrame)
  end
end

function dumbFrame(frameToMock)
  return {
    x = frameToMock.x,
    y = frameToMock.y,
    w = frameToMock.w,
    h = frameToMock.h
  }
end

function setupWorkWorkspace()
  local screens = hs.screen.allScreens()
  if ((# screens) == 3) then
    -- laptop
      -- terminal
    local terminalApp = hs.appfinder.appFromName("Terminal")
    local terminalWindows = terminalApp:allWindows()
    if ((# terminalWindows) <= 0) then
      hs.eventtap.keyStroke({"alt"}, "Space")
    end
    local terminalWindow = terminalApp:focusedWindow()
    local pinMenuSelector = {"Window", "Pin Visor"}
    local pinMenuItem = terminalApp:findMenuItem(pinMenuSelector)
    if (pinMenuItem and not pinMenuItem["ticked"]) then
      terminalApp:selectMenuItem(pinMenuSelector)
    end
    -- other windows
    local laptopFrame = screens[1]:frame()
    local evernoteFrame = dumbFrame(laptopFrame)
    local terminalFrame = dumbFrame(terminalWindow:frame())
    evernoteFrame.x = terminalFrame.x + terminalFrame.w
    evernoteFrame.w = laptopFrame.w - evernoteFrame.x
    placeAppAtFrame("Evernote", evernoteFrame, true)

    -- monitor 1
    local monitor1Frame = screens[2]:frame()
    local slackFrame = dumbFrame(monitor1Frame)
    slackFrame.w = monitor1Frame.w / 2
    placeAppAtFrame("Slack", slackFrame, true)

    for _,appName in pairs({"Sublime Text 2", "PyCharm", "Xcode"}) do
      local ideFrame = dumbFrame(monitor1Frame)
      ideFrame.x = monitor1Frame.x + (monitor1Frame.w / 2)
      ideFrame.w = monitor1Frame.w / 2
      placeAppAtFrame(appName, ideFrame, false)
    end

    -- monitor 2
    local monitor2Frame = screens[3]:frame()
    local firefoxFrame = dumbFrame(monitor2Frame)
    placeAppAtFrame("Firefox", firefoxFrame, true)
  end
end
local workWorkspaceScreenWatcher = hs.screen.watcher.new(setupWorkWorkspace)
workWorkspaceScreenWatcher:start()
