package game_engin

import "core:fmt"
import "core:math"
import as "../assets"
import rl "vendor:raylib"
import "core:slice"
import rlgl "vendor:raylib/rlgl"
// import b2 "vendor:box2d"

camera:rl.Camera2D = { 0 ,0 ,0 ,1 }

this_frame_camera_target:=camera.target
light_mask:rl.RenderTexture 
dark_mask:rl.RenderTexture 
bloom_mask:rl.RenderTexture 
ui_mask:rl.RenderTexture 
// lit_obj_mask:rl.RenderTexture 
bace_mask:rl.RenderTexture 
// particle_mask:rl.RenderTexture

screane_Width_old :i32
screane_height_old :i32

framerate:i32=120

init_camera::proc(){
    camera.zoom = .6

    //i need to spawn a partical at the begining for some reson
    //particle :Particle = gen_p_confetti(rl.GetScreenToWorld2D(rl.GetMousePosition(), camera))
    //spawn_particle(particle)

}
init_maskes::proc(){

    light_mask = rl.LoadRenderTexture(rl.GetScreenWidth(), rl.GetScreenHeight())
    dark_mask = rl.LoadRenderTexture(rl.GetScreenWidth(), rl.GetScreenHeight())
    bloom_mask = rl.LoadRenderTexture(rl.GetScreenWidth(), rl.GetScreenHeight())
    ui_mask = rl.LoadRenderTexture(rl.GetScreenWidth(), rl.GetScreenHeight())
    // lit_obj_mask = rl.LoadRenderTexture(rl.GetScreenWidth(), rl.GetScreenHeight())
    bace_mask = rl.LoadRenderTexture(rl.GetScreenWidth(), rl.GetScreenHeight())
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

    // rl.BeginTextureMode(lit_obj_mask)
    // rl.ClearBackground({0,0,0,0})
    // rl.EndTextureMode()

    // rl.BeginTextureMode(bace_mask)
    // rl.ClearBackground({255,255,255,255})
    // rl.EndTextureMode()

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
        // rl.UnloadRenderTexture(lit_obj_mask)
        rl.UnloadRenderTexture(bace_mask)
        // rl.UnloadRenderTexture(particle_mask)
        light_mask = rl.LoadRenderTexture(screen_width, screen_height)
        dark_mask = rl.LoadRenderTexture(screen_width, screen_height)
        bloom_mask = rl.LoadRenderTexture(screen_width, screen_height)
        ui_mask = rl.LoadRenderTexture(screen_width, screen_height)
        // lit_obj_mask = rl.LoadRenderTexture(screen_width, screen_height)
        bace_mask = rl.LoadRenderTexture(screen_width, screen_height)
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

    // rl.BeginTextureMode(lit_obj_mask)
    // rl.ClearBackground({0,0,0,0})
    // rl.EndTextureMode()

    // rl.BeginTextureMode(bace_mask)
    // rl.ClearBackground({255,255,255,255})
    // rl.EndTextureMode()
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

draw_to_bace_mask::proc(){
    rl.BeginTextureMode(bace_mask)
    rl.BeginMode2D(camera)
    rl.ClearBackground({0,0,50,50})
    draw_all_sprites()
    draw_world_mg_map()
    draw_all_particle()
    rl.EndMode2D()
    rl.EndTextureMode()
}
draw_bace_mask::proc(){ 
    cord := this_frame_camera_target
    rl.DrawTexturePro(bace_mask.texture,{0,0,cast(f32)bace_mask.texture.width,cast(f32)bace_mask.texture.height * -1},{cord.x, cord.y, cast(f32)bace_mask.texture.width / camera.zoom,cast(f32)bace_mask.texture.height / camera.zoom},{0,0},0,rl.WHITE)
}

do_under_ui :: proc(){

}

do_bg :: proc(){
    draw_world_bg_map()
}

do_mg :: proc(){
    // draw_all_sprites()
    // render_sprites()
    // draw_world_mg_map()
    // draw_bace_lit()
    // draw_all_particle()
    // draw_bace_mask()
    draw_lighting_mask()
    // draw_bace_mask()
    // draw_bloom_mask()
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

draw_texture_pro_custom::proc(texture:rl.Texture2D , source:rl.Rectangle ,dest:rl.Rectangle ,origin:rl.Vector2 ,rotation:f32,tint:rl.Color ) {
    source := source
    dest := dest
    // Check if texture is valid
    if (texture.id > 0)
    {
        width:f32  = cast(f32)texture.width
        height:f32  = cast(f32)texture.height

        flipX:bool = false
        if (source.width < 0) { flipX = true; source.width *= -1}
        if (source.height < 0) {source.y -= source.height}

        if (dest.width < 0) {dest.width *= -1}
        if (dest.height < 0) {dest.height *= -1}

        topLeft:rl.Vector2  = {0,0};
        topRight:rl.Vector2 = {0,0};
        bottomLeft:rl.Vector2 = {0,0};
        bottomRight:rl.Vector2 = {0,0};

        // Only calculate rotation if needed
        if (rotation == 0)
        {
            x:f32 = dest.x - origin.x
            y:f32 = dest.y - origin.y
            topLeft = { x, y }
            topRight = { x + dest.width, y }
            bottomLeft = { x, y + dest.height }
            bottomRight = { x + dest.width, y + dest.height }
        }
        else
        {
            sinRotation:f32 = math.sin(rotation*rl.DEG2RAD)
            cosRotation:f32 = math.cos(rotation*rl.DEG2RAD)
            x:f32 = dest.x;
            y:f32 = dest.y
            dx:f32 = -origin.x
            dy:f32 = -origin.y

            topLeft.x = x + dx*cosRotation - dy*sinRotation
            topLeft.y = y + dx*sinRotation + dy*cosRotation

            topRight.x = x + (dx + dest.width)*cosRotation - dy*sinRotation
            topRight.y = y + (dx + dest.width)*sinRotation + dy*cosRotation

            bottomLeft.x = x + dx*cosRotation - (dy + dest.height)*sinRotation
            bottomLeft.y = y + dx*sinRotation + (dy + dest.height)*cosRotation

            bottomRight.x = x + (dx + dest.width)*cosRotation - (dy + dest.height)*sinRotation
            bottomRight.y = y + (dx + dest.width)*sinRotation + (dy + dest.height)*cosRotation
        }

        rlgl.SetTexture(texture.id)
        // rlgl.SetTexture(0)
        rlgl.Begin(rlgl.QUADS)

        rlgl.Color4ub(tint.r, tint.g, tint.b, tint.a)
            rlgl.Normal3f(0.5, 0.5, 1.0)         
            rlgl.Normal3f(0.5, 0.5, 1.0)   
            rlgl.Normal3f(0.5, 0.5, 1.0)   
            rlgl.Normal3f(0.5, 0.5, 1.0)                    // Normal vector pointing towards viewer
        
            // Top-left corner for texture and quad
            if (flipX) {
                rlgl.TexCoord2f((source.x + source.width)/width, source.y/height)
            }
            else {
                rlgl.TexCoord2f(source.x/width, source.y/height)
                rlgl.Vertex2f(topLeft.x, topLeft.y)
            }

            // Bottom-left corner for texture and quad
            if (flipX) {
                rlgl.TexCoord2f((source.x + source.width)/width, (source.y + source.height)/height)
            }
            else {
                rlgl.TexCoord2f(source.x/width, (source.y + source.height)/height)
                rlgl.Vertex2f(bottomLeft.x, bottomLeft.y)
            }

            // Bottom-right corner for texture and quad
            if (flipX) {
                rlgl.TexCoord2f(source.x/width, (source.y + source.height)/height) 
            }
            else {
                rlgl.TexCoord2f((source.x + source.width)/width, (source.y + source.height)/height)
                rlgl.Vertex2f(bottomRight.x, bottomRight.y)
            }

            // Top-right corner for texture and quad
            if (flipX) {
                rlgl.TexCoord2f(source.x/width, source.y/height) 
            }
            else {
                rlgl.TexCoord2f((source.x + source.width)/width, source.y/height)
                rlgl.Vertex2f(topRight.x, topRight.y)
            }
        rlgl.End();
        rlgl.SetTexture(0);
        // rlgl.SetTexture(1);
    }
}