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
    },

    Towers = {
        [Constants.TOWER_TYPE_COMMON] = {
            factory_url = "/go#common_tower_factory",
            cost = 100,
            radius = Constants.CELL_SIZE * 2,
            damage = 50,
        },
        [Constants.TOWER_TYPE_FREEZE] = {
            factory_url = "/go#freeze_tower_factory",
            cost = 150,
            radius = Constants.CELL_SIZE * 2,
            damage = 25,
        },
    }
}