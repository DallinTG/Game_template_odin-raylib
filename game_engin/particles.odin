package game_engin

import rl "vendor:raylib"
import as "../assets"
import "core:fmt"
import "core:math"
import "core:math/rand"
import "core:thread"

particle :: struct{
    xy: rl.Vector2,
    life: f32,
    velocity: rl.Vector2,
    curent_frame:int,
    frame_timer:f32,
    id:particle_id,
    rand_id:particle_id,
    seed:f32,
    max_life: f32,
}
particle_data :: struct{
    acceleration: rl.Vector2,
    grav: rl.Vector2,
    angle_s: f32,
    angle_e: f32,
    size_s: rl.Vector2,
    size_e: rl.Vector2,
    color_s:[4]f32,
    color_e:[4]f32,
    texture_name:as.texture_names,
    // frames_per_second:int,
    is_light:bool,

    light_size_s:f32,
    light_size_e:f32,
    light_size_c:f32,

    light_shift_size_s:f32,
    light_shift_size_e:f32,
    light_shift_size_c:f32,

    light_color_1_s:[4]f32,
    light_color_1_e:[4]f32,
    light_color_1_c:f32,

    light_color_2_s:[4]f32,
    light_color_2_e:[4]f32,
    light_color_2_c:f32,

    light_color_3_s:[4]f32,
    light_color_3_e:[4]f32,
    light_color_3_c:f32,

    bloom_size_s:f32,
    bloom_size_e:f32,
    bloom_size_c:f32,

    bloom_shift_size_s:f32,
    bloom_shift_size_e:f32,
    bloom_shift_size_c:f32,

    bloom_intensity_s:f32,
    bloom_intensity_e:f32,
    bloom_intensity_c:f32,

    bloom_shift_intensity_s:f32,
    bloom_shift_intensity_e:f32,
    bloom_shift_intensity_c:f32,
}
particle_id::enum{
    none,
    test,
    confety,
    fiyer,
}
p_time:f32
defalt_p_data:[particle_id]particle_data 
rand_p_data:[particle_id]particle_data 
max_particles:: 2000
all_particles:=new(#soa[max_particles]particle)
particle_count: int = 0
shader: rl.Shader
init_defalt_particle_data::proc(){
    defalt_p_data[.test]={
        acceleration= rl.Vector2{0,0},
        grav= rl.Vector2{0,800},
        angle_s= 0,
        angle_e= 720,
        size_s= rl.Vector2{100,100},
        size_e= rl.Vector2{0,0},
        color_s=[4]f32{1,1,0,1},
        color_e=[4]f32{1,0,1,1},
        texture_name=as.texture_names.electrum_ingot,
        // frames_per_second=.4,

        is_light=true,
        light_size_s=200,
        light_size_e=0,
        light_size_c=12,

        light_shift_size_s=20,
        light_shift_size_e=0,
        light_shift_size_c=12,

        light_color_1_s=[4]f32{0,0,0,.5},
        light_color_1_e=[4]f32{0,.5,0,.5},
        light_color_1_c=90,

        light_color_2_s=[4]f32{.5,.5,0,.5},
        light_color_2_e=[4]f32{0,0,.5,.5},
        light_color_2_c=7,

        light_color_3_s=[4]f32{0,0,.5,.5},
        light_color_3_e=[4]f32{.5,0,0,.5},
        light_color_3_c=13,

        bloom_size_s=200,
        bloom_size_e=0,
        bloom_size_c=9,

        bloom_shift_size_s=20,
        bloom_shift_size_e=0,
        bloom_shift_size_c=5,

        bloom_intensity_s=.2,
        bloom_intensity_e=0,
        bloom_intensity_c=3,

        bloom_shift_intensity_s=.2,
        bloom_shift_intensity_e=0,
        bloom_shift_intensity_c=20,
    }
}

calculate_particles::proc(){
    p_time = p_time+rl.GetFrameTime()
    if p_time>.01667 {
        delta :f32= p_time
        p_time = 0
        if particle_count > 0{
            #reverse for &particle, i in all_particles[0 : particle_count] {
                all_particles[i].life -= delta
                all_particles[i].frame_timer += delta
                if as.textures[defalt_p_data[particle.id].texture_name].frames !=0 {
                    for all_particles[i].frame_timer > cast(f32)as.textures[defalt_p_data[particle.id].texture_name].frame_rate {
                        all_particles[i].frame_timer -= cast(f32)as.textures[defalt_p_data[particle.id].texture_name].frame_rate
                        all_particles[i].curent_frame +=1
                    }
                    if all_particles[i].curent_frame+1 > as.textures[defalt_p_data[particle.id].texture_name].frames{
                        all_particles[i].curent_frame = 0
                    }
                }
                p_kinematics(i,delta)
                if particle.life < 0{
                    all_particles[i] = all_particles[particle_count-1]
                    particle_count -=1
                }
                // draw_particle(all_particles[i])
                
            }
        }
        // draw_all_particle()
    }
}
// calculate_particles::proc(){
//     // thread.pool_add_task(&pool, allocator=context.allocator, procedure=calculate_particles_thred, data=nil, user_index=1)
// }
draw_all_particle::proc(){
    // rl.BeginTextureMode(particle_mask)
    if particle_count > 0{
        #reverse for &particle, i in all_particles[0 : particle_count] {
            draw_particle(particle)
        }
    }
    // rl.EndTextureMode()
}
// defalt_p_data[particle.id]
draw_all_particles_light::proc(){
#reverse for &particle, i in all_particles[0 : particle_count] { 
    color := calc_particale_color(particle)
        size := math.lerp(
            defalt_p_data[particle.id].light_size_e,
            defalt_p_data[particle.id].light_size_s,
            (math.cos_f32((particle.life/particle.max_life * math.PI * defalt_p_data[particle.id].light_size_c - math.PI)) + 1) / 2) +
                math.lerp(
                    defalt_p_data[particle.id].light_shift_size_e,
                    defalt_p_data[particle.id].light_shift_size_s,
                    (math.cos_f32((particle.life / particle.max_life * math.PI * defalt_p_data[particle.id].light_shift_size_c - math.PI)) + 1) / 2)
        draw_colored_light(all_particles[i].xy,size,color)     
    }
}

