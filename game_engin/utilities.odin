package game_engin

import rl "vendor:raylib"
import fmt "core:fmt"
import as "../assets"
import "core:math"
import "core:thread"
import "core:os"
import "core:time"

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

}
every_1_2_s::proc(){
    // fmt.print(rl.GetTime()," one second has elapsed \n")
}
every_1_4_s::proc(){
    create_entity_by_id({0,0},entity_id.test,sprite_id.invalid,light_id.defalt)
    // fmt.print(rl.GetTime()," one second has elapsed \n")
}
every_1_8_s::proc(){
    // fmt.print(rl.GetTime()," one second has elapsed \n")
}
every_1_16_s::proc(){
    // create_simp_cube_entity({0,0},{32,32})

    // create_entity_by_id({0,0},entity_id.test,sprite_id.invalid,light_id.defalt)
    // fmt.print(rl.GetTime()," one second has elapsed \n")
    // sound:=rl.LoadSoundAlias(as.sounds[as.sound_names.eat])
    // rl.SetSoundPan(sound, 4)
    // rl.PlaySound(sound)
    //play_sound_at_pos(as.sound_names.s_paper_swipe,{0,0})
}

pool: thread.Pool
N :: 8

init_threads::proc(){
    thread.pool_init(&pool, allocator=context.allocator, thread_count=N)
    thread.pool_start(&pool)
}

cleanup_threds::proc(){
    thread.pool_finish(&pool)
    thread.pool_destroy(&pool)
}
thred_test::proc(t: thread.Task){
    fmt.print("this is a test \n")
}

safe_div :: proc(top, bottom: $T) -> T {
    if bottom == 0 {
        return 1
    }
    return top / bottom
}

key_info::struct{
    m_left_p:bool,
    m_right_p:bool,
    m_left_d:bool,
    m_right_d:bool,
}
key:key_info
manage_key_data::proc(){
    key.m_left_d = false
    key.m_right_d = false
    key.m_left_p = false
    key.m_right_p = false
    if rl.IsMouseButtonDown(rl.MouseButton.LEFT) {key.m_left_d = true}
    if rl.IsMouseButtonDown(rl.MouseButton.RIGHT) {key.m_right_d = true}
    if rl.IsMouseButtonPressed(rl.MouseButton.LEFT) {key.m_left_p = true}
    if rl.IsMouseButtonPressed(rl.MouseButton.RIGHT) {key.m_right_p = true}
}
