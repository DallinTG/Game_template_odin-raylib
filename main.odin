package main

import as "assets"
import re"rendering"
import "core:fmt"
import rl "vendor:raylib"

    camera:rl.Camera2D = { 0 ,0 ,0 ,1 }

main :: proc() {
    rl.SetConfigFlags({.WINDOW_RESIZABLE})
    rl.InitWindow(400, 400, "test")
    rl.SetTargetFPS(60)
    camera.zoom = 1.0
    as.init_texturs()
    as.int_shaders()



    for (!rl.WindowShouldClose()) 
    {
        re.maintane_light_mask()


                             
        

        rl.BeginTextureMode(re.light_mask)
       // rl.BeginBlendMode(rl.BlendMode.)     
    //    rl.SetShaderValue(as.shader_test, rl.GetShaderLocation(as.shader_test, "world_light"), &as.world_light, rl.ShaderUniformDataType.VEC4)
     //   rl.BeginShaderMode(as.shader_test)
        re.draw_simple_light({100,100},camera)

        rl.EndTextureMode()



        rl.BeginDrawing()
            rl.ClearBackground(rl.RAYWHITE)
        rl.BeginMode2D(camera)
            re.calculate_particles()
            if rl.IsMouseButtonDown(.LEFT) {
                particle :re.Particle= {rl.GetScreenToWorld2D(rl.GetMousePosition(), camera), 5.0,5.0, {0,0},{0,0},0,0,{0,0}, {100,100},{100,100}, {1,1,1,1}, {1,1,1,1},as.textures[.burning_loop_1],1}
                for i in 0..=1 {
                re.spawn_particle(particle)
                }
            }

        if rl.IsMouseButtonDown(.RIGHT) {
            delta:rl.Vector2 = rl.GetMouseDelta()
            delta = (delta * -1.0/camera.zoom)
            camera.target += delta
        }

        
        rl.EndMode2D()
       // rl.SetShaderValue(as.shader_test, rl.GetShaderLocation(as.shader_test, "world_light"), &as.world_light, rl.ShaderUniformDataType.VEC4)
       // rl.SetShaderValue(as.shader_test, rl.GetShaderLocation(as.shader_test, "lights"), &as.light_mask.texture, rl.ShaderUniformDataType.SAMPLER2D)
       // rl.BeginShaderMode(as.shader_test)
        re.do_lighting(camera)
       // rl.EndShaderMode()
        rl.DrawFPS(10, 10)
        rl.EndDrawing()
    }
    rl.CloseWindow()
 
}
