-- Modern UI Server Info Script for KRNL (Improved Version)
-- This script displays server, player, and user information in a clean, modern UI

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local SocialService = game:GetService("SocialService") -- Added SocialService

-- Variables
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera

-- Destroy previous GUI if it exists
if CoreGui:FindFirstChild("ServerInfoGUI") then
    CoreGui:FindFirstChild("ServerInfoGUI"):Destroy()
end

-- Create the main GUI
local ServerInfoGUI = Instance.new("ScreenGui")
ServerInfoGUI.Name = "ServerInfoGUI"
ServerInfoGUI.Parent = CoreGui
ServerInfoGUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ServerInfoGUI.ResetOnSpawn = false

-- Create the main frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ServerInfoGUI
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.Size = UDim2.new(0, 600, 0, 375)
MainFrame.ClipsDescendants = true

-- Create minimized circle frame (hidden initially)
local MinimizedCircle = Instance.new("Frame")
MinimizedCircle.Name = "MinimizedCircle"
MinimizedCircle.Parent = ServerInfoGUI
MinimizedCircle.AnchorPoint = Vector2.new(0.5, 0.5)
MinimizedCircle.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MinimizedCircle.BorderSizePixel = 0
MinimizedCircle.Position = UDim2.new(0.1, 0, 0.1, 0)
MinimizedCircle.Size = UDim2.new(0, 50, 0, 50)
MinimizedCircle.Visible = false

local CircleCorner = Instance.new("UICorner")
CircleCorner.CornerRadius = UDim.new(1, 0)
CircleCorner.Parent = MinimizedCircle

local CircleIcon = Instance.new("TextLabel")
CircleIcon.Name = "CircleIcon"
CircleIcon.Parent = MinimizedCircle
CircleIcon.BackgroundTransparency = 1
CircleIcon.Size = UDim2.new(1, 0, 1, 0)
CircleIcon.Font = Enum.Font.GothamBold
CircleIcon.Text = "SI"
CircleIcon.TextColor3 = Color3.fromRGB(0, 170, 255)
CircleIcon.TextSize = 18

-- Add rounded corners to main frame
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 6)
UICorner.Parent = MainFrame

-- Add shadow to main frame
local Shadow = Instance.new("ImageLabel")
Shadow.Name = "Shadow"
Shadow.Parent = MainFrame
Shadow.BackgroundTransparency = 1
Shadow.Position = UDim2.new(0, -15, 0, -15)
Shadow.Size = UDim2.new(1, 30, 1, 30)
Shadow.ZIndex = -1
Shadow.Image = "rbxassetid://5554236805"
Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
Shadow.ScaleType = Enum.ScaleType.Slice
Shadow.SliceCenter = Rect.new(23, 23, 277, 277)

-- Create Top Bar
local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Parent = MainFrame
TopBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
TopBar.BorderSizePixel = 0
TopBar.Size = UDim2.new(1, 0, 0, 30)

local UICorner_TopBar = Instance.new("UICorner")
UICorner_TopBar.CornerRadius = UDim.new(0, 6)
UICorner_TopBar.Parent = TopBar

-- Create Title
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Parent = TopBar
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 10, 0, 0)
Title.Size = UDim2.new(0, 200, 1, 0)
Title.Font = Enum.Font.GothamSemibold
Title.Text = "Server Information"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Create Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Parent = TopBar
CloseButton.BackgroundTransparency = 1
CloseButton.Position = UDim2.new(1, -25, 0, 5)
CloseButton.Size = UDim2.new(0, 20, 0, 20)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 100, 100)
CloseButton.TextSize = 14

-- Create Minimize Button
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Name = "MinimizeButton"
MinimizeButton.Parent = TopBar
MinimizeButton.BackgroundTransparency = 1
MinimizeButton.Position = UDim2.new(1, -50, 0, 5)
MinimizeButton.Size = UDim2.new(0, 20, 0, 20)
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.Text = "_"
MinimizeButton.TextColor3 = Color3.fromRGB(200, 200, 200)
MinimizeButton.TextSize = 14

-- Create Side Navigation
local SideNav = Instance.new("Frame")
SideNav.Name = "SideNav"
SideNav.Parent = MainFrame
SideNav.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
SideNav.BorderSizePixel = 0
SideNav.Position = UDim2.new(0, 0, 0, 30)
SideNav.Size = UDim2.new(0, 120, 1, -30)

