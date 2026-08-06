-- ============================================================
-- VANGUARD HUB - UTILS v1.0
-- ============================================================

local Utils = {}

-- ============================================================
-- SERVIÇOS (CACHE PARA PERFORMANCE)
-- ============================================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local RunService = game:GetService("RunService")
local Workspace = workspace
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local StatsService = game:GetService("Stats")

-- ============================================================
-- GAME LOADED (UMA ÚNICA VEZ)
-- ============================================================

if not game:IsLoaded() then
    game.Loaded:Wait()
end

-- ============================================================
-- CONFIG (INJEÇÃO DE DEPENDÊNCIA)
-- ============================================================

local Config = nil

function Utils.SetConfig(cfg)
    Config = cfg
end

local function GetUIPreference(name, fallback)
    if Config and type(Config[name]) == "boolean" then
        return Config[name]
    end

    if Config and type(Config.UI) == "table" and type(Config.UI[name]) == "boolean" then
        return Config.UI[name]
    end

    return fallback
end

-- ============================================================
-- LOGS CONDICIONAIS
-- ============================================================

function Utils.Log(...)
    if Config and Config.Debug == true then
        warn("[Vanguard DEBUG]", ...)
    end
end

-- ============================================================
-- NOTIFICAÇÕES (COM RETRY)
-- ============================================================

function Utils.Notify(title, message, duration)
    if GetUIPreference("Notifications", true) == false then
        return
    end

    duration = duration or 4

    task.spawn(function()
        local success = false

        for i = 1, 10 do
            success = pcall(function()
                StarterGui:SetCore("SendNotification", {
                    Title = title or "Vanguard",
                    Text = message or "",
                    Duration = duration
                })
            end)

            if success then
                break
            end

            task.wait(0.2)
        end
    end)
end

-- ============================================================
-- ANIMAÇÕES (RETORNA O TWEEN)
-- ============================================================

function Utils.Tween(obj, data, duration)
    duration = duration or 0.3

    if GetUIPreference("Animations", true) == false then
        if obj then
            for property, value in pairs(data) do
                pcall(function()
                    obj[property] = value
                end)
            end
        end
        return nil
    end

    if not obj then
        Utils.Log("Tween: objeto é nil")
        return nil
    end

    local success, tween = pcall(function()
        return TweenService:Create(
            obj,
            TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
            data
        )
    end)

    if not success or not tween then
        Utils.Log("Falha ao criar tween")
        return nil
    end

    tween:Play()
    return tween
end

-- ============================================================
-- FPS (PROTEGIDO CONTRA DIVISÃO POR ZERO)
-- ============================================================

local FPS = 60
local fpsRunning = false

local function StartFPS()
    if fpsRunning then return end
    fpsRunning = true

    task.spawn(function()
        while fpsRunning do
            local dt = RunService.RenderStepped:Wait()
            if dt > 0 then
                FPS = math.floor(1 / dt)
            end
        end
    end)
end

function Utils.GetFPS()
    StartFPS()
    return FPS
end

function Utils.StopFPS()
    fpsRunning = false
end

-- ============================================================
-- TRADUÇÃO (PREPARADA PARA MÓDULOS EXTERNOS)
-- ============================================================

