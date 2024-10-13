package assets

import "core:hash"

asset :: struct {
	path: string,
	path_hash: u64,
	data: []u8,
	info: cstring,
}

texture_names :: enum {
none,
	bace_light,
	burning_loop_1,
	debug_hb,
	ebf_casing,
	electrum_ingot,
	enderium_ingot,
	furnace_heater,
	furnace_heater_active,
	furnace_heater_active_overlay,
	generator,
	heavy_engineering,
	inertelectrum_block,
	inertelectrum_ingot,
	invar_ingot,
	light_engineering,
	livingrock,
	lumium_ingot,
	metal_ingot_steel,
	radiator,
	redstone_engineering,
	signalum_ingot,
	slot,
	smooth_stone_brick,
	smooth_stone_brick_side,
	space,
	space_2,
	space_3,
	space_4,
	space_5,
	space_6,
	space_6_copy,
	square,
	stone_brick,
	test,
}

font_names :: enum {
}

shader_names :: enum {
	test,
	vs_test,
}

sound_names :: enum {
	none,
	eat,
	running_1,
	running_2,
	running_3,
	running_4,
	running_5,
	running_6,
	sand_step_1,
	s_click,
	s_nu,
	s_paper_swipe,
	s_pop,
	s_thud,
	s_ts,
	s_woo,
}

music_names :: enum {
	none,
}

tile_map_names :: enum {
	none,
	pos_0_0,
	pos_n1_0,
}

