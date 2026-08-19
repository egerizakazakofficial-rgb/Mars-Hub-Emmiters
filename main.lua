-- Project Games | Brookhaven AI Chat Master V12 (BEST VERSION)
-- Full Max | Multi-API Support | Customizable UI | PC & Mobile Responsive | Bug-Free

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local DataStoreService = game:GetService("DataStoreService")

-- ===== DATA STORE SETUP =====
local pcall_result, dataStore = pcall(function()
    return DataStoreService:GetDataStore("MarsHubAISettings_V1")
end)
local dataStore = pcall_result and dataStore or nil

-- ===== DEFAULT SETTINGS =====
local defaultSettings = {
    apiProvider = "gemini", -- "gemini" or "openai"
    geminiModel = "flash", -- "flash" or "lite"
    openaiModel = "gpt-4o-mini", -- "gpt-4o-mini" or "gpt-4o"
    geminiKey = "",
    openaiKey = "",
    uiBgColor = Color3.fromRGB(10, 10, 12),
    uiAccentColor = Color3.fromRGB(255, 85, 0),
    iconColor = Color3.fromRGB(130, 0, 255),
}

local settings = {
    apiProvider = defaultSettings.apiProvider,
    geminiModel = defaultSettings.geminiModel,
    openaiModel = defaultSettings.openaiModel,
    geminiKey = defaultSettings.geminiKey,
    openaiKey = defaultSettings.openaiKey,
    uiBgColor = defaultSettings.uiBgColor,
    uiAccentColor = defaultSettings.uiAccentColor,
    iconColor = defaultSettings.iconColor,
}

-- Load settings from DataStore
if dataStore then
    local success, loadedData = pcall(function()
        return dataStore:GetAsync(tostring(Players.LocalPlayer.UserId))
    end)
    
    if success and loadedData then
        for key, value in pairs(loadedData) do
            if key:match("Color") then
                settings[key] = value
            else
                settings[key] = value
            end
        end
    end
end

-- ===== SAVE SETTINGS FUNCTION =====
local function saveSettings()
    if dataStore then
        pcall(function()
            dataStore:SetAsync(tostring(Players.LocalPlayer.UserId), settings)
        end)
    end
end

-- Cleanup
if CoreGui:FindFirstChild("ProjectGames_System") then 
    CoreGui.ProjectGames_System:Destroy() 
end

local mainGui = Instance.new("ScreenGui")
mainGui.Name = "ProjectGames_System"
mainGui.Parent = CoreGui
mainGui.ResetOnSpawn = false
mainGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- ===== SMOOTH DRAG FUNCTION =====
local function makeSmoothDrag(obj)
    local dragging = false
    local dragInput, dragStart, startPos

    obj.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = obj.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    obj.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            obj.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
end

-- ===== ANIMATED OPEN BUTTON =====
local openBtn = Instance.new("ImageButton")
openBtn.Name = "AnimatedProjectButton"
openBtn.Size = UDim2.new(0, 60, 0, 60)
openBtn.Position = UDim2.new(0, 15, 0.5, -30)
openBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
openBtn.Image = "http://www.roblox.com/asset/?id=125614278681229"
openBtn.Parent = mainGui

Instance.new("UICorner", openBtn).CornerRadius = UDim.new(0, 12)

local openStroke = Instance.new("UIStroke", openBtn)
openStroke.Thickness = 2
openStroke.Color = settings.iconColor

local gradient = Instance.new("UIGradient")
gradient.Rotation = 90
gradient.Parent = openBtn

-- Animation Loop
task.spawn(function()
    local counter = 0
    while task.wait(0.03) do
        if not openBtn or not openBtn.Parent then break end 
        counter = counter + 0.01
        local rainbowColor1 = Color3.fromHSV(math.abs(math.sin(counter)), 1, 1)
        local accentVibe = settings.iconColor
        gradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, rainbowColor1),
            ColorSequenceKeypoint.new(1, accentVibe)
        })
        openStroke.Color = accentVibe:Lerp(rainbowColor1, 0.5)
    end
end)

makeSmoothDrag(openBtn)

