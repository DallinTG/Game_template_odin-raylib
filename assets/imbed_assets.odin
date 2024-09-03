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
	space,
	space_2,
	space_3,
	space_4,
	space_5,
	space_6,
	square,
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

	all_raw_textures := [texture_names]asset {
		.none = {},
		.bace_light = { path = "textures/Bace_light.png", path_hash = 13365536812083001676, data = #load("textures/Bace_light.png"),info = #load("textures/Bace_light.txt",cstring) or_else #load("textures/default.txt", cstring), },
		.burning_loop_1 = { path = "textures/burning_loop_1.png", path_hash = 6166790060608745278, data = #load("textures/burning_loop_1.png"),info = #load("textures/burning_loop_1.txt",cstring) or_else #load("textures/default.txt", cstring), },
		.space = { path = "textures/space.png", path_hash = 15929091025269918601, data = #load("textures/space.png"),info = #load("textures/space.txt",cstring) or_else #load("textures/default.txt", cstring), },
		.space_2 = { path = "textures/space_2.png", path_hash = 15114738339118189970, data = #load("textures/space_2.png"),info = #load("textures/space_2.txt",cstring) or_else #load("textures/default.txt", cstring), },
		.space_3 = { path = "textures/space_3.png", path_hash = 8840834339669454624, data = #load("textures/space_3.png"),info = #load("textures/space_3.txt",cstring) or_else #load("textures/default.txt", cstring), },
		.space_4 = { path = "textures/space_4.png", path_hash = 14066465962513658753, data = #load("textures/space_4.png"),info = #load("textures/space_4.txt",cstring) or_else #load("textures/default.txt", cstring), },
		.space_5 = { path = "textures/space_5.png", path_hash = 9585186594634933907, data = #load("textures/space_5.png"),info = #load("textures/space_5.txt",cstring) or_else #load("textures/default.txt", cstring), },
		.space_6 = { path = "textures/space_6.png", path_hash = 15458173398917068474, data = #load("textures/space_6.png"),info = #load("textures/space_6.txt",cstring) or_else #load("textures/default.txt", cstring), },
		.square = { path = "textures/square.png", path_hash = 4981428206918530665, data = #load("textures/square.png"),info = #load("textures/square.txt",cstring) or_else #load("textures/default.txt", cstring), },
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