-- Translations inline (recommend moving to Modules/Translations/)
local Translations = {
    pt = {
        home_title = "Home",
        home_credits = "Criador: ₳ĐⱤł₳₦Ø",
        home_discord = "Copiar Link",
        home_discord_link = "dsc.gg/VanguardHub",
        home_server_hop = "Server Hop",
        home_rejoin = "Rejoin",
        home_exit = "Exit",
        player_title = "Player",
        player_movement = "Movimento",
        player_camera = "Camera",
        player_utilities = "Utilitarios",
        player_walk = "Velocidade",
        player_sprint = "Sprint",
        player_sprint_inf = "Sprint Infinito",
        player_jump = "Jump Power",
        player_fly_speed = "Fly Speed",
        player_fly_key = "Fly Key",
        player_fly_up = "Fly Up",
        player_fly_down = "Fly Down",
        player_noclip_key = "Noclip Key",
        player_noclip = "Noclip",
        player_infinite_jump = "Infinite Jump",
        player_flight = "Flight",
        player_invisible = "Invisivel",
        player_fov = "FOV",
        player_zoom = "Zoom",
        player_reset_fov = "Reset FOV",
        player_flashlight = "Lanterna (F)",
        player_antiafk = "Anti-AFK",
        player_godmode = "God Mode",
        player_antikb = "Anti-Knockback",
        player_antivoid = "Anti-Void",
        player_safe_death = "Safe Death",
        player_btools = "BTools",
        player_hard_dragger = "Hard Dragger",
        world_title = "World",
        world_lighting = "Iluminacao",
        world_water = "Agua",
        world_removals = "Remocoes",
        world_themes = "Temas",
        world_graphics = "Graficos",
        world_always_day = "Always Day",
        world_always_night = "Always Night",
        world_no_fog = "No Fog",
        world_spook = "Spook Mode",
        world_bright_mode = "Bright Mode",
        world_brightness = "Brilho",
        world_gravity = "Gravidade",
        world_water_walk = "Water Walk",
        world_remove_water = "Remover Agua",
        world_water_color = "Cor da Agua",
        world_remove_shadows = "Remover Sombras",
        world_remove_lava = "Remover Lava",
        world_remove_shrine = "Remover Portas Santuario",
        world_remove_snow = "Remover Pedras de Neve",
        world_remove_volcano = "Remover Pedras Vulcao",
        world_remove_trees = "Remover Arvores",
        world_remove_buildings = "Remover Construcoes",
        world_remove_items = "Remover Itens do Chao",
        world_christmas = "Tema Natal",
        world_halloween = "Tema Halloween",
        world_autumn = "Tema Outono",
        world_alien = "Tema Alienigena",
        world_disable_theme = "Desativar Tema",
        world_improved_graphics = "Graficos Melhorados",
        world_better_graphics = "Graficos HD",
        world_bloom = "Bloom Effect",
        world_realistic_water = "Agua Realista",
        world_antialiasing = "Anti-Aliasing",
        world_soft_shadows = "Sombras Suaves",
        world_reflections = "Reflexos",
        world_dof = "Depth of Field",
        world_bloom_intensity = "Intensidade do Bloom",
        teleports_title = "Teleports",
        teleports_waypoints = "Waypoints",
        teleports_players = "Jogadores",
        teleports_paths = "Caminhos",
        teleports_custom = "Personalizado",
        teleports_select_location = "Selecionar Local",
        teleports_select_store = "Selecionar Loja",
        teleports_select_biome = "Selecionar Bioma",
        teleports_to_player = "Teleportar para Jogador",
        teleports_to_base = "Teleportar para Base do Jogador",
        teleports_follow = "Seguir Jogador",
        teleports_spectate = "Espectar Jogador",
        teleports_path_palm = "Caminho para Palmeiras",
        teleports_path_volcano = "Caminho para Vulcao",
        teleports_path_safari = "Caminho para Safari",
        teleports_path_swamp = "Caminho para Pantano",
        teleports_path_snow = "Caminho para SnowGlow",
        teleports_coord_x = "Coord X",
        teleports_coord_y = "Coord Y",
        teleports_coord_z = "Coord Z",
        teleports_custom_tp = "Teleportar",
        teleports_click_tp = "Click Teleport",
        teleports_click_tp_key = "Click TP Key",
        wood_title = "Wood",
        wood_bring = "Trazer Arvore",
        wood_mod = "Mod Wood",
        wood_logs = "Logs",
        wood_tools = "Ferramentas",
        wood_tree_type = "Tipo de Arvore",
        wood_amount = "Quantidade",
        wood_tree_size = "Tamanho da Arvore",
        wood_abort = "Abortar",
        wood_autofarm = "Autofarm",
        wood_mod_wood = "Mod Wood",
        wood_mod_sawmill = "Mod Sawmill",
        wood_bring_logs = "Trazer Todos os Logs",
        wood_sell_logs = "Vender Todos os Logs",
        wood_sell_planks = "Vender Todas as Tabuas",
        wood_cut_plank = "Cortar Tabua 1x1",
        wood_click_sell = "Click to Sell",
        wood_dismember = "Desmembrar Arvore",
        wood_view_lone = "Ver Arvore LoneCave",
        dupe_title = "Dupe",
        dupe_base = "Base Dupe",
        dupe_items = "O que Duplicar",
        dupe_actions = "Acoes",
        dupe_settings = "Configuracoes",
        dupe_select_base = "Selecionar Base do Jogador",
        dupe_select_slot = "Selecionar Slot",
        dupe_type = "Tipo de Dupe",
        dupe_truck = "Truck (com itens)",
        dupe_empty = "Vazio (so a base)",
        dupe_woods = "Madeiras e Troncos",
        dupe_gifts = "Presentes",
        dupe_blueprints = "Blueprints",
        dupe_paintings = "Quadros",
        dupe_wires = "Fios e Componentes",
        dupe_vehicles = "Veiculos",
        dupe_select_all = "Selecionar Tudo",
        dupe_deselect_all = "Deselecionar Tudo",
        dupe_start = "Iniciar Dupe",
        dupe_abort = "Abortar",
        dupe_save_config = "Salvar Config do Dupe",
        dupe_load_config = "Carregar Config do Dupe",
        dupe_slot = "Slot para Dupe",
        dupe_speed = "Velocidade do Dupe",
        dupe_wait_time = "Tempo de Espera (Truck)",
        slot_title = "Slot",
        slot_slots = "Slots",
        slot_land = "Terreno",
        slot_number = "Slot",
        slot_load = "Carregar Slot",
        slot_save = "Salvar Slot",
        slot_overwrite = "Sobrescrever Slot",
        slot_fast_load = "Fast Load",
        slot_free_land = "Terreno Gratis",
        slot_max_land = "Terreno Maximo",
        slot_expand = "Expandir Terreno",
        slot_sell_sign = "Vender Placa de Vendido",
        slot_force_save = "Force Save",
        slot_land_color = "Cor do Terreno",
        slot_plot_material = "Material do Terreno",
        slot_rainbow = "Terreno Arco-Iris",
        item_title = "Item",
        item_lasso = "Lasso",
        item_select = "Selecao",
        item_tp = "Teleporte",
        item_lasso_tool = "Lasso Tool",
        item_click_select = "Click to Select",
        item_select_group = "Selecionar Grupo",
        item_deselect = "Deselecionar Todos",
        item_tp_facing = "TP para Onde Esta Virado",
        item_mark_waypoint = "Marcar Waypoint",
        item_tp_waypoint = "TP para Waypoint",
        item_direction = "Direcao",
        sorter_title = "Sorter",
        sorter_config = "Configuracoes",
        sorter_actions = "Acoes",
        sorter_select_player = "Selecionar Jogador",
        sorter_select_type = "Selecionar Tipo",
        sorter_truck_tp = "Truck Teleport",
        sorter_speed = "Velocidade do Sorter",
        sorter_size_x = "Tamanho X",
        sorter_size_y = "Tamanho Y",
        sorter_size_z = "Tamanho Z",
        sorter_start = "Iniciar Sorter",
        autobuy_title = "Autobuy",
        autobuy_items = "Itens",
        autobuy_misc = "Misc",
        autobuy_counter = "Balcao",
        autobuy_amount = "Quantidade",
        autobuy_select = "Selecionar Item",
        autobuy_open_box = "Abrir Caixa",
        autobuy_buy = "Comprar Item Selecionado",
        autobuy_abort = "Abortar",
        autobuy_rukiryaxe = "Rukiryaxe (Especial)",
        autobuy_blueprints = "Comprar Todas Blueprints",
        autobuy_fast_checkout = "Fast Checkout",
        autobuy_toll = "Comprar Toll Bridge",
        autobuy_ferry = "Comprar Ferry Ticket",
        autobuy_power = "Comprar Power of Ease",
        autobuy_woodrus = "Wood R'Us Counter",
        autobuy_links = "Links Logic Counter",
        autobuy_fancy = "Fancy Furnishings Counter",
        autobuy_bob = "Bob's Shack Counter",
        build_title = "Build",
        build_base = "Base",
        build_ui = "Build UI",
        build_wood = "Wood",
        build_base_wood = "Base para Pegar Madeira",
        build_base_target = "Base para Construir",
        build_mode = "Build Mode",
        build_load = "Load Schematic",
        build_unload = "Unload Preview",
        build_start = "Start Build",
        build_stop = "Stop Build",
        build_select_wood = "Selecionar Tipo de Madeira",
        build_auto_fill = "Auto Fill",
        build_click_fill = "Click to Fill",
        build_fill_bps = "Fill Blueprints",
        vehicle_title = "Vehicle",
        vehicle_options = "Opcoes",
        vehicle_spawner = "Spawner",
        vehicle_speed = "Velocidade do Veiculo",
        vehicle_pitch = "Pitch do Veiculo",
        vehicle_unflip = "Desvirar Veiculo (R)",
        vehicle_fly = "Voo de Veiculo",
        vehicle_sit = "Sentar em Qualquer Veiculo",
        vehicle_teleport = "Teleportar Veiculo",
        vehicle_delete = "Deletar Veiculo",
        vehicle_boost = "Boost",
        vehicle_jump = "Pulo do Veiculo",
        vehicle_color = "Cor do Veiculo",
        vehicle_spawn = "Spawnar Veiculo",
        vehicle_abort_spawn = "Abortar Spawner",
        vehicle_stop_pink = "Parar no Rosa",
        vehicle_delete_spot = "Deletar Spot Apos Spawn",
        settings_title = "Settings",
        settings_ui = "Interface",
        settings_config = "Configuracao",
        settings_colors = "Cores",
        settings_profiles = "Perfis",
        settings_backup = "Backup",
        settings_info = "Informações",
        settings_language = "Idioma",
        settings_theme = "Tema da UI",
        settings_toggle_ui = "Toggle UI",
        settings_destroy = "Destruir UI",
        settings_animations = "Animacoes",
        settings_notifications = "Notificacoes",
        settings_dark_mode = "Dark Mode (Menu do Jogo)",
        settings_fps_overlay = "FPS e Ping no Canto",
        settings_save = "Salvar Config",
        settings_load = "Carregar Config",
        settings_reset = "Resetar Config",
        settings_export = "Exportar Config",
        settings_import = "Importar Config",
        settings_auto_save = "Auto-Salvar Config",
        settings_main_color = "Cor Principal",
        settings_secondary_color = "Cor Secundaria",
        settings_accent_color = "Cor de Destaque",
        settings_text_color = "Cor do Texto",
        settings_new_profile = "Novo Perfil",
        settings_load_profile = "Carregar Perfil",
        settings_save_profile = "Salvar Perfil",
        settings_delete_profile = "Deletar Perfil",
        settings_create_backup = "Criar Backup",
        settings_restore_backup = "Restaurar Backup",
        settings_list_backups = "Listar Backups",
        settings_delete_backup = "Deletar Backup",
        settings_version = "Versao: 1.0",
        settings_executor = "Executor: ",
        settings_creators = "Criador: ₳ĐⱤł₳₦Ø",
        settings_discord = "Discord",
        settings_github = "GitHub",
        settings_check_updates = "Verificar Atualizacoes",
    },
    en = {
        home_title = "Home",
        home_credits = "Creator: ₳ĐⱤł₳₦Ø",
        home_discord = "Copy Link",
        home_discord_link = "dsc.gg/VanguardHub",
        home_server_hop = "Server Hop",
        home_rejoin = "Rejoin",
        home_exit = "Exit",
        player_title = "Player",
        player_movement = "Movement",
        player_camera = "Camera",
        player_utilities = "Utilities",
        player_walk = "Walk Speed",
        player_sprint = "Sprint",
        player_sprint_inf = "Infinite Sprint",
        player_jump = "Jump Power",
        player_fly_speed = "Fly Speed",
        player_fly_key = "Fly Key",
        player_fly_up = "Fly Up",
        player_fly_down = "Fly Down",
        player_noclip_key = "Noclip Key",
        player_noclip = "Noclip",
        player_infinite_jump = "Infinite Jump",
        player_flight = "Flight",
        player_invisible = "Invisible",
        player_fov = "FOV",
        player_zoom = "Zoom",
        player_reset_fov = "Reset FOV",
        player_flashlight = "Flashlight (F)",
        player_antiafk = "Anti-AFK",
        player_godmode = "God Mode",
        player_antikb = "Anti-Knockback",
        player_antivoid = "Anti-Void",
        player_safe_death = "Safe Death",
        player_btools = "BTools",
        player_hard_dragger = "Hard Dragger",
        world_title = "World",
        world_lighting = "Lighting",
        world_water = "Water",
        world_removals = "Removals",
        world_themes = "Themes",
        world_graphics = "Graphics",
        world_always_day = "Always Day",
        world_always_night = "Always Night",
        world_no_fog = "No Fog",
        world_spook = "Spook Mode",
        world_bright_mode = "Bright Mode",
        world_brightness = "Brightness",
        world_gravity = "Gravity",
        world_water_walk = "Water Walk",
        world_remove_water = "Remove Water",
        world_water_color = "Water Color",
        world_remove_shadows = "Remove Shadows",
        world_remove_lava = "Remove Lava",
        world_remove_shrine = "Remove Shrine Doors",
        world_remove_snow = "Remove Snow Boulders",
        world_remove_volcano = "Remove Volcano Boulders",
        world_remove_trees = "Remove Trees",
        world_remove_buildings = "Remove Buildings",
        world_remove_items = "Remove Items on Ground",
        world_christmas = "Christmas Theme",
        world_halloween = "Halloween Theme",
        world_autumn = "Autumn Theme",
        world_alien = "Alien Theme",
        world_disable_theme = "Disable Theme",
        world_improved_graphics = "Improved Graphics",
        world_better_graphics = "Better Graphics (HD)",
        world_bloom = "Bloom Effect",
        world_realistic_water = "Realistic Water",
        world_antialiasing = "Anti-Aliasing",
        world_soft_shadows = "Soft Shadows",
        world_reflections = "Reflections",
        world_dof = "Depth of Field",
        world_bloom_intensity = "Bloom Intensity",
        teleports_title = "Teleports",
        teleports_waypoints = "Waypoints",
        teleports_players = "Players",
        teleports_paths = "Paths",
        teleports_custom = "Custom",
        teleports_select_location = "Select Location",
        teleports_select_store = "Select Store",
        teleports_select_biome = "Select Biome",
        teleports_to_player = "Teleport to Player",
        teleports_to_base = "Teleport to Player's Base",
        teleports_follow = "Follow Player",
        teleports_spectate = "Spectate Player",
        teleports_path_palm = "Path to Palm",
        teleports_path_volcano = "Path to Volcano",
        teleports_path_safari = "Path to Safari",
        teleports_path_swamp = "Path to Swamp",
        teleports_path_snow = "Path to SnowGlow",
        teleports_coord_x = "Coord X",
        teleports_coord_y = "Coord Y",
        teleports_coord_z = "Coord Z",
        teleports_custom_tp = "Teleport",
        teleports_click_tp = "Click Teleport",
        teleports_click_tp_key = "Click TP Key",
        wood_title = "Wood",
        wood_bring = "Bring Tree",
        wood_mod = "Mod Wood",
        wood_logs = "Logs",
        wood_tools = "Tools",
        wood_tree_type = "Tree Type",
        wood_amount = "Amount",
        wood_tree_size = "Tree Size",
        wood_abort = "Abort",
        wood_autofarm = "Autofarm",
        wood_mod_wood = "Mod Wood",
        wood_mod_sawmill = "Mod Sawmill",
        wood_bring_logs = "Bring All Logs",
        wood_sell_logs = "Sell All Logs",
        wood_sell_planks = "Sell All Planks",
        wood_cut_plank = "Cut Plank 1x1",
        wood_click_sell = "Click to Sell",
        wood_dismember = "Dismember Tree",
        wood_view_lone = "View LoneCave Tree",
        dupe_title = "Dupe",
        dupe_base = "Base Dupe",
        dupe_items = "What to Dupe",
        dupe_actions = "Actions",
        dupe_settings = "Settings",
        dupe_select_base = "Select Player's Base",
        dupe_select_slot = "Select Slot",
        dupe_type = "Dupe Type",
        dupe_truck = "Truck (with items)",
        dupe_empty = "Empty (base only)",
        dupe_woods = "Woods & Logs",
        dupe_gifts = "Gifts",
        dupe_blueprints = "Blueprints",
        dupe_paintings = "Paintings",
        dupe_wires = "Wires & Components",
        dupe_vehicles = "Vehicles",
        dupe_select_all = "Select All",
        dupe_deselect_all = "Deselect All",
        dupe_start = "Start Dupe",
        dupe_abort = "Abort",
        dupe_save_config = "Save Dupe Config",
        dupe_load_config = "Load Dupe Config",
        dupe_slot = "Dupe Slot",
        dupe_speed = "Dupe Speed",
        dupe_wait_time = "Wait Time (Truck)",
        slot_title = "Slot",
        slot_slots = "Slots",
        slot_land = "Land",
        slot_number = "Slot",
        slot_load = "Load Slot",
        slot_save = "Save Slot",
        slot_overwrite = "Overwrite Slot",
        slot_fast_load = "Fast Load",
        slot_free_land = "Free Land",
        slot_max_land = "Max Land",
        slot_expand = "Expand Land",
        slot_sell_sign = "Sell Sold Sign",
        slot_force_save = "Force Save",
        slot_land_color = "Land Color",
        slot_plot_material = "Plot Material",
        slot_rainbow = "Rainbow Land",
        item_title = "Item",
        item_lasso = "Lasso",
        item_select = "Select",
        item_tp = "Teleport",
        item_lasso_tool = "Lasso Tool",
        item_click_select = "Click to Select",
        item_select_group = "Select Group",
        item_deselect = "Deselect All",
        item_tp_facing = "TP to Where You're Facing",
        item_mark_waypoint = "Mark Waypoint",
        item_tp_waypoint = "TP to Waypoint",
        item_direction = "Direction",
        sorter_title = "Sorter",
        sorter_config = "Config",
        sorter_actions = "Actions",
        sorter_select_player = "Select Player",
        sorter_select_type = "Select Type",
        sorter_truck_tp = "Truck Teleport",
        sorter_speed = "Sorter Speed",
        sorter_size_x = "Size X",
        sorter_size_y = "Size Y",
        sorter_size_z = "Size Z",
        sorter_start = "Start Sorter",
        autobuy_title = "Autobuy",
        autobuy_items = "Items",
        autobuy_misc = "Misc",
        autobuy_counter = "Counter",
        autobuy_amount = "Amount",
        autobuy_select = "Select Item",
        autobuy_open_box = "Open Box",
        autobuy_buy = "Buy Selected Item",
        autobuy_abort = "Abort",
        autobuy_rukiryaxe = "Rukiryaxe (Special)",
        autobuy_blueprints = "Buy All Blueprints",
        autobuy_fast_checkout = "Fast Checkout",
        autobuy_toll = "Buy Toll Bridge",
        autobuy_ferry = "Buy Ferry Ticket",
        autobuy_power = "Buy Power of Ease",
        autobuy_woodrus = "Wood R'Us Counter",
        autobuy_links = "Links Logic Counter",
        autobuy_fancy = "Fancy Furnishings Counter",
        autobuy_bob = "Bob's Shack Counter",
        build_title = "Build",
        build_base = "Base",
        build_ui = "Build UI",
        build_wood = "Wood",
        build_base_wood = "Base to Get Wood From",
        build_base_target = "Base to Build On",
        build_mode = "Build Mode",
        build_load = "Load Schematic",
        build_unload = "Unload Preview",
        build_start = "Start Build",
        build_stop = "Stop Build",
        build_select_wood = "Select Wood Type",
        build_auto_fill = "Auto Fill",
        build_click_fill = "Click to Fill",
        build_fill_bps = "Fill Blueprints",
        vehicle_title = "Vehicle",
        vehicle_options = "Options",
        vehicle_spawner = "Spawner",
        vehicle_speed = "Vehicle Speed",
        vehicle_pitch = "Vehicle Pitch",
        vehicle_unflip = "Unflip Vehicle (R)",
        vehicle_fly = "Vehicle Fly",
        vehicle_sit = "Sit in Any Vehicle",
        vehicle_teleport = "Teleport Vehicle",
        vehicle_delete = "Delete Vehicle",
        vehicle_boost = "Boost",
        vehicle_jump = "Vehicle Jump",
        vehicle_color = "Vehicle Color",
        vehicle_spawn = "Spawn Vehicle",
        vehicle_abort_spawn = "Abort Spawner",
        vehicle_stop_pink = "Stop on Pink",
        vehicle_delete_spot = "Delete Spot After Spawn",
        settings_title = "Settings",
        settings_ui = "Interface",
        settings_config = "Configuration",
        settings_colors = "Colors",
        settings_profiles = "Profiles",
        settings_backup = "Backup",
        settings_info = "Info",
        settings_language = "Language",
        settings_theme = "UI Theme",
        settings_toggle_ui = "Toggle UI",
        settings_destroy = "Destroy UI",
        settings_animations = "Animations",
        settings_notifications = "Notifications",
        settings_dark_mode = "Dark Mode (Game Menu)",
        settings_fps_overlay = "FPS & Ping Overlay",
        settings_save = "Save Config",
        settings_load = "Load Config",
        settings_reset = "Reset Config",
        settings_export = "Export Config",
        settings_import = "Import Config",
        settings_auto_save = "Auto-Save Config",
        settings_main_color = "Main Color",
        settings_secondary_color = "Secondary Color",
        settings_accent_color = "Accent Color",
        settings_text_color = "Text Color",
        settings_new_profile = "New Profile",
        settings_load_profile = "Load Profile",
        settings_save_profile = "Save Profile",
        settings_delete_profile = "Delete Profile",
        settings_create_backup = "Create Backup",
        settings_restore_backup = "Restore Backup",
        settings_list_backups = "List Backups",
        settings_delete_backup = "Delete Backup",
        settings_version = "Version: 1.0",
        settings_executor = "Executor: ",
        settings_creators = "Creator: ₳ĐⱤł₳₦Ø",
        settings_discord = "Discord",
        settings_github = "GitHub",
        settings_check_updates = "Check Updates",
    }
}