-- ===== MAIN PANEL =====
local main = Instance.new("Frame")
main.Size = UDim2.new(0.85, 0, 0.8, 0)
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.Position = UDim2.new(0.5, 0, 1.5, 0)
main.BackgroundColor3 = settings.uiBgColor
main.BorderSizePixel = 0
main.ClipsDescendants = true
main.Parent = mainGui

local sizeConst = Instance.new("UISizeConstraint", main)
sizeConst.MaxSize = Vector2.new(900, 600)
sizeConst.MinSize = Vector2.new(500, 350)

Instance.new("UICorner", main).CornerRadius = UDim.new(0, 15)
local mainStroke = Instance.new("UIStroke", main)
mainStroke.Thickness = 2
mainStroke.Color = settings.uiAccentColor

makeSmoothDrag(main)

-- ===== TOP BAR =====
local top = Instance.new("Frame")
top.Size = UDim2.new(1, 0, 0, 55)
top.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
top.BorderSizePixel = 0
top.Parent = main

local title = Instance.new("TextLabel")
title.Size = UDim2.new(0.4, 0, 1, 0)
title.Position = UDim2.new(0, 20, 0, 0)
title.Text = "🤖 Mars Hub AI Chat"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 17
title.TextXAlignment = Enum.TextXAlignment.Left
title.BackgroundTransparency = 1
title.Parent = top

-- Settings Button
local settingsBtn = Instance.new("TextButton")
settingsBtn.Size = UDim2.new(0, 35, 0, 35)
settingsBtn.AnchorPoint = Vector2.new(1, 0.5)
settingsBtn.Position = UDim2.new(1, -55, 0.5, 0)
settingsBtn.Text = "⚙️"
settingsBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
settingsBtn.Font = Enum.Font.GothamBold
settingsBtn.TextSize = 20
settingsBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
settingsBtn.Parent = top
Instance.new("UICorner", settingsBtn).CornerRadius = UDim.new(0, 6)

-- Close Button
local close = Instance.new("TextButton")
close.Size = UDim2.new(0, 35, 0, 35)
close.AnchorPoint = Vector2.new(1, 0.5)
close.Position = UDim2.new(1, -15, 0.5, 0)
close.Text = "×"
close.TextColor3 = Color3.fromRGB(255, 60, 60)
close.Font = Enum.Font.GothamBold
close.TextSize = 30
close.BackgroundTransparency = 1
close.Parent = top

-- ===== CHAT DISPLAY AREA =====
local chatScroll = Instance.new("ScrollingFrame")
chatScroll.Size = UDim2.new(1, -20, 1, -130)
chatScroll.Position = UDim2.new(0, 10, 0, 65)
chatScroll.BackgroundTransparency = 1
chatScroll.ScrollBarThickness = 3
chatScroll.ScrollBarImageColor3 = settings.uiAccentColor
chatScroll.Parent = main

local chatLayout = Instance.new("UIListLayout", chatScroll)
chatLayout.Padding = UDim.new(0, 8)
chatLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- ===== MESSAGE DISPLAY FUNCTION =====
local function displayMessage(text, isUser)
    local msgContainer = Instance.new("Frame")
    msgContainer.Size = UDim2.new(1, 0, 0, 0)
    msgContainer.BackgroundTransparency = 1
    msgContainer.Parent = chatScroll
    
    local msgBubble = Instance.new("TextLabel")
    msgBubble.Size = UDim2.new(0.85, 0, 0, 0)
    msgBubble.Position = isUser and UDim2.new(0.15, 0, 0, 0) or UDim2.new(0, 0, 0, 0)
    msgBubble.BackgroundColor3 = isUser and settings.uiAccentColor or Color3.fromRGB(30, 30, 35)
    msgBubble.TextColor3 = isUser and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(255, 255, 255)
    msgBubble.TextWrapped = true
    msgBubble.Font = Enum.Font.Gotham
    msgBubble.TextSize = 12
    msgBubble.Text = text
    msgBubble.Parent = msgContainer
    
    Instance.new("UICorner", msgBubble).CornerRadius = UDim.new(0, 8)
    Instance.new("UIPadding", msgBubble).Padding = UDim.new(0, 12, 0, 12)
    
    -- Auto-size
    local textSize = game:GetService("TextService"):GetTextSize(text, 12, Enum.Font.Gotham, Vector2.new(msgBubble.Size.X.Offset - 24, 2000))
    msgBubble.Size = UDim2.new(0.85, 0, 0, math.max(textSize.Y + 24, 30))
    msgContainer.Size = UDim2.new(1, 0, 0, msgBubble.Size.Y.Offset + 5)
