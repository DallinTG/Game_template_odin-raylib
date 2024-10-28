package game_engin

import rl "vendor:raylib"
import as "../assets"
import "core:fmt"
import "core:math"
// import "core:math/rand"
import b2 "vendor:box2d"

stats :: struct{
    speed:f32
}
// entity_s :: struct{
//     pos:[2]f32,
//     extent:[2]f32,
//     body_id:b2.BodyId,
//     shape_id:b2.ShapeId,
//     data:entity_data,
// }
entity :: struct{
    pos:[2]f32,
    extent:[2]f32,
    body_id:b2.BodyId,
    shape_id:b2.ShapeId,
    data:entity_data,
}

// all_entity_s:[dynamic]entity
all_entitys:[dynamic]entity
all_defalt_entitys:[entity_id]entity

entity_id::enum{
    none,
    test,
}
entity_type::union{
    et_bace,
}
et_bace::struct{
    stats_b:stats,
}
entity_data::struct{
    sprite:sprite,
    light:light,
    color:rl.Color,
    entity_type:entity_type,
    body_type:b2.BodyType,
    density :f32,
    friction :f32,
    restitution :f32,
}

init_all_entity_data::proc(){

    all_defalt_entitys[entity_id.none]={
        data={
            sprite={},     
            color = {255,255,255,255},
            entity_type = et_bace{},
        },
        
    }
    all_defalt_entitys[entity_id.test]={
        data={
            sprite={
                rec={0,0,16,16},
                data=dfalt_sprite_data[.invalid]
            },    
            density =4,
            friction =.4,
            restitution=.3,
            body_type=b2.BodyType.dynamicBody,
            color = {255,255,255,255},
            entity_type = et_bace{},
        },
        extent={16/2,16/2},
        
    }
}




do_entitys::proc(){
    // do_entitys_s()
    do_entitys_d()
}
// do_entitys_s::proc(){
//     for entity,i in all_entity_s{

//         pos :b2.Vec2= b2.Body_GetWorldPoint(entity.body_id, -entity.extent)
//         radians :f32= b2.Rot_GetAngle(b2.Body_GetRotation(entity.body_id))

//         all_entity_s[i].data.sprite.frame_timer += rl.GetFrameTime()
//         if as.textures[all_entity_s[i].data.sprite.data.texture_name].frames !=0 {
//             for all_entity_s[i].data.sprite.frame_timer > cast(f32)as.textures[all_entity_s[i].data.sprite.data.texture_name].frame_rate {
//                 all_entity_s[i].data.sprite.frame_timer -= cast(f32)as.textures[all_entity_s[i].data.sprite.data.texture_name].frame_rate
//                 all_entity_s[i].data.sprite.curent_frame +=1
//             }
//             if all_entity_s[i].data.sprite.curent_frame+1 > as.textures[all_entity_s[i].data.sprite.data.texture_name].frames{
//                 all_entity_s[i].data.sprite.curent_frame = 0
//             }
//         }
//         append(&sprite_rendering_q, &all_entity_s[i].data.sprite)
//         append(&light_rendering_q, &all_entity_s[i].data.light)
//     }
// }
do_entitys_d::proc(){
    for entity,i in all_entitys{
        pos :b2.Vec2= b2.Body_GetWorldPoint(entity.body_id, -entity.extent)
        pos_center := b2.Body_GetPosition(entity.body_id)
        radians :f32= b2.Rot_GetAngle(b2.Body_GetRotation(entity.body_id))

        all_entitys[i].pos = pos
        all_entitys[i].data.sprite.rec.x = pos.x
        all_entitys[i].data.sprite.rec.y = pos.y
        all_entitys[i].data.sprite.rotation = rl.RAD2DEG *radians
        all_entitys[i].data.light.rect.x = pos_center.x 
        all_entitys[i].data.light.rect.y = pos_center.y 

        all_entitys[i].data.sprite.frame_timer += rl.GetFrameTime()
        if as.textures[all_entitys[i].data.sprite.data.texture_name].frames !=0 {
            for all_entitys[i].data.sprite.frame_timer > cast(f32)as.textures[all_entitys[i].data.sprite.data.texture_name].frame_rate {
                all_entitys[i].data.sprite.frame_timer -= cast(f32)as.textures[all_entitys[i].data.sprite.data.texture_name].frame_rate
                all_entitys[i].data.sprite.curent_frame +=1
            }
            if all_entitys[i].data.sprite.curent_frame+1 > as.textures[all_entitys[i].data.sprite.data.texture_name].frames{
                all_entitys[i].data.sprite.curent_frame = 0
            }
        }
        append(&sprite_rendering_q, &all_entitys[i].data.sprite)
        if all_entitys[i].data.light.name != as.texture_names.none {append(&light_rendering_q, &all_entitys[i].data.light)}
        
    }
}
create_entity_by_id::proc(pos:[2]f32,entity_id:entity_id ){
    n_entity :entity = all_defalt_entitys[entity_id]
    
    body_def : b2.BodyDef = b2.DefaultBodyDef()
    body_def.type = n_entity.data.body_type
    body_def.position = {pos.x+(n_entity.extent.x),pos.y+(n_entity.extent.y)}
    // body_def.rotation = b2.MakeRot(rl.RAD2DEG * 180)
    shape_def :b2.ShapeDef = b2.DefaultShapeDef()
    shape_def.density = n_entity.data.density
    shape_def.friction = n_entity.data.friction
    shape_def.restitution = n_entity.data.restitution
    
    n_entity.pos = pos
    n_entity.body_id = b2.CreateBody(box_2d_world_id, body_def)
    // n_entity.data.sprite.data.color = rl.Color{255,255,255,255}

    n_entity.shape_id = b2.CreatePolygonShape(n_entity.body_id, shape_def, b2.MakeBox(n_entity.extent.x, n_entity.extent.y))
    // n_entity.shape_id = b2.CreatePolygonShape(n_entity.body_id, shape_def, b2.MakePolygon(b2.ComputeHull({{0,0},{20,-20,},{100,100}}),16))
    append(&all_entitys, n_entity)
}

create_simp_cube_entity::proc(pos:[2]f32, size:[2]f32){
    
    n_entity :entity
    
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
    n_entity.data.sprite.data.color = rl.Color{255,255,255,255}
    // n_entity.sprite.name= as.texture_names.burning_loop_1
    n_entity.data.sprite.data.texture_name = as.texture_names.burning_loop_1
    n_entity.data.sprite.rec = {pos.x,pos.y,size.x,size.y}
    n_entity.extent = size/2
    n_entity.data.light.color = rl.Color{255,0,255,155}
    n_entity.data.light.name = as.texture_names.bace_light
    n_entity.data.light.rect = {pos.x,pos.y,100,100}
    n_entity.data.light.bloom_size = 2
    n_entity.data.light.bloom_intensity = .1
    
    

    n_entity.shape_id = b2.CreatePolygonShape(n_entity.body_id, shape_def, b2.MakeBox(size.x/2, size.y/2))
    append(&all_entitys, n_entity)
}
