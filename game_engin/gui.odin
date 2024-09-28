package game_engin

import rl "vendor:raylib"
import fmt "core:fmt"
import as "../assets"
import "core:math"

gui_grab_h :f32 : 25
pading:f32:4

init_gui :: proc (){
    
}
checking_guis::proc(){
    check_editer_mode()
    if rl.IsKeyPressed(.ESCAPE){
        menu_show = !menu_show 
        menu_panel.pos.x = cast(f32)rl.GetScreenWidth()/2  - menu_panel.w_h.x/2
        menu_panel.pos.y = cast(f32)rl.GetScreenHeight()/2 - menu_panel.w_h.y/2
    }
}

editor_show : bool 
editor_panel :gui_panel = {{10,10},{317,400},25,"Editor",false}
editor_curent_page : i32
editer_spinner:gui_spinner = {{editer_icon_pading,26},{-editer_icon_pading-editer_icon_pading,30},1,1,""}
editer_spinner_mode : bool
editer_exit_button:gui_button = {{editor_panel.w_h.x-22,2},{20,20},"X"}
editer_icon_button:gui_button = {{editer_icon_pading,editer_spinner.pos_offset.y+editer_spinner.w_h_offset.y+editer_icon_pading},{20,20},"X"}
editer_icon_size:f32:33 
editer_icon_pading:f32:2


do_ui_t_editor :: proc(){
    if editer_mode {
        if editor_show{
            render_gui_panel(&editor_panel)  // maine panel everything is relitive to this
            render_gui_spinner(&editor_panel,&editer_spinner,&editor_curent_page,&editer_spinner_mode)  // Gui page tab
            render_gui_textur_icons(editer_icon_button.pos_offset.x,editer_icon_button.pos_offset.y,0,0)                                          
            if render_gui_button(&editor_panel,&editer_exit_button) {editor_show = false}               // X button
        }
    }
}

menu_show : bool
menu_panel :gui_panel = {{10,cast(f32)rl.GetScreenHeight()/2},{317,400},25,"Menu",false}
menu_exit_button:gui_button = {{menu_panel.w_h.x-22,2},{20,20},"X"}
menu_exit_to_desktop_button:gui_button = {{pading,pading+25},{menu_panel.w_h.x-pading-pading,30},"Exit To Desktop"}
do_ui_menu :: proc(){
    if menu_show{
        render_gui_panel(&menu_panel)  // maine panel everything is relitive to this                                        
        if render_gui_button(&menu_panel,&menu_exit_button) {menu_show = false}               // X button
        if render_gui_button(&menu_panel,&menu_exit_to_desktop_button) {window_should_close = true}
    }
}


render_gui_textur_icons::proc(shrink_l_x:f32,shrink_u_y:f32,shrink_r_x:f32,shrink_b_y:f32){
    width := editor_panel.w_h.x - editer_icon_pading-shrink_r_x-shrink_l_x+editer_icon_pading
    hight := editor_panel.w_h.y - shrink_b_y-shrink_u_y
    pos_x := shrink_l_x
    pos_y := shrink_u_y
    slot_by_x:= cast(i32)math.floor(width / (editer_icon_size + editer_icon_pading))
    slot_by_y:= cast(i32)math.floor(hight / (editer_icon_size + editer_icon_pading))

    editer_spinner.max_page = math.abs(cast(i32)math.ceil_f32(cast(f32)len(as.textures)/ cast(f32)(slot_by_x * slot_by_y)))

    index:i32=0
    button :gui_button={{0,0},{editer_icon_size,editer_icon_size}," "}
    for textur_info in as.textures{
        page_index := index % ((slot_by_x * slot_by_y))
        button.pos_offset ={ cast(f32)(page_index % slot_by_x)*(editer_icon_size+editer_icon_pading)+pos_x, cast(f32)(page_index / slot_by_x)*(editer_icon_size+editer_icon_pading)+pos_y}
        if index > ((slot_by_x * slot_by_y)*(editor_curent_page-1)-1)&&index < ((slot_by_x * slot_by_y)*(editor_curent_page)){
            button_c :bool
            if render_gui_button_textur(&editor_panel,&button,textur_info.name) {button_c = true} 
            if button_c{
                curent_brush_textur = textur_info.name
            }
        }
        index = index+1
    } 
}

