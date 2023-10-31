---@class Constants
return {
	TOWER_TYPE_COMMON     = "common",
	TOWER_TYPE_DAMAGE     = "damage",
	TOWER_TYPE_RANGE      = "range",
	TOWER_TYPE_DAMAGE_T2  = "damage_t2",
	TOWER_TYPE_RANGE_T2   = "range_t2",
	TOWER_TYPE_MAGIC      = "magic",
	TOWER_TYPE_FREEZE     = "freeze",
	TOWER_TYPE_POISON     = "poison",
	TOWER_TYPE_FREEZE_T2  = "freeze_t2",
	TOWER_TYPE_POISON_T2  = "poison_t2",

	STATUS_TYPE_FROZEN    = "Frozen",
	STATUS_TYPE_POISONED  = "Poisoned",

	CELL_SIZE             = 64,

	URL_MAIN              = "/go#main",
	URL_GUI               = "/gui#gui",
	URL_ROUTER 			  = msg.url("main_router", "/logic", "scene_router"),

	FACTORY_URL_HP_BAR    = "/ui#hp_bar_factory",
	FACTORY_URL_SELECTION = "/ui#selection_factory",
	FACTORY_URL_UPGRADE   = "/ui#upgrade_ui_factory",

	FACTORY_URL_EDITOR_CASTLE   = "/world_objects#castle_factory",
	FACTORY_URL_EDITOR_WAYPOINT   = "/world_objects#palete_factory",
	FACTORY_URL_EDITOR_CONNECTION   = "/ui#connection_factory",
	FACTORY_URL_EDITOR_CONNECTION_DIR   = "/ui#connection_dir_factory",

	SHOOT_DELAY           = 0.5
}