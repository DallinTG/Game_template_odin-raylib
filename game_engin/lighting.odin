package game_engin

import "core:strings"
import "core:strconv"
import "core:fmt"
import "core:sort"
import "core:slice"
import as "../assets"
import rl "vendor:raylib"

bace_light:rl.Color= {0,0,0,0}
bace_dark:rl.Color= {0,0,20,200}
light::struct{
    rect:rl.Rectangle,
    color:rl.Color,
    name:as.texture_names,
    rot:f32,
    origin:[2]f32,
    bloom_size:f32,
    bloom_intensity:f32,

}
simple_light::struct{
    pos:[2]f32,
    size:f32,
    color:rl.Color,
}
light_rendering_q:=make([dynamic]^light)
temp_light_buffer:=make([dynamic]light)
light_buffer:=make([dynamic]light)


render_light_q::proc(){
    for light, i in light_buffer {
        append(&light_rendering_q, &light_buffer[i])
    }

    for light, i in temp_light_buffer {
        append(&light_rendering_q, &temp_light_buffer[i])
    }
    clear(&temp_light_buffer)

    for light, i in light_rendering_q {
        draw_light(light)
    }
    // clear(&light_rendering_q)
}

render_bloom_q::proc(){
    for light, i in light_rendering_q {
        draw_bloom(light)
    }
    // clear(&light_rendering_q)
}

do_lightting::proc(){
    maintane_masks()
    //fmt.print("\n\n",light_rendering_q,"\n\n")
    rl.BeginTextureMode(light_mask)
    rl.BeginBlendMode(rl.BlendMode.ALPHA_PREMULTIPLY)  
    render_light_q()
    calculate_particles_light()
    // draw_simple_light({50,50},50)
    // draw_simple_light({150,150},50)
    // draw_simple_light({300,300},50)
    rl.EndBlendMode()
    rl.EndTextureMode()

    do_bloom()
    clear(&light_rendering_q)
}
do_bloom::proc(){
    rl.BeginTextureMode(bloom_mask)
    rl.BeginBlendMode(rl.BlendMode.ALPHA_PREMULTIPLY)  
    render_bloom_q()
    calculate_particles_bloom()
    // draw_simple_light({50,50},500)
    // draw_simple_light({150,150},500)
    // draw_simple_light({300,300},500)
    rl.EndBlendMode()
    rl.EndTextureMode()
}




draw_lighting_mask::proc(){
    // screen_width:=rl.GetScreenWidth() 
    // screen_height:=rl.GetScreenHeight()

    rl.SetShaderValueTexture(as.shader_test,rl.GetShaderLocation(as.shader_test, "lights"), light_mask.texture)
    rl.SetShaderValueTexture(as.shader_test,rl.GetShaderLocation(as.shader_test, "darknes"), dark_mask.texture)
    rl.BeginShaderMode(as.shader_test)
    //rl.DrawTextureRec(dark_mask.texture, {0,0,cast(f32)dark_mask.texture.width,cast(f32)dark_mask.texture.height*-1},{0,0},rl.WHITE)
    cord := this_frame_camera_target
    rl.DrawTexturePro(dark_mask.texture,{0,0,cast(f32)dark_mask.texture.width,cast(f32)dark_mask.texture.height * -1},{cord.x, cord.y, cast(f32)dark_mask.texture.width / camera.zoom,cast(f32)dark_mask.texture.height / camera.zoom},{0,0},0,rl.WHITE)
    rl.EndShaderMode()
}
draw_bloom_mask::proc(){

    // rl.SetShaderValueTexture(as.shader_test,rl.GetShaderLocation(as.shader_test, "lights"), bloom_mask.texture)
    // rl.SetShaderValueTexture(as.shader_test,rl.GetShaderLocation(as.shader_test, "darknes"), dark_mask.texture)
    // rl.BeginShaderMode(as.shader_test)
    rl.BeginBlendMode(rl.BlendMode.ADDITIVE)  
    cord := this_frame_camera_target
    rl.DrawTexturePro(bloom_mask.texture,{0,0,cast(f32)bloom_mask.texture.width,cast(f32)bloom_mask.texture.height * -1},{cord.x, cord.y, cast(f32)bloom_mask.texture.width / camera.zoom,cast(f32)bloom_mask.texture.height / camera.zoom},{0,0},0,rl.WHITE)
    rl.EndBlendMode()
    // rl.EndShaderMode()
}

draw_simple_light::proc(pos:rl.Vector2,size:f32){
    vec2:=rl.GetWorldToScreen2D(pos,camera)
    x:=vec2.x
    y:=vec2.y
    draw_texture(as.texture_names.bace_light ,rl.Rectangle{x-(size) * camera.zoom,y-(size) * camera.zoom,size * camera.zoom,size * camera.zoom} , {(size*-1/2) * camera.zoom,(size*-1/2) * camera.zoom} )
}

draw_colored_light::proc(pos:rl.Vector2,size:f32,color:rl.Color){
    vec2:=rl.GetWorldToScreen2D(pos,camera)
    x:=vec2.x
    y:=vec2.y
    draw_texture(as.texture_names.bace_light ,rl.Rectangle{x-(size) * camera.zoom,y-(size) * camera.zoom,size * camera.zoom,size * camera.zoom} , {(size*-1/2) * camera.zoom,(size*-1/2) * camera.zoom},0,color )
}
draw_colored_bloom::proc(pos:rl.Vector2,size:f32,color:rl.Color){
    vec2:=rl.GetWorldToScreen2D(pos,camera)
    x:=vec2.x
    y:=vec2.y
    draw_texture(as.texture_names.bace_light ,rl.Rectangle{x-(size) * camera.zoom,y-(size) * camera.zoom,size * camera.zoom,size * camera.zoom} , {(size*-1/2) * camera.zoom,(size*-1/2) * camera.zoom},0,color )
}



draw_light::proc(light:^light){
    vec2:=rl.GetWorldToScreen2D({light.rect.x,light.rect.y},camera)
    x:=vec2.x
    y:=vec2.y
    draw_texture(light.name ,rl.Rectangle{x-(light.rect.width) * camera.zoom,y-(light.rect.height) * camera.zoom,light.rect.width * camera.zoom,light.rect.height * camera.zoom} , {(light.rect.width*-1/2) * camera.zoom,(light.rect.height*-1/2) * camera.zoom},light.rot,light.color )
}

draw_bloom::proc(light:^light){
    vec2:=rl.GetWorldToScreen2D({light.rect.x,light.rect.y},camera)
    x:=vec2.x
    y:=vec2.y
    draw_texture(light.name ,rl.Rectangle{x-(light.rect.width*light.bloom_size) * camera.zoom,y-(light.rect.height*light.bloom_size) * camera.zoom,(light.rect.width*light.bloom_size) * camera.zoom,(light.rect.height*light.bloom_size) * camera.zoom} , {((light.rect.width*light.bloom_size)*-1/2) * camera.zoom,((light.rect.height*light.bloom_size)*-1/2) * camera.zoom},light.rot,rl.ColorAlpha(light.color, light.bloom_intensity) )
}
