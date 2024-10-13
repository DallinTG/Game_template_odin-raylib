package game_engin

import "core:fmt"
import as "../assets"
import rl "vendor:raylib"
import "core:slice"
// import b2 "vendor:box2d"

camera:rl.Camera2D = { 0 ,0 ,0 ,1 }
sprite::struct {
    z:f32,
    rotation:f32,
    rec:rl.Rectangle,
    origin:rl.Vector2,
    color:rl.Color,
    curent_frame:int,
    texture_name:as.texture_names,
    frame_timer:f32,
    frames_per_second:int,
}
sprite_rendering_q:=make([dynamic]^sprite)
temp_sprite_buffer:=make([dynamic]sprite)

this_frame_camera_target:=camera.target
light_mask:rl.RenderTexture 
dark_mask:rl.RenderTexture 
bloom_mask:rl.RenderTexture 
ui_mask:rl.RenderTexture 
//Particle_mask:rl.RenderTexture2D

screane_Width_old :i32
screane_height_old :i32

framerate:i32=120

init_camera::proc(){
    camera.zoom = 1

    //i need to spawn a partical at the begining for some reson
    //particle :Particle = gen_p_confetti(rl.GetScreenToWorld2D(rl.GetMousePosition(), camera))
    //spawn_particle(particle)

}
init_maskes::proc(){

    light_mask = rl.LoadRenderTexture(rl.GetScreenWidth(), rl.GetScreenHeight())
    dark_mask = rl.LoadRenderTexture(rl.GetScreenWidth(), rl.GetScreenHeight())
    bloom_mask = rl.LoadRenderTexture(rl.GetScreenWidth(), rl.GetScreenHeight())
    ui_mask = rl.LoadRenderTexture(rl.GetScreenWidth(), rl.GetScreenHeight())

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
        light_mask = rl.LoadRenderTexture(screen_width, screen_height)
        dark_mask = rl.LoadRenderTexture(screen_width, screen_height)
        bloom_mask = rl.LoadRenderTexture(screen_width, screen_height)
        ui_mask = rl.LoadRenderTexture(screen_width, screen_height)
        //Particle_mask = rl.LoadRenderTexture(screen_width, screen_height)
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
}

render_sprites::proc(){
    //slice.sort(sprite_rendering_q[:])
    for sprite, i in temp_sprite_buffer {
        append(&sprite_rendering_q, &temp_sprite_buffer[i])
    }
    clear(&temp_sprite_buffer)

    slice.sort_by(sprite_rendering_q[:],sort_by_z_index)
    sort_by_z_index::proc(sprite_1: ^sprite,sprite_2: ^sprite)->(bool){
        return sprite_1.z < sprite_2.z
    }

    for sprite, i in sprite_rendering_q {
        draw_sprite(sprite^)
    }
    clear(&sprite_rendering_q)
}


draw_texture::proc(name : as.texture_names ,rec:rl.Rectangle,origin:rl.Vector2={0,0},rotation:f32=0,color:rl.Color=rl.WHITE,frame_index:int = 0) {
    rl.DrawTexturePro(as.atlases[as.textures[name].atlas_index].render_texture.texture, as.textures[name].rectangle[frame_index], rec, origin, rotation, color)
}

draw_sprite::proc(sprite:sprite){

    draw_texture(sprite.texture_name,sprite.rec,sprite.origin,sprite.rotation,sprite.color,sprite.curent_frame)
    // rl.DrawTexturePro(as.atlases[as.textures[sprite.name].atlas_index].render_texture.texture, as.textures[sprite.name].rectangle[sprite.frame_index], sprite.rec, sprite.origin, sprite.rotation, sprite.color)
}


do_under_ui :: proc(){

}

do_bg :: proc(){
    //draw_bg_t_map(temp_t_map)
    draw_world_bg_map()
}

do_mg :: proc(){
    //draw_mg_t_map(temp_t_map)
    render_sprites()
    draw_world_mg_map()
}

do_fg :: proc(){
    // draw_fg_t_map(temp_t_map)
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

