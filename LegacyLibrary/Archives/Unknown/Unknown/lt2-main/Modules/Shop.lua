-- [[ SHOP MODULE ]] --
-- Designed for Dynxe LT2 UI Engine

local ShopModule = {}

local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui        = game:GetService("StarterGui")
local Player            = Players.LocalPlayer

-- ┌─────────────────────────────────────────────────────────────────┐
-- │                     LOT REFERENCE                               │
-- └─────────────────────────────────────────────────────────────────┘
local _LOT = nil

function ShopModule.SetLOT(lot)
    _LOT = lot
end

-- ┌─────────────────────────────────────────────────────────────────┐
-- │                  MODULE-LEVEL SHARED STATE                      │
-- │  _ShopItems   — item list loaded on Init, exposed via API.      │
-- │  _cachedFunds — last known balance, refreshed on a background   │
-- │                 poll so UI updates don't block on remotes.      │
-- └─────────────────────────────────────────────────────────────────┘
local _ShopItems   = nil
local _cachedFunds = nil

-- ┌─────────────────────────────────────────────────────────────────┐
-- │                     NPC / REMOTE SETUP                          │
-- └─────────────────────────────────────────────────────────────────┘
local NPCs = {
    Thom    = workspace.Stores.WoodRUs.Thom,
    Corey   = workspace.Stores.FurnitureStore.Corey,
    Jenny   = workspace.Stores.CarStore.Jenny,
    Bob     = workspace.Stores.ShackShop.Bob,
    Timothy = workspace.Stores.FineArt.Timothy,
    Lincoln = workspace.Stores.LogicStore.Lincoln,
}

local Remote      = ReplicatedStorage.NPCDialog.PlayerChatted
local PromptChat  = ReplicatedStorage.NPCDialog.PromptChat
local Interact    = ReplicatedStorage.Interaction.ClientInteracted

-- ┌─────────────────────────────────────────────────────────────────┐
-- │                   PER-STORE CONFIGURATION                       │
-- └─────────────────────────────────────────────────────────────────┘
local StoreConfigs = {
    WoodRUs = {
        NPCName     = "Thom",
        PlayerBuyCF = CFrame.new(262.1, 3.2,  64.8),
    },
    FurnitureStore = {
        NPCName     = "Corey",
        PlayerBuyCF = CFrame.new(481.4, 3.2, -1712.5),
    },
    CarStore = {
        NPCName     = "Jenny",
        PlayerBuyCF = CFrame.new(524.9, 3.2, -1466.6),
    },
    ShackShop = {
        NPCName     = "Bob",
        PlayerBuyCF = CFrame.new(256.7, 8.4, -2546.7),
    },
    FineArt = {
        NPCName     = "Timothy",
        PlayerBuyCF = CFrame.new(5232.4, -166.0, 737.3),
    },
    LogicStore = {
        NPCName     = "Lincoln",
        PlayerBuyCF = CFrame.new(4598.4, 7.0, -778.4),
    },
}

-- ┌─────────────────────────────────────────────────────────────────┐
-- │              COUNTER-BASED ITEM DROP CF RESOLVER                │
-- │  Finds the Counter BasePart for a store and computes a CFrame   │
-- │  that places the item centered and flush on its top surface.    │
-- │  Uses the counter's own UpVector so angled counters work too.   │
-- │  Handles both BasePart and Model Counters. Cached per store.    │
-- └─────────────────────────────────────────────────────────────────┘
local CounterCache = {}

local function GetCounterPart(storeName)
    if CounterCache[storeName] ~= nil then
        return CounterCache[storeName] or nil
    end

    local config = StoreConfigs[storeName]
    if not config then CounterCache[storeName] = false; return nil end

    local npc   = NPCs[config.NPCName]
    local store = npc and npc.Parent
    if not store then CounterCache[storeName] = false; return nil end

    local counter = store:FindFirstChild("Counter")
    if not counter then CounterCache[storeName] = false; return nil end

    local part
    if counter:IsA("BasePart") then
        part = counter
    elseif counter:IsA("Model") then
        part = counter.PrimaryPart
        if not part then
            for _, desc in ipairs(counter:GetDescendants()) do
                if desc:IsA("BasePart") then part = desc; break end
            end
        end
    end

    CounterCache[storeName] = part or false
    return part or nil
end

local function ComputeDropCF(storeName, mainPart)
    local counterPart = GetCounterPart(storeName)
    if not counterPart then return nil end

    -- Use the counter's own up-vector so angled counters still work correctly.
    local up         = counterPart.CFrame.UpVector
    local surfaceTop = counterPart.Position + up * (counterPart.Size.Y / 2)
    local itemRise   = mainPart and (mainPart.Size.Y / 2) or 0
    -- Small gap prevents the item from clipping into the counter surface.
    return CFrame.new(surfaceTop + up * (itemRise + 0.05))
end

-- ┌─────────────────────────────────────────────────────────────────┐
-- │                       FUNDS REMOTE                              │
-- └─────────────────────────────────────────────────────────────────┘
local GetFundsRemote = nil

local function FindRemoteRecursive(root, name)
    for _, child in ipairs(root:GetDescendants()) do
        if child.Name == name and child:IsA("RemoteFunction") then
            return child
        end
    end
    return nil
end

local function FetchFunds()
    if not GetFundsRemote then
        GetFundsRemote = FindRemoteRecursive(ReplicatedStorage, "GetFunds")
        if not GetFundsRemote then return nil end
    end
    local ok, result = pcall(function()
        return GetFundsRemote:InvokeServer()
    end)
    if ok and type(result) == "number" then return result end
    return nil
end

-- ┌─────────────────────────────────────────────────────────────────┐
-- │                      NPC ID FETCHING                            │
-- │  NOTE: SetChatting is intentionally NOT used here.              │
-- │  Calling SetChatting:InvokeServer(true) without a guaranteed    │
-- │  matching false call permanently locks the player in a dialog   │
-- │  state server-side, blocking all future NPC purchases.          │
-- └─────────────────────────────────────────────────────────────────┘
local NPCIDs = {}