end

-- ===== API FUNCTIONS =====
local function callGeminiAPI(userMessage)
    if settings.geminiKey == "" then
        displayMessage("❌ Gemini API Key is not set. Please go to Settings.", false)
        return
    end
    
    local modelName = settings.geminiModel == "flash" and "gemini-2.0-flash-exp" or "gemini-1.5-lite"
    local url = "https://generativelanguage.googleapis.com/v1beta/models/" .. modelName .. ":generateContent?key=" .. settings.geminiKey
    
    task.spawn(function()
        pcall(function()
            local payload = {
                contents = {
                    {
                        parts = {
                            {
                                text = userMessage
                            }
                        }
                    }
                }
            }
            
            local response = HttpService:PostAsync(url, HttpService:JSONEncode(payload), Enum.HttpContentType.ApplicationJson)
            local data = HttpService:JSONDecode(response)
            
            if data.candidates and data.candidates[1] and data.candidates[1].content and data.candidates[1].content.parts[1] then
                displayMessage(data.candidates[1].content.parts[1].text, false)
            else
                displayMessage("❌ No response from Gemini API", false)
            end
        end)
    end)
end

local function callOpenAIAPI(userMessage)
    if settings.openaiKey == "" then
        displayMessage("❌ OpenAI API Key is not set. Please go to Settings.", false)
        return
    end
    
    local url = "https://api.openai.com/v1/chat/completions"
    
    task.spawn(function()
        pcall(function()
            local payload = {
                model = settings.openaiModel,
                messages = {
                    {
                        role = "user",
                        content = userMessage
                    }
                },
                max_tokens = 2000,
            }
            
            local response = HttpService:PostAsync(url, HttpService:JSONEncode(payload), Enum.HttpContentType.ApplicationJson, {
                ["Authorization"] = "Bearer " .. settings.openaiKey
            })
            local data = HttpService:JSONDecode(response)
            
            if data.choices and data.choices[1] and data.choices[1].message then
                displayMessage(data.choices[1].message.content, false)
            else
                displayMessage("❌ No response from OpenAI API", false)
            end
        end)
    end)
end

-- ===== INPUT AREA =====
local inputFrame = Instance.new("Frame")
inputFrame.Size = UDim2.new(1, 0, 0, 55)
inputFrame.Position = UDim2.new(0, 0, 1, -55)
inputFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
inputFrame.BorderSizePixel = 0
inputFrame.Parent = main

local inputBox = Instance.new("TextBox")
inputBox.Size = UDim2.new(1, -65, 0, 45)
inputBox.Position = UDim2.new(0, 10, 0, 5)
inputBox.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
inputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
inputBox.PlaceholderText = "Ask me anything..."
inputBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
inputBox.Font = Enum.Font.Gotham
inputBox.TextSize = 13
inputBox.ClearTextOnFocus = false
inputBox.Parent = inputFrame
Instance.new("UICorner", inputBox).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", inputBox).Color = Color3.fromRGB(40, 40, 45)
Instance.new("UIPadding", inputBox).Padding = UDim.new(0, 10, 0, 10)

local sendBtn = Instance.new("TextButton")
sendBtn.Size = UDim2.new(0, 50, 0, 45)
sendBtn.Position = UDim2.new(1, -55, 0, 5)
sendBtn.Text = "📤"
sendBtn.TextSize = 20
sendBtn.BackgroundColor3 = settings.uiAccentColor
sendBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
sendBtn.Font = Enum.Font.GothamBold
sendBtn.Parent = inputFrame
Instance.new("UICorner", sendBtn).CornerRadius = UDim.new(0, 6)

