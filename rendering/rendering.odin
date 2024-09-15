package game_eengin

import "core:fmt"
import as "../assets"
import rl "vendor:raylib"

camera:rl.Camera2D = { 0 ,0 ,0 ,1 }

this_frame_camera_target:=camera.target
light_mask:rl.RenderTexture 
dark_mask:rl.RenderTexture 
//Particle_mask:rl.RenderTexture2D

screane_Width_old :i32 = 0
screane_height_old :i32 = 0

init_camera::proc(){
    camera.zoom = .1
    
    //i need to spawn a partical at the begining for some reson
    //particle :Particle = gen_p_confetti(rl.GetScreenToWorld2D(rl.GetMousePosition(), camera))
    //spawn_particle(particle)
}

maintane_masks::proc(){
    this_frame_camera_target = camera.target
    screen_width:=rl.GetScreenWidth()
    screen_height:=rl.GetScreenHeight()
    if screane_Width_old != screen_width || screane_height_old != screen_height {
        light_mask = rl.LoadRenderTexture(screen_width, screen_height)
        dark_mask = rl.LoadRenderTexture(screen_width, screen_height)
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
}

draw_texture::proc(name : as.texture_names ,rec:rl.Rectangle,origin:rl.Vector2={0,0},rotation:f32=0,color:rl.Color=rl.WHITE,frame_index:int = 0) {
    rl.DrawTexturePro(as.atlases[as.textures[name].atlas_index].render_texture.texture, as.textures[name].rectangle[frame_index], rec, origin, rotation, color)
}

do_under_ui :: proc(){

}

do_bg :: proc(){
    //draw_bg_t_map(temp_t_map)
    draw_world_bg_map()
}

do_mg :: proc(){
    //draw_mg_t_map(temp_t_map)
    draw_world_mg_map()
}

do_fg :: proc(){
    // draw_fg_t_map(temp_t_map)
    draw_world_fg_map()
}

do_ui :: proc(){
    rl.DrawFPS(10, 10)
}

