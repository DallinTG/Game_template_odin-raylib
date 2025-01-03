package game_engin

import rl "vendor:raylib"
import as "../assets"
import "core:fmt"
import "core:math"
// import "core:math/rand"
import b2 "vendor:box2d"

max_entity_c::4000
stats :: struct{
    speed:f32
}
entity :: struct{
    entity_index:entity_index,
    pos:[2]f32,
    entity_type:entity_type,
    body_id:b2.BodyId,
    shape_id:b2.ShapeId,
    light_id:light_index,
    sprite_id:sprite_index,
}
entity_bucket::struct{
    data:[max_entity_c]entity_data,
    next_open_slot:int,
    last_entity:int,
    count:int,
}
entity_data::struct{
    entity:entity,
    is_occupied:bool,
    gen:int,
}

// all_entity_s:[dynamic]entity
all_entitys:entity_bucket
defalt_entitys:[entity_id]defalt_entity

entity_index::struct{
    id:int,
    gen:int,
}
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
box_2d_body::struct{
    extent:[2]f32,
    density:f32,
    friction:f32,
    restitution:f32,
    body_type:b2.BodyType,
}
defalt_entity::struct{
    entity:entity,
    body:box_2d_body,
}

init_defalt_entity_data::proc(){

    defalt_entitys[entity_id.none]={
        entity = {
            entity_type = et_bace{},
        },
        
    }
    defalt_entitys[entity_id.test]={
        entity = {
            entity_type = et_bace{},
        },
        body = {
            extent= {16/2,16/2},
            density =4,
            friction =.4,
            restitution=.3,
            body_type=b2.BodyType.dynamicBody,
        }
    }
}

// do_entitys::proc(){
//     do_entitys_d()
// }
// loops all entitys then will do logic
do_entitys::proc(){
if all_entitys.count > 0 {
    for &entity_data,i in all_entitys.data[:all_entitys.last_entity+1]{
        if entity_data.is_occupied {
        pos :b2.Vec2= b2.Body_GetWorldPoint(entity_data.entity.body_id,{all_sprites.data[entity_data.entity.sprite_id.id].sprite.rec.x,all_sprites.data[entity_data.entity.sprite_id.id].sprite.rec.y})
        pos_center := b2.Body_GetPosition(entity_data.entity.body_id)
        radians :f32= b2.Rot_GetAngle(b2.Body_GetRotation(entity_data.entity.body_id))

        
        all_lights.data[entity_data.entity.light_id.id].light.rect.x = pos_center.x 
        all_lights.data[entity_data.entity.light_id.id].light.rect.y = pos_center.y 

        entity_data.entity.pos = pos_center

        if all_sprites.data[entity_data.entity.sprite_id.id].gen == entity_data.entity.sprite_id.gen{

            all_sprites.data[entity_data.entity.sprite_id.id].sprite.pos.x = pos.x
            all_sprites.data[entity_data.entity.sprite_id.id].sprite.pos.y = pos.y
            all_sprites.data[entity_data.entity.sprite_id.id].sprite.rotation = rl.RAD2DEG *radians


            all_sprites.data[entity_data.entity.sprite_id.id].sprite.frame_timer += rl.GetFrameTime()
            if as.textures[all_sprites.data[entity_data.entity.sprite_id.id].sprite.texture_name].frames !=0 {
                for all_sprites.data[entity_data.entity.sprite_id.id].sprite.frame_timer > cast(f32)as.textures[ all_sprites.data[entity_data.entity.sprite_id.id].sprite.texture_name].frame_rate {
                    all_sprites.data[entity_data.entity.sprite_id.id].sprite.frame_timer -= cast(f32)as.textures[ all_sprites.data[entity_data.entity.sprite_id.id].sprite.texture_name].frame_rate
                    all_sprites.data[entity_data.entity.sprite_id.id].sprite.curent_frame +=1
                }
                if all_sprites.data[entity_data.entity.sprite_id.id].sprite.curent_frame+1 > as.textures[all_sprites.data[entity_data.entity.sprite_id.id].sprite.texture_name].frames{
                    all_sprites.data[entity_data.entity.sprite_id.id].sprite.curent_frame = 0
                }
            }
        }
        }
        // append(&sprite_rendering_q, &entity.data.sprite)       
    }
}
}
// }
create_entity_by_id::proc(pos:[2]f32,entity_id:entity_id,sprite_id:sprite_id,light_id:light_id ){
    if all_entitys.count < max_entity_c {
    n_entity :entity = defalt_entitys[entity_id].entity
    
    
    body_def : b2.BodyDef = b2.DefaultBodyDef()
    body_def.type = defalt_entitys[entity_id].body.body_type
    body_def.position = {pos.x,pos.y}
    // body_def.rotation = b2.MakeRot(rl.RAD2DEG * 180)
    shape_def :b2.ShapeDef = b2.DefaultShapeDef()
    shape_def.density = defalt_entitys[entity_id].body.density
    shape_def.friction = defalt_entitys[entity_id].body.friction
    shape_def.restitution = defalt_entitys[entity_id].body.restitution
    
    n_entity.pos = pos
    n_entity.body_id = b2.CreateBody(box_2d_world_id, body_def)
    n_entity.shape_id = b2.CreatePolygonShape(n_entity.body_id, shape_def, b2.MakeBox(defalt_entitys[entity_id].body.extent.x, defalt_entitys[entity_id].body.extent.y))
    entity_id := create_entity(n_entity)
    if entity_id.id > -1 {
       all_entitys.data[entity_id.id].entity.sprite_id = create_sprite(sprite = defalt_sprite_data[sprite_id])
       all_entitys.data[entity_id.id].entity.light_id = create_light(defalt_lights[light_id])
    }
    }
    // append(&all_entitys, n_entity)
}

