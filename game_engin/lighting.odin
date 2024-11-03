package game_engin

import "core:strings"
import "core:strconv"
import "core:fmt"
import "core:sort"
import "core:slice"
import as "../assets"
import rl "vendor:raylib"
test:f32:7
bace_light:rl.Color= {0,0,0,0}
bace_dark:rl.Color= {0,0,20,200}
max_light_c::4000
light_bucket::struct{
    data:[max_light_c]light_data,
    next_open_slot:int,
    last_light:int,
}
light_data::struct{
    light:light,
    is_occupied:bool,
    gen:int,
}
light::struct{
    rect:rl.Rectangle,
    color:rl.Color,
    name:as.texture_names,
    rot:f32,
    origin:[2]f32,
    bloom_size:f32,
    bloom_intensity:f32,
}
light_index::struct{
    id:int,
    gen:int,
}
light_id::enum{
    none,
    defalt,
    invalid,
    test,
}
simple_light::struct{
    pos:[2]f32,
    size:f32,
    color:rl.Color,
}

light_buffer:=make([dynamic]light)
all_lights:=new(light_bucket)
defalt_lights:[light_id]light
init_defalt_light_data::proc(){
    defalt_lights[.none]={
        origin = {0,0},
        color = {255,255,255,255},
        name = .none,

    }
    defalt_lights[.defalt]={
        origin = {0,0},
        color = {255,255,255,255},
        name = .bace_light,
        rect = {0,0,100,100},
        bloom_size = 2,
        bloom_intensity = .1
    }
    defalt_lights[.invalid]={
        origin = {0,0},
        color = {255,255,255,255},
        name = .test,
        rect = {0,0,100,100},
        bloom_size = 2,
        bloom_intensity = .1
    }
    defalt_lights[.test]={
        origin = {0,0},
        color = {255,255,255,255},
        name = .test,
        rect = {0,0,100,100},
        bloom_size = 2,
        bloom_intensity = .1
    }
}


// all_lights:=make([1000]light)
do_all_lights::proc(){
    rl.BeginTextureMode(light_mask)
    rl.BeginBlendMode(rl.BlendMode.ALPHA_PREMULTIPLY)  
    for &light_data, i in all_lights.data[:all_lights.last_light+1] {
        if light_data.is_occupied{
            draw_light(&light_data.light)
        }
    }
    draw_all_particles_light()
    rl.EndBlendMode()
    rl.EndTextureMode()

    rl.BeginTextureMode(bloom_mask)
    rl.BeginBlendMode(rl.BlendMode.ADDITIVE)  
    for &light_data, i in all_lights.data[:all_lights.last_light+1] {
        if light_data.is_occupied{
            draw_bloom(&light_data.light)
            // fmt.print(light_data.light.rect,"\n")
        }
    }
    draw_all_particles_bloom()
    rl.EndBlendMode()
    rl.EndTextureMode()


    if all_lights.last_light != 0 {
        for !all_lights.data[all_lights.last_light].is_occupied{
            all_lights.last_light -= 1
        }
    }
}
create_light::proc(light:light)->(light_id:light_index){
    all_lights.data[all_lights.next_open_slot].light = light
    all_lights.data[all_lights.next_open_slot].is_occupied = true
    all_lights.data[all_lights.next_open_slot].gen += 1
    light_id = {id = all_lights.next_open_slot,gen = all_lights.data[all_lights.next_open_slot].gen}
    if all_lights.next_open_slot != max_light_c-1{
        all_lights.next_open_slot += 1
        for all_lights.data[all_lights.next_open_slot].is_occupied{
            if all_lights.next_open_slot != max_light_c-1{
                all_lights.next_open_slot += 1
            }else { break }
        }
    }

    if all_lights.last_light != max_light_c-1 {
        for all_lights.data[all_lights.last_light].is_occupied{
            if all_lights.last_light != max_light_c-1{
                all_lights.last_light += 1
            }else{break}
        }
    }
    return light_id
}
delete_light::proc(light_id:light_index){
    if all_lights.data[light_id.id].gen == light_id.gen{
        all_lights.data[light_id.id].is_occupied=false
        if light_id.id < all_lights.next_open_slot{
            all_lights.next_open_slot = light_id.id 
        }
        if light_id.id == all_lights.last_light {
            if all_lights.last_light != 0 {
                all_lights.last_light -= 1
                for !all_lights.data[all_lights.last_light].is_occupied{
                    all_lights.last_light -= 1
                }
            }
        }
    }

}