function Utils._(key)
    if not Config then
        return key
    end

    local lang = Config.language or "pt"

    if not Translations[lang] then
        lang = "pt"
    end

    return (Translations[lang] and Translations[lang][key])
        or (Translations.pt and Translations.pt[key])
        or key
end

-- ============================================================
-- PLAYER UTILS
-- ============================================================

function Utils.GetPlayers()
    return Players:GetPlayers()
end

function Utils.GetPlayerNames()
    local names = {}

    for _, player in pairs(Players:GetPlayers()) do
        table.insert(names, player.Name)
    end

    return names
end

function Utils.GetLocalPlayer()
    return Players.LocalPlayer
end

function Utils.GetCharacter(player)
    player = player or Players.LocalPlayer
    return player and player.Character
end

function Utils.GetHumanoid(player)
    local character = Utils.GetCharacter(player)
    return character and character:FindFirstChild("Humanoid")
end

function Utils.GetRoot(player)
    local character = Utils.GetCharacter(player)
    return character and character:FindFirstChild("HumanoidRootPart")
end

function Utils.IsAlive(player)
    local humanoid = Utils.GetHumanoid(player)
    return humanoid and humanoid.Health > 0
end

function Utils.WaitForCharacter(player, timeout)
    player = player or Players.LocalPlayer
    timeout = timeout or 30

    local start = tick()

    repeat
        task.wait()

        if (tick() - start) >= timeout then
            return nil
        end
    until player.Character
        and player.Character:FindFirstChild("Humanoid")
        and player.Character:FindFirstChild("HumanoidRootPart")

    return player.Character