local UICorner_SideNav = Instance.new("UICorner")
UICorner_SideNav.CornerRadius = UDim.new(0, 6)
UICorner_SideNav.Parent = SideNav

-- Fix corner overlap
local FixCorner = Instance.new("Frame")
FixCorner.Name = "FixCorner"
FixCorner.Parent = SideNav
FixCorner.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
FixCorner.BorderSizePixel = 0
FixCorner.Position = UDim2.new(1, -6, 0, 0)
FixCorner.Size = UDim2.new(0, 6, 0, 6)

-- Create Tabs
local function CreateTab(name, position, selected)
    local Tab = Instance.new("TextButton")
    Tab.Name = name .. "Tab"
    Tab.Parent = SideNav
    Tab.BackgroundColor3 = selected and Color3.fromRGB(45, 45, 45) or Color3.fromRGB(35, 35, 35)
    Tab.BorderSizePixel = 0
    Tab.Position = UDim2.new(0, 0, 0, position)
    Tab.Size = UDim2.new(1, 0, 0, 30)
    Tab.Font = Enum.Font.Gotham
    Tab.Text = name
    Tab.TextColor3 = selected and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(200, 200, 200)
    Tab.TextSize = 14
    
    local Indicator = Instance.new("Frame")
    Indicator.Name = "Indicator"
    Indicator.Parent = Tab
    Indicator.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    Indicator.BorderSizePixel = 0
    Indicator.Size = UDim2.new(0, 2, 1, 0)
    Indicator.Visible = selected
    
    return Tab
end

local ServerTab = CreateTab("Server", 10, true)
local PlayersTab = CreateTab("Players", 50, false)
local LocalTab = CreateTab("Local User", 90, false)

-- Create content frames
local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Parent = MainFrame
ContentFrame.BackgroundTransparency = 1
ContentFrame.Position = UDim2.new(0, 130, 0, 40)
ContentFrame.Size = UDim2.new(1, -140, 1, -50)

-- Server Info Content
local ServerInfo = Instance.new("ScrollingFrame")
ServerInfo.Name = "ServerInfo"
ServerInfo.Parent = ContentFrame
ServerInfo.Active = true
ServerInfo.BackgroundTransparency = 1
ServerInfo.BorderSizePixel = 0
ServerInfo.Size = UDim2.new(1, 0, 1, 0)
ServerInfo.ScrollBarThickness = 4
ServerInfo.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
ServerInfo.Visible = true
ServerInfo.CanvasSize = UDim2.new(0, 0, 0, 0) -- Will be adjusted dynamically

local UIListLayout_Server = Instance.new("UIListLayout")
UIListLayout_Server.Parent = ServerInfo
UIListLayout_Server.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout_Server.Padding = UDim.new(0, 10)

-- Players Info Content
local PlayersInfo = Instance.new("ScrollingFrame")
PlayersInfo.Name = "PlayersInfo"
PlayersInfo.Parent = ContentFrame
PlayersInfo.Active = true
PlayersInfo.BackgroundTransparency = 1
PlayersInfo.BorderSizePixel = 0
PlayersInfo.Size = UDim2.new(1, 0, 1, -30) -- Adjusted to make room for search bar
PlayersInfo.Position = UDim2.new(0, 0, 0, 30) -- Moved down to make room for search bar
PlayersInfo.ScrollBarThickness = 4
PlayersInfo.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
PlayersInfo.Visible = false
PlayersInfo.CanvasSize = UDim2.new(0, 0, 0, 0) -- Will be adjusted dynamically

local UIListLayout_Players = Instance.new("UIListLayout")
UIListLayout_Players.Parent = PlayersInfo
UIListLayout_Players.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout_Players.Padding = UDim.new(0, 10)

-- Search bar for Players tab
local SearchBarFrame = Instance.new("Frame")
SearchBarFrame.Name = "SearchBarFrame"
SearchBarFrame.Parent = ContentFrame
SearchBarFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
SearchBarFrame.BorderSizePixel = 0
SearchBarFrame.Position = UDim2.new(0, 0, 0, 0)
SearchBarFrame.Size = UDim2.new(1, 0, 0, 25)
SearchBarFrame.Visible = false

local UICorner_SearchBar = Instance.new("UICorner")
UICorner_SearchBar.CornerRadius = UDim.new(0, 4)
UICorner_SearchBar.Parent = SearchBarFrame