local function FetchNPCID(npcName)
    local npc = NPCs[npcName]
    if not npc then return nil end

    if not npc:FindFirstChild("Dialog") then
        Instance.new("Dialog", npc)
    end

    local lastData = nil
    local conn = PromptChat.OnClientEvent:Connect(function(_, chatData)
        if chatData then lastData = chatData end
    end)

    pcall(function() PromptChat:FireServer(true, npc, npc.Dialog) end)
    local t = tick()
    repeat task.wait(0.05) until lastData or tick() - t > 5
    conn:Disconnect()

    -- Close the prompt cleanly — no SetChatting needed.
    -- Wait a beat after the close so the server processes it
    -- before any purchase loop touches this NPC.
    pcall(function() PromptChat:FireServer(false, npc, npc.Dialog) end)
    task.wait(0.2)

    if lastData then
        NPCIDs[npcName] = lastData.ID
        return lastData.ID
    end

    warn("[Shop] Failed to fetch ID for NPC:", npcName)
    return nil
end

local function EnsureNPCID(npcName)
    if NPCIDs[npcName] then return NPCIDs[npcName] end
    return FetchNPCID(npcName)
end

local function InvalidateNPCID(npcName)
    NPCIDs[npcName] = nil
end

local function FetchAllNPCIDs()
    for name, _ in pairs(NPCs) do
        if not NPCIDs[name] then
            FetchNPCID(name)
            task.wait(0.15)
        end
    end
end

-- ┌─────────────────────────────────────────────────────────────────┐
-- │          PROXIMITY-BASED CASHIER FINDER (fallback only)         │
-- └─────────────────────────────────────────────────────────────────┘
local function FindNearestCashierToItem(mainPart)
    if not mainPart then return nil, nil end
    local itemPos  = mainPart.Position
    local bestNPC, bestName, bestDist = nil, nil, math.huge

    for name, npc in pairs(NPCs) do
        local head = npc:FindFirstChild("Head")
        if head then
            local dist = (head.Position - itemPos).Magnitude
            if dist < bestDist then
                bestDist = dist
                bestNPC  = npc
                bestName = name
            end
        end
    end

    return bestNPC, bestName
end

-- ┌─────────────────────────────────────────────────────────────────┐
-- │                   NPC ARG BUILDER                               │
-- └─────────────────────────────────────────────────────────────────┘
local function BuildNPCArg(npcName, npc)
    if not npc then return nil end
    if not npc:FindFirstChild("Dialog") then
        Instance.new("Dialog", npc)
    end
    local id = EnsureNPCID(npcName)
    if not id then return nil end
    return {
        ID        = id,
        Character = npc,
        Name      = npcName,
        Dialog    = npc.Dialog,
    }
end

local function GetNPCArgForItem(storeName, mainPart)
    -- Always prefer the explicit store config — proximity lookup reads
    -- mainPart.Position which may be stale immediately after TeleportMany,
    -- causing the wrong NPC to be resolved for some stores.
    local config = StoreConfigs[storeName]
    if config then
        local npc = NPCs[config.NPCName]
        if npc then
            local arg = BuildNPCArg(config.NPCName, npc)
            if arg then return arg, config.NPCName end
        end
    end

    -- Proximity fallback — only reached if the config lookup failed.
    if mainPart then
        local proxNPC, proxName = FindNearestCashierToItem(mainPart)
        if proxNPC and proxName then
            local arg = BuildNPCArg(proxName, proxNPC)
            if arg then return arg, proxName end
        end
    end

    return nil, nil
end

-- ┌─────────────────────────────────────────────────────────────────┐
-- │               SAFE INVOKE — HARD TIMEOUT PER CALL               │
-- │                                                                 │
-- │  When the timeout cancels the client thread, the server may     │
-- │  still have an open dialog session. We fire EndChat from a      │
-- │  separate thread so the server-side session is always cleaned   │
-- │  up and the NPC never gets permanently locked.                  │
-- └─────────────────────────────────────────────────────────────────┘
local INVOKE_TIMEOUT = 4

local function SafeInvoke(npcArg, action)
    local co   = coroutine.running()
    local done = false

    local fireThread = task.spawn(function()
        pcall(function()
            Remote:InvokeServer(npcArg, action)
        end)
        if not done then
            done = true
            task.spawn(co)
        end
    end)

    task.delay(INVOKE_TIMEOUT, function()
        if not done then
            done = true
            pcall(task.cancel, fireThread)
            if action ~= "EndChat" then
                task.spawn(function()
                    pcall(function() Remote:InvokeServer(npcArg, "EndChat") end)
                end)
            end
            task.spawn(co)
        end
    end)

    coroutine.yield()
end

-- ┌─────────────────────────────────────────────────────────────────┐
-- │                     POWER OF EASE PURCHASE                      │
-- └─────────────────────────────────────────────────────────────────┘
local POE_PRICE    = 10009000
local POE_TP_CF    = CFrame.new(1059.4, 17.2, 1130.3)
local POE_TIMEOUT  = 60
local POE_INTERVAL = 0.2