gui_panel::struct {
    pos:[2]f32,
    w_h:[2]f32,
    nav_bar_size:f32,
    name:cstring,
    nav_bar_moving:bool
}

render_gui_panel :: proc(gui_panel:^gui_panel){
    if rl.IsMouseButtonPressed(.LEFT)||gui_panel.nav_bar_moving {
        mouse_pos := rl.GetMousePosition()
        if gui_panel.nav_bar_moving {
            gui_panel.pos = gui_panel.pos+rl.GetMouseDelta()
        }else{
            if mouse_pos.x > gui_panel.pos.x && mouse_pos.x < gui_panel.pos.x + gui_panel.w_h.x && mouse_pos.y > gui_panel.pos.y && mouse_pos.y < gui_panel.pos.y + gui_panel.nav_bar_size {
                gui_panel.nav_bar_moving = true
            }
        }

        if rl.IsMouseButtonReleased(.LEFT){
            gui_panel.nav_bar_moving = false
            if(gui_panel.pos.x<0){
                gui_panel.pos.x = 0
            }
            if(gui_panel.pos.y<0){
                gui_panel.pos.y = 0
            }
            if gui_panel.pos.x+gui_panel.w_h.x> cast(f32)rl.GetScreenWidth(){
                gui_panel.pos.x = cast(f32)rl.GetScreenWidth()-(gui_panel.w_h.x+0)
            }
            if gui_panel.pos.y+gui_grab_h> cast(f32)rl.GetScreenHeight(){
                gui_panel.pos.y = cast(f32)rl.GetScreenHeight()-(gui_grab_h+0)
            }
        }
    }
    rl.GuiPanel({gui_panel.pos.x ,gui_panel.pos.y ,gui_panel.w_h.x ,gui_panel.w_h.y},gui_panel.name)
}

gui_spinner::struct {
    pos_offset:[2]f32,
    w_h_offset:[2]f32,
    min_page:i32,
    max_page:i32,
    name:cstring,
}
render_gui_spinner :: proc(gui_panel:^gui_panel,gui_spinner:^gui_spinner,curent_page:^i32,spinner_mode:^bool){
    pos :[2]f32= gui_panel.pos + gui_spinner.pos_offset
    if cast(bool)(rl.GuiSpinner({pos.x ,pos.y, gui_panel.w_h.x+gui_spinner.w_h_offset.x ,gui_spinner.w_h_offset.y},gui_spinner.name, curent_page, gui_spinner.min_page, gui_spinner.max_page, spinner_mode^)){spinner_mode^ = !spinner_mode^}
}

gui_button::struct{
    pos_offset:[2]f32,
    w_h:[2]f32,
    name:cstring,
}
render_gui_button :: proc(gui_panel:^gui_panel,gui_button:^gui_button)->(button_prssed:bool){
    return rl.GuiButton({gui_panel.pos.x+gui_button.pos_offset.x,gui_panel.pos.y+gui_button.pos_offset.y,gui_button.w_h.x,gui_button.w_h.y},gui_button.name)
}
// --- wil make the textur 1 px smaller on all sideds to let the huvering hyligt show throu
render_gui_button_textur :: proc(gui_panel:^gui_panel,gui_button:^gui_button,t_name:as.texture_names)->(button_prssed:bool){
    clicked:= rl.GuiButton({gui_panel.pos.x+gui_button.pos_offset.x,gui_panel.pos.y+gui_button.pos_offset.y,gui_button.w_h.x,gui_button.w_h.y},gui_button.name)
    draw_texture(t_name,{gui_panel.pos.x+gui_button.pos_offset.x+1,gui_panel.pos.y+gui_button.pos_offset.y+1,gui_button.w_h.x-2,gui_button.w_h.y-2})
    return clicked
}