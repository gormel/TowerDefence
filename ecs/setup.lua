local Constants = require "ecs.constants"

return {
    ---@class setup.MonsterSpawnerSetup
    MonsterSpawnerSetup = {
		monster_interval = 2,
        wave_interval = 20,
        wave_size = 5,
        monster_hp = 100,
		monster_reward = 25,
        wave_size_progression = 1.2,
        monster_hp_progression = 1.5,
		monster_reward_progression = 1.4,
        monster_damage_to_castle = 1,
        speed = 25,
        monster_factory_url = "/world_objects#monster_factory",
    },

    ---@class setup.CastleSetup
    CastleSetup = {
        health = 10,
    },

    ---@type table<string, setup.TowerSetup>
    Towers = {
        ---@class setup.TowerSetup
        [Constants.TOWER_TYPE_COMMON] = {
            factory_url = "/towers#common_tower_factory",
            cost = 100,
            radius = Constants.CELL_SIZE * 2,
            damage = 50,
            bullet_factory_url = "/world_objects#bullet_factory",
            bullet_speed = 120,
            apply_status = {},
            button_template = "tmpl_common_tower",
            target_filters = {},
            gui_icon = "common_tower",
        },
        [Constants.TOWER_TYPE_DAMAGE] = {
            factory_url = "/towers#damage_tower_factory",
            radius = Constants.CELL_SIZE * 2,
            damage = 60,
            bullet_factory_url = "/world_objects#bullet_factory",
            apply_status = { },
            bullet_speed = 120,
            target_filters = { },
            gui_icon = "damage_tower",
        },
        [Constants.TOWER_TYPE_DAMAGE_T2] = {
            factory_url = "/towers#damage_tower_factory_t2",
            radius = Constants.CELL_SIZE * 2,
            damage = 85,
            bullet_factory_url = "/world_objects#bullet_factory",
            apply_status = { },
            bullet_speed = 120,
            target_filters = { },
            gui_icon = "damage_tower_t2",
        },
        [Constants.TOWER_TYPE_RANGE] = {
            factory_url = "/towers#range_tower_factory",
            radius = Constants.CELL_SIZE * 3,
            damage = 50,
            bullet_factory_url = "/world_objects#bullet_factory",
            apply_status = { },
            bullet_speed = 120,
            target_filters = { },
            gui_icon = "range_tower",
        },
        [Constants.TOWER_TYPE_RANGE_T2] = {
            factory_url = "/towers#range_tower_factory_t2",
            radius = Constants.CELL_SIZE * 6,
            damage = 50,
            bullet_factory_url = "/world_objects#bullet_factory",
            apply_status = { },
            bullet_speed = 120,
            target_filters = { },
            gui_icon = "range_tower_t2",
        },
        ----------------------------------------------------------
        [Constants.TOWER_TYPE_MAGIC] = {
            factory_url = "/towers#magic_tower_factory",
            cost = 150,
            radius = Constants.CELL_SIZE * 2,
            damage = 25,
            bullet_factory_url = "/world_objects#bullet_factory",
            apply_status = { },
            bullet_speed = 120,
            button_template = "tmpl_magic_tower",
            target_filters = { },
            gui_icon = "magic_tower",
        },
        [Constants.TOWER_TYPE_POISON] = {
            factory_url = "/towers#poison_tower_factory",
            radius = Constants.CELL_SIZE * 2,
            damage = 25,
            bullet_factory_url = "/world_objects#bullet_factory",
            apply_status = { "Poisoned" },
            bullet_speed = 120,
            target_filters = { "NonPoisonedFilter" },
            gui_icon = "poison_tower",
        },
        [Constants.TOWER_TYPE_FREEZE] = {
            factory_url = "/towers#freeze_tower_factory",
            radius = Constants.CELL_SIZE * 2,
            damage = 25,
            bullet_factory_url = "/world_objects#bullet_factory",
            apply_status = { "Frozen" },
            bullet_speed = 120,
            target_filters = { "NonFrozenFilter" },
            gui_icon = "freeze_tower",
        },
        [Constants.TOWER_TYPE_POISON_T2] = {
            factory_url = "/towers#poison_tower_factory_t2",
            radius = Constants.CELL_SIZE * 2,
            damage = 25,
            bullet_factory_url = "/world_objects#bullet_factory",
            apply_status = { "PoisonedT2" },
            bullet_speed = 120,
            target_filters = { "NonPoisonedFilter" },
            gui_icon = "poison_tower_t2",
        },
        [Constants.TOWER_TYPE_FREEZE_T2] = {
            factory_url = "/towers#freeze_tower_factory_t2",
            radius = Constants.CELL_SIZE * 2,
            damage = 25,
            bullet_factory_url = "/world_objects#bullet_factory",
            apply_status = { "FrozenT2" },
            bullet_speed = 120,
            target_filters = { "NonFrozenFilter" },
            gui_icon = "freeze_tower_t2",
        },
    },

    ---@type table<string, setup.TargetFiletr>
    TargetFilters = {
        ---@class setup.TargetFiletr
        ["NonPoisonedFilter"] = {
            exc_status_types = { Constants.STATUS_TYPE_POISONED },
            no_exceptions = false,
        },
        ["NonFrozenFilter"] = {
            exc_status_types = { Constants.STATUS_TYPE_FROZEN },
            no_exceptions = false,
        },
    },

    ---@type table<string, table<string, setup.TowerUpgrade>>
    TowerUpgrades = {
        [Constants.TOWER_TYPE_COMMON] = {
            ---@class setup.TowerUpgrade
            [Constants.TOWER_TYPE_DAMAGE] = {
                cost = 80,
                icon_factory_url = "/ui#upgrade_damage_ui_factory",
            },
            [Constants.TOWER_TYPE_RANGE] = {
                cost = 80,
                icon_factory_url = "/ui#upgrade_range_ui_factory",
            },
        },
        [Constants.TOWER_TYPE_DAMAGE] = {
            ---@class setup.TowerUpgrade
            [Constants.TOWER_TYPE_DAMAGE_T2] = {
                cost = 150,
                icon_factory_url = "/ui#upgrade_ui_factory",
            },
        },
        [Constants.TOWER_TYPE_RANGE] = {
            ---@class setup.TowerUpgrade
            [Constants.TOWER_TYPE_RANGE_T2] = {
                cost = 150,
                icon_factory_url = "/ui#upgrade_ui_factory",
            },
        },

        [Constants.TOWER_TYPE_MAGIC] = {
            ---@class setup.TowerUpgrade
            [Constants.TOWER_TYPE_FREEZE] = {
                cost = 80,
                icon_factory_url = "/ui#upgrade_freeze_ui_factory",
            },
            [Constants.TOWER_TYPE_POISON] = {
                cost = 80,
                icon_factory_url = "/ui#upgrade_poison_ui_factory",
            },
        },
        [Constants.TOWER_TYPE_FREEZE] = {
            ---@class setup.TowerUpgrade
            [Constants.TOWER_TYPE_FREEZE_T2] = {
                cost = 150,
                icon_factory_url = "/ui#upgrade_ui_factory",
            },
        },
        [Constants.TOWER_TYPE_POISON] = {
            ---@class setup.TowerUpgrade
            [Constants.TOWER_TYPE_POISON_T2] = {
                cost = 150,
                icon_factory_url = "/ui#upgrade_ui_factory",
            },
        },
    },

    Statuses = {
        ---@class setup.FrozenStatus
        ["Frozen"] = {
            type = Constants.STATUS_TYPE_FROZEN,
            force = 0.5,
            duration = 5,
            factory_url = "/effects#freeze_status_factory",
        },
        ---@class setup.PoisonedStatus
        ["Poisoned"] = {
            type = Constants.STATUS_TYPE_POISONED,
            tick_time = 0.5,
            tick_count = 10,
            tick_damage = 5,
            factory_url = "/effects#poison_status_factory",
        },
        ---@class setup.FrozenStatus
        ["FrozenT2"] = {
            type = Constants.STATUS_TYPE_FROZEN,
            force = 0.2,
            duration = 8,
            factory_url = "/effects#freeze_status_factory",
        },
        ---@class setup.PoisonedStatus
        ["PoisonedT2"] = {
            type = Constants.STATUS_TYPE_POISONED,
            tick_time = 0.5,
            tick_count = 20,
            tick_damage = 8,
            factory_url = "/effects#poison_status_factory",
        },
    },

---@class setup.Map.Point
---@field x number
---@field y number

---@class setup.Map
---@field Routes table<string, setup.Map.Point[]>
---@field Castle setup.Map.Point

    ---@type table<string, setup.Map>
    Maps = {
        ---@class setup.Map
        ["Map_01"] = require "ecs.maps.map_01",
        ["Map_02"] = require "ecs.maps.map_02",
    },
}