local function PurchasePowerOfEase()
    local funds = FetchFunds()
    if funds == nil then return end
    if funds < POE_PRICE then return end

    FetchAllNPCIDs()

    local char = Player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    local returnCF = root.CFrame
    root.CFrame = POE_TP_CF
    task.wait(0.15)

    local bestDist = math.huge
    local bestNPC, bestName

    for name, npc in pairs(NPCs) do
        local store = npc.Parent
        if store and store:FindFirstChild("Counter") then
            local dist = (store.Counter.CFrame.p - root.Position).Magnitude
            if dist < bestDist then
                bestDist = dist
                bestNPC  = npc
                bestName = name
            end
        end
    end

    if not bestNPC then
        root.CFrame = returnCF
        return
    end

    if not bestNPC:FindFirstChild("Dialog") then
        Instance.new("Dialog", bestNPC)
    end

    local npcArg = BuildNPCArg(bestName, bestNPC)
    if not npcArg then
        root.CFrame = returnCF
        return
    end

    local deadline = tick() + POE_TIMEOUT

    while tick() < deadline do
        SafeInvoke(npcArg, "Initiate")
        SafeInvoke(npcArg, "ConfirmPurchase")
        SafeInvoke(npcArg, "EndChat")

        local newFunds = FetchFunds()
        if newFunds and newFunds < funds then break end

        task.wait(POE_INTERVAL)
    end

    task.wait(0.1)
    local returnChar = Player.Character
    local returnRoot = returnChar and returnChar:FindFirstChild("HumanoidRootPart")
    if returnRoot then returnRoot.CFrame = returnCF end
end

-- ┌─────────────────────────────────────────────────────────────────┐
-- │                       PURCHASE SEQUENCE                         │
-- └─────────────────────────────────────────────────────────────────┘
local SPAM_TIMEOUT       = 30
local INVOKE_GAP         = 0.05
local CYCLE_GAP          = 0.12
local FAIL_BACKOFF_AFTER = 8
local FAIL_BACKOFF_WAIT  = 0.6
local ID_REFETCH_AFTER   = 16

local function IsSuccessParent(parent)
    if not parent then return false end
    if parent.Name == "PlayerModels" then return true end
    if parent == Player.Backpack     then return true end
    if parent == Player.Character    then return true end
    local current = parent
    while current do
        if current.Name == "PlayerModels" then return true end
        current = current.Parent
    end
    return false
end

local function CheckItemState(mainPart)
    if not mainPart then return "gone" end
    local parent = mainPart.Parent
    if IsSuccessParent(parent) then return "success" end
    if parent == nil then
        task.wait(0.12)
        local newParent = mainPart.Parent
        if IsSuccessParent(newParent) then return "success" end
        if newParent == nil             then return "gone"    end
    end
    return "pending"
end

local function FlushDialog(npcArg, count)
    count = count or 2
    for _ = 1, count do
        SafeInvoke(npcArg, "EndChat")
        task.wait(0.05)
    end
end

-- ┌─────────────────────────────────────────────────────────────────┐
-- │  Track whether Initiate completed without timing out.           │
-- │  If Initiate timed out we skip ConfirmPurchase entirely —       │
-- │  firing it into a session that never opened was a source of     │
-- │  permanently stuck NPC state.                                   │
-- └─────────────────────────────────────────────────────────────────┘
local _lastInvokeTimedOut = false

local function SafeInvokeTracked(npcArg, action)
    local co       = coroutine.running()
    local done     = false
    local timedOut = false

    local fireThread = task.spawn(function()
        pcall(function()
            Remote:InvokeServer(npcArg, action)
        end)
        if not done then
            done = true
            task.spawn(co)
        end
    end)

    task.delay(INVOKE_TIMEOUT, function()
        if not done then
            done     = true
            timedOut = true
            pcall(task.cancel, fireThread)
            if action ~= "EndChat" then
                task.spawn(function()
                    pcall(function() Remote:InvokeServer(npcArg, "EndChat") end)
                end)
            end
            task.spawn(co)
        end
    end)

    coroutine.yield()
    _lastInvokeTimedOut = timedOut
end

local function SpamPurchase(mainPart, npcArg, itemName, npcName)
    -- Clear any leftover server dialog state before we begin.
    FlushDialog(npcArg, 2)
    task.wait(0.1)

    -- Open the session exactly once. The server moves the item to the
    -- counter on Initiate, so we never call it again during this purchase.
    SafeInvokeTracked(npcArg, "Initiate")
    if _lastInvokeTimedOut then
        warn("[Shop] Initiate timed out for NPC:", npcArg.Name)
        return false
    end

    task.wait(INVOKE_GAP)

    -- Loop only ConfirmPurchase until success or timeout.
    local deadline = tick() + SPAM_TIMEOUT
    while tick() < deadline do
        local state = CheckItemState(mainPart)
        if state == "success" then SafeInvoke(npcArg, "EndChat"); return true  end
        if state == "gone"    then SafeInvoke(npcArg, "EndChat"); return false end

        SafeInvoke(npcArg, "ConfirmPurchase")
        task.wait(CYCLE_GAP)
    end

    SafeInvoke(npcArg, "EndChat")
    return false
end

-- ┌─────────────────────────────────────────────────────────────────┐
-- │                      PURCHASE PART                              │
-- └─────────────────────────────────────────────────────────────────┘
-- TP item to the store counter + move player, return npcArg ready for purchasing.
local function PositionForPurchase(mainPart, item, pressedCF)
    local storeName = item.Store
    local config    = StoreConfigs[storeName]
    if not config then return nil, nil end

    local dropCF = ComputeDropCF(storeName, mainPart)
    if not dropCF then return nil, nil end

    local success = _LOT.TeleportMany({ { target = mainPart, goalCF = dropCF } })
    if _LOT.IsBusy() then success = _LOT.WaitForBatch() end
    if not success then return nil, nil end

    local char = Player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return nil, nil end

    root.CFrame = config.PlayerBuyCF
    task.wait(0.1)

    local npcArg, resolvedNPCName = GetNPCArgForItem(storeName, mainPart)
    if not npcArg or not npcArg.ID then return nil, nil end

    return npcArg, resolvedNPCName
end

