package game_engin

import "core:fmt"
import as "../assets"
import rl "vendor:raylib"
import "core:slice"

settings::struct{
    video:settings_video,
    adio:settings_adio,
}
settings_video::struct{
    show_fps:bool,
}
settings_adio::struct{
    maine_volume:f32,
    game_volume:f32,
    music_volume:f32,
    ui_volume:f32,
}
settings_game :settings

init_settings::proc(){
    settings_game.adio.game_volume=1
    settings_game.adio.maine_volume=1
    settings_game.adio.music_volume=1
    settings_game.adio.ui_volume=1

    settings_game.video.show_fps=true
}
save_settings::proc(){

}
