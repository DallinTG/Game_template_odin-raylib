package game_engin

import rl "vendor:raylib"
import as "../assets"
import "core:fmt"
import "core:math"
import "core:math/rand"

Particle :: struct{
    xy: rl.Vector2,
    life: f32,
    max_life: f32,
    velocity: rl.Vector2,
    acceleration: rl.Vector2,
    angle_s: f32,
    angle_e: f32,
    grav: rl.Vector2,
    size_s: rl.Vector2,
    size_e: rl.Vector2,
    color_s:[4]f32,
    color_e:[4]f32,
    texture: as.textur_info,
    frames_per_second:int,
    is_light:bool,
    light_size_s:f32,
    light_size_e:f32,
    light_color_s:[4]f32,
    light_color_e:[4]f32,
    bloom_size_s:f32,
    bloom_intensity_s:f32,
    bloom_size_e:f32,
    bloom_intensity_e:f32,
}

max_particles:: 2000
all_particles:=new(#soa[max_particles]Particle)
particle_count: int = 0
shader: rl.Shader

calculate_particles::proc(){
    delta :f32= rl.GetFrameTime()
    //rl.BeginTextureMode(Particle_mask)
    //rl.BeginDrawing()
    //rl.ClearBackground({0,0,0,0})
    if particle_count > 0{
        particles: #soa[]Particle = all_particles[0 : particle_count]
        #reverse for particle, i in particles {
            all_particles[i].life -= delta
            all_particles[i].texture.frame_timer += delta
            if all_particles[i].texture.frames !=0 {
                for all_particles[i].texture.frame_timer > cast(f32)all_particles[i].texture.frame_rate {
                    all_particles[i].texture.frame_timer -= cast(f32)all_particles[i].texture.frame_rate
                    all_particles[i].texture.curent_frame +=1
                }
                
                //fmt.print(all_particles[i].texture.curent_frame)
                if all_particles[i].texture.curent_frame+1 > all_particles[i].texture.frames{
                    all_particles[i].texture.curent_frame = 0
                }
            }
            p_kinematics(i,delta)
            if particle.life < 0{
                all_particles[i] = all_particles[particle_count-1]
                particle_count -=1
            }
            draw_particle(all_particles[i])
        }
    }
   // rl.EndTextureMode()
    //rl.EndDrawing()
}
calculate_particles_light::proc(){
    particles: #soa[]Particle = all_particles[0 : particle_count]
        #reverse for particle, i in particles {
            if all_particles[i].is_light{   
                color := rl.ColorFromNormalized(math.lerp(particle.light_color_e,particle.light_color_s,cast(f32)particle.life/particle.max_life))
                size :=  math.lerp(particle.light_size_e,particle.light_size_s,cast(f32)particle.life/particle.max_life)
                draw_colored_light(all_particles[i].xy,size,color)
        }
    }
}
calculate_particles_bloom::proc(){
    particles: #soa[]Particle = all_particles[0 : particle_count]
        #reverse for particle, i in particles {
            if all_particles[i].is_light{   
                color := rl.ColorAlpha(rl.ColorFromNormalized(math.lerp(particle.light_color_e,particle.light_color_s,cast(f32)particle.life/particle.max_life)),math.lerp(particle.bloom_intensity_e,particle.bloom_intensity_s,cast(f32)particle.life/particle.max_life))
                size :=  math.lerp(particle.light_size_e,particle.light_size_s,cast(f32)particle.life/particle.max_life)*math.lerp(particle.bloom_size_e,particle.bloom_size_s,cast(f32)particle.life/particle.max_life)
                draw_colored_bloom(all_particles[i].xy,size,color)
        }
    }
}


spawn_particle::proc(particle: Particle){
    if particle_count < max_particles {
        all_particles[particle_count] = particle
        particle_count += 1
    }
}

draw_particle::proc(particle: Particle){
    // vec2:=rl.GetWorldToScreen2D(particle.xy ,camera)
    vec2:=particle.xy
    x:=vec2.x
    y:=vec2.y

    size :=  math.lerp(particle.size_e,particle.size_s,cast(f32)particle.life/particle.max_life)
    angle := math.lerp(particle.angle_e,particle.angle_s,cast(f32)particle.life/particle.max_life)
    color := rl.ColorFromNormalized(math.lerp(particle.color_e,particle.color_s,cast(f32)particle.life/particle.max_life))
//camra is biult in to this one
    //draw_texture(particle.texture.name,rl.Rectangle{x,y,size.x * camera.zoom,size.y * camera.zoom},size/2 * camera.zoom, angle, color,particle.texture.curent_frame)
    draw_texture(particle.texture.name,rl.Rectangle{x,y,size.x,size.y},size/2, angle, color,particle.texture.curent_frame)
}


p_kinematics::proc(i: int, del:f32){
    p:= all_particles[i]
    all_particles[i].velocity +=(p.acceleration+p.grav)*((del)*(del))
    all_particles[i].xy += (p.velocity*(del))
}