end

-- ============================================================
-- TELEPORTE
-- ============================================================

function Utils.Teleport(cframe)
    if not cframe then
        Utils.Log("Teleport: CFrame é nil")
        return false
    end

    local rootPart = Utils.GetRoot()

    if not rootPart then
        Utils.Log("Teleport: HumanoidRootPart não encontrado")
        return false
    end

    rootPart.CFrame = cframe
    return true
end

-- ============================================================
-- DISTANCE
-- ============================================================

function Utils.Distance(pos1, pos2)
    if not pos1 or not pos2 then
        return math.huge
    end

    pos1 = type(pos1) == "CFrame" and pos1.Position or pos1
    pos2 = type(pos2) == "CFrame" and pos2.Position or pos2

    return (pos1 - pos2).Magnitude
end

-- ============================================================
-- PROPRIEDADE
-- ============================================================

function Utils.GetProperty(playerName)
    if not playerName then
        return nil
    end

    local properties = Workspace:FindFirstChild("Properties")

    if not properties then
        return nil
    end

    for _, property in pairs(properties:GetChildren()) do
        local owner = property:FindFirstChild("Owner")
        if owner and owner.Value then
            if tostring(owner.Value) == playerName then
                return property
            end
        end
    end

    return nil
end

function Utils.GetPlot(player)
    player = player or Players.LocalPlayer

    if type(player) == "string" then
        return Utils.GetProperty(player)
    end

    return Utils.GetProperty(player.Name)