// render_light_q::proc(){
//     for light, i in light_buffer {
//         append(&light_rendering_q, &light_buffer[i])
//     }

//     for light, i in temp_light_buffer {
//         append(&light_rendering_q, &temp_light_buffer[i])
//     }
//     clear(&temp_light_buffer)

//     for light, i in light_rendering_q {
//         draw_light(light)
//     }
//     // clear(&light_rendering_q)
// }

// render_bloom_q::proc(){
//     for light, i in light_rendering_q {
//         draw_bloom(light)
//     }
//     // clear(&light_rendering_q)
// }

// do_lightting::proc(){
//     rl.BeginTextureMode(light_mask)
//     rl.BeginBlendMode(rl.BlendMode.ALPHA_PREMULTIPLY)  
//     render_light_q()
//     draw_all_particles_light()
//     rl.EndBlendMode()
//     rl.EndTextureMode()

//     do_bloom()
//     clear(&light_rendering_q)
// }
// do_bloom::proc(){
//     rl.BeginTextureMode(bloom_mask)
//     rl.BeginBlendMode(rl.BlendMode.ADDITIVE)  
//     render_bloom_q()
//     draw_all_particles_bloom()
//     rl.EndBlendMode()
//     rl.EndTextureMode()
// }




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

// draw_particle_mask::proc(){

    // rl.SetShaderValueTexture(as.shader_test,rl.GetShaderLocation(as.shader_test, "lights"), bloom_mask.texture)
    // rl.SetShaderValueTexture(as.shader_test,rl.GetShaderLocation(as.shader_test, "darknes"), dark_mask.texture)
    // rl.BeginShaderMode(as.shader_test)
    // rl.BeginBlendMode(rl.BlendMode.ADDITIVE)  
    // cord := this_frame_camera_target
    // rl.DrawTexturePro(particle_mask.texture,{0,0,cast(f32)particle_mask.texture.width,cast(f32)particle_mask.texture.height * -1},{cord.x, cord.y, cast(f32)particle_mask.texture.width / camera.zoom,cast(f32)particle_mask.texture.height / camera.zoom},{0,0},0,rl.WHITE)
    // rl.EndBlendMode()
    // rl.EndShaderMode()
// }

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
    // fmt.print(x,y,"\n")
    draw_texture(light.name ,rl.Rectangle{x-(light.rect.width) * camera.zoom,y-(light.rect.height) * camera.zoom,light.rect.width * camera.zoom,light.rect.height * camera.zoom} , {(light.rect.width*-1/2) * camera.zoom,(light.rect.height*-1/2) * camera.zoom},light.rot,light.color )
}

draw_bloom::proc(light:^light){
    vec2:=rl.GetWorldToScreen2D({light.rect.x,light.rect.y},camera)
    x:=vec2.x
    y:=vec2.y
    draw_texture(light.name ,rl.Rectangle{x-(light.rect.width*light.bloom_size) * camera.zoom,y-(light.rect.height*light.bloom_size) * camera.zoom,(light.rect.width*light.bloom_size) * camera.zoom,(light.rect.height*light.bloom_size) * camera.zoom} , {((light.rect.width*light.bloom_size)*-1/2) * camera.zoom,((light.rect.height*light.bloom_size)*-1/2) * camera.zoom},light.rot,rl.ColorAlpha(light.color, light.bloom_intensity) )
}