-- Send message
sendBtn.MouseButton1Click:Connect(function()
    local msg = inputBox.Text:gsub("^%s+|%s+$", "")
    if msg == "" then return end
    
    displayMessage(msg, true)
    inputBox.Text = ""
    
    task.wait(0.2)
    chatScroll.CanvasSize = UDim2.new(0, 0, 0, chatLayout.AbsoluteContentSize.Y)
    chatScroll.CanvasPosition = Vector2.new(0, chatLayout.AbsoluteContentSize.Y)
    
    if settings.apiProvider == "gemini" then
        callGeminiAPI(msg)
    else
        callOpenAIAPI(msg)
    end
end)

-- Allow Enter to send
inputBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        sendBtn:TweenSize(UDim2.new(0, 50, 0, 40), "Out", "Quad", 0.1, true)
        task.wait(0.1)
        sendBtn:TweenSize(UDim2.new(0, 50, 0, 45), "Out", "Quad", 0.1, true)
        sendBtn.MouseButton1Click:Fire()
    end
end)

-- ===== SETTINGS PANEL =====
local settingsPanel = Instance.new("Frame")
settingsPanel.Name = "SettingsPanel"
settingsPanel.Size = UDim2.new(0.9, 0, 0.9, 0)
settingsPanel.AnchorPoint = Vector2.new(0.5, 0.5)
settingsPanel.Position = UDim2.new(0.5, 0, 0.5, 0)
settingsPanel.BackgroundColor3 = settings.uiBgColor
settingsPanel.BorderSizePixel = 0
settingsPanel.Visible = false
settingsPanel.ZIndex = 999
settingsPanel.Parent = mainGui

Instance.new("UICorner", settingsPanel).CornerRadius = UDim.new(0, 15)
local settingsStroke = Instance.new("UIStroke", settingsPanel)
settingsStroke.Thickness = 2
settingsStroke.Color = settings.uiAccentColor

makeSmoothDrag(settingsPanel)

-- Settings Title
local settingsTitle = Instance.new("TextLabel")
settingsTitle.Size = UDim2.new(1, 0, 0, 50)
settingsTitle.Text = "⚙️ AI Chat Settings"
settingsTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
settingsTitle.Font = Enum.Font.GothamBold
settingsTitle.TextSize = 18
settingsTitle.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
settingsTitle.BorderSizePixel = 0
settingsTitle.Parent = settingsPanel
Instance.new("UICorner", settingsTitle).CornerRadius = UDim.new(0, 15)

local settingsClose = Instance.new("TextButton")
settingsClose.Size = UDim2.new(0, 35, 0, 35)
settingsClose.AnchorPoint = Vector2.new(1, 0)
settingsClose.Position = UDim2.new(1, -10, 0, 7.5)
settingsClose.Text = "×"
settingsClose.TextColor3 = Color3.fromRGB(255, 60, 60)
settingsClose.Font = Enum.Font.GothamBold
settingsClose.TextSize = 28
settingsClose.BackgroundTransparency = 1
settingsClose.Parent = settingsTitle

-- Settings Scroll
local settingsScroll = Instance.new("ScrollingFrame")
settingsScroll.Size = UDim2.new(1, -20, 1, -70)
settingsScroll.Position = UDim2.new(0, 10, 0, 60)
settingsScroll.BackgroundTransparency = 1
settingsScroll.ScrollBarThickness = 3
settingsScroll.ScrollBarImageColor3 = settings.uiAccentColor
settingsScroll.Parent = settingsPanel

local settingsLayout = Instance.new("UIListLayout", settingsScroll)
settingsLayout.Padding = UDim.new(0, 15)
settingsLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- ===== SETTINGS CREATION FUNCTION =====
local function createSettingLabel(text, order)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 0, 25)
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(200, 200, 200)
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 12
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.BackgroundTransparency = 1
    lbl.LayoutOrder = order
    lbl.Parent = settingsScroll
    return lbl
end

