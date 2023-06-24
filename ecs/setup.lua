local Constants = require "ecs.constants"

return {
    ---@class MonsterSpawnerSetup
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
        factory_url = "",
        monster_factory_url = "/go#monster_factory",
    },

    ---@class CastleSetup
    CastleSetup = {
        health = 1,
    },

    ---@type TowerSetup[]
    Towers = {
        ---@class TowerSetup
        [Constants.TOWER_TYPE_COMMON] = {
            factory_url = "/go#common_tower_factory",
            cost = 100,
            radius = Constants.CELL_SIZE * 2,
            damage = 50,
            bullet_factory_url = "/go#bullet_factory",
            bullet_speed = 120,
            ApplyStatus = {},
            button_template = "tmpl_common_tower",
        },
        [Constants.TOWER_TYPE_FREEZE] = {
            factory_url = "/go#freeze_tower_factory",
            cost = 150,
            radius = Constants.CELL_SIZE * 2,
            damage = 25,
            bullet_factory_url = "/go#bullet_factory",
            ApplyStatus = { "Frozen" },
            bullet_speed = 120,
            button_template = "tmpl_freeze_tower",
        },
        [Constants.TOWER_TYPE_POISON] = {
            factory_url = "/go#poison_tower_factory",
            cost = 150,
            radius = Constants.CELL_SIZE * 2,
            damage = 25,
            bullet_factory_url = "/go#bullet_factory",
            ApplyStatus = { "Poisoned" },
            bullet_speed = 120,
            button_template = "tmpl_poison_tower",
        },
    },

    Statuses = {
        ["Frozen"] = {
            type = Constants.STATUS_TYPE_FROZEN,
            force = 0.5,
            duration = 5,
        },
        ["Poisoned"] = {
            type = Constants.STATUS_TYPE_POISONED,
            tick_time = 0.05,
            tick_count = 10,
            tick_damage = 5,
        },
    },
}