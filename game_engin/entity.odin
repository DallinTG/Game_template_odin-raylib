package game_engin

import rl "vendor:raylib"
import as "../assets"
import "core:fmt"
import "core:math"
import "core:math/rand"

stats :: struct{
    speed:f32
}
entity_s :: struct{
    pos:[2]f32,
    sprite:sprite,
    light:light,
    hit_box:rl.Rectangle,
}
entity_d :: struct{
    pos:[2]f32,
    sprite:sprite,
    light:light,
    hit_box:rl.Rectangle,
    velocity:[2]f32,
    stats_b:stats,
}

all_entity_s:[dynamic]entity_s
all_entity_d:[dynamic]entity_d

do_entitys::proc(){
    do_entitys_s()
    do_entitys_d()
}
do_entitys_s::proc(){

}
do_entitys_d::proc(){

}