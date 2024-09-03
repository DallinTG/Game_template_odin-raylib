package rendering

import "core:strings"
import "core:strconv"
import "core:fmt"
import "core:sort"
import "core:slice"
import as "../assets"
import rl "vendor:raylib"

bace_light:rl.Color= {0,0,0,0}
bace_dark:rl.Color= {0,0,20,200}

do_lighting::proc(){
    rl.SetShaderValueTexture(as.shader_test,rl.GetShaderLocation(as.shader_test, "lights"), light_mask.texture)
    rl.SetShaderValueTexture(as.shader_test,rl.GetShaderLocation(as.shader_test, "darknes"), dark_mask.texture)
    rl.BeginShaderMode(as.shader_test)
    rl.DrawTextureRec(dark_mask.texture, {0,0,cast(f32)dark_mask.texture.width,cast(f32)dark_mask.texture.height*-1},{0,0},rl.WHITE)
    rl.EndShaderMode()
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
