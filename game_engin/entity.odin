package game_engin

import rl "vendor:raylib"
import as "../assets"
import "core:fmt"
import "core:math"
import "core:math/rand"
import b2 "vendor:box2d"


stats :: struct{
    speed:f32
}
entity_s :: struct{
    pos:[2]f32,
    extent:[2]f32,
    sprite:sprite,
    light:light,
    body_id:b2.BodyId,
    shape_id:b2.ShapeId,
}
entity_d :: struct{
    pos:[2]f32,
    extent:[2]f32,
    sprite:sprite,
    light:light,
    stats_b:stats,
    body_id:b2.BodyId,
    shape_id:b2.ShapeId,
}

all_entity_s:[dynamic]entity_s
all_entity_d:[dynamic]entity_d

do_entitys::proc(){
    do_entitys_s()
    do_entitys_d()
}
do_entitys_s::proc(){
    for entity,i in all_entity_s{

        pos :b2.Vec2= b2.Body_GetWorldPoint(entity.body_id, -entity.extent)
        radians :f32= b2.Rot_GetAngle(b2.Body_GetRotation(entity.body_id))

        all_entity_s[i].sprite.frame_timer += rl.GetFrameTime()
        if as.textures[all_entity_s[i].sprite.texture_name].frames !=0 {
            for all_entity_s[i].sprite.frame_timer > cast(f32)as.textures[all_entity_s[i].sprite.texture_name].frame_rate {
                all_entity_s[i].sprite.frame_timer -= cast(f32)as.textures[all_entity_s[i].sprite.texture_name].frame_rate
                all_entity_s[i].sprite.curent_frame +=1
            }
            if all_entity_s[i].sprite.curent_frame+1 > as.textures[all_entity_s[i].sprite.texture_name].frames{
                all_entity_s[i].sprite.curent_frame = 0
            }
        }
        append(&sprite_rendering_q, &all_entity_s[i].sprite)
        append(&light_rendering_q, &all_entity_s[i].light)
    }
}
do_entitys_d::proc(){
    for entity,i in all_entity_d{
        pos :b2.Vec2= b2.Body_GetWorldPoint(entity.body_id, -entity.extent)
        pos_center := b2.Body_GetPosition(entity.body_id)
        radians :f32= b2.Rot_GetAngle(b2.Body_GetRotation(entity.body_id))

        all_entity_d[i].pos = pos
        all_entity_d[i].sprite.rec.x = pos.x
        all_entity_d[i].sprite.rec.y = pos.y
        all_entity_d[i].sprite.rotation = rl.RAD2DEG *radians
        all_entity_d[i].light.rect.x = pos_center.x 
        all_entity_d[i].light.rect.y = pos_center.y 
        all_entity_d[i].sprite.texture_name = as.texture_names.burning_loop_1

        all_entity_d[i].sprite.frame_timer += rl.GetFrameTime()
        if as.textures[all_entity_d[i].sprite.texture_name].frames !=0 {
            for all_entity_d[i].sprite.frame_timer > cast(f32)as.textures[all_entity_d[i].sprite.texture_name].frame_rate {
                all_entity_d[i].sprite.frame_timer -= cast(f32)as.textures[all_entity_d[i].sprite.texture_name].frame_rate
                all_entity_d[i].sprite.curent_frame +=1
            }
            if all_entity_d[i].sprite.curent_frame+1 > as.textures[all_entity_d[i].sprite.texture_name].frames{
                all_entity_d[i].sprite.curent_frame = 0
            }
        }
        append(&sprite_rendering_q, &all_entity_d[i].sprite)
        if all_entity_d[i].light.name != as.texture_names.none {append(&light_rendering_q, &all_entity_d[i].light)}
        
    }
}

create_simp_cube_entity::proc(pos:[2]f32, size:[2]f32){
    
    n_entity :entity_d
    
    body_def : b2.BodyDef = b2.DefaultBodyDef()
    body_def.type = .dynamicBody
    body_def.position = {pos.x+(size.x/2),pos.y+(size.y/2)}
    // body_def.rotation = b2.MakeRot(33)

    shape_def :b2.ShapeDef = b2.DefaultShapeDef()
    shape_def.density = 4.0
    shape_def.friction = 0.3
    shape_def.restitution = .3
    
    n_entity.pos = pos
    n_entity.body_id = b2.CreateBody(box_2d_world_id, body_def)
    n_entity.sprite.color = rl.Color{255,255,255,255}
    // n_entity.sprite.name= as.texture_names.burning_loop_1
    n_entity.sprite.texture_name = as.texture_names.burning_loop_1
    n_entity.sprite.rec = {pos.x,pos.y,size.x,size.y}
    n_entity.extent = size/2
    n_entity.light.color = rl.Color{255,0,255,155}
    n_entity.light.name = as.texture_names.bace_light
    n_entity.light.rect = {pos.x,pos.y,100,100}
    n_entity.light.bloom_size = 2
    n_entity.light.bloom_intensity = .1
    
    

    n_entity.shape_id = b2.CreatePolygonShape(n_entity.body_id, shape_def, b2.MakeBox(size.x/2, size.y/2))
    append(&all_entity_d, n_entity)
}