-- Purchase only — no TP. Call PositionForPurchase first.
local function DoPurchase(mainPart, item, npcArg, resolvedNPCName, pressedCF)
    local purchased = SpamPurchase(mainPart, npcArg, item.Name, resolvedNPCName)
    if purchased then
        task.wait(0.05)
        if mainPart and mainPart.Parent then
            _LOT.TeleportMany({ { target = mainPart, goalCF = pressedCF } })
        end
        local returnChar = Player.Character
        local returnRoot = returnChar and returnChar:FindFirstChild("HumanoidRootPart")
        if returnRoot then
            returnRoot.CFrame = pressedCF * CFrame.new(0, 0, 3)
        end
    end
    return purchased
end

-- ┌─────────────────────────────────────────────────────────────────┐
-- │                     REMOTE ITEM LIST LOADER                     │
-- └─────────────────────────────────────────────────────────────────┘
local function LoadItemList()
    local genv   = getgenv()
    local user   = genv.User   or "learnhtsd"
    local repo   = genv.Repo   or "lt2"
    local branch = genv.Branch or "main"

    local url = string.format(
        "https://raw.githubusercontent.com/%s/%s/%s/LT2ItemList.lua?t=%s",
        user, repo, branch, tick()
    )

    local ok, result = pcall(function()
        return game:HttpGet(url)
    end)

    if not ok or not result or result:find("404: Not Found") then return nil end

    local fn, parseErr = loadstring(result)
    if not fn then return nil end

    local ok2, items = pcall(fn)
    if not ok2 or type(items) ~= "table" then return nil end

    return items
end

-- ┌─────────────────────────────────────────────────────────────────┐
-- │                   SHOPITEMS ↔ STORE MATCHER                     │
-- └─────────────────────────────────────────────────────────────────┘
local ShopItemsCache = {}

local function GetShopItemsForStore(storeName)
    if ShopItemsCache[storeName] ~= nil then
        return ShopItemsCache[storeName] or nil
    end

    local config = StoreConfigs[storeName]
    if not config then
        ShopItemsCache[storeName] = false
        return nil
    end

    local npc   = NPCs[config.NPCName]
    local store = npc and npc.Parent
    local anchor

    if store and store:FindFirstChild("Counter") then
        anchor = store.Counter.CFrame.p
    elseif store and store:IsA("Model") then
        local ok, piv = pcall(function() return store:GetPivot().Position end)
        if ok then anchor = piv end
    end

    if not anchor then
        ShopItemsCache[storeName] = false
        return nil
    end

    local stores = workspace:FindFirstChild("Stores")
    if not stores then
        ShopItemsCache[storeName] = false
        return nil
    end

    local bestContainer, bestDist = nil, math.huge

    for _, child in ipairs(stores:GetChildren()) do
        if child.Name ~= "ShopItems" then continue end

        local samplePos
        for _, desc in ipairs(child:GetDescendants()) do
            if desc:IsA("BasePart") then
                samplePos = desc.Position
                break
            end
        end

        if samplePos then
            local dist = (samplePos - anchor).Magnitude
            if dist < bestDist then
                bestDist      = dist
                bestContainer = child
            end
        end
    end

    ShopItemsCache[storeName] = bestContainer or false
    return bestContainer
end

-- ┌─────────────────────────────────────────────────────────────────┐
-- │                      WORLD PATH RESOLVER                        │
-- └─────────────────────────────────────────────────────────────────┘
local function ResolveItemParts(item, limit)
    local stores = workspace:FindFirstChild("Stores")
    if not stores then return {} end

    local results = {}

    local function searchContainer(shopItems)
        for _, box in ipairs(shopItems:GetChildren()) do
            if #results >= limit then break end
            if not (box:IsA("Model") and box.Name == "Box") then continue end

            local nameVal = box:FindFirstChild("BoxItemName")
            if not (nameVal and nameVal:IsA("StringValue")) then continue end
            if nameVal.Value ~= item.BoxItemName then continue end

            local main = box:FindFirstChild("Main")
            if main and main:IsA("BasePart") and not main.Anchored then
                table.insert(results, main)
            end
        end
    end

    local storeName = item.Store
    if storeName then
        local targetContainer = GetShopItemsForStore(storeName)
        if targetContainer then
            searchContainer(targetContainer)
            return results
        end
    end

    for _, child in ipairs(stores:GetChildren()) do
        if #results >= limit then break end
        if child.Name ~= "ShopItems" then continue end
        searchContainer(child)
    end

    return results
end

-- ┌─────────────────────────────────────────────────────────────────┐
-- │                    RESTOCK-AWARE BUY LOOP                       │
-- └─────────────────────────────────────────────────────────────────┘
local RESTOCK_POLL_RATE = 0.5
local RESTOCK_TIMEOUT   = 120

local _isBuying = false

local function RunBuyLoop(item, totalQty, pressedCF, onDone)
    _isBuying = true
    FetchAllNPCIDs()

    local bought       = 0
    local restockTimer = 0

    while bought < totalQty and _isBuying do
        local stillNeed = totalQty - bought
        local parts     = ResolveItemParts(item, stillNeed)

        if #parts == 0 then
            task.wait(RESTOCK_POLL_RATE)
            restockTimer += RESTOCK_POLL_RATE
            if restockTimer >= RESTOCK_TIMEOUT then break end
            continue
        end

        restockTimer = 0

        for _, mainPart in ipairs(parts) do
            if not _isBuying      then break end
            if bought >= totalQty then break end
            if not mainPart or not mainPart.Parent then continue end
            if _LOT.IsBusy() then _LOT.WaitForBatch() end

            -- TP item and player exactly once per item.
            local npcArg, resolvedNPCName = PositionForPurchase(mainPart, item, pressedCF)
            if not npcArg then continue end

            -- Retry the purchase in place — no further TPs regardless of outcome.
            local ok     = false
            local giveUp = tick() + 90
            while not ok and _isBuying and tick() < giveUp do
                if not mainPart or not mainPart.Parent then break end
                ok = DoPurchase(mainPart, item, npcArg, resolvedNPCName, pressedCF)
                if not ok then task.wait(0.2) end
            end

            if ok then bought += 1 end
        end
    end

    _isBuying = false
    if onDone then onDone() end