create_entity::proc(entity:entity)->(entity_id:entity_index){
    if !all_entitys.data[all_entitys.next_open_slot].is_occupied{
        all_entitys.count +=1
        all_entitys.data[all_entitys.next_open_slot].entity = entity
        all_entitys.data[all_entitys.next_open_slot].is_occupied = true
        // all_entitys.data[all_entitys.next_open_slot].gen += 1
        entity_id = {id = all_entitys.next_open_slot,gen = all_entitys.data[all_entitys.next_open_slot].gen}
        all_entitys.data[all_entitys.next_open_slot].entity.entity_index = entity_id
        if all_entitys.next_open_slot != max_entity_c-1{
            all_entitys.next_open_slot += 1
            for all_entitys.data[all_entitys.next_open_slot].is_occupied{
                if all_entitys.next_open_slot != max_entity_c-1{
                    all_entitys.next_open_slot += 1
                }else { break }
            }
        }

        if all_entitys.last_entity != max_entity_c-1 {
            for all_entitys.data[all_entitys.last_entity].is_occupied{
                if all_entitys.last_entity != max_entity_c-1{
                    all_entitys.last_entity += 1
                }else{break}
            }
        }    
        return entity_id
    }
    entity_id = {-1,-1}
    return entity_id
}
delete_entity::proc(entity_id:entity_index){
    
    if all_entitys.data[entity_id.id].gen == entity_id.gen&& all_entitys.data[entity_id.id].is_occupied{
        all_entitys.count -=1
        all_entitys.data[entity_id.id].is_occupied=false
        all_entitys.data[all_entitys.next_open_slot].gen += 1
        delete_sprite(all_entitys.data[entity_id.id].entity.sprite_id)
        delete_light(all_entitys.data[entity_id.id].entity.light_id)
        if b2.Body_IsValid(all_entitys.data[entity_id.id].entity.body_id){
            b2.DestroyBody(all_entitys.data[entity_id.id].entity.body_id)
        }
        if entity_id.id < all_entitys.next_open_slot{
            all_entitys.next_open_slot = entity_id.id 
        }
        if entity_id.id == all_entitys.last_entity {
            if all_entitys.last_entity != 0 {
                all_entitys.last_entity -= 1
                for !all_entitys.data[all_entitys.last_entity].is_occupied{
                    all_entitys.last_entity -= 1
                }
            }
        }
    }
}

dos_entity_exist::proc(entity_id:entity_index)->bool{
    if all_entitys.data[entity_id.id].gen == entity_id.gen&& all_entitys.data[entity_id.id].is_occupied{
        return true
    }
    return false
}

get_entity_by_index::proc(entity_id:entity_index) -> (entity:^entity){
    if dos_entity_exist(entity_id) {
        // success = true
        entity = &all_entitys.data[entity_id.id].entity
        return
    }
    // success = false
    entity = nil
    return
}