draw_all_particles_bloom::proc(){

    #reverse for &particle, i in all_particles[0 : particle_count] {
        color := rl.ColorAlpha(calc_particale_color(particle),
        math.lerp(
            defalt_p_data[particle.id].bloom_intensity_e,
            defalt_p_data[particle.id].bloom_intensity_s,
            (math.cos_f32((particle.life / particle.max_life * math.PI * defalt_p_data[particle.id].bloom_intensity_c - math.PI)) + 1) / 2) +
                math.lerp(
                    defalt_p_data[particle.id].bloom_shift_intensity_e,
                    defalt_p_data[particle.id].bloom_shift_intensity_s,
                    (math.cos_f32((particle.life / particle.max_life * math.PI * defalt_p_data[particle.id].bloom_shift_intensity_c- math.PI)) + 1) / 2))
        size :=  math.lerp(
            defalt_p_data[particle.id].bloom_size_e,
            defalt_p_data[particle.id].bloom_size_s,
            math.cos_f32((particle.life / particle.max_life * math.PI * defalt_p_data[particle.id].bloom_size_c - math.PI)) + 1) / 2+
                math.lerp(
                    defalt_p_data[particle.id].bloom_shift_size_e,
                    defalt_p_data[particle.id].bloom_shift_size_s,
                    math.cos_f32((particle.life / particle.max_life * math.PI * defalt_p_data[particle.id].bloom_shift_size_c - math.PI)) + 1) / 2
        draw_colored_bloom(all_particles[i].xy,size,color)
    }
}
calc_particale_color::proc(particle:particle)->(color:rl.Color){
    color = rl.ColorFromNormalized(
        math.lerp(
            defalt_p_data[particle.id].light_color_1_e,
            defalt_p_data[particle.id].light_color_1_s,
            (math.cos_f32((particle.life / particle.max_life * math.PI * defalt_p_data[particle.id].light_color_1_c - math.PI)) + 1) / 2) +
            math.lerp(
                defalt_p_data[particle.id].light_color_2_e,
                defalt_p_data[particle.id].light_color_2_s,
                (math.cos_f32((particle.life / particle.max_life * math.PI * defalt_p_data[particle.id].light_color_2_c - math.PI)) + 1) / 2) +
                math.lerp(
                    defalt_p_data[particle.id].light_color_3_e,
                    defalt_p_data[particle.id].light_color_3_s,
                    (math.cos_f32((particle.life / particle.max_life * math.PI * defalt_p_data[particle.id].light_color_3_c - math.PI)) + 1) / 2) / 2 )
    return color
}