end

-- ┌─────────────────────────────────────────────────────────────────┐
-- │              BLUEPRINT — PURCHASE WITHOUT ITEM TP               │
-- └─────────────────────────────────────────────────────────────────┘
local function PurchaseBlueprintPart(mainPart, item)
    local npcArg, resolvedNPCName = PositionForPurchase(mainPart, item, nil)
    if not npcArg then return false end
    return SpamPurchase(mainPart, npcArg, item.Name, resolvedNPCName)
end

-- ┌─────────────────────────────────────────────────────────────────┐
-- │              BLUEPRINT — OPEN BOX FROM PLAYERMODELS             │
-- └─────────────────────────────────────────────────────────────────┘
local BOX_OPEN_TIMEOUT = 10

local function OpenBlueprintBox(boxItemName)
    local PlayerModels = workspace:FindFirstChild("PlayerModels")
    if not PlayerModels then return false end

    local deadline = tick() + BOX_OPEN_TIMEOUT

    while tick() < deadline do
        for _, model in ipairs(PlayerModels:GetChildren()) do
            if model:IsA("Model") and model.Name:find("Box Purchased by") then
                local nameVal = model:FindFirstChild("PurchasedBoxItemName")
                if nameVal and nameVal.Value == boxItemName then
                    local char = Player.Character
                    local head = char and char:FindFirstChild("Head")
                    if head then
                        Interact:FireServer(model, "Open box", head.CFrame)
                        task.wait(0.5)
                        return true
                    end
                end
            end
        end
        task.wait(0.2)
    end

    warn("[Blueprints] Timed out waiting for box:", boxItemName)
    return false
end

-- ┌─────────────────────────────────────────────────────────────────┐
-- │                   PURCHASE ALL BLUEPRINTS                       │
-- └─────────────────────────────────────────────────────────────────┘
local _isBuyingBlueprints = false

