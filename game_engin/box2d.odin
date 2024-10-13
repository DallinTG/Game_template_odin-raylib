package game_engin

import rl "vendor:raylib"
import fmt "core:fmt"
import as "../assets"
import "core:math"
import b2 "vendor:box2d"

box_2d_world_id :b2.WorldId
world_grav:f32:9
time_step :f32= 1
sub_step_count :i32= 4

lengthUnitsPerMeter :f32: 128.0


init_box_2d::proc(){
    b2.SetLengthUnitsPerMeter(lengthUnitsPerMeter)

    box_2d_world_def :b2.WorldDef = b2.DefaultWorldDef()
    box_2d_world_def.gravity.y = world_grav * lengthUnitsPerMeter

    // box_2d_world_def.workerCount = 4;
    // box_2d_world_def.enqueueTask = myAddTaskFunction
    // box_2d_world_def.finishTask = myFinishTaskFunction
    // box_2d_world_def.userTaskContext = &myTaskSystem

    box_2d_world_id = b2.CreateWorld(box_2d_world_def)
}
sim_box_2d::proc(){
    b2.World_Step(box_2d_world_id, rl.GetFrameTime()*time_step, sub_step_count)
}
cleanup_box_2d::proc(){
    b2.DestroyWorld(box_2d_world_id)
}

create_static_tile::proc(pos:[2]i32) -> (body_id:b2.BodyId,shape_id:b2.ShapeId){
    body_def : b2.BodyDef = b2.DefaultBodyDef()
    body_def.type = .staticBody
    body_def.position = {cast(f32)pos.x*t_map_t_size+(cast(f32)t_map_t_size/2),cast(f32)pos.y*t_map_t_size+(cast(f32)t_map_t_size/2)}

    shape_def :b2.ShapeDef = b2.DefaultShapeDef()
    shape_def.density = 4.0
    shape_def.friction = 0.3
    shape_def.restitution = .3

    body_id = b2.CreateBody(box_2d_world_id, body_def)
    shape_id = b2.CreatePolygonShape(body_id, shape_def, b2.MakeBox(t_map_t_size/2, t_map_t_size/2))
    return body_id,shape_id
}