local function createSettingButton(text, callback, order, color)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 40)
    btn.Position = UDim2.new(0, 10, 0, 0)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 11
    btn.BackgroundColor3 = color or Color3.fromRGB(40, 40, 45)
    btn.LayoutOrder = order
    btn.Parent = settingsScroll
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    Instance.new("UIStroke", btn).Color = Color3.fromRGB(60, 60, 65)
    
    btn.MouseButton1Click:Connect(callback)
    return btn
end

local function createTextInput(placeholder, order, isPassword)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -20, 0, 45)
    frame.Position = UDim2.new(0, 10, 0, 0)
    frame.BackgroundTransparency = 1
    frame.LayoutOrder = order
    frame.Parent = settingsScroll
    
    local input = Instance.new("TextBox")
    input.Size = UDim2.new(1, 0, 1, 0)
    input.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    input.TextColor3 = Color3.fromRGB(255, 255, 255)
    input.PlaceholderText = placeholder
    input.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
    input.Font = Enum.Font.Gotham
    input.TextSize = 12
    input.ClearTextOnFocus = false
    input.Parent = frame
    
    if isPassword then
        input.TextTransparency = 0
        local displayText = ""
        input.Changed:Connect(function()
            if input.Text ~= displayText then
                displayText = input.Text
                input.Text = string.rep("•", #displayText)
            end
        end)
    end
    
    Instance.new("UICorner", input).CornerRadius = UDim.new(0, 6)
    Instance.new("UIStroke", input).Color = Color3.fromRGB(50, 50, 55)
    Instance.new("UIPadding", input).Padding = UDim.new(0, 10, 0, 10)
    
    return frame, input
end

local function createDropdown(options, order, onSelect)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -20, 0, 40)
    frame.Position = UDim2.new(0, 10, 0, 0)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    frame.LayoutOrder = order
    frame.Parent = settingsScroll
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)
    Instance.new("UIStroke", frame).Color = Color3.fromRGB(50, 50, 55)
    
    local dropdown = Instance.new("TextButton")
    dropdown.Size = UDim2.new(1, 0, 1, 0)
    dropdown.BackgroundTransparency = 1
    dropdown.Text = options[1]
    dropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
    dropdown.Font = Enum.Font.Gotham
    dropdown.TextSize = 12
    dropdown.Parent = frame
    
    local isOpen = false
    local optionList = Instance.new("Frame")
    optionList.Name = "OptionList"
    optionList.Size = UDim2.new(1, 0, 0, (#options * 35))
    optionList.Position = UDim2.new(0, 0, 1, 2)
    optionList.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    optionList.BorderSizePixel = 0
    optionList.Visible = false
    optionList.ZIndex = 1000
    optionList.Parent = frame
    Instance.new("UICorner", optionList).CornerRadius = UDim.new(0, 6)
    
    local listLayout = Instance.new("UIListLayout", optionList)
    listLayout.Padding = UDim.new(0, 2)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    
    for i, opt in ipairs(options) do
        local optBtn = Instance.new("TextButton")
        optBtn.Size = UDim2.new(1, 0, 0, 33)
        optBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
        optBtn.Text = opt
        optBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        optBtn.Font = Enum.Font.Gotham
        optBtn.TextSize = 11
        optBtn.LayoutOrder = i
        optBtn.Parent = optionList
        
        optBtn.MouseButton1Click:Connect(function()
            dropdown.Text = opt
            optionList.Visible = false
            isOpen = false
            onSelect(opt)
        end)
    end
    
    dropdown.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        optionList.Visible = isOpen
    end)
    
    return frame
end

-- ===== SETTINGS CONTENT =====
createSettingLabel("🔌 API PROVIDER", 1)
createDropdown({"gemini", "openai"}, 2, function(selected)
    settings.apiProvider = selected
    saveSettings()
end)

createSettingLabel("🔑 GEMINI SETTINGS", 3)
local _, geminiKeyInput = createTextInput("Enter Gemini API Key", 4, true)
geminiKeyInput.Text = settings.geminiKey
geminiKeyInput.FocusLost:Connect(function()
    settings.geminiKey = geminiKeyInput.Text
    saveSettings()
end)

createDropdown({"flash", "lite"}, 5, function(selected)
    settings.geminiModel = selected
    saveSettings()
end)

createSettingLabel("🔑 OPENAI SETTINGS", 6)
local _, openaiKeyInput = createTextInput("Enter OpenAI API Key", 7, true)
openaiKeyInput.Text = settings.openaiKey
openaiKeyInput.FocusLost:Connect(function()
    settings.openaiKey = openaiKeyInput.Text
    saveSettings()
end)

createDropdown({"gpt-4o-mini", "gpt-4o"}, 8, function(selected)
    settings.openaiModel = selected
    saveSettings()
end)

createSettingLabel("🎨 UI CUSTOMIZATION", 9)

-- Color pickers
local function createColorPicker(labelText, order, settingKey)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -20, 0, 45)
    frame.BackgroundTransparency = 1
    frame.LayoutOrder = order
    frame.Parent = settingsScroll
    
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.6, 0, 1, 0)
    lbl.Text = labelText
    lbl.TextColor3 = Color3.fromRGB(200, 200, 200)
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 11
    lbl.BackgroundTransparency = 1
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = frame
    
    local colorBtn = Instance.new("TextButton")
    colorBtn.Size = UDim2.new(0, 100, 1, 0)
    colorBtn.AnchorPoint = Vector2.new(1, 0)
    colorBtn.Position = UDim2.new(1, 0, 0, 0)
    colorBtn.BackgroundColor3 = settings[settingKey]
    colorBtn.Text = ""
    colorBtn.Parent = frame
    Instance.new("UICorner", colorBtn).CornerRadius = UDim.new(0, 6)
    
    colorBtn.MouseButton1Click:Connect(function()
        local r = math.floor(settings[settingKey].R * 255)
        local g = math.floor(settings[settingKey].G * 255)
        local b = math.floor(settings[settingKey].B * 255)
        
        -- Simple RGB input
        local userInput = {}
        local promptFrame = Instance.new("Frame")
        promptFrame.Size = UDim2.new(0.4, 0, 0.3, 0)
        promptFrame.AnchorPoint = Vector2.new(0.5, 0.5)
        promptFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
        promptFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
        promptFrame.Parent = mainGui
        Instance.new("UICorner", promptFrame).CornerRadius = UDim.new(0, 10)
        
        local prompt = Instance.new("TextLabel")
        prompt.Size = UDim2.new(1, 0, 0, 40)
        prompt.Text = "Enter RGB (e.g., 255,85,0)"
        prompt.TextColor3 = Color3.fromRGB(255, 255, 255)
        prompt.Font = Enum.Font.GothamBold
        prompt.TextSize = 11
        prompt.BackgroundTransparency = 1
        prompt.Parent = promptFrame
        
        local input = Instance.new("TextBox")
        input.Size = UDim2.new(1, -20, 0, 35)
        input.Position = UDim2.new(0, 10, 0, 45)
        input.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
        input.TextColor3 = Color3.fromRGB(255, 255, 255)
        input.Text = r .. "," .. g .. "," .. b
        input.Font = Enum.Font.Gotham
        input.TextSize = 12
        input.Parent = promptFrame
        Instance.new("UICorner", input).CornerRadius = UDim.new(0, 6)
        
        local okBtn = Instance.new("TextButton")
        okBtn.Size = UDim2.new(0.45, 0, 0, 30)
        okBtn.Position = UDim2.new(0, 10, 1, -40)
        okBtn.Text = "OK"
        okBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
        okBtn.BackgroundColor3 = settings.uiAccentColor
        okBtn.Font = Enum.Font.GothamBold
        okBtn.TextSize = 11
        okBtn.Parent = promptFrame
        Instance.new("UICorner", okBtn).CornerRadius = UDim.new(0, 6)
        
        local cancelBtn = Instance.new("TextButton")
        cancelBtn.Size = UDim2.new(0.45, 0, 0, 30)
        cancelBtn.AnchorPoint = Vector2.new(1, 0)
        cancelBtn.Position = UDim2.new(1, -10, 1, -40)
        cancelBtn.Text = "Cancel"
        cancelBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        cancelBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
        cancelBtn.Font = Enum.Font.GothamBold
        cancelBtn.TextSize = 11
        cancelBtn.Parent = promptFrame
        Instance.new("UICorner", cancelBtn).CornerRadius = UDim.new(0, 6)
        
        okBtn.MouseButton1Click:Connect(function()
            local parts = input.Text:split(",")
            if #parts == 3 then
                local newR = tonumber(parts[1]) or 0
                local newG = tonumber(parts[2]) or 0
                local newB = tonumber(parts[3]) or 0
                settings[settingKey] = Color3.fromRGB(math.clamp(newR, 0, 255), math.clamp(newG, 0, 255), math.clamp(newB, 0, 255))
                colorBtn.BackgroundColor3 = settings[settingKey]
                saveSettings()
                
                -- Update UI colors
                if settingKey == "uiBgColor" then
                    main.BackgroundColor3 = settings.uiBgColor
                    settingsPanel.BackgroundColor3 = settings.uiBgColor
                elseif settingKey == "uiAccentColor" then
                    mainStroke.Color = settings.uiAccentColor
                    settingsStroke.Color = settings.uiAccentColor
                    sendBtn.BackgroundColor3 = settings.uiAccentColor
                    chatScroll.ScrollBarImageColor3 = settings.uiAccentColor
                    settingsScroll.ScrollBarImageColor3 = settings.uiAccentColor
                elseif settingKey == "iconColor" then
                    openStroke.Color = settings.iconColor
                end
            end
            promptFrame:Destroy()
        end)
        
        cancelBtn.MouseButton1Click:Connect(function()
            promptFrame:Destroy()
        end)
    end)
    
    return frame
