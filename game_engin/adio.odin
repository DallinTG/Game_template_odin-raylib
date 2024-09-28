package game_engin

import rl "vendor:raylib"
import fmt "core:fmt"
import as "../assets"
import "core:math"

sound_aliases:[dynamic]sound_byte

sound_byte::struct{
    pos:[2]f32,
    has_pos:bool,
    name:as.sound_names,
    sound:rl.Sound,
    intesity:f32,
}
defalt_sound_intesity:f32:5000

play_sound_at_pos::proc(s_name:as.sound_names,pos:[2]f32){
    cam := camera.target+{cast(f32)rl.GetScreenWidth()*2,cast(f32)rl.GetScreenHeight()*2}
    sound:=rl.LoadSoundAlias(as.sounds[s_name])
    rl.SetSoundPan(sound, math.lerp(cast(f32)1,cast(f32)0,cast(f32)(pos.x-cam.x+(defalt_sound_intesity/2))/defalt_sound_intesity))
    //fmt.print(math.lerp(cast(f32)1,cast(f32)0,cast(f32)(pos.x-cam.x+(defalt_sound_intesity/2))/defalt_sound_intesity),"  ")
    rl.SetSoundVolume(sound,math.clamp(math.abs(math.lerp(cast(f32)0,cast(f32)1,math.sqrt(math.pow_f32(cam.x-pos.x,2)+math.pow_f32(cam.y-pos.y,2))/defalt_sound_intesity)),0,1)*-1)
    //fmt.print(math.clamp(math.abs(math.lerp(cast(f32)0,cast(f32)1,math.sqrt(math.pow_f32(cam.x-pos.x,2)+math.pow_f32(cam.y-pos.y,2))/defalt_sound_intesity)),0,1)*-1,"   \n")


    rl.PlaySound(sound)
    s_bty:sound_byte
    s_bty.pos = pos
    s_bty.has_pos = true
    s_bty.sound = sound
    s_bty.intesity = defalt_sound_intesity
    append(&sound_aliases, s_bty)
    
}
manage_sound_bytes::proc(){
    cam := camera.target+{cast(f32)rl.GetScreenWidth()*2,cast(f32)rl.GetScreenHeight()*2}
    for sound_byte,i in sound_aliases{
        if rl.IsSoundPlaying(sound_byte.sound){
            if sound_byte.has_pos{
                rl.SetSoundPan(sound_byte.sound, math.lerp(cast(f32)1,cast(f32)0,cast(f32)(sound_byte.pos.x-cam.x+(defalt_sound_intesity/2))/defalt_sound_intesity))
                //fmt.print(math.lerp(cast(f32)1,cast(f32)0,cast(f32)(pos.x-cam.x+(defalt_sound_intesity/2))/defalt_sound_intesity),"  ")
                rl.SetSoundVolume(sound_byte.sound,math.clamp(math.abs(math.lerp(cast(f32)0,cast(f32)1,math.sqrt(math.pow_f32(cam.x-sound_byte.pos.x,2)+math.pow_f32(cam.y-sound_byte.pos.y,2))/defalt_sound_intesity)),0,1)*-1+1)
                //fmt.print(math.clamp(math.abs(math.lerp(cast(f32)0,cast(f32)1,math.sqrt(math.pow_f32(cam.x-pos.x,2)+math.pow_f32(cam.y-pos.y,2))/defalt_sound_intesity)),0,1)*-1+1,"   \n")
                
            }
        }else{
            rl.UnloadSoundAlias(sound_byte.sound)
            unordered_remove(&sound_aliases, i) 
        }
    }
}