spawn_particle::proc(particle: particle){
    if particle_count < max_particles {
        all_particles[particle_count] = particle
        particle_count += 1
    }
}

draw_particle::proc(particle: particle){
    // vec2:=rl.GetWorldToScreen2D(particle.xy ,camera)
    vec2:=particle.xy
    x:=vec2.x
    y:=vec2.y

    size :=  math.lerp(defalt_p_data[particle.id].size_e,defalt_p_data[particle.id].size_s,cast(f32)particle.life/particle.max_life)
    angle := math.lerp(defalt_p_data[particle.id].angle_e,defalt_p_data[particle.id].angle_s,cast(f32)particle.life/particle.max_life)
    color := rl.ColorFromNormalized(math.lerp(defalt_p_data[particle.id].color_e,defalt_p_data[particle.id].color_s,cast(f32)particle.life/particle.max_life))
//camra is biult in to this one
    // draw_texture(particle.texture.name,rl.Rectangle{x,y,size.x * camera.zoom,size.y * camera.zoom},size/2 * camera.zoom, angle, color,particle.texture.curent_frame)
    draw_texture(defalt_p_data[particle.id].texture_name,rl.Rectangle{x,y,size.x,size.y},size/2, angle, color,particle.curent_frame)
}


p_kinematics::proc(i: int, del:f32){
    p:= all_particles[i]
    all_particles[i].velocity +=(defalt_p_data[p.id].acceleration+defalt_p_data[p.id].grav)*del
    all_particles[i].xy += (p.velocity*(del))
}