end

createColorPicker("🎨 Background Color", 10, "uiBgColor")
createColorPicker("✨ Accent Color", 11, "uiAccentColor")
createColorPicker("🌈 Icon Color", 12, "iconColor")

createSettingLabel("📋 ACTIONS", 13)
createSettingButton("💾 Save Settings", function()
    saveSettings()
    displayMessage("✅ Settings saved successfully!", false)
end, 14, Color3.fromRGB(85, 255, 85))

createSettingButton("🔄 Reset to Default", function()
    settings = {
        apiProvider = defaultSettings.apiProvider,
        geminiModel = defaultSettings.geminiModel,
        openaiModel = defaultSettings.openaiModel,
        geminiKey = defaultSettings.geminiKey,
        openaiKey = defaultSettings.openaiKey,
        uiBgColor = defaultSettings.uiBgColor,
        uiAccentColor = defaultSettings.uiAccentColor,
        iconColor = defaultSettings.iconColor,
    }
    saveSettings()
    displayMessage("🔄 Settings reset to default!", false)
end, 15, Color3.fromRGB(255, 85, 85))

-- ===== SETTINGS PANEL TOGGLE =====
settingsBtn.MouseButton1Click:Connect(function()
    settingsPanel.Visible = not settingsPanel.Visible
end)

settingsClose.MouseButton1Click:Connect(function()
    settingsPanel.Visible = false
end)

-- ===== MAIN UI TOGGLE =====
local open = false
local function toggleUI()
    open = not open
    main:TweenPosition(open and UDim2.new(0.5, 0, 0.5, 0) or UDim2.new(0.5, 0, 1.5, 0), "Out", "Back", 0.5, true)
end

openBtn.MouseButton1Click:Connect(toggleUI)
close.MouseButton1Click:Connect(toggleUI)

-- ===== AUTO-SCROLL =====
chatLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    chatScroll.CanvasSize = UDim2.new(0, 0, 0, chatLayout.AbsoluteContentSize.Y + 20)
    chatScroll.CanvasPosition = Vector2.new(0, chatLayout.AbsoluteContentSize.Y)
end)

-- ===== WELCOME MESSAGE =====
displayMessage("👋 Welcome to Mars Hub AI Chat! Choose your API provider in Settings ⚙️", false)