local SearchBarIcon = Instance.new("ImageLabel")
SearchBarIcon.Name = "SearchBarIcon"
SearchBarIcon.Parent = SearchBarFrame
SearchBarIcon.BackgroundTransparency = 1
SearchBarIcon.Position = UDim2.new(0, 5, 0, 4)
SearchBarIcon.Size = UDim2.new(0, 16, 0, 16)
SearchBarIcon.Image = "rbxassetid://3926305904" -- Roblox icon asset
SearchBarIcon.ImageRectOffset = Vector2.new(964, 324)
SearchBarIcon.ImageRectSize = Vector2.new(36, 36)
SearchBarIcon.ImageColor3 = Color3.fromRGB(200, 200, 200)

local SearchBar = Instance.new("TextBox")
SearchBar.Name = "SearchBar"
SearchBar.Parent = SearchBarFrame
SearchBar.BackgroundTransparency = 1
SearchBar.Position = UDim2.new(0, 25, 0, 0)
SearchBar.Size = UDim2.new(1, -30, 1, 0)
SearchBar.Font = Enum.Font.Gotham
SearchBar.PlaceholderText = "Search players..."
SearchBar.Text = ""
SearchBar.TextColor3 = Color3.fromRGB(255, 255, 255)
SearchBar.TextSize = 14
SearchBar.TextXAlignment = Enum.TextXAlignment.Left
SearchBar.ClearTextOnFocus = false

-- Local User Info Content
local LocalUserInfo = Instance.new("ScrollingFrame")
LocalUserInfo.Name = "LocalUserInfo"
LocalUserInfo.Parent = ContentFrame
LocalUserInfo.Active = true
LocalUserInfo.BackgroundTransparency = 1
LocalUserInfo.BorderSizePixel = 0
LocalUserInfo.Size = UDim2.new(1, 0, 1, 0)
LocalUserInfo.ScrollBarThickness = 4
LocalUserInfo.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
LocalUserInfo.Visible = false
LocalUserInfo.CanvasSize = UDim2.new(0, 0, 0, 0) -- Will be adjusted dynamically

local UIListLayout_Local = Instance.new("UIListLayout")
UIListLayout_Local.Parent = LocalUserInfo
UIListLayout_Local.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout_Local.Padding = UDim.new(0, 10)

-- Helper Functions
local function CreateInfoCard(parent, title, content, order)
    local InfoCard = Instance.new("Frame")
    InfoCard.Name = title .. "Card"
    InfoCard.Parent = parent
    InfoCard.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    InfoCard.BorderSizePixel = 0
    InfoCard.Size = UDim2.new(1, -20, 0, 50)
    InfoCard.LayoutOrder = order
    
    local UICorner_Card = Instance.new("UICorner")
    UICorner_Card.CornerRadius = UDim.new(0, 4)
    UICorner_Card.Parent = InfoCard
    
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Parent = InfoCard
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 10, 0, 5)
    Title.Size = UDim2.new(1, -20, 0, 20)
    Title.Font = Enum.Font.GothamBold
    Title.Text = title
    Title.TextColor3 = Color3.fromRGB(200, 200, 200)
    Title.TextSize = 14
    Title.TextXAlignment = Enum.TextXAlignment.Left
    
    local Content = Instance.new("TextLabel")
    Content.Name = "Content"
    Content.Parent = InfoCard
    Content.BackgroundTransparency = 1
    Content.Position = UDim2.new(0, 10, 0, 25)
    Content.Size = UDim2.new(1, -20, 0, 20)
    Content.Font = Enum.Font.Gotham
    Content.Text = content
    Content.TextColor3 = Color3.fromRGB(255, 255, 255)
    Content.TextSize = 14
    Content.TextXAlignment = Enum.TextXAlignment.Left
    
    return Content
end