//do_particle_mask::proc(){
//    rl.DrawTextureRec(Particle_mask.texture, {0,0,cast(f32)Particle_mask.texture.width,cast(f32)Particle_mask.texture.height*-1},{0,0},rl.WHITE)
//}
rand_mix_p_all::proc(particle_1:Particle, particle_2:Particle) -> Particle {
    Particle:Particle=particle_1
    //angle
    Particle.angle_e = rand.float32_range(particle_1.angle_e,particle_2.angle_e)
    Particle.angle_s = rand.float32_range(particle_1.angle_s,particle_2.angle_s)
    //color
    Particle.color_e.r = rand.float32_range(particle_1.color_e.r,particle_2.color_e.r)
    Particle.color_e.g = rand.float32_range(particle_1.color_e.g,particle_2.color_e.g)
    Particle.color_e.b = rand.float32_range(particle_1.color_e.b,particle_2.color_e.b)
    Particle.color_e.a = rand.float32_range(particle_1.color_e.a,particle_2.color_e.a)
    Particle.color_s.r = rand.float32_range(particle_1.color_s.r,particle_2.color_s.r)
    Particle.color_s.g = rand.float32_range(particle_1.color_s.g,particle_2.color_s.g)
    Particle.color_s.b = rand.float32_range(particle_1.color_s.b,particle_2.color_s.b)
    Particle.color_s.a = rand.float32_range(particle_1.color_s.a,particle_2.color_s.a)
    //grav
    Particle.grav.x = rand.float32_range(particle_1.grav.x,particle_2.grav.x)
    Particle.grav.y = rand.float32_range(particle_1.grav.y,particle_2.grav.y)
    //velocity
    Particle.velocity.x = rand.float32_range(particle_1.velocity.x,particle_2.velocity.x)
    Particle.velocity.y = rand.float32_range(particle_1.velocity.y,particle_2.velocity.y)
    //acceloration
    Particle.acceleration.x = rand.float32_range(particle_1.acceleration.x,particle_2.acceleration.x)
    Particle.acceleration.y = rand.float32_range(particle_1.acceleration.y,particle_2.acceleration.y)
    //life
    Particle.life = rand.float32_range(particle_1.life,particle_2.life)
    Particle.max_life = rand.float32_range(particle_1.max_life,particle_2.max_life)
    //size
    Particle.size_e.x = rand.float32_range(particle_1.size_e.x,particle_2.size_e.x)
    Particle.size_e.y = rand.float32_range(particle_1.size_e.y,particle_2.size_e.y)
    Particle.size_s.x = rand.float32_range(particle_1.size_s.x,particle_2.size_s.x)
    Particle.size_s.y = rand.float32_range(particle_1.size_s.y,particle_2.size_s.y)
    //xy
    Particle.xy.x = rand.float32_range(particle_1.xy.x,particle_2.xy.x)
    Particle.xy.y = rand.float32_range(particle_1.xy.y,particle_2.xy.y)
    //light size
    Particle.light_size_e = rand.float32_range(particle_1.light_size_e,particle_2.light_size_e)
    Particle.light_size_s = rand.float32_range(particle_1.light_size_s,particle_2.light_size_s)
    //light color
    Particle.light_color_e.r = rand.float32_range(particle_1.light_color_e.r,particle_2.light_color_e.r)
    Particle.light_color_e.g = rand.float32_range(particle_1.light_color_e.g,particle_2.light_color_e.g)
    Particle.light_color_e.b = rand.float32_range(particle_1.light_color_e.b,particle_2.light_color_e.b)
    Particle.light_color_e.a = rand.float32_range(particle_1.light_color_e.a,particle_2.light_color_e.a)
    Particle.light_color_s.r = rand.float32_range(particle_1.light_color_s.r,particle_2.light_color_s.r)
    Particle.light_color_s.b = rand.float32_range(particle_1.light_color_s.b,particle_2.light_color_s.b)
    Particle.light_color_s.g = rand.float32_range(particle_1.light_color_s.g,particle_2.light_color_s.g)
    Particle.light_color_s.a = rand.float32_range(particle_1.light_color_s.a,particle_2.light_color_s.a)

    return Particle
}

gen_p_confetti::proc(xy_1:rl.Vector2) -> Particle{
    confetti_1 :Particle= {xy_1, 4.50,4.50, {-400,-400},{-100,-100},-720,-720,{0,-300}, {-100,-50},{-100,-50}, {0,0,0,1}, {0,0,0,0},as.textures[as.texture_names.square],1,true,200,0,{1,0,0,1},{1,0,0,0},.5,.2,0,0}
    confetti_2 :Particle= {xy_1, 4.50,4.50, {400,400},{100,100},720,720,{0,-300}, {100,50},{100,50}, {1,1,1,1}, {1,1,1,0},as.textures[as.texture_names.square],1,true,200,0,{1,0,0,1},{1,0,0,0},.5,.2,0,0}
    return rand_mix_p_all(confetti_1,confetti_2)
}