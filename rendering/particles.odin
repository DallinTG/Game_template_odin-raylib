package rendering

import rl "vendor:raylib"
import as "../assets"
import "core:fmt"
import "core:math"




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
    
}

max_particles:: 10000
all_particles:#soa[max_particles]Particle
particle_count: int = 0
shader: rl.Shader


calculate_particles::proc(){
    delta :f32= rl.GetFrameTime()
    if particle_count > 0{
        particles: #soa[]Particle = all_particles[0 : particle_count]
        #reverse for particle, i in particles {
            all_particles[i].life -= delta
            all_particles[i].texture.frame_timer += delta
            for all_particles[i].texture.frame_timer > cast(f32)all_particles[i].texture.frame_rate {
                all_particles[i].texture.frame_timer -= cast(f32)all_particles[i].texture.frame_rate
                all_particles[i].texture.curent_frame +=1
            }
            
            //fmt.print(all_particles[i].texture.curent_frame)
            if all_particles[i].texture.curent_frame+1 > all_particles[i].texture.frames{
                all_particles[i].texture.curent_frame = 0
            }
            p_kinematics(i,delta)
            if particle.life < 0{
                all_particles[i] = all_particles[particle_count-1]
                particle_count -=1
            }
            draw_particle(all_particles[i])
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
    size :=  math.lerp(particle.size_e,particle.size_s,cast(f32)particle.life/particle.max_life)
    angle := math.lerp(particle.angle_e,particle.angle_s,cast(f32)particle.life/particle.max_life)
    as.draw_texture(particle.texture.name, {particle.xy.x,particle.xy.y,size.x,size.y}, size/2, angle, rl.ColorFromNormalized(math.lerp(particle.color_e,particle.color_s,cast(f32)particle.life/particle.max_life)),particle.texture.curent_frame)
}


p_kinematics::proc(i: int, del:f32){
    p:= all_particles[i]
    all_particles[i].velocity +=(p.acceleration+p.grav)*((del)*(del))
    all_particles[i].xy += (p.velocity*(del))
}