end

-- ============================================================
-- MELHOR MACHADO (OTIMIZADO)
-- ============================================================

function Utils.GetBestAxe()
    local player = Players.LocalPlayer

    if not player then
        return nil
    end

    local bestAxe = nil
    local bestDamage = 0

    local function checkTool(tool)
        if not tool then return end

        local toolName = tool:FindFirstChild("ToolName")
        local cuttingTool = tool:FindFirstChild("CuttingTool")

        if not cuttingTool or not toolName then
            return
        end

        local axeFolder = ReplicatedStorage:FindFirstChild("AxeClasses")
        if not axeFolder then
            return
        end

        local axeClass = axeFolder:FindFirstChild("AxeClass_" .. toolName.Value)
        if not axeClass then
            return
        end

        -- Use cached stats from the axe class directly
        local success, stats = pcall(function()
            return require(axeClass)
        end)

        if success and stats then
            local damage = stats.Damage or (stats.new and stats.new().Damage) or 0
            if damage > bestDamage then
                bestDamage = damage
                bestAxe = tool
            end
        end
    end

    local backpack = player:FindFirstChild("Backpack")
    if backpack then
        for _, tool in pairs(backpack:GetChildren()) do
            checkTool(tool)
        end
    end

    local character = player.Character
    if character then
        for _, tool in pairs(character:GetChildren()) do
            checkTool(tool)
        end
    end

    return bestAxe
