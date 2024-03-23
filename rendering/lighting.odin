package rendering

import "core:strings"
import "core:strconv"
import "core:fmt"
import "core:sort"
import "core:slice"
import as "../assets"
import rl "vendor:raylib"

light_mask:rl.RenderTexture
light_mask_f:rl.RenderTexture
screane_Width:i32 = 0
screane_height:i32 = 0
world_light:rl.Vector4 = {0,0,0.1,0.3}
world_light_color:rl.Color = {0,0,0,150}

maintane_light_mask::proc(){
    if screane_Width != rl.GetScreenWidth() || screane_height != rl.GetScreenHeight() {
        light_mask = rl.LoadRenderTexture(rl.GetScreenWidth(), rl.GetScreenHeight())
        light_mask_f = rl.LoadRenderTexture(rl.GetScreenWidth(), rl.GetScreenHeight())
        screane_Width=rl.GetScreenWidth()
        screane_height=rl.GetScreenHeight()
    }
    rl.BeginTextureMode(light_mask)
    rl.ClearBackground({0,0,0,0})
    rl.EndTextureMode()

    rl.BeginTextureMode(light_mask_f)
    rl.ClearBackground({0,0,0,0})
    rl.EndTextureMode()

}

do_lighting::proc(camera:rl.Camera2D){
    pos:=rl.GetWorldToScreen2D({0,0},camera)
    
    rl.SetShaderValue(as.shader_test, rl.GetShaderLocation(as.shader_test, "world_light"), &world_light, rl.ShaderUniformDataType.VEC4)
    rl.SetShaderValue(as.shader_test, rl.GetShaderLocation(as.shader_test, "lights"), &light_mask.texture, rl.ShaderUniformDataType.SAMPLER2D)
    rl.BeginShaderMode(as.shader_test)
    rl.DrawTextureRec(light_mask.texture, {0,0,cast(f32)light_mask.texture.width,cast(f32)light_mask.texture.height*-1},{0,0},rl.WHITE)
    rl.EndShaderMode()
}

draw_simple_light::proc(pos:rl.Vector2,camera:rl.Camera2D){
    vec2:=rl.GetWorldToScreen2D(pos,camera)
    x:=vec2.x
    y:=vec2.y
    rl.DrawCircleGradient(cast(i32)x, cast(i32)y, 500, {255,255,0,255}, {255,255,0,0})

    

}
