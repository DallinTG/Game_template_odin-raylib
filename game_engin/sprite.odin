package game_engin

import "core:fmt"
import as "../assets"
import rl "vendor:raylib"
import "core:slice"


max_sprite_c::4000
sprite_bucket::struct{
    data:[max_sprite_c]sprite_data,
    next_open_slot:int,
    last_sprite:int,
    count:int,
}
sprite::struct {
    z:f32,
    rotation:f32,
    curent_frame:int,
    frame_timer:f32,
    pos:[2]f32,
    rec:rl.Rectangle,
    origin:rl.Vector2,
    color:rl.Color,
    texture_name:as.texture_names,
    frames_per_second:int,
}
sprite_data::struct{
    sprite:sprite,
    is_occupied:bool,
    gen:int,
}
sprite_index::struct{
    id:int,
    gen:int,
}
sprite_id::enum{
    none,
    invalid,
}
defalt_sprite_data:[sprite_id]sprite
sprite_rendering_q:=make([dynamic]int)
all_sprites:=new(sprite_bucket)

init_defalt_sprite_data::proc(){
    defalt_sprite_data[.none]={
        z = 0,
        pos = {0,0},
        origin = {0,0},
        rec = {0,0,0,0},
        rotation = 0,
        color = {255,255,255,255},
        texture_name = .none,
        frames_per_second = 0,
    }
    defalt_sprite_data[.invalid]={
        z = 0,
        pos = {0,0},
        origin = {16/2,16/2},
        rotation = 0,
        rec = {0,0,16,16},
        color = {255,255,255,255},
        texture_name = .test,
        frames_per_second = 0
    }
}

draw_all_sprites::proc(){
    for &sprite_info, i in all_sprites.data[:all_sprites.last_sprite+1] {
        if sprite_info.is_occupied{
            append(&sprite_rendering_q, i)
        }
    }
    
    slice.sort_by(sprite_rendering_q[:],sort_by_z_index)
    sort_by_z_index::proc(sprite_1: int,sprite_2: int)->(bool){
        return all_sprites.data[sprite_1].sprite.z < all_sprites.data[sprite_2].sprite.z
    }

    for &id, i in sprite_rendering_q[:] {
        if all_sprites.data[id].is_occupied{
            draw_sprite(all_sprites.data[id].sprite)
        }
    }

    clear(&sprite_rendering_q)

    // if all_sprites.last_sprite != 0 {
    //     for !all_sprites.data[all_sprites.last_sprite].is_occupied{
    //         all_sprites.last_sprite -= 1
    //     }
    // }
}

create_sprite::proc(sprite:sprite)->(sprite_id:sprite_index){
    if !all_sprites.data[all_sprites.next_open_slot].is_occupied{
        all_sprites.data[all_sprites.next_open_slot].sprite = sprite
        all_sprites.data[all_sprites.next_open_slot].is_occupied = true
        all_sprites.count +=1
        all_sprites.data[all_sprites.next_open_slot].gen += 1
        sprite_id = {id = all_sprites.next_open_slot,gen = all_sprites.data[all_sprites.next_open_slot].gen}
        if all_sprites.next_open_slot != max_sprite_c-1{
            all_sprites.next_open_slot += 1
            for all_sprites.data[all_sprites.next_open_slot].is_occupied{
                if all_sprites.next_open_slot != max_sprite_c-1{
                    all_sprites.next_open_slot += 1
                }else { break }
            }
        }

        if all_sprites.last_sprite != max_sprite_c-1 {
            for all_sprites.data[all_sprites.last_sprite].is_occupied{
                if all_sprites.last_sprite != max_sprite_c-1{
                    all_sprites.last_sprite += 1
                }else{break}
            }
        }
    return sprite_id
    }
    sprite_id = {-1,-1}
    return sprite_id
}

delete_sprite::proc(sprite_id:sprite_index){
    if all_sprites.data[sprite_id.id].gen == sprite_id.gen && all_sprites.data[sprite_id.id].is_occupied{
        all_sprites.count -=1
        all_sprites.data[sprite_id.id].is_occupied=false
        if sprite_id.id < all_sprites.next_open_slot{
            all_sprites.next_open_slot = sprite_id.id 
        }
        if sprite_id.id == all_sprites.last_sprite {
            if all_sprites.last_sprite != 0 {
                all_sprites.last_sprite -= 1
                for !all_sprites.data[all_sprites.last_sprite].is_occupied{
                    all_sprites.last_sprite -= 1
                }
            }
        }
    }

}

draw_sprite::proc(sprite:sprite){
    draw_texture(
        name = sprite.texture_name,
        rec = {
            sprite.rec.x+sprite.pos.x,
            sprite.rec.y+sprite.pos.y,
            sprite.rec.width,
            sprite.rec.height
        },
        origin = sprite.origin,
        rotation = sprite.rotation,
        color = sprite.color,
         frame_index =sprite.curent_frame
        )
}