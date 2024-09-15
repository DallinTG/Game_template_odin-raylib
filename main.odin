package main

import as "assets"
import ge"game_engin"
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
    ge.init_camera()
    ge.init_gui()
    as.init_texturs()
    as.init_sounds()
    as.init_shaders()



    // ge.init_t_map(&ge.temp_t_map)
    // ge.fill_t_map(&ge.temp_t_map,as.texture_names.space_2)
    // ge.init_t_map(&ge.temp_t_map)
    // ge.add_t_map_to_world_map(&ge.temp_t_map, &ge.Curent_world_map)

    // ge.fill_t_map(&ge.temp_t_map,as.texture_names.space_2)
    // ge.init_t_map(&ge.temp_t_map)
    // ge.temp_t_map.pos = {1,1}
    // ge.add_t_map_to_world_map(&ge.temp_t_map, &ge.Curent_world_map)
    // ge.fill_t_map(&ge.temp_t_map,as.texture_names.space_2)
    // ge.init_t_map(&ge.temp_t_map)
    // ge.temp_t_map.pos = {-1,-1}
    // ge.add_t_map_to_world_map(&ge.temp_t_map, &ge.Curent_world_map)
    // ge.fill_t_map(&ge.temp_t_map,as.texture_names.space_2)
    // ge.init_t_map(&ge.temp_t_map)
    // ge.temp_t_map.pos = {1,-1}
    // ge.add_t_map_to_world_map(&ge.temp_t_map, &ge.Curent_world_map)
    // ge.fill_t_map(&ge.temp_t_map,as.texture_names.space_2)
    // ge.init_t_map(&ge.temp_t_map)
    // ge.temp_t_map.pos = {-1,1}
    // ge.add_t_map_to_world_map(&ge.temp_t_map, &ge.Curent_world_map)
    // ge.fill_t_map(&ge.temp_t_map,as.texture_names.space_2)
    // ge.init_t_map(&ge.temp_t_map)
    // ge.temp_t_map.pos = {0,1}
    // ge.add_t_map_to_world_map(&ge.temp_t_map, &ge.Curent_world_map)
    // ge.fill_t_map(&ge.temp_t_map,as.texture_names.space_2)
    // ge.init_t_map(&ge.temp_t_map)
    // ge.temp_t_map.pos = {1,0}
    // ge.add_t_map_to_world_map(&ge.temp_t_map, &ge.Curent_world_map)
    // ge.fill_t_map(&ge.temp_t_map,as.texture_names.space_2)
    // ge.init_t_map(&ge.temp_t_map)
    // ge.temp_t_map.pos = {-1,0}
    // ge.add_t_map_to_world_map(&ge.temp_t_map, &ge.Curent_world_map)
    // ge.fill_t_map(&ge.temp_t_map,as.texture_names.space_2)
    // ge.init_t_map(&ge.temp_t_map)
    // ge.temp_t_map.pos = {0,-1}
    // ge.add_t_map_to_world_map(&ge.temp_t_map, &ge.Curent_world_map)
    // ge.fill_t_map(&ge.temp_t_map,as.texture_names.space_2)
    // ge.init_t_map(&ge.temp_t_map)
    // ge.temp_t_map.pos = {0,-2}
    // ge.add_t_map_to_world_map(&ge.temp_t_map, &ge.Curent_world_map)
    // ge.fill_t_map(&ge.temp_t_map,as.texture_names.space_2)
    // ge.init_t_map(&ge.temp_t_map)
    // ge.temp_t_map.pos = {0,-3}
    // ge.add_t_map_to_world_map(&ge.temp_t_map, &ge.Curent_world_map)
    // ge.fill_t_map(&ge.temp_t_map,as.texture_names.space_2)
    // ge.init_t_map(&ge.temp_t_map)
    // ge.temp_t_map.pos = {0,-5}
    // ge.add_t_map_to_world_map(&ge.temp_t_map, &ge.Curent_world_map)
    // ge.fill_t_map(&ge.temp_t_map,as.texture_names.space_2)
    // ge.init_t_map(&ge.temp_t_map)
    // ge.temp_t_map.pos = {8,-8}
    // ge.add_t_map_to_world_map(&ge.temp_t_map, &ge.Curent_world_map)

    temptmap := ge.lode_t_map_from_bi(as.all_tile_maps[as.tile_map_names.pos_0_0].data)
    ge.init_t_map(&temptmap)
    ge.add_t_map_to_world_map(&temptmap, &ge.Curent_world_map)



    for (!rl.WindowShouldClose()) 
    {
        ge.maintane_masks()
        ge.check_editer_mode()
        rl.BeginTextureMode(ge.light_mask)
        rl.BeginBlendMode(rl.BlendMode.ADDITIVE)     
        ge.calculate_particles_light()
        ge.draw_simple_light({50,50},50)
        ge.draw_simple_light({150,150},50)
        ge.draw_simple_light({300,300},50)
        rl.EndBlendMode()
        rl.EndTextureMode()

        rl.BeginDrawing()
        rl.ClearBackground(rl.RAYWHITE)
        ge.do_under_ui()
        rl.BeginMode2D(ge.camera)
        if !ge.editer_mode{
            if rl.IsMouseButtonDown(.LEFT) {
                for i in 0..=1 {
                particle :ge.Particle = ge.gen_p_confetti(rl.GetScreenToWorld2D(rl.GetMousePosition(), ge.camera))
                ge.spawn_particle(particle)
                //rl.PlaySound(as.sounds[as.sound_names.s_paper_swipe])
                }
            }
        }
        if rl.IsMouseButtonDown(.RIGHT) {
            delta:rl.Vector2 = rl.GetMouseDelta()
            delta = (delta * -1.0/ge.camera.zoom)
            ge.camera.target += delta
        }

        ge.do_bg()
        ge.do_mg()
        ge.calculate_particles()
        ge.do_lighting()
        ge.do_fg()
        rl.EndMode2D()
        ge.do_ui()
        rl.EndDrawing()
    }
    rl.CloseAudioDevice()
    rl.CloseWindow()
 
}
