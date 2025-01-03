package main

import as "assets"
import ge"game_engin"
import "core:fmt"
import rl "vendor:raylib"
import rlgl "vendor:raylib/rlgl"
import "core:os"
import "core:slice"
import "core:encoding/cbor"
import "core:math"


init_startup::proc(){
    rl.SetConfigFlags({.WINDOW_RESIZABLE})
    // rl.SetConfigFlags({.WINDOW_ALWAYS_RUN})
    // rl.ConfigFlags(rl.FLAG_WINDOW_ALWAYS_RUN)
    // rl.SetTargetFPS(ge.framerate)
    rl.SetTargetFPS(300)
    ge.init_memery()
    ge.init_threads()
    rl.InitWindow(800, 800, "test")
    rl.InitAudioDevice()
    rl.SetExitKey(.KEY_NULL)
    ge.init_settings()
    ge.init_defalt_light_data()
    ge.init_defalt_sprite_data()
    ge.init_defalt_particle_data()
    ge.init_all_tile_data()
    ge.init_defalt_entity_data()
    ge.init_camera()
    ge.init_box_2d()
    ge.init_gui()
    as.init_texturs()
    as.init_sounds()
    as.init_shaders()
    ge.init_maskes()
    ge.camera.target = {0,0}

}
main :: proc() {
    
    init_startup()


    // temptmap := ge.lode_t_map_from_bi(as.all_tile_maps[as.tile_map_names.pos_0_0].data)
    // ge.init_t_map(&temptmap)
    // ge.add_t_map_to_world_map(&temptmap, &ge.Curent_world_map)
    // temptmap.pos.x = -1
    // ge.init_t_map(&temptmap)
    // ge.add_t_map_to_world_map(&temptmap, &ge.Curent_world_map)

    for (!ge.window_should_close) 
    {
        ge.window_should_close = rl.WindowShouldClose()
        ge.manage_key_data()
        ge.maintane_masks()
        ge.draw_and_calculate_ui()
        ge.get_time_util()
        if !ge.game_paused{
            ge.do_entitys()
            ge.calculate_particles()
            // ge.do_lightting()
            ge.draw_to_bace_mask()
            ge.do_all_lights()
            ge.sim_box_2d()
            
            
            // ge.pool_join_my_threds()
        }
        ge.manage_sound_bytes()
        rl.BeginDrawing()
        rl.ClearBackground(rl.RAYWHITE)
        ge.do_under_ui()
        rl.BeginMode2D(ge.camera)
        if !ge.editer_mode{
            if ge.key.m_left_d {
                for i in 0..=1 {
                particle :ge.particle = {
                    xy=rl.GetScreenToWorld2D(rl.GetMousePosition(), ge.camera),
                    life=10,
                    max_life=10,
                    id=ge.particle_id.test,
                    
                }
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
        if rl.IsKeyDown(.SPACE){
            //ge.unlode_t_map(&ge.Curent_world_map.t_maps[{0,0}])
            for &entity_data,i in ge.all_entitys.data[:ge.all_entitys.last_entity]{
               ge.delete_entity(entity_data.entity.entity_index)
           }
        }


        ge.do_bg()
        ge.do_mg()
        ge.do_fg()
        ge.do_debug()
        // rl.DrawCube({0,10,1.5}, 100, 100, 100, {255,0,0,255})
        // rl.DrawCubeV({0,0,.5}, {100,100,100}, {255,0,0,255})
        rl.EndMode2D()
        ge.do_ui()
        rl.EndDrawing()
    }
    ge.free_memery()
    rl.CloseAudioDevice()
    rl.CloseWindow()
}
