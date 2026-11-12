-- Send selected text to the Claude desktop app with a preset prompt.
-- Install: ./setup.sh in the dotfiles installs Hammerspoon and links this file to ~/.hammerspoon/init.lua;
-- grant Accessibility permission, then "Reload Config" from the menu bar icon.

local CLAUDE_APP = "Claude"
local AUTO_SEND  = true   -- false = paste only, so you can tweak before sending
local MODS       = { "ctrl", "alt", "cmd" }

-- key = direct hotkey (optional); every action also appears in the picker (⌃⌥⌘Space)
local actions = {
  { key = "e", label = "Translate to English", prompt = "Translate the following text to English. Only return the translation:" },
  { key = "n", label = "Translate to Dutch",   prompt = "Translate the following text to Dutch. Only return the translation:" },
  { key = "g", label = "Check grammar",        prompt = "Check the following text for grammar and spelling. Return the corrected text, then list the changes briefly:" },
  { key = "s", label = "Improve style",        prompt = "Improve the style and clarity of the following text, keeping the tone and meaning:" },
  {            label = "Make more formal",     prompt = "Rewrite the following text in a more formal tone, keeping the meaning:" },
  {            label = "Summarize",            prompt = "Summarize the following text in a few sentences:" },
}

local function getSelection()
  local before = hs.pasteboard.changeCount()
  local saved = hs.pasteboard.readAllData()
  hs.eventtap.keyStroke({ "cmd" }, "c")
  -- wait until the clipboard actually changes (max ~0.5s)
  for _ = 1, 25 do
    if hs.pasteboard.changeCount() ~= before then break end
    hs.timer.usleep(20000)
  end
  if hs.pasteboard.changeCount() == before then return nil, saved end
  return hs.pasteboard.getContents(), saved
end

local function pasteIntoClaude(prompt, text, saved)
  hs.pasteboard.setContents(prompt .. "\n\n" .. text)
  hs.application.launchOrFocus(CLAUDE_APP)

  hs.timer.doAfter(0.4, function()
    hs.eventtap.keyStroke({ "cmd" }, "n")          -- new chat
    hs.timer.doAfter(0.4, function()
      hs.eventtap.keyStroke({ "cmd" }, "v")        -- paste
      if AUTO_SEND then
        hs.timer.doAfter(0.2, function() hs.eventtap.keyStroke({}, "return") end)
      end
      -- restore the original clipboard
      hs.timer.doAfter(1.0, function()
        if saved then hs.pasteboard.writeAllData(saved) end
      end)
    end)
  end)
end

local function sendToClaude(prompt)
  local text, saved = getSelection()
  if not text or text == "" then
    hs.alert.show("No text selected")
    return
  end
  pasteIntoClaude(prompt, text, saved)
end

-- Direct hotkeys: ⌃⌥⌘ + E (English), N (Dutch), G (grammar), S (style)
for _, a in ipairs(actions) do
  if a.key then
    hs.hotkey.bind(MODS, a.key, function() sendToClaude(a.prompt) end)
  end
end

-- Picker: ⌃⌥⌘Space, type to filter, Enter to send
local pending = nil   -- selection captured before the picker opens

local chooser = hs.chooser.new(function(choice)
  if not pending then return end
  if not choice then   -- Esc: put the original clipboard back
    if pending.saved then hs.pasteboard.writeAllData(pending.saved) end
    pending = nil
    return
  end
  local p = pending
  pending = nil
  pasteIntoClaude(actions[choice.index].prompt, p.text, p.saved)
end)

local choices = {}
for i, a in ipairs(actions) do
  table.insert(choices, {
    text = a.label,
    subText = a.key and ("⌃⌥⌘" .. a.key:upper()) or nil,
    index = i,
  })
end
chooser:choices(choices)
chooser:placeholderText("Send selection to Claude…")

hs.hotkey.bind(MODS, "space", function()
  local text, saved = getSelection()   -- grab selection first, the picker steals focus
  if not text or text == "" then
    hs.alert.show("No text selected")
    return
  end
  pending = { text = text, saved = saved }
  chooser:query("")
  chooser:show()
end)

hs.alert.show("Claude hotkeys loaded")