local function RunBlueprintLoop(ShopItems, onDone)
    _isBuyingBlueprints = true

    FetchAllNPCIDs()

    local char     = Player.Character
    local root     = char and char:FindFirstChild("HumanoidRootPart")
    local returnCF = root and root.CFrame

    local blueprints = {}
    for _, item in ipairs(ShopItems) do
        if item.Name:find("Blueprint") then
            table.insert(blueprints, item)
        end
    end

    if #blueprints == 0 then
        warn("[Blueprints] No blueprint items found in item list.")
        _isBuyingBlueprints = false
        if onDone then onDone() end
        return
    end

    print("[Blueprints] Found " .. #blueprints .. " blueprints to purchase.")

    for _, item in ipairs(blueprints) do
        if not _isBuyingBlueprints then break end

        local parts = ResolveItemParts(item, 1)
        if #parts == 0 then
            warn("[Blueprints] No stock found for:", item.Name, "— skipping.")
            continue
        end

        local mainPart = parts[1]
        if not mainPart or not mainPart.Parent then
            warn("[Blueprints] mainPart gone for:", item.Name, "— skipping.")
            continue
        end

        local blueprintsFolder = Player:FindFirstChild("PlayerBlueprints")
            and Player.PlayerBlueprints:FindFirstChild("Blueprints")
        if blueprintsFolder and blueprintsFolder:FindFirstChild(item.BoxItemName) then
            print("[Blueprints] Already owned, skipping:", item.Name)
            continue
        end

        local funds = FetchFunds()
        if funds == nil or funds < item.Price then
            warn("[Blueprints] Not enough funds for:", item.Name, "(need $" .. item.Price .. ")")
            continue
        end

        print("[Blueprints] Purchasing:", item.Name)
        local purchased = PurchaseBlueprintPart(mainPart, item)

        if purchased then
            print("[Blueprints] Purchased! Opening box for:", item.Name)
            local boxName = item.BoxItemName or item.Name
            OpenBlueprintBox(boxName)
        else
            warn("[Blueprints] Failed to purchase:", item.Name)
        end

        task.wait(0.2)
    end

    local returnChar = Player.Character
    local returnRoot = returnChar and returnChar:FindFirstChild("HumanoidRootPart")
    if returnRoot and returnCF then
        returnRoot.CFrame = returnCF
    end

    print("[Blueprints] All done!")
    _isBuyingBlueprints = false
    if onDone then onDone() end
end

-- ┌─────────────────────────────────────────────────────────────────┐
-- │                         MODULE INIT                             │
-- └─────────────────────────────────────────────────────────────────┘
function ShopModule.Init(Tab, lot, GetImageFunc)
    if lot ~= nil then _LOT = lot end

    local GetImage = GetImageFunc
                  or getgenv().GetImage
                  or function() return nil end

    -- Store at module level so the public API can access it.
    _ShopItems = LoadItemList()
    local ShopItems = _ShopItems

    if not ShopItems or #ShopItems == 0 then
        Tab:CreateSection("Hardware Store")
        return
    end

    local SelectedItem = ShopItems[1]
    local Quantity     = 1

    local PurchaseBtn

    -- ┌──────────────────────────────────────────────────────────────┐
    -- │                  FUNDS CACHE + BUTTON STATE                  │
    -- │                                                              │
    -- │  RefreshFundsCache — fires a background remote call, stores  │
    -- │  the result, then syncs the button's disabled state.         │
    -- │                                                              │
    -- │  UpdateDisplay — uses the cached value so it is instant      │
    -- │  (no yield) whenever item selection or quantity changes.     │
    -- │                                                              │
    -- │  SetBuyingState — keeps the button enabled and showing       │
    -- │  "Stop" while a purchase is running, then hands back to      │
    -- │  UpdateDisplay (which re-checks funds) when done.            │
    -- └──────────────────────────────────────────────────────────────┘
    local function RefreshFundsCache()
        task.spawn(function()
            local f = FetchFunds()
            if f ~= nil then _cachedFunds = f end
            -- Sync button state after every refresh (if not mid-purchase).
            if PurchaseBtn and SelectedItem and not _isBuying then
                local canAfford = _cachedFunds ~= nil and _cachedFunds >= SelectedItem.Price
                PurchaseBtn:SetDisabled(not canAfford)
            end
        end)
    end

    local function UpdateDisplay()
        if not SelectedItem or not PurchaseBtn then return end
        if _isBuying then return end  -- don't override the "Stop" label
        local cost      = SelectedItem.Price * Quantity
        local canAfford = _cachedFunds ~= nil and _cachedFunds >= SelectedItem.Price
        PurchaseBtn:SetText(("$%d"):format(cost))
        PurchaseBtn:SetDisabled(not canAfford)
    end

    local function SetBuyingState(buying)
        if not PurchaseBtn then return end
        if buying then
            PurchaseBtn:SetText("Stop")
            PurchaseBtn:SetDisabled(false)  -- must stay clickable so user can stop
        else
            RefreshFundsCache()             -- re-check funds now that buying finished
            UpdateDisplay()
        end
    end

    Tab:CreateSection("Stores")

    local Catalog = Tab:CreateImageSelector("Select an Item", {
        MultiSelect = false,
        VisibleRows = 3,
        SlotSize    = UDim2.new(0, 73, 0, 73),
    }, function(name)
        for _, item in pairs(ShopItems) do
            if item.Name == name then
                SelectedItem = item
                break
            end
        end
        UpdateDisplay()
    end)

    local BlueprintSlotObjs = {}

    for _, item in pairs(ShopItems) do
        pcall(function()
            local img = GetImage("", item.Image)
            local slotObj = Catalog:AddSlot(img, item.Name, "$" .. tostring(item.Price))
            if item.Name:find("Blueprint") then
                BlueprintSlotObjs[item.Name] = slotObj
            end
        end)
    end

    Tab:CreateSlider("Quantity", 1, 100, 1, function(val)
        Quantity = val
        UpdateDisplay()
    end)

    PurchaseBtn = Tab:CreateAction("Purchase", ("$%d"):format(ShopItems[1].Price), function()
        if _isBuying then
            _isBuying = false
            return
        end

        if not SelectedItem                       then return end
        if _LOT == nil                            then return end
        if not SelectedItem.Store                 then return end
        if not StoreConfigs[SelectedItem.Store]   then return end
        if _LOT.IsBusy()                          then return end

        local funds = FetchFunds()
        if funds == nil               then return end
        if funds < SelectedItem.Price then return end

        local totalCost = SelectedItem.Price * Quantity
        local targetQty = Quantity
        if funds < totalCost then
            targetQty = math.floor(funds / SelectedItem.Price)
        end

        local char      = Player.Character
        local root      = char and char:FindFirstChild("HumanoidRootPart")
        local pressedCF = root and root.CFrame

        SetBuyingState(true)

        task.spawn(function()
            RunBuyLoop(SelectedItem, targetQty, pressedCF, function()
                SetBuyingState(false)
            end)
        end)
    end, false)

    -- Seed the cache immediately, then keep it fresh every 3 seconds.
    RefreshFundsCache()
    task.spawn(function()
        while true do
            task.wait(3)
            RefreshFundsCache()
        end
    end)

    UpdateDisplay()
    ShopModule.UpdateDisplay = UpdateDisplay

    -- ┌──────────────────────────────────────────────────────────────┐
    -- │                        SPECIAL SECTION                       │
    -- └──────────────────────────────────────────────────────────────┘
    Tab:CreateSection("Special")

    Tab:CreateAction("Power of Ease ($10,009,000)", "Buy", function()
        task.spawn(PurchasePowerOfEase)
    end, false)

    local BlueprintItems = {}
    for _, item in ipairs(ShopItems) do
        if item.Name:find("Blueprint") then
            table.insert(BlueprintItems, item)
        end
    end

    local function CheckAllBlueprintsOwned()
        if #BlueprintItems == 0 then return false end
        local playerBP = Player:FindFirstChild("PlayerBlueprints")
        if not playerBP then return false end
        local blueprintsFolder = playerBP:FindFirstChild("Blueprints")
        if not blueprintsFolder then return false end
        local owned = 0
        for _, item in ipairs(BlueprintItems) do
            if blueprintsFolder:FindFirstChild(item.BoxItemName) then
                owned += 1
            end
        end
        return owned >= #BlueprintItems
    end

    local BlueprintBtn

    local function GetTotalBlueprintCost()
        local blueprintsFolder = Player:FindFirstChild("PlayerBlueprints")
            and Player.PlayerBlueprints:FindFirstChild("Blueprints")
        local total = 0
        for _, item in ipairs(BlueprintItems) do
            local owned = blueprintsFolder and blueprintsFolder:FindFirstChild(item.BoxItemName)
            if not owned then total += item.Price end
        end
        return total
    end

    local function UpdateBlueprintBtnState()
        if not BlueprintBtn then return end
        if _isBuyingBlueprints then return end
        local allOwned = CheckAllBlueprintsOwned()
        BlueprintBtn:SetDisabled(allOwned)
        if allOwned then
            BlueprintBtn:SetText("All Owned")
        else
            local total = GetTotalBlueprintCost()
            BlueprintBtn:SetText("$" .. tostring(total))
        end
    end

    BlueprintBtn = Tab:CreateAction("Purchase All Blueprints", "Buy", function()
        if _isBuyingBlueprints then
            _isBuyingBlueprints = false
            UpdateBlueprintBtnState()
            return
        end
        BlueprintBtn:SetText("Stop")
        task.spawn(function()
            RunBlueprintLoop(ShopItems, function()
                UpdateBlueprintBtnState()
            end)
        end)
    end, false)

    UpdateBlueprintBtnState()

    -- ── Rukiry Axe ─────────────────────────────────────────────────
    local RUKIRY_ITEMS = {
        { BoxItemName = "CanOfWorms", GoalCF = CFrame.new(317.3, 46.0, 1918.1) },
        { BoxItemName = "BagOfSand",  GoalCF = CFrame.new(319.5, 46.0, 1914.9) },
        { BoxItemName = "LightBulb",  GoalCF = CFrame.new(322.4, 43.6, 1916.4) },
    }

    local RUKIRY_PLAYER_CF = CFrame.new(320.6, 45.8, 1919.2)

    local RukiryBtn
    local _isBuyingRukiry = false

    local function PurchaseRukiryItem(mainPart, item, goalCF)
        local npcArg, resolvedNPCName = PositionForPurchase(mainPart, item, nil)
        if not npcArg then return false end

        local purchased = SpamPurchase(mainPart, npcArg, item.Name, resolvedNPCName)

        if purchased then
            task.wait(0.05)

            local PlayerModels = workspace:FindFirstChild("PlayerModels")
            local existingModels = {}
            if PlayerModels then
                for _, m in ipairs(PlayerModels:GetChildren()) do
                    existingModels[m] = true
                end
            end

            local boxModel = mainPart and mainPart.Parent
            if boxModel and boxModel:IsA("Model") then
                local ch   = Player.Character
                local head = ch and ch:FindFirstChild("Head")
                if head then
                    Interact:FireServer(boxModel, "Open box", head.CFrame)
                end
            end

            local spawnedPart = nil
            local deadline = tick() + 5
            while tick() < deadline do
                task.wait(0.1)
                if PlayerModels then
                    for _, m in ipairs(PlayerModels:GetChildren()) do
                        if not existingModels[m] and m:IsA("Model") then
                            local itemNameVal = m:FindFirstChild("ItemName")
                            if not (itemNameVal and itemNameVal.Value == item.BoxItemName) then continue end
                            local ownerFolder = m:FindFirstChild("Owner")
                            local ownerString = ownerFolder and ownerFolder:FindFirstChild("OwnerString")
                            if not (ownerString and ownerString.Value == Player.Name) then continue end
                            local foundMain = m:FindFirstChild("Main")
                            if foundMain then
                                spawnedPart = foundMain
                                break
                            end
                        end
                    end
                end
                if spawnedPart then break end
            end

            if spawnedPart and spawnedPart.Parent then
                _LOT.TeleportMany({ { target = spawnedPart, goalCF = goalCF } })
                if _LOT.IsBusy() then _LOT.WaitForBatch() end
            else
                warn("[Rukiry] Could not find spawned item after box open")
            end
        end

        return purchased
    end

    local function RunRukiryLoop()
        _isBuyingRukiry = true
        FetchAllNPCIDs()

        local returnChar = Player.Character
        local returnRoot = returnChar and returnChar:FindFirstChild("HumanoidRootPart")
        local rukiryReturnCF = returnRoot and returnRoot.CFrame

        for _, rukiryItem in ipairs(RUKIRY_ITEMS) do
            if not _isBuyingRukiry then break end

            local itemDef = nil
            for _, shopItem in ipairs(ShopItems) do
                if shopItem.BoxItemName == rukiryItem.BoxItemName then
                    itemDef = shopItem
                    break
                end
            end

            if not itemDef then
                warn("[Rukiry] Item not found in list:", rukiryItem.BoxItemName)
                continue
            end

            local funds = FetchFunds()
            if funds == nil or funds < itemDef.Price then
                warn("[Rukiry] Not enough funds for:", itemDef.Name, "(need $" .. itemDef.Price .. ")")
                continue
            end

            local parts = ResolveItemParts(itemDef, 1)
            if #parts == 0 then
                warn("[Rukiry] No stock found for:", itemDef.Name)
                continue
            end

            local mainPart = parts[1]
            if not mainPart or not mainPart.Parent then
                warn("[Rukiry] mainPart gone for:", itemDef.Name)
                continue
            end

            print("[Rukiry] Purchasing:", itemDef.Name)
            local purchased = PurchaseRukiryItem(mainPart, itemDef, rukiryItem.GoalCF)

            if purchased then
                print("[Rukiry] Placed:", itemDef.Name)
            else
                warn("[Rukiry] Failed:", itemDef.Name)
            end

            task.wait(0.2)
        end

        local retChar = Player.Character
        local retRoot = retChar and retChar:FindFirstChild("HumanoidRootPart")
        if retRoot then retRoot.CFrame = RUKIRY_PLAYER_CF end

        print("[Rukiry] Waiting for axe to spawn...")
        local axeModel    = nil
        local axeDeadline = tick() + 20
        while tick() < axeDeadline do
            task.wait(0.2)
            local PlayerModels = workspace:FindFirstChild("PlayerModels")
            if not PlayerModels then continue end

            local ch   = Player.Character
            local root = ch and ch:FindFirstChild("HumanoidRootPart")

            for _, m in ipairs(PlayerModels:GetChildren()) do
                if not (m:IsA("Model") and m.Name == "Model") then continue end
                local toolName = m:FindFirstChild("ToolName")
                if not (toolName and toolName.Value == "Rukiryaxe") then continue end
                local ownerFolder = m:FindFirstChild("Owner")
                local ownerString = ownerFolder and ownerFolder:FindFirstChild("OwnerString")
                if not (ownerString and ownerString.Value == "") then continue end
                local lastInteraction = ownerFolder and ownerFolder:FindFirstChild("LastInteraction")
                if not (lastInteraction and lastInteraction.Value == 0) then continue end
                if root then
                    local handle = m:FindFirstChild("Handle") or m.PrimaryPart
                    if handle and (handle.Position - root.Position).Magnitude > 50 then continue end
                end
                axeModel = m
                break
            end

            if axeModel then break end
        end

        if axeModel then
            local handle = axeModel:FindFirstChild("Handle") or axeModel.PrimaryPart
            if handle then
                print("[Rukiry] Found axe, teleporting and picking up...")
                _LOT.TeleportMany({ { target = handle, goalCF = handle.CFrame * CFrame.new(0, -1, 0) } })
                if _LOT.IsBusy() then _LOT.WaitForBatch() end
                task.wait(0.1)
                Interact:FireServer(axeModel, "Pick up tool", handle.CFrame)
                print("[Rukiry] Axe picked up!")
                task.wait(0.1)
                local rc = Player.Character
                local rr = rc and rc:FindFirstChild("HumanoidRootPart")
                if rr and rukiryReturnCF then
                    rr.CFrame = rukiryReturnCF
                    print("[Rukiry] Returned to original position.")
                end
            else
                warn("[Rukiry] Axe found but no Handle/PrimaryPart")
            end
        else
            warn("[Rukiry] Axe did not spawn within timeout")
        end

        print("[Rukiry] Done!")
        _isBuyingRukiry = false
        RukiryBtn:SetText("$7,400")
    end

    RukiryBtn = Tab:CreateAction("Purchase Rukiry Axe", "$7,400", function()
        if _isBuyingRukiry then
            _isBuyingRukiry = false
            RukiryBtn:SetText("$7,400")
            return
        end
        RukiryBtn:SetText("Stop")
        task.spawn(RunRukiryLoop)
    end, false)

    -- ── Blueprint slot watcher ──────────────────────────────────────
    local function GetBlueprintsFolder()
        local playerBP = Player:FindFirstChild("PlayerBlueprints")
        return playerBP and playerBP:FindFirstChild("Blueprints")
    end

    local function UpdateBlueprintSlots()
        local bpFolder = GetBlueprintsFolder()
        for _, item in ipairs(BlueprintItems) do
            local owned = bpFolder ~= nil and bpFolder:FindFirstChild(item.BoxItemName) ~= nil
            local slotObj = BlueprintSlotObjs[item.Name]
            if slotObj then slotObj:SetEnabled(not owned) end
        end
    end

    local _bpFolderConns = {}

    local function WireBlueprintFolder(folder)
        for _, c in ipairs(_bpFolderConns) do c:Disconnect() end
        _bpFolderConns = {}
        if not folder then return end
        table.insert(_bpFolderConns, folder.ChildAdded:Connect(function()
            UpdateBlueprintSlots()
            UpdateBlueprintBtnState()
        end))
        table.insert(_bpFolderConns, folder.ChildRemoved:Connect(function()
            UpdateBlueprintSlots()
            UpdateBlueprintBtnState()
        end))
    end

    local function WatchPlayerBlueprints()
        local playerBP = Player:FindFirstChild("PlayerBlueprints")
        if not playerBP then
            Player.ChildAdded:Connect(function(child)
                if child.Name ~= "PlayerBlueprints" then return end
                local sub = child:FindFirstChild("Blueprints")
                if sub then
                    WireBlueprintFolder(sub)
                    UpdateBlueprintSlots()
                    UpdateBlueprintBtnState()
                else
                    child.ChildAdded:Connect(function(subchild)
                        if subchild.Name == "Blueprints" then
                            WireBlueprintFolder(subchild)
                            UpdateBlueprintSlots()
                            UpdateBlueprintBtnState()
                        end
                    end)
                end
            end)
            return
        end

        local folder = playerBP:FindFirstChild("Blueprints")
        if folder then
            WireBlueprintFolder(folder)
        else
            playerBP.ChildAdded:Connect(function(child)
                if child.Name == "Blueprints" then
                    WireBlueprintFolder(child)
                    UpdateBlueprintSlots()
                    UpdateBlueprintBtnState()
                end
            end)
        end

        Player.ChildRemoved:Connect(function(child)
            if child.Name == "PlayerBlueprints" then
                for _, c in ipairs(_bpFolderConns) do c:Disconnect() end
                _bpFolderConns = {}
                UpdateBlueprintSlots()
                UpdateBlueprintBtnState()
                WatchPlayerBlueprints()
            end
        end)
    end

    WatchPlayerBlueprints()
    UpdateBlueprintSlots()
    UpdateBlueprintBtnState()
end

-- ┌─────────────────────────────────────────────────────────────────┐
-- │                         PUBLIC API                              │
-- └─────────────────────────────────────────────────────────────────┘

-- Returns the full item list. nil if Init hasn't run yet.
function ShopModule.GetItems()
    return _ShopItems
end

-- Purchase `quantity` of the named item from any external script.
--
--   itemName  (string)   — must match item.Name exactly in the list
--   quantity  (number)   — defaults to 1
--   pressedCF (CFrame)   — return position after buying; defaults to
--                          the player's current CFrame at call time
--   onDone    (function) — optional callback when the loop finishes
--
-- Returns true if the loop was started, or false + reason string on
-- an immediate failure (busy, not initialised, item not found, etc.)
--
-- Example:
--   local ok, err = ShopModule.PurchaseItem("Oak Wood", 10, nil, function()
--       print("done!")
--   end)
function ShopModule.PurchaseItem(itemName, quantity, pressedCF, onDone)
    if _isBuying               then return false, "already buying"    end
    if not _ShopItems          then return false, "not initialised"   end

    local item
    for _, i in ipairs(_ShopItems) do
        if i.Name == itemName then item = i; break end
    end

    if not item                     then return false, "item not found"    end
    if not item.Store               then return false, "item has no store" end
    if not StoreConfigs[item.Store] then return false, "no store config"   end

    quantity  = math.max(1, quantity or 1)
    pressedCF = pressedCF or (function()
        local c = Player.Character
        local r = c and c:FindFirstChild("HumanoidRootPart")
        return r and r.CFrame
    end)()

    task.spawn(function()
        RunBuyLoop(item, quantity, pressedCF, onDone)
    end)

    return true
end

return ShopModule