world_map_names :: enum {
	none,
}

	all_raw_textures := [texture_names]asset {
		.none = {},
		.bace_light = { path = "textures/Bace_light.png", path_hash = 13365536812083001676, data = #load("textures/Bace_light.png"),info = #load("textures/Bace_light.txt",cstring) or_else #load("textures/default.txt", cstring), },
		.burning_loop_1 = { path = "textures/burning_loop_1.png", path_hash = 6166790060608745278, data = #load("textures/burning_loop_1.png"),info = #load("textures/burning_loop_1.txt",cstring) or_else #load("textures/default.txt", cstring), },
		.debug_hb = { path = "textures/debug_hb.png", path_hash = 3299811164142654984, data = #load("textures/debug_hb.png"),info = #load("textures/debug_hb.txt",cstring) or_else #load("textures/default.txt", cstring), },
		.ebf_casing = { path = "textures/ebf_casing.png", path_hash = 10390386613932180382, data = #load("textures/ebf_casing.png"),info = #load("textures/ebf_casing.txt",cstring) or_else #load("textures/default.txt", cstring), },
		.electrum_ingot = { path = "textures/electrum_ingot.png", path_hash = 8754388046225043245, data = #load("textures/electrum_ingot.png"),info = #load("textures/electrum_ingot.txt",cstring) or_else #load("textures/default.txt", cstring), },
		.enderium_ingot = { path = "textures/enderium_ingot.png", path_hash = 12084417163272295509, data = #load("textures/enderium_ingot.png"),info = #load("textures/enderium_ingot.txt",cstring) or_else #load("textures/default.txt", cstring), },
		.furnace_heater = { path = "textures/furnace_heater.png", path_hash = 13022341367022600994, data = #load("textures/furnace_heater.png"),info = #load("textures/furnace_heater.txt",cstring) or_else #load("textures/default.txt", cstring), },
		.furnace_heater_active = { path = "textures/furnace_heater_active.png", path_hash = 8347715471938772810, data = #load("textures/furnace_heater_active.png"),info = #load("textures/furnace_heater_active.txt",cstring) or_else #load("textures/default.txt", cstring), },
		.furnace_heater_active_overlay = { path = "textures/furnace_heater_active_overlay.png", path_hash = 10875590478785330958, data = #load("textures/furnace_heater_active_overlay.png"),info = #load("textures/furnace_heater_active_overlay.txt",cstring) or_else #load("textures/default.txt", cstring), },
		.generator = { path = "textures/generator.png", path_hash = 13626569050913750044, data = #load("textures/generator.png"),info = #load("textures/generator.txt",cstring) or_else #load("textures/default.txt", cstring), },
		.heavy_engineering = { path = "textures/heavy_engineering.png", path_hash = 589271216586481319, data = #load("textures/heavy_engineering.png"),info = #load("textures/heavy_engineering.txt",cstring) or_else #load("textures/default.txt", cstring), },
		.inertelectrum_block = { path = "textures/inertelectrum_block.png", path_hash = 17270655304981712002, data = #load("textures/inertelectrum_block.png"),info = #load("textures/inertelectrum_block.txt",cstring) or_else #load("textures/default.txt", cstring), },
		.inertelectrum_ingot = { path = "textures/inertelectrum_ingot.png", path_hash = 7861070513532811415, data = #load("textures/inertelectrum_ingot.png"),info = #load("textures/inertelectrum_ingot.txt",cstring) or_else #load("textures/default.txt", cstring), },
		.invar_ingot = { path = "textures/invar_ingot.png", path_hash = 4133426364480701946, data = #load("textures/invar_ingot.png"),info = #load("textures/invar_ingot.txt",cstring) or_else #load("textures/default.txt", cstring), },
		.light_engineering = { path = "textures/light_engineering.png", path_hash = 9783186649381942432, data = #load("textures/light_engineering.png"),info = #load("textures/light_engineering.txt",cstring) or_else #load("textures/default.txt", cstring), },
		.livingrock = { path = "textures/livingrock.png", path_hash = 3930536961460311311, data = #load("textures/livingrock.png"),info = #load("textures/livingrock.txt",cstring) or_else #load("textures/default.txt", cstring), },
		.lumium_ingot = { path = "textures/lumium_ingot.png", path_hash = 16932440210034172741, data = #load("textures/lumium_ingot.png"),info = #load("textures/lumium_ingot.txt",cstring) or_else #load("textures/default.txt", cstring), },
		.metal_ingot_steel = { path = "textures/metal_ingot_steel.png", path_hash = 15666197803909243112, data = #load("textures/metal_ingot_steel.png"),info = #load("textures/metal_ingot_steel.txt",cstring) or_else #load("textures/default.txt", cstring), },
		.radiator = { path = "textures/radiator.png", path_hash = 3477820327255557349, data = #load("textures/radiator.png"),info = #load("textures/radiator.txt",cstring) or_else #load("textures/default.txt", cstring), },
		.redstone_engineering = { path = "textures/redstone_engineering.png", path_hash = 15710039393131326869, data = #load("textures/redstone_engineering.png"),info = #load("textures/redstone_engineering.txt",cstring) or_else #load("textures/default.txt", cstring), },
		.signalum_ingot = { path = "textures/signalum_ingot.png", path_hash = 9220798395061397675, data = #load("textures/signalum_ingot.png"),info = #load("textures/signalum_ingot.txt",cstring) or_else #load("textures/default.txt", cstring), },
		.slot = { path = "textures/slot.png", path_hash = 980004971222327857, data = #load("textures/slot.png"),info = #load("textures/slot.txt",cstring) or_else #load("textures/default.txt", cstring), },
		.smooth_stone_brick = { path = "textures/smooth_stone_brick.png", path_hash = 7879108188018242015, data = #load("textures/smooth_stone_brick.png"),info = #load("textures/smooth_stone_brick.txt",cstring) or_else #load("textures/default.txt", cstring), },
		.smooth_stone_brick_side = { path = "textures/smooth_stone_brick_side.png", path_hash = 1665871021801579726, data = #load("textures/smooth_stone_brick_side.png"),info = #load("textures/smooth_stone_brick_side.txt",cstring) or_else #load("textures/default.txt", cstring), },
		.space = { path = "textures/space.png", path_hash = 15929091025269918601, data = #load("textures/space.png"),info = #load("textures/space.txt",cstring) or_else #load("textures/default.txt", cstring), },
		.space_2 = { path = "textures/space_2.png", path_hash = 15114738339118189970, data = #load("textures/space_2.png"),info = #load("textures/space_2.txt",cstring) or_else #load("textures/default.txt", cstring), },
		.space_3 = { path = "textures/space_3.png", path_hash = 8840834339669454624, data = #load("textures/space_3.png"),info = #load("textures/space_3.txt",cstring) or_else #load("textures/default.txt", cstring), },
		.space_4 = { path = "textures/space_4.png", path_hash = 14066465962513658753, data = #load("textures/space_4.png"),info = #load("textures/space_4.txt",cstring) or_else #load("textures/default.txt", cstring), },
		.space_5 = { path = "textures/space_5.png", path_hash = 9585186594634933907, data = #load("textures/space_5.png"),info = #load("textures/space_5.txt",cstring) or_else #load("textures/default.txt", cstring), },
		.space_6 = { path = "textures/space_6.png", path_hash = 15458173398917068474, data = #load("textures/space_6.png"),info = #load("textures/space_6.txt",cstring) or_else #load("textures/default.txt", cstring), },
		.space_6_copy = { path = "textures/space_6_Copy.png", path_hash = 11124607320499186961, data = #load("textures/space_6_Copy.png"),info = #load("textures/space_6_Copy.txt",cstring) or_else #load("textures/default.txt", cstring), },
		.square = { path = "textures/square.png", path_hash = 4981428206918530665, data = #load("textures/square.png"),info = #load("textures/square.txt",cstring) or_else #load("textures/default.txt", cstring), },
		.stone_brick = { path = "textures/stone_brick.png", path_hash = 9854756531852246637, data = #load("textures/stone_brick.png"),info = #load("textures/stone_brick.txt",cstring) or_else #load("textures/default.txt", cstring), },
		.test = { path = "textures/test.png", path_hash = 9959172591819369990, data = #load("textures/test.png"),info = #load("textures/test.txt",cstring) or_else #load("textures/default.txt", cstring), },
	}

	all_fonts := [font_names]asset {
	}

	all_shaders := [shader_names]asset {
		.test = { path = "shaders/test.fs", path_hash = 16528326675515972663, info = #load("shaders/test.fs",cstring), },
		.vs_test = { path = "shaders/vs_test.vs", path_hash = 17034886045086792897, data = #load("shaders/vs_test.vs"), },
	}

	all_sounds := [sound_names]asset {
		.none = {},
		.eat = { path = "sounds/eat.wav", path_hash = 9322739684646411757, data = #load("sounds/eat.wav"), },
		.running_1 = { path = "sounds/running_1.wav", path_hash = 8802162981989364211, data = #load("sounds/running_1.wav"), },
		.running_2 = { path = "sounds/running_2.wav", path_hash = 15640088568689936950, data = #load("sounds/running_2.wav"), },
		.running_3 = { path = "sounds/running_3.wav", path_hash = 2696931676953568120, data = #load("sounds/running_3.wav"), },
		.running_4 = { path = "sounds/running_4.wav", path_hash = 7603131260951650725, data = #load("sounds/running_4.wav"), },
		.running_5 = { path = "sounds/running_5.wav", path_hash = 14737963692332942463, data = #load("sounds/running_5.wav"), },
		.running_6 = { path = "sounds/running_6.wav", path_hash = 2743540702027105922, data = #load("sounds/running_6.wav"), },
		.sand_step_1 = { path = "sounds/sand_step_1.wav", path_hash = 4652838226723517885, data = #load("sounds/sand_step_1.wav"), },
		.s_click = { path = "sounds/S_Click.wav", path_hash = 18424844719441642079, data = #load("sounds/S_Click.wav"), },
		.s_nu = { path = "sounds/S_NU.wav", path_hash = 8132877811779969108, data = #load("sounds/S_NU.wav"), },
		.s_paper_swipe = { path = "sounds/S_Paper_Swipe.wav", path_hash = 5076741369102766507, data = #load("sounds/S_Paper_Swipe.wav"), },
		.s_pop = { path = "sounds/S_POP.wav", path_hash = 7151092392910782292, data = #load("sounds/S_POP.wav"), },
		.s_thud = { path = "sounds/S_Thud.wav", path_hash = 3399557965137847213, data = #load("sounds/S_Thud.wav"), },
		.s_ts = { path = "sounds/S_TS.wav", path_hash = 855195129459061715, data = #load("sounds/S_TS.wav"), },
		.s_woo = { path = "sounds/S_woo.wav", path_hash = 1657458895254586232, data = #load("sounds/S_woo.wav"), },
	}

	all_music := [music_names]asset {
		.none = {},
	}

	all_tile_maps := [tile_map_names]asset {
		.none = {},
		.pos_0_0 = { path = "tile_maps/pos_0_0.tmap", path_hash = 9625980316099917482, data = #load("tile_maps/pos_0_0.tmap"), },
		.pos_n1_0 = { path = "tile_maps/pos_N1_0.tmap", path_hash = 8508157100387709519, data = #load("tile_maps/pos_N1_0.tmap"), },
	}

	all_world_map := [world_map_names]asset {
		.none = {},
	}