//do_particle_mask::proc(){
//    rl.DrawTextureRec(Particle_mask.texture, {0,0,cast(f32)Particle_mask.texture.width,cast(f32)Particle_mask.texture.height*-1},{0,0},rl.WHITE)
//}
// rand_mix_p_all::proc(particle_1:particle, particle_2:particle) -> particle {
//     particle:particle=particle_1
//     //angle
//     particle.angle_e = rand.float32_range(particle_1.angle_e,particle_2.angle_e)
//     particle.angle_s = rand.float32_range(particle_1.angle_s,particle_2.angle_s)
//     //color
//     particle.color_e.r = rand.float32_range(particle_1.color_e.r,particle_2.color_e.r)
//     particle.color_e.g = rand.float32_range(particle_1.color_e.g,particle_2.color_e.g)
//     particle.color_e.b = rand.float32_range(particle_1.color_e.b,particle_2.color_e.b)
//     particle.color_e.a = rand.float32_range(particle_1.color_e.a,particle_2.color_e.a)
//     particle.color_s.r = rand.float32_range(particle_1.color_s.r,particle_2.color_s.r)
//     particle.color_s.g = rand.float32_range(particle_1.color_s.g,particle_2.color_s.g)
//     particle.color_s.b = rand.float32_range(particle_1.color_s.b,particle_2.color_s.b)
//     particle.color_s.a = rand.float32_range(particle_1.color_s.a,particle_2.color_s.a)
//     //grav
//     particle.grav.x = rand.float32_range(particle_1.grav.x,particle_2.grav.x)
//     particle.grav.y = rand.float32_range(particle_1.grav.y,particle_2.grav.y)
//     //velocity
//     particle.velocity.x = rand.float32_range(particle_1.velocity.x,particle_2.velocity.x)
//     particle.velocity.y = rand.float32_range(particle_1.velocity.y,particle_2.velocity.y)
//     //acceloration
//     particle.acceleration.x = rand.float32_range(particle_1.acceleration.x,particle_2.acceleration.x)
//     particle.acceleration.y = rand.float32_range(particle_1.acceleration.y,particle_2.acceleration.y)
//     //life
//     particle.life = rand.float32_range(particle_1.life,particle_2.life)
//     particle.max_life = rand.float32_range(particle_1.max_life,particle_2.max_life)
//     //size
//     particle.size_e.x = rand.float32_range(particle_1.size_e.x,particle_2.size_e.x)
//     particle.size_e.y = rand.float32_range(particle_1.size_e.y,particle_2.size_e.y)
//     particle.size_s.x = rand.float32_range(particle_1.size_s.x,particle_2.size_s.x)
//     particle.size_s.y = rand.float32_range(particle_1.size_s.y,particle_2.size_s.y)
//     //xy
//     particle.xy.x = rand.float32_range(particle_1.xy.x,particle_2.xy.x)
//     particle.xy.y = rand.float32_range(particle_1.xy.y,particle_2.xy.y)
//     //light size
//     particle.light_size_e = rand.float32_range(particle_1.light_size_e,particle_2.light_size_e)
//     particle.light_size_s = rand.float32_range(particle_1.light_size_s,particle_2.light_size_s)
//     //light color
//     particle.light_color_e.r = rand.float32_range(particle_1.light_color_e.r,particle_2.light_color_e.r)
//     particle.light_color_e.g = rand.float32_range(particle_1.light_color_e.g,particle_2.light_color_e.g)
//     particle.light_color_e.b = rand.float32_range(particle_1.light_color_e.b,particle_2.light_color_e.b)
//     particle.light_color_e.a = rand.float32_range(particle_1.light_color_e.a,particle_2.light_color_e.a)
//     particle.light_color_s.r = rand.float32_range(particle_1.light_color_s.r,particle_2.light_color_s.r)
//     particle.light_color_s.b = rand.float32_range(particle_1.light_color_s.b,particle_2.light_color_s.b)
//     particle.light_color_s.g = rand.float32_range(particle_1.light_color_s.g,particle_2.light_color_s.g)
//     particle.light_color_s.a = rand.float32_range(particle_1.light_color_s.a,particle_2.light_color_s.a)

//     return Particle
// }

// gen_p_confetti::proc(xy_1:rl.Vector2) -> particle{
//     confetti_1 :Particle= {xy=xy_1, life=4.50,max_life=4.50, velocity={-400,-400},acceleration={-100,-100},angle_s= -720,angle_e= -720,grav={0,-300}, size_s={-100,-50},size_e={-100,-50}, color_s={0,0,0,1}, color_e={0,0,0,0},texture_name=as.texture_names.square,frames_per_second=1,is_light=true,light_size_s=200,light_size_e=0,light_color_s={1,0,0,1},light_color_e={1,0,0,0},bloom_size_s=.2,bloom_intensity_s=.2,bloom_size_e=0,bloom_intensity_e=0}
//     confetti_2 :Particle= {xy=xy_1, life=4.50,max_life=4.50, velocity={400,400},acceleration={100,100},angle_s= 720,angle_e= 720,grav={0,-300}, size_s={100,50},size_e={100,50}, color_s={1,1,1,1}, color_e={1,1,1,0},texture_name=as.texture_names.square,frames_per_second=1,is_light=true,light_size_s=200,light_size_e=0,light_color_s={1,0,0,1},light_color_e={1,0,0,0},bloom_size_s=.2,bloom_intensity_s=.2,bloom_size_e=0,bloom_intensity_e=0}
//     return rand_mix_p_all(confetti_1,confetti_2)
// }