package game_engin

import "core:fmt"
import as "../assets"
import rl "vendor:raylib"
import "core:slice"
// import b2 "vendor:box2d"

camera:rl.Camera2D = { 0 ,0 ,0 ,1 }

this_frame_camera_target:=camera.target
light_mask:rl.RenderTexture 
dark_mask:rl.RenderTexture 
bloom_mask:rl.RenderTexture 
ui_mask:rl.RenderTexture 
lit_obj_mask:rl.RenderTexture 
// particle_mask:rl.RenderTexture

screane_Width_old :i32
screane_height_old :i32

framerate:i32=120

init_camera::proc(){
    camera.zoom = .5

    //i need to spawn a partical at the begining for some reson
    //particle :Particle = gen_p_confetti(rl.GetScreenToWorld2D(rl.GetMousePosition(), camera))
    //spawn_particle(particle)

}
init_maskes::proc(){

    light_mask = rl.LoadRenderTexture(rl.GetScreenWidth(), rl.GetScreenHeight())
    dark_mask = rl.LoadRenderTexture(rl.GetScreenWidth(), rl.GetScreenHeight())
    bloom_mask = rl.LoadRenderTexture(rl.GetScreenWidth(), rl.GetScreenHeight())
    ui_mask = rl.LoadRenderTexture(rl.GetScreenWidth(), rl.GetScreenHeight())
    lit_obj_mask = rl.LoadRenderTexture(rl.GetScreenWidth(), rl.GetScreenHeight())
    // particle_mask = rl.LoadRenderTexture(rl.GetScreenWidth(), rl.GetScreenHeight())

    rl.BeginTextureMode(light_mask)
    rl.ClearBackground(bace_light)
    rl.EndTextureMode()

    rl.BeginTextureMode(dark_mask)
    rl.ClearBackground(bace_dark)
    rl.EndTextureMode()

    rl.BeginTextureMode(bloom_mask)
    rl.ClearBackground({0,0,0,0})
    rl.EndTextureMode()

    rl.BeginTextureMode(ui_mask)
    rl.ClearBackground({0,0,0,0})
    rl.EndTextureMode()

    rl.BeginTextureMode(lit_obj_mask)
    rl.ClearBackground({0,0,0,0})
    rl.EndTextureMode()

    // rl.BeginTextureMode(particle_mask)
    // rl.ClearBackground({0,0,0,0})
    // rl.EndTextureMode()
}

maintane_masks::proc(){
    this_frame_camera_target = camera.target
    screen_width:=rl.GetScreenWidth()
    screen_height:=rl.GetScreenHeight()

    if screane_Width_old != screen_width || screane_height_old != screen_height {
        rl.UnloadRenderTexture(light_mask)
        rl.UnloadRenderTexture(dark_mask)
        rl.UnloadRenderTexture(bloom_mask)
        rl.UnloadRenderTexture(ui_mask)
        rl.UnloadRenderTexture(lit_obj_mask)
        // rl.UnloadRenderTexture(particle_mask)
        light_mask = rl.LoadRenderTexture(screen_width, screen_height)
        dark_mask = rl.LoadRenderTexture(screen_width, screen_height)
        bloom_mask = rl.LoadRenderTexture(screen_width, screen_height)
        ui_mask = rl.LoadRenderTexture(screen_width, screen_height)
        lit_obj_mask = rl.LoadRenderTexture(screen_width, screen_height)
        // particle_mask = rl.LoadRenderTexture(screen_width, screen_height)
        screane_Width_old = screen_width
        screane_height_old = screen_height
    }
    rl.BeginTextureMode(light_mask)
    rl.ClearBackground(bace_light)
    rl.EndTextureMode()

    rl.BeginTextureMode(dark_mask)
    rl.ClearBackground(bace_dark)
    rl.EndTextureMode()

    rl.BeginTextureMode(bloom_mask)
    rl.ClearBackground({0,0,0,0})
    rl.EndTextureMode()

    rl.BeginTextureMode(ui_mask)
    rl.ClearBackground({0,0,0,0})
    rl.EndTextureMode()

    rl.BeginTextureMode(lit_obj_mask)
    rl.ClearBackground({0,0,0,0})
    rl.EndTextureMode()
}



draw_texture::proc(name : as.texture_names ,rec:rl.Rectangle,origin:rl.Vector2={0,0},rotation:f32=0,color:rl.Color=rl.WHITE,frame_index:int = 0,w_s:f32=1,h_s:f32=1) {
    // fmt.print(name,"\n")
    if len(as.textures[name].rectangle) > frame_index{
        source:=as.textures[name].rectangle[frame_index]
        source.width = source.width * w_s
        source.height = source.height * h_s
        rl.DrawTexturePro(as.atlases[as.textures[name].atlas_index].render_texture.texture, source, rec, origin, rotation, color)
    }
}

do_under_ui :: proc(){

}

do_bg :: proc(){
    draw_world_bg_map()
}

do_mg :: proc(){
    draw_all_sprites()
    // render_sprites()
    draw_world_mg_map()
    draw_all_particle()
    draw_lighting_mask()
    draw_bloom_mask()
}

do_fg :: proc(){
    draw_world_fg_map()
}

do_debug::proc(){
    draw_world_debug_map()
}

do_ui :: proc(){
    draw_ui_mask()
    // if settings_game.video.show_fps{rl.DrawFPS(10, 10)}
    // do_ui_t_editor()
    // do_ui_menu()
    // checking_guis()
}

