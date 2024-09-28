package game_engin

import rl "vendor:raylib"
import fmt "core:fmt"
import as "../assets"
import "core:math"


seconds_1:bool
seconds_1_2:bool
seconds_1_4:bool
seconds_1_8:bool
seconds_1_16:bool

time_q:f32
q_1_8:i32

get_time_util::proc(){
    time_q = time_q+rl.GetFrameTime()
    seconds_1 = false
    seconds_1_2 = false
    seconds_1_4 = false
    seconds_1_8 = false
    seconds_1_16 = false

    if time_q > 0.0625{
        time_q=time_q - 0.0625
        seconds_1_16 = true
        every_1_16_s()
        q_1_8 = q_1_8+1
        if q_1_8 % 2 == 0{
            seconds_1 = true
            every_1_8_s()
            if q_1_8 % 4 == 0{
                seconds_1_4 = true
                every_1_4_s()
                if q_1_8 % 8 == 0{
                    seconds_1_2 = true
                    every_1_2_s()
                    if q_1_8 % 16 == 0{
                        seconds_1 = true
                        every_1_s()
                    }
                }
            }
        }
    }
}

every_1_s::proc(){
    // fmt.print(rl.GetTime()," one second has elapsed \n")
}
every_1_2_s::proc(){
    // fmt.print(rl.GetTime()," one second has elapsed \n")
}
every_1_4_s::proc(){
    // fmt.print(rl.GetTime()," one second has elapsed \n")
}
every_1_8_s::proc(){
    // fmt.print(rl.GetTime()," one second has elapsed \n")
}
every_1_16_s::proc(){
    // fmt.print(rl.GetTime()," one second has elapsed \n")
    // sound:=rl.LoadSoundAlias(as.sounds[as.sound_names.eat])
    // rl.SetSoundPan(sound, 4)
    // rl.PlaySound(sound)
    play_sound_at_pos(as.sound_names.s_paper_swipe,{0,0})
}