end

-- ============================================================
-- PING (UNIVERSAL - USA STATS SERVICE)
-- ============================================================

function Utils.GetPing()
    -- Method 1: Use Stats service (works universally)
    local success, ping = pcall(function()
        return StatsService.PerformanceStats.Ping:GetValue()
    end)

    if success and ping then
        return math.floor(ping)
    end

    -- Method 2: Use TestPing remote (game-specific)
    success, ping = pcall(function()
        local remote = ReplicatedStorage:FindFirstChild("TestPing")
        if not remote then
            return nil
        end

        local start = tick()
        remote:InvokeServer()
        return math.floor((tick() - start) * 1000)
    end)

    if success and ping then
        return ping
    end

    return 0
end

function Utils.GetPingColor(ping)
    ping = ping or Utils.GetPing()

    if ping < 50 then
        return Color3.fromRGB(0, 255, 0)
    elseif ping < 100 then
        return Color3.fromRGB(255, 255, 0)
    elseif ping < 200 then
        return Color3.fromRGB(255, 165, 0)
    else
        return Color3.fromRGB(255, 0, 0)
    end
end

-- ============================================================
-- EXECUTOR (SIMPLIFICADO)
-- ============================================================

function Utils.GetExecutor()
    local registry = rawget(_G, "__VanguardModuleRegistry") or {}
    local environment = registry["Core/Environment/Environment"]
    if environment and type(environment.Get) == "function" then
        local current = environment.Get()
        if current and current.Executor then
            return tostring(current.Executor)
        end
    end

    return "Unknown"
