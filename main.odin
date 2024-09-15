package main

import as "assets"
import re"rendering"
import "core:fmt"
import rl "vendor:raylib"
import "core:os"
import "core:slice"
import "core:encoding/cbor"



main :: proc() {
    rl.SetConfigFlags({.WINDOW_RESIZABLE})
    rl.InitWindow(800, 800, "test")
    rl.InitAudioDevice()
    rl.SetTargetFPS(120)
    re.init_camera()
    re.init_gui()
    as.init_texturs()
    as.init_sounds()
    as.init_shaders()



    // re.init_t_map(&re.temp_t_map)
    // re.fill_t_map(&re.temp_t_map,as.texture_names.space_2)
    // re.init_t_map(&re.temp_t_map)
    // re.add_t_map_to_world_map(&re.temp_t_map, &re.Curent_world_map)

    // re.fill_t_map(&re.temp_t_map,as.texture_names.space_2)
    // re.init_t_map(&re.temp_t_map)
    // re.temp_t_map.pos = {1,1}
    // re.add_t_map_to_world_map(&re.temp_t_map, &re.Curent_world_map)
    // re.fill_t_map(&re.temp_t_map,as.texture_names.space_2)
    // re.init_t_map(&re.temp_t_map)
    // re.temp_t_map.pos = {-1,-1}
    // re.add_t_map_to_world_map(&re.temp_t_map, &re.Curent_world_map)
    // re.fill_t_map(&re.temp_t_map,as.texture_names.space_2)
    // re.init_t_map(&re.temp_t_map)
    // re.temp_t_map.pos = {1,-1}
    // re.add_t_map_to_world_map(&re.temp_t_map, &re.Curent_world_map)
    // re.fill_t_map(&re.temp_t_map,as.texture_names.space_2)
    // re.init_t_map(&re.temp_t_map)
    // re.temp_t_map.pos = {-1,1}
    // re.add_t_map_to_world_map(&re.temp_t_map, &re.Curent_world_map)
    // re.fill_t_map(&re.temp_t_map,as.texture_names.space_2)
    // re.init_t_map(&re.temp_t_map)
    // re.temp_t_map.pos = {0,1}
    // re.add_t_map_to_world_map(&re.temp_t_map, &re.Curent_world_map)
    // re.fill_t_map(&re.temp_t_map,as.texture_names.space_2)
    // re.init_t_map(&re.temp_t_map)
    // re.temp_t_map.pos = {1,0}
    // re.add_t_map_to_world_map(&re.temp_t_map, &re.Curent_world_map)
    // re.fill_t_map(&re.temp_t_map,as.texture_names.space_2)
    // re.init_t_map(&re.temp_t_map)
    // re.temp_t_map.pos = {-1,0}
    // re.add_t_map_to_world_map(&re.temp_t_map, &re.Curent_world_map)
    // re.fill_t_map(&re.temp_t_map,as.texture_names.space_2)
    // re.init_t_map(&re.temp_t_map)
    // re.temp_t_map.pos = {0,-1}
    // re.add_t_map_to_world_map(&re.temp_t_map, &re.Curent_world_map)
    // re.fill_t_map(&re.temp_t_map,as.texture_names.space_2)
    // re.init_t_map(&re.temp_t_map)
    // re.temp_t_map.pos = {0,-2}
    // re.add_t_map_to_world_map(&re.temp_t_map, &re.Curent_world_map)
    // re.fill_t_map(&re.temp_t_map,as.texture_names.space_2)
    // re.init_t_map(&re.temp_t_map)
    // re.temp_t_map.pos = {0,-3}
    // re.add_t_map_to_world_map(&re.temp_t_map, &re.Curent_world_map)
    // re.fill_t_map(&re.temp_t_map,as.texture_names.space_2)
    // re.init_t_map(&re.temp_t_map)
    // re.temp_t_map.pos = {0,-5}
    // re.add_t_map_to_world_map(&re.temp_t_map, &re.Curent_world_map)
    // re.fill_t_map(&re.temp_t_map,as.texture_names.space_2)
    // re.init_t_map(&re.temp_t_map)
    // re.temp_t_map.pos = {8,-8}
    // re.add_t_map_to_world_map(&re.temp_t_map, &re.Curent_world_map)

    temptmap := re.lode_t_map_from_bi(as.all_tile_maps[as.tile_map_names.pos_0_0].data)
    re.init_t_map(&temptmap)
    re.add_t_map_to_world_map(&temptmap, &re.Curent_world_map)



    for (!rl.WindowShouldClose()) 
    {
        re.maintane_masks()
        re.check_editer_mode()
        rl.BeginTextureMode(re.light_mask)
        rl.BeginBlendMode(rl.BlendMode.ADDITIVE)     
        re.calculate_particles_light()
        re.draw_simple_light({50,50},50)
        re.draw_simple_light({150,150},50)
        re.draw_simple_light({300,300},50)
        rl.EndBlendMode()
        rl.EndTextureMode()

        rl.BeginDrawing()
        rl.ClearBackground(rl.RAYWHITE)
        re.do_under_ui()
        rl.BeginMode2D(re.camera)
        if !re.editer_mode{
            if rl.IsMouseButtonDown(.LEFT) {
                for i in 0..=1 {
                particle :re.Particle = re.gen_p_confetti(rl.GetScreenToWorld2D(rl.GetMousePosition(), re.camera))
                re.spawn_particle(particle)
                //rl.PlaySound(as.sounds[as.sound_names.s_paper_swipe])
                }
            }
        }
        if rl.IsMouseButtonDown(.RIGHT) {
            delta:rl.Vector2 = rl.GetMouseDelta()
            delta = (delta * -1.0/re.camera.zoom)
            re.camera.target += delta
        }

        re.do_bg()
        re.do_mg()
        re.calculate_particles()
        re.do_lighting()
        re.do_fg()
        rl.EndMode2D()
        re.do_ui()
        rl.EndDrawing()
    }
    rl.CloseAudioDevice()
    rl.CloseWindow()
 
}