-- Create notification function
local function CreateNotification(text, duration)
    duration = duration or 3
    
    local notification = Instance.new("Frame")
    notification.Name = "Notification"
    notification.Parent = ServerInfoGUI
    notification.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    notification.BorderSizePixel = 0
    notification.Position = UDim2.new(0.5, -100, 0.1, 0)
    notification.Size = UDim2.new(0, 200, 0, 50)
    notification.AnchorPoint = Vector2.new(0.5, 0)
    
    local UICorner_Notif = Instance.new("UICorner")
    UICorner_Notif.CornerRadius = UDim.new(0, 6)
    UICorner_Notif.Parent = notification
    
    local NotifText = Instance.new("TextLabel")
    NotifText.Name = "NotifText"
    NotifText.Parent = notification
    NotifText.BackgroundTransparency = 1
    NotifText.Position = UDim2.new(0, 10, 0, 0)
    NotifText.Size = UDim2.new(1, -20, 1, 0)
    NotifText.Font = Enum.Font.GothamSemibold
    NotifText.Text = text
    NotifText.TextColor3 = Color3.fromRGB(255, 255, 255)
    NotifText.TextSize = 14
    NotifText.TextWrapped = true
    
    -- Add a nice fade-in and fade-out effect
    notification.BackgroundTransparency = 1
    NotifText.TextTransparency = 1
    
    -- Fade in
    TweenService:Create(notification, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
    TweenService:Create(NotifText, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
    
    -- Fade out after delay
    task.delay(duration, function()
        local fadeOut = TweenService:Create(notification, TweenInfo.new(0.5), {BackgroundTransparency = 1})
        local textFadeOut = TweenService:Create(NotifText, TweenInfo.new(0.5), {TextTransparency = 1})
        
        fadeOut:Play()
        textFadeOut:Play()
        
        fadeOut.Completed:Connect(function()
            notification:Destroy()
        end)
    end)
end

local function SwitchToOriginalPlayer()
    -- Switch camera back to local player
    local localHumanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if localHumanoid then
        workspace.CurrentCamera.CameraSubject = localHumanoid
    end
end

local CurrentlySpectating = false -- Flag to track spectating state
local function CreatePlayerCard(player, order)
    local PlayerCard = Instance.new("Frame")
    PlayerCard.Name = player.Name .. "Card"
    PlayerCard.Parent = PlayersInfo
    PlayerCard.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    PlayerCard.BorderSizePixel = 0
    PlayerCard.Size = UDim2.new(1, -20, 0, 165)
    PlayerCard.LayoutOrder = order
    
    -- Tag to store player's name for search filtering
    PlayerCard:SetAttribute("PlayerName", string.lower(player.Name))
    if player.DisplayName then
        PlayerCard:SetAttribute("DisplayName", string.lower(player.DisplayName))
    end
    
    local UICorner_Card = Instance.new("UICorner")
    UICorner_Card.CornerRadius = UDim.new(0, 4)
    UICorner_Card.Parent = PlayerCard
    
    -- Create a gradient background for a modern look
    local UIGradient = Instance.new("UIGradient")
    UIGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(45, 45, 45)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(35, 35, 35))
    })
    UIGradient.Rotation = 90
    UIGradient.Parent = PlayerCard
    
    local Avatar = Instance.new("ImageLabel")
    Avatar.Name = "Avatar"
    Avatar.Parent = PlayerCard
    Avatar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Avatar.BorderSizePixel = 0
    Avatar.Position = UDim2.new(0, 10, 0, 10)
    Avatar.Size = UDim2.new(0, 80, 0, 80)
    
    local UICorner_Avatar = Instance.new("UICorner")
    UICorner_Avatar.CornerRadius = UDim.new(0, 4)
    UICorner_Avatar.Parent = Avatar
    
    -- Avatar stroke for better appearance
    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = Color3.fromRGB(60, 60, 60)
    UIStroke.Thickness = 1
    UIStroke.Parent = Avatar
    
    -- Try to load the player's thumbnail
    local success, result = pcall(function()
        return Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
    end)
    
    if success then
        Avatar.Image = result
    else
        Avatar.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
    end
    
    -- Player info
    local PlayerName = Instance.new("TextLabel")
    PlayerName.Name = "PlayerName"
    PlayerName.Parent = PlayerCard
    PlayerName.BackgroundTransparency = 1
    PlayerName.Position = UDim2.new(0, 100, 0, 10)
    PlayerName.Size = UDim2.new(1, -190, 0, 20) -- Adjusted width for buttons
    PlayerName.Font = Enum.Font.GothamBold
    PlayerName.Text = player.Name
    PlayerName.TextColor3 = Color3.fromRGB(255, 255, 255)
    PlayerName.TextSize = 16
    PlayerName.TextXAlignment = Enum.TextXAlignment.Left
    
    local DisplayName = Instance.new("TextLabel")
    DisplayName.Name = "DisplayName"
    DisplayName.Parent = PlayerCard
    DisplayName.BackgroundTransparency = 1
    DisplayName.Position = UDim2.new(0, 100, 0, 30)
    DisplayName.Size = UDim2.new(1, -110, 0, 20)
    DisplayName.Font = Enum.Font.Gotham
    DisplayName.Text = "Display: " .. player.DisplayName
    DisplayName.TextColor3 = Color3.fromRGB(200, 200, 200)
    DisplayName.TextSize = 14
    DisplayName.TextXAlignment = Enum.TextXAlignment.Left
    
    local UserId = Instance.new("TextLabel")
    UserId.Name = "UserId"
    UserId.Parent = PlayerCard
    UserId.BackgroundTransparency = 1
    UserId.Position = UDim2.new(0, 100, 0, 50)
    UserId.Size = UDim2.new(1, -110, 0, 20)
    UserId.Font = Enum.Font.Gotham
    UserId.Text = "ID: " .. player.UserId
    UserId.TextColor3 = Color3.fromRGB(200, 200, 200)
    UserId.TextSize = 14
    UserId.TextXAlignment = Enum.TextXAlignment.Left
    
    local Account = Instance.new("TextLabel")
    Account.Name = "Account"
    Account.Parent = PlayerCard
    Account.BackgroundTransparency = 1
    Account.Position = UDim2.new(0, 100, 0, 70)
    Account.Size = UDim2.new(1, -110, 0, 20)
    Account.Font = Enum.Font.Gotham
    Account.Text = "Age: " .. player.AccountAge .. " days"
    Account.TextColor3 = Color3.fromRGB(200, 200, 200)
    Account.TextSize = 14
    Account.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Additional player details
    local TeamLabel = Instance.new("TextLabel")
    TeamLabel.Name = "TeamLabel"
    TeamLabel.Parent = PlayerCard
    TeamLabel.BackgroundTransparency = 1
    TeamLabel.Position = UDim2.new(0, 10, 0, 100)
    TeamLabel.Size = UDim2.new(0.48, 0, 0, 20)
    TeamLabel.Font = Enum.Font.Gotham
    TeamLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    TeamLabel.TextSize = 14
    TeamLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Check if player is on a team
    if player.Team then
        TeamLabel.Text = "Team: " .. player.Team.Name
        TeamLabel.TextColor3 = player.TeamColor.Color
    else
        TeamLabel.Text = "Team: None"
    end
    
    -- Check if player is friend
    local IsFriendLabel = Instance.new("TextLabel")
    IsFriendLabel.Name = "IsFriendLabel"
    IsFriendLabel.Parent = PlayerCard
    IsFriendLabel.BackgroundTransparency = 1
    IsFriendLabel.Position = UDim2.new(0.52, 0, 0, 100)
    IsFriendLabel.Size = UDim2.new(0.48, 0, 0, 20)
    IsFriendLabel.Font = Enum.Font.Gotham
    IsFriendLabel.TextSize = 14
    IsFriendLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Check if player is a friend (safely)
    local isFriend = false
    pcall(function()
        isFriend = LocalPlayer:IsFriendsWith(player.UserId)
    end)
    
    if isFriend then
        IsFriendLabel.Text = "Friend: Yes"
        IsFriendLabel.TextColor3 = Color3.fromRGB(85, 255, 127)
    else
        IsFriendLabel.Text = "Friend: No"
        IsFriendLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    end
    
    -- Premium status (if available)
    local PremiumLabel = Instance.new("TextLabel")
    PremiumLabel.Name = "PremiumLabel"
    PremiumLabel.Parent = PlayerCard
    PremiumLabel.BackgroundTransparency = 1
    PremiumLabel.Position = UDim2.new(0, 10, 0, 120)
    PremiumLabel.Size = UDim2.new(0.48, 0, 0, 20)
    PremiumLabel.Font = Enum.Font.Gotham
    PremiumLabel.TextSize = 14
    PremiumLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Check premium status (safely)
    local hasPremium = false
    pcall(function()
        hasPremium = player.MembershipType == Enum.MembershipType.Premium
    end)
    
    if hasPremium then
        PremiumLabel.Text = "Premium: Yes"
        PremiumLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
    else
        PremiumLabel.Text = "Premium: No"
        PremiumLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    end
    
    -- Distance from local player (if both have characters)
    local DistanceLabel = Instance.new("TextLabel")
    DistanceLabel.Name = "DistanceLabel"
    DistanceLabel.Parent = PlayerCard
    DistanceLabel.BackgroundTransparency = 1
    DistanceLabel.Position = UDim2.new(0.52, 0, 0, 120)
    DistanceLabel.Size = UDim2.new(0.48, 0, 0, 20)
    DistanceLabel.Font = Enum.Font.Gotham
    DistanceLabel.TextSize = 14
    DistanceLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local distance = "N/A"
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and 
       player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        distance = math.floor((LocalPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude)
        DistanceLabel.Text = "Distance: " .. distance .. " studs"
    else
        DistanceLabel.Text = "Distance: N/A"
    end
    DistanceLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    
     -- Spectate button with play icon
    local SpectateButton = Instance.new("TextButton")
    SpectateButton.Name = "SpectateButton"
    SpectateButton.Parent = PlayerCard
    SpectateButton.BackgroundColor3 = Color3.fromRGB(60, 120, 190)
    SpectateButton.BorderSizePixel = 0
    SpectateButton.Position = UDim2.new(1, -150, 0, 15) -- Adjusted position
    SpectateButton.Size = UDim2.new(0, 70, 0, 25)
    SpectateButton.Font = Enum.Font.GothamSemibold
    SpectateButton.Text = "Spectate"
    SpectateButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    SpectateButton.TextSize = 12
    SpectateButton.TextXAlignment = Enum.TextXAlignment.Center

    -- Friend Request Button
    local FriendButton = Instance.new("TextButton")
    FriendButton.Name = "FriendButton"
    FriendButton.Parent = PlayerCard
    FriendButton.BackgroundColor3 = Color3.fromRGB(80, 150, 80)
    FriendButton.BorderSizePixel = 0
    FriendButton.Position = UDim2.new(1, -150, 0, 50) -- Adjusted position
    FriendButton.Size = UDim2.new(0, 70, 0, 25)
    FriendButton.Font = Enum.Font.GothamSemibold
    FriendButton.Text = "Friend"
    FriendButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    FriendButton.TextSize = 12
    FriendButton.TextXAlignment = Enum.TextXAlignment.Center
    -- Teleport Button
    local TeleportButton = Instance.new("TextButton")
    TeleportButton.Name = "Teleport Button"
    TeleportButton.Parent = PlayerCard
    TeleportButton.BackgroundColor3 = Color3.fromRGB(150, 80, 80)
    TeleportButton.BorderSizePixel = 0
    TeleportButton.Position = UDim2.new(1, -150, 0, 85) -- Adjusted position
    TeleportButton.Size = UDim2.new(0, 70, 0, 25)
    TeleportButton.Font = Enum.Font.GothamSemibold
    TeleportButton.Text = "Teleport"
    TeleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    TeleportButton.TextSize = 12
    TeleportButton.TextXAlignment = Enum.TextXAlignment.Center

    -- Button Click Handlers
    SpectateButton.MouseButton1Click:Connect(function()
        if CurrentlySpectating then
            SwitchToOriginalPlayer()
            CurrentlySpectating = false
            CreateNotification("Stopped spectating!", 2) -- Notification for stopping spectating
            return -- Exit the function if already spectating
        end
        local targetCharacter = player.Character
        if targetCharacter and targetCharacter:FindFirstChild("HumanoidRootPart") then
            Camera.CameraSubject = targetCharacter:FindFirstChild("Humanoid") or targetCharacter:FindFirstChild("HumanoidRootPart")
            CurrentlySpectating = true -- set flag to indicate spectating state
            CreateNotification("Spectating " .. player.Name, 2)
        else
            CreateNotification("Character not loaded for " .. player.Name, 2)
        end
    end)

    FriendButton.MouseButton1Click:Connect(function()
        local success, errorMessage = pcall(function()
            SocialService:PromptFriendRequest(player.UserId)
        end)

        if success then
            CreateNotification("Friend request sent to " .. player.Name, 3)
        else
            CreateNotification("Failed to send friend request: " .. (errorMessage or "Unknown error"), 3)
        end
    end)

    TeleportButton.MouseButton1Click:Connect(function()
        local targetCharacter = player.Character
        if targetCharacter and targetCharacter:FindFirstChild("HumanoidRootPart") then
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character:MoveTo(targetCharacter.HumanoidRootPart.Position + Vector3.new(2, 0, 0)) -- Teleport a bit away to avoid collision
                CreateNotification("Teleported to " .. player.Name, 2)
            else
                CreateNotification("Local player character not loaded.", 2)
            end
        else
            CreateNotification("Character not loaded for " .. player.Name, 2)
        end
    end)
    return PlayerCard
end

-- Function to filter player cards based on search input
local function FilterPlayers(searchText)
    searchText = string.lower(searchText)
    for _, card in pairs(PlayersInfo:GetChildren()) do
        if card:IsA("Frame") and card:GetAttribute("PlayerName") then
            local playerName = card:GetAttribute("PlayerName")
            local displayName = card:GetAttribute("DisplayName") or ""
            if string.find(playerName, searchText) or string.find(displayName, searchText) then
                card.Visible = true
            else
                card.Visible = false
            end
        end
    end
end

-- Function to update player list
local function UpdatePlayerList()
    -- Destroy existing player cards
    for _, child in pairs(PlayersInfo:GetChildren()) do
        if child:IsA("Frame") and child.Name ~= "SearchBarFrame" then
            child:Destroy()
        end
    end

    local playerOrder = 1
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local playerCard = CreatePlayerCard(player, playerOrder)
            playerOrder = playerOrder + 1
        end
    end

    -- Adjust canvas size
    PlayersInfo.CanvasSize = UDim2.new(0, 0, 0, (playerOrder - 1) * 175)
end

--Minimize function
local function ToggleMinimize()
    MainFrame.Visible = not MainFrame.Visible
    MinimizedCircle.Visible = not MinimizedCircle.Visible
    if not MainFrame.Visible then
        --GUI is minimized
        CreateNotification("GUI Minimized!", 2)
    else
        --GUI is restored
        CreateNotification("GUI Restored!", 2)
    end
end

-- Populate Server Info
CreateInfoCard(ServerInfo, "Server Name", game.JobId, 1)
CreateInfoCard(ServerInfo, "Players", #Players:GetPlayers() .. " / " .. Players.MaxPlayers, 2)
CreateInfoCard(ServerInfo, "Roblox Time", os.date("%I:%M %p"), 3)
CreateInfoCard(ServerInfo, "Memory", collectgarbage("count") .. " KB", 4)
CreateInfoCard(ServerInfo, "Platform", RunService:IsStudio() and "Studio" or "Game Client", 5)
CreateInfoCard(ServerInfo, "Up Time", math.floor(tick() - game.Workspace.DistributedGameTime), 6)

-- Populate Local User Info
CreateInfoCard(LocalUserInfo, "User Name", LocalPlayer.Name, 1)
CreateInfoCard(LocalUserInfo, "Display Name", LocalPlayer.DisplayName, 2)
CreateInfoCard(LocalUserInfo, "User ID", LocalPlayer.UserId, 3)
CreateInfoCard(LocalUserInfo, "Account Age", LocalPlayer.AccountAge .. " days", 4)
CreateInfoCard(LocalUserInfo, "Is Friend", LocalPlayer:IsFriendsWith(LocalPlayer.UserId) and "Yes" or "No", 5)
CreateInfoCard(LocalUserInfo, "Premium", LocalPlayer.MembershipType == Enum.MembershipType.Premium and "Yes" or "No", 6)

-- Initial population of player list
UpdatePlayerList()

-- Adjust ServerInfo CanvasSize
local function UpdateServerInfoCanvasSize()
    local totalHeight = 0
    for _, child in pairs(ServerInfo:GetChildren()) do
        if child:IsA("Frame") then
            totalHeight = totalHeight + child.Size.Y.Offset + UIListLayout_Server.Padding.Offset
        end
    end
    ServerInfo.CanvasSize = UDim2.new(0, 0, 0, totalHeight)
end

-- Adjust LocalUserInfo CanvasSize
local function UpdateLocalUserInfoCanvasSize()
    local totalHeight = 0
    for _, child in pairs(LocalUserInfo:GetChildren()) do
        if child:IsA("Frame") then
            totalHeight = totalHeight + child.Size.Y.Offset + UIListLayout_Local.Padding.Offset
        end
    end
    LocalUserInfo.CanvasSize = UDim2.new(0, 0, 0, totalHeight)
end

-- Event Handling
CloseButton.MouseButton1Click:Connect(function()
    ServerInfoGUI:Destroy()
end)

MinimizeButton.MouseButton1Click:Connect(ToggleMinimize)

MinimizedCircle.MouseButton1Click:Connect(ToggleMinimize)

ServerTab.MouseButton1Click:Connect(function()
    ServerTab.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    ServerTab.TextColor3 = Color3.fromRGB(255, 255, 255)
    ServerTab.Indicator.Visible = true
    PlayersTab.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    PlayersTab.TextColor3 = Color3.fromRGB(200, 200, 200)
    PlayersTab.Indicator.Visible = false
    LocalTab.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    LocalTab.TextColor3 = Color3.fromRGB(200, 200, 200)
    LocalTab.Indicator.Visible = false

    ServerInfo.Visible = true
    PlayersInfo.Visible = false
    LocalUserInfo.Visible = false
    SearchBarFrame.Visible = false
    UpdateServerInfoCanvasSize()
end)

PlayersTab.MouseButton1Click:Connect(function()
    PlayersTab.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    PlayersTab.TextColor3 = Color3.fromRGB(255, 255, 255)
    PlayersTab.Indicator.Visible = true
    ServerTab.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    ServerTab.TextColor3 = Color3.fromRGB(200, 200, 200)
    ServerTab.Indicator.Visible = false
    LocalTab.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    LocalTab.TextColor3 = Color3.fromRGB(200, 200, 200)
    LocalTab.Indicator.Visible = false

    ServerInfo.Visible = false
    PlayersInfo.Visible = true
    LocalUserInfo.Visible = false
    SearchBarFrame.Visible = true
    UpdatePlayerList() -- Refresh player list when the tab is opened
end)

LocalTab.MouseButton1Click:Connect(function()
    LocalTab.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    LocalTab.TextColor3 = Color3.fromRGB(255, 255, 255)
    LocalTab.Indicator.Visible = true
    ServerTab.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    ServerTab.TextColor3 = Color3.fromRGB(200, 200, 200)
    ServerTab.Indicator.Visible = false
    PlayersTab.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    PlayersTab.TextColor3 = Color3.fromRGB(200, 200, 200)
    PlayersTab.Indicator.Visible = false

    ServerInfo.Visible = false
    PlayersInfo.Visible = false
    LocalUserInfo.Visible = true
    SearchBarFrame.Visible = false
    UpdateLocalUserInfoCanvasSize()
end)

-- Update player list whenever a player joins or leaves
Players.PlayerAdded:Connect(UpdatePlayerList)
Players.PlayerRemoving:Connect(UpdatePlayerList)

-- Update the player list when the display name changes.
Players.PlayerChanged:Connect(function(player, property)
    if property == "DisplayName" then
        UpdatePlayerList()
    end
end)

-- Connect the SearchBar input to the filter function
SearchBar:GetPropertyChangedSignal("Text"):Connect(function()
    FilterPlayers(SearchBar.Text)
end)

-- Continuously update server info
RunService.Heartbeat:Connect(function()
    -- Update the player count
    local playerCountString = #Players:GetPlayers() .. " / " .. Players.MaxPlayers
    for _, child in pairs(ServerInfo:GetChildren()) do
        if child:IsA("Frame") and child.Name == "PlayersCard" then
            local contentLabel = child:FindFirstChild("Content")
            if contentLabel then
                contentLabel.Text = playerCountString
            end
        end
    end

    --Update up time
    for _, child in pairs(ServerInfo:GetChildren()) do
        if child:IsA("Frame") and child.Name == "Up TimeCard" then
            local contentLabel = child:FindFirstChild("Content")
            if contentLabel then
                contentLabel.Text = math.floor(tick() - game.Workspace.DistributedGameTime)
            end
        end
    end
    -- Update the Roblox time
    for _, child in pairs(ServerInfo:GetChildren()) do
        if child:IsA("Frame") and child.Name == "Roblox TimeCard" then
            local contentLabel = child:FindFirstChild("Content")
            if contentLabel then
                contentLabel.Text = os.date("%I:%M %p")
            end
        end
    end

    -- Update the memory
    for _, child in pairs(ServerInfo:GetChildren()) do
        if child:IsA("Frame") and child.Name == "MemoryCard" then
            local contentLabel = child:FindFirstChild("Content")
            if contentLabel then
                contentLabel.Text = collectgarbage("count") .. " KB"
            end
        end
    end
end)