end

-- ============================================================
-- SISTEMA
-- ============================================================

function Utils.CopyToClipboard(text)
    local registry = rawget(_G, "__VanguardModuleRegistry") or {}
    local clipboard = registry["Core/Services/Clipboard"]

    if clipboard and type(clipboard.Copy) == "function" then
        return clipboard.Copy(text)
    end

    return false
end

function Utils.ServerHop()
    local servers = {}

    pcall(function()
        local cursor = ""
        local attempts = 0

        repeat
            local url = "https://games.roblox.com/v1/games/" .. game.PlaceId
                .. "/servers/Public?sortOrder=Asc&limit=100"

            if cursor ~= "" then
                url = url .. "&cursor=" .. cursor
            end

            local response = HttpService:JSONDecode(game:HttpGet(url))

            for _, server in pairs(response.data) do
                if server.playing < server.maxPlayers then
                    table.insert(servers, server.id)
                end
            end

            cursor = response.nextPageCursor or ""
            attempts = attempts + 1
        until cursor == "" or attempts >= 5 or #servers >= 50

        if #servers > 0 then
            TeleportService:TeleportToPlaceInstance(
                game.PlaceId,
                servers[math.random(1, #servers)]
            )
        end
    end)
end

function Utils.Rejoin()
    pcall(function()
        TeleportService:Teleport(game.PlaceId, Players.LocalPlayer)
    end)
end

-- ============================================================
-- VEÍCULOS
-- ============================================================

function Utils.IsInVehicle(player)
    local humanoid = Utils.GetHumanoid(player)
    return humanoid and humanoid.SeatPart ~= nil
end

function Utils.GetVehicle(player)
    local humanoid = Utils.GetHumanoid(player)
    if not humanoid then return nil end

    if humanoid.SeatPart then
        return humanoid.SeatPart.Parent
    end

    return nil
end

-- ============================================================
-- REMOTES SEGUROS (CORRIGIDO - VARARG)
-- ============================================================

function Utils.SafeFireRemote(remote, ...)
    if not remote then
        return false
    end

    local args = table.pack(...)

    return pcall(function()
        remote:FireServer(table.unpack(args, 1, args.n))
    end)
end

function Utils.SafeInvoke(remote, ...)
    if not remote then
        return false, nil
    end

    local args = table.pack(...)

    return pcall(function()
        return remote:InvokeServer(table.unpack(args, 1, args.n))
    end)
end

-- ============================================================
-- CONEXÕES (COM LIMPEZA DE MEMÓRIA E VERIFICAÇÃO)
-- ============================================================

function Utils.DestroyConnections(connections)
    if not connections then return end

    for i, connection in pairs(connections) do
        pcall(function()
            if connection.Connected then
                connection:Disconnect()
            end
        end)
        connections[i] = nil
    end
end

-- ============================================================
-- MATH UTILS
-- ============================================================

function Utils.FormatNumber(num)
    if not num then return "0" end

    if num >= 1e12 then
        return string.format("%.1fT", num / 1e12)
    elseif num >= 1e9 then
        return string.format("%.1fB", num / 1e9)
    elseif num >= 1e6 then
        return string.format("%.1fM", num / 1e6)
    elseif num >= 1e3 then
        return string.format("%.1fK", num / 1e3)
    else
        return tostring(math.floor(num))
    end
end

function Utils.Lerp(a, b, t)
    return a + (b - a) * t
end

-- ============================================================
-- RAYCAST (COM IGNORE WATER)
-- ============================================================

function Utils.Raycast(origin, direction, maxDistance, ignoreList)
    maxDistance = maxDistance or 1000
    ignoreList = ignoreList or {Players.LocalPlayer.Character}

    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.FilterDescendantsInstances = ignoreList
    raycastParams.IgnoreWater = true

    return Workspace:Raycast(origin, direction * maxDistance, raycastParams)
end

-- ============================================================
-- LUMBER TYCOON 2 - SPECIFIC
-- ============================================================

function Utils.GetNearestTree(position)
    if not position then
        local root = Utils.GetRoot()
        if not root then
            return nil
        end
        position = root.Position
    end

    local nearest = nil
    local nearestDistance = math.huge

    for _, tree in pairs(Workspace:GetChildren()) do
        if tree.Name == "TreeRegion" then
            local wood = tree:FindFirstChild("WoodSection")
            if wood and wood.Position then
                local distance = Utils.Distance(position, wood.Position)
                if distance < nearestDistance then
                    nearestDistance = distance
                    nearest = tree
                end
            end
        end
    end

    return nearest
end

function Utils.GetWoodType(tree)
    if not tree then return "Desconhecido" end

    local log = tree:FindFirstChild("Logs")
    if not log then return "Desconhecido" end

    local firstLog = log:FindFirstChildWhichIsA("Part")
    if firstLog then
        return firstLog.Name
    end

    return "Desconhecido"
end

function Utils.GetTruck(player)
    player = player or Players.LocalPlayer

    -- First try Vehicles folder
    local vehiclesFolder = Workspace:FindFirstChild("Vehicles")
    if vehiclesFolder then
        for _, vehicle in pairs(vehiclesFolder:GetChildren()) do
            if vehicle:IsA("Model") then
                local owner = vehicle:FindFirstChild("Owner")
                if owner and owner.Value == player then
                    local hasSeat = vehicle:FindFirstChild("DriveSeat")
                        or vehicle:FindFirstChild("VehicleSeat")
                        or vehicle:FindFirstChild("Main")

                    if hasSeat then
                        return vehicle
                    end
                end
            end
        end
    end

    -- Fallback to workspace (limited search)
    for _, vehicle in pairs(Workspace:GetChildren()) do
        if vehicle:IsA("Model") and vehicle ~= vehiclesFolder then
            local owner = vehicle:FindFirstChild("Owner")
            if owner and owner.Value == player then
                local hasSeat = vehicle:FindFirstChild("DriveSeat")
                    or vehicle:FindFirstChild("VehicleSeat")
                    or vehicle:FindFirstChild("Main")

                if hasSeat then
                    return vehicle
                end
            end
        end
    end

    return nil
end

function Utils.IsTruckFull(truck)
    if not truck then return false end

    local woodCount = 0
    local maxWood = 30

    for _, child in pairs(truck:GetDescendants()) do
        if child:IsA("Part") and child.Name:find("Wood") then
            woodCount = woodCount + 1
        end
    end

    return woodCount >= maxWood
end

function Utils.GetClosestPlayer(maxDistance)
    maxDistance = maxDistance or 50
    local localPlayer = Players.LocalPlayer
    local localRoot = Utils.GetRoot()

    if not localRoot then return nil end

    local closest = nil
    local closestDistance = maxDistance

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= localPlayer then
            if Utils.IsAlive(player) then
                local targetRoot = Utils.GetRoot(player)
                if targetRoot then
                    local distance = Utils.Distance(localRoot.Position, targetRoot.Position)
                    if distance < closestDistance then
                        closestDistance = distance
                        closest = player
                    end
                end
            end
        end
    end

    return closest
end

-- ============================================================
-- BIND TOGGLE (COM PROTEÇÃO)
-- ============================================================

function Utils.BindToggle(key, callback, description)
    local connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == key then
            pcall(callback)
        end
    end)

    Utils.Log("Bind toggle criado: " .. (description or tostring(key)))
    return connection
end

return Utils
