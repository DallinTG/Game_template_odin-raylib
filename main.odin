package main

import as "assets"
import ge"game_engin"
import "core:fmt"
import rl "vendor:raylib"
import "core:os"
import "core:slice"
import "core:encoding/cbor"


init_startup::proc(){
    rl.SetConfigFlags({.WINDOW_RESIZABLE})
    rl.SetTargetFPS(ge.framerate)
    ge.init_memery()
    rl.InitWindow(800, 800, "test")
    rl.InitAudioDevice()
    ge.init_camera()
    ge.init_gui()
    as.init_texturs()
    as.init_sounds()
    as.init_shaders()
    ge.init_maskes()
}
main :: proc() {
    init_startup()

    temptmap := ge.lode_t_map_from_bi(as.all_tile_maps[as.tile_map_names.pos_0_0].data)
    ge.init_t_map(&temptmap)
    ge.add_t_map_to_world_map(&temptmap, &ge.Curent_world_map)

    for (!rl.WindowShouldClose()) 
    {
        ge.check_editer_mode()
        ge.do_lightting()
        rl.BeginDrawing()
        rl.ClearBackground(rl.RAYWHITE)
        ge.do_under_ui()
        rl.BeginMode2D(ge.camera)
        if !ge.editer_mode{
            if rl.IsMouseButtonDown(.LEFT) {
                for i in 0..=1 {
                particle :ge.Particle = ge.gen_p_confetti(rl.GetScreenToWorld2D(rl.GetMousePosition(), ge.camera))
                particle.texture=as.textures[as.texture_names.burning_loop_1]
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
        ge.draw_lighting_mask()
        ge.do_fg()
        rl.EndMode2D()
        ge.do_ui()
        rl.EndDrawing()

    }
    ge.free_memery()
    rl.CloseAudioDevice()
    rl.CloseWindow()
 
}
