package main

import as "assets"
import re"rendering"
import "core:fmt"
import rl "vendor:raylib"

    

main :: proc() {
    rl.SetConfigFlags({.WINDOW_RESIZABLE})
    rl.InitWindow(800, 800, "test")
    rl.InitAudioDevice()
    rl.SetTargetFPS(120)
    re.init_camera()
    as.init_texturs()
    as.init_sounds()
    as.int_shaders()

    for (!rl.WindowShouldClose()) 
    {
        
        re.maintane_masks()
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
        rl.BeginMode2D(re.camera)
            if rl.IsMouseButtonDown(.LEFT) {
                for i in 0..=1 {
                particle :re.Particle = re.gen_p_confetti(rl.GetScreenToWorld2D(rl.GetMousePosition(), re.camera))
                re.spawn_particle(particle)
                //rl.PlaySound(as.sounds[as.sound_names.s_paper_swipe])
                }
            }
        if rl.IsMouseButtonDown(.RIGHT) {
            delta:rl.Vector2 = rl.GetMouseDelta()
            delta = (delta * -1.0/re.camera.zoom)
            re.camera.target += delta
        }

        
        rl.EndMode2D()
        //re.do_particle_mask()
        re.calculate_particles()
        re.do_lighting()
        rl.DrawFPS(10, 10)
        rl.EndDrawing()
    }
    rl.CloseAudioDevice()
    rl.CloseWindow()
 
}
