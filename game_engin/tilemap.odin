package game_engin
import rl "vendor:raylib"
import as "../assets"
import "core:fmt"
import "core:math"
import "core:encoding/cbor"
import "core:os"
import "core:strings"
import "core:strconv"

t_map_width:: 32 
t_map_height:: 32
t_map_t_size:: 32
t_map_zoom:: 1

alow_editer_mode::true
editer_mode := false
render_edit_bg:=true
render_edit_mg:=true
render_edit_fg:=true


tile :: struct{
    bg_id: as.texture_names,
    mg_id: as.texture_names,
    fg_id: as.texture_names,
    hb: bool,
}

tile_map :: struct{
    pos:[2]i32,
    is_initialised:bool,
    tiles :[t_map_width][t_map_height]tile,
    bg_texture:rl.RenderTexture,
    mg_texture:rl.RenderTexture,
    fg_texture:rl.RenderTexture,
}
tile_map_save_data :: struct{
    pos:[2]i32,
    tiles :[t_map_width][t_map_height]tile,
}

World_map :: struct{
    t_maps : map[[2]i32]tile_map,
}

temp_t_map :tile_map={}
Curent_world_map :World_map

save_t_map :: proc(t_map:^tile_map,f_name:string = "temp.temp",directory:string = "./TEMP_TEMP\\test.txt"){
    f_d:[3]string={directory,"/",f_name}
    data_to_save:tile_map_save_data
    data_to_save.pos = t_map.pos
    data_to_save.tiles = t_map.tiles

    //fmt.print(f_name,"\n")

    data,err := cbor.marshal_into_bytes(data_to_save)
    if err == nil{
        sucses:=os.write_entire_file(strings.concatenate(f_d[:]), data)
        if !sucses{
            fmt.print("writeing file failed when saving a t_map check if file path is good \n")   
        }
        
    }else{
        fmt.print("marshaling failed when saving a t_map")
    }
}

save_world_map :: proc (directory:string,World_map:^World_map){ 
    for key in Curent_world_map.t_maps {
        buf: [64]u8
        buf2: [64]u8
        x:=strconv.itoa(buf[:], cast(int)key.x)
        y:=strconv.itoa(buf2[:], cast(int)key.y)
        x_y:[5]string={"pos_",x,"_",y,".tmap"}
        tmap_name,err:=strings.replace(strings.concatenate(x_y[:]), "-", "N", -1)
        save_t_map(&World_map.t_maps[key],tmap_name,directory)
    }
}

lode_t_map_from_path ::proc(f_name:string = "temp.temp",directory:string= "./TEMP_TEMP\\test.txt")->(tile_map){
    f_d:[2]string={directory,f_name}
    data_to_save:tile_map_save_data
    cbor.unmarshal_from_reader(os.stream_from_handle(os.open(strings.concatenate(f_d[:])) or_else panic("Can't open file")),&data_to_save)
    new_t_map :tile_map
    new_t_map.pos = data_to_save.pos
    new_t_map.tiles = data_to_save.tiles
    //fmt.print("n","n",as.all_tile_maps[as.tile_map_names.pos_0_0],"/n","/n")
return new_t_map
}
lode_t_map_from_bi ::proc(data:[]u8)->(tile_map){
    data_to_save:tile_map_save_data
    cbor.unmarshal_from_string(cast(string)data,&data_to_save)
    fmt.print(data_to_save)
    new_t_map :tile_map
    new_t_map.pos = data_to_save.pos
    new_t_map.tiles = data_to_save.tiles
return new_t_map
}


init_t_map :: proc(t_map:^tile_map){
    t_map.bg_texture = rl.LoadRenderTexture(t_map_width * t_map_t_size, t_map_height * t_map_t_size)
    t_map.mg_texture = rl.LoadRenderTexture(t_map_width * t_map_t_size, t_map_height * t_map_t_size)
    t_map.fg_texture = rl.LoadRenderTexture(t_map_width * t_map_t_size, t_map_height * t_map_t_size)

    rl.BeginTextureMode(t_map.bg_texture)
    rl.ClearBackground({0,0,0,0})
    for x in 0..<t_map_width {
        for y in 0..<t_map_height {
            draw_texture(t_map.tiles[x][y].bg_id ,{cast(f32)( x * t_map_t_size),cast(f32)( y * t_map_t_size), t_map_t_size, t_map_t_size})
        }
    }
    rl.EndTextureMode()

    rl.BeginTextureMode(t_map.mg_texture)
    rl.ClearBackground({0,0,0,0})
    for x in 0..<t_map_width {
        for y in 0..<t_map_height {
            draw_texture(t_map.tiles[x][y].mg_id ,{cast(f32)( x * t_map_t_size),cast(f32)( y * t_map_t_size), t_map_t_size, t_map_t_size})
        }
    }
    rl.EndTextureMode()

    rl.BeginTextureMode(t_map.fg_texture)
    rl.ClearBackground({0,0,0,0})
    for x in 0..<t_map_width {
        for y in 0..<t_map_height {
            draw_texture(t_map.tiles[x][y].fg_id ,{cast(f32)( x * t_map_t_size),cast(f32)( y * t_map_t_size), t_map_t_size, t_map_t_size})
        }
    }
    rl.EndTextureMode()
    t_map.is_initialised = true
}

draw_bg_t_map :: proc(t_map:^tile_map){
    if render_edit_bg{
        rl.DrawTextureRec(t_map.bg_texture.texture, {0,0,t_map_t_size*t_map_width,+t_map_t_size*t_map_height*-1}, {cast(f32)t_map.pos[0]*t_map_width*t_map_t_size,cast(f32)t_map.pos[1]*t_map_height*t_map_t_size,},rl.WHITE)
    }
}

draw_mg_t_map :: proc(t_map:^tile_map){
    if render_edit_mg{
        rl.DrawTextureRec(t_map.mg_texture.texture, {0,0,t_map_t_size*t_map_width,+t_map_t_size*t_map_height*-1}, {cast(f32)t_map.pos[0]*t_map_width*t_map_t_size,cast(f32)t_map.pos[1]*t_map_height*t_map_t_size,},rl.WHITE)
    }
}

draw_fg_t_map :: proc(t_map:^tile_map){
    if render_edit_fg{
        rl.DrawTextureRec(t_map.fg_texture.texture, {0,0,t_map_t_size*t_map_width,+t_map_t_size*t_map_height*-1}, {cast(f32)t_map.pos[0]*t_map_width*t_map_t_size,cast(f32)t_map.pos[1]*t_map_height*t_map_t_size,},rl.WHITE)
    }
}

fill_t_map :: proc(t_map:^tile_map,texture:as.texture_names){
        for x in 0..<t_map_width {
        for y in 0..<t_map_height {
            t_map.tiles[x][y].bg_id=texture
            t_map.tiles[x][y].mg_id=texture
            t_map.tiles[x][y].fg_id=texture
        }
    }
}

set_t_in_t_map :: proc(t_map: ^tile_map, t_pos:[2]f32, texture: as.texture_names, if_bg: bool, if_mg: bool, if_fg: bool){
    x_shift:=t_map_width*t_map.pos.x
    y_shift:=t_map_width*t_map.pos.y

    d_t_pos := t_pos
    if t_map.pos.x<0{
        d_t_pos.x=math.abs(d_t_pos.x-t_map_width)-1
    }
    if t_map.pos.y<0{
        d_t_pos.y=math.abs(d_t_pos.y-t_map_height)-1
    }

    if cast(i32)math.abs(t_pos.x)<t_map_width && cast(i32)math.abs(t_pos.x)>-1 && cast(i32)math.abs(t_pos.y)<t_map_height && cast(i32)math.abs(t_pos.y)>-1{
        if texture == as.texture_names.none{
            rl.BeginBlendMode(rl.BlendMode.SUBTRACT_COLORS)  
        }
            if if_bg{
            rl.BeginTextureMode(t_map.bg_texture)
            t_map.tiles[cast(int)d_t_pos.x][cast(int)d_t_pos.y].bg_id = texture
            draw_texture(t_map.tiles[cast(int)d_t_pos.x][cast(int)d_t_pos.y].bg_id ,{cast(f32)( cast(int)d_t_pos.x * t_map_t_size),cast(f32)( cast(int)d_t_pos.y * t_map_t_size), t_map_t_size, t_map_t_size})
            rl.EndTextureMode()
            }
            if if_mg{
            rl.BeginTextureMode(t_map.mg_texture)
            t_map.tiles[cast(int)d_t_pos.x][cast(int)d_t_pos.y].mg_id = texture
            draw_texture(t_map.tiles[cast(int)d_t_pos.x][cast(int)d_t_pos.y].mg_id ,{cast(f32)( cast(int)d_t_pos.x * t_map_t_size),cast(f32)( cast(int)d_t_pos.y * t_map_t_size), t_map_t_size, t_map_t_size})
            rl.EndTextureMode()
            }
            if if_fg{
            rl.BeginTextureMode(t_map.fg_texture)
            t_map.tiles[cast(int)d_t_pos.x][cast(int)d_t_pos.y].fg_id = texture
            draw_texture(t_map.tiles[cast(int)d_t_pos.x][cast(int)d_t_pos.y].fg_id ,{cast(f32)( cast(int)d_t_pos.x * t_map_t_size),cast(f32)( cast(int)d_t_pos.y * t_map_t_size), t_map_t_size, t_map_t_size})
            rl.EndTextureMode()
            }
        if texture == as.texture_names.none{
            rl.EndBlendMode() 
        }
    }
}

check_editer_mode :: proc(){
    if alow_editer_mode{
        if rl.IsKeyPressed(.F5){
            editer_mode = !editer_mode
        }
        if editer_mode{
            if rl.IsKeyDown(.LEFT_SHIFT) { 
                if rl.IsKeyPressed(.ONE){
                    render_edit_bg = !render_edit_bg
                }
                if rl.IsKeyPressed(.TWO){
                    render_edit_mg = !render_edit_mg
                }
                if rl.IsKeyPressed(.THREE){
                    render_edit_fg = !render_edit_fg
                }
                if rl.IsKeyPressed(.S){
                    //save_t_map(Curent_world_map.t_maps[{0,0}])
                    save_world_map("temp_w_map",&Curent_world_map)
                    fmt.print("saving")
                }
            }
            draw_on_world_map(&Curent_world_map)
        }
    }
}

draw_on_world_map :: proc(world_map: ^World_map){
    mp:=rl.GetScreenToWorld2D(rl.GetMousePosition(), camera)
    tp:=mp/t_map_t_size
    tp.x = cast(f32)(math.abs((cast(i32)tp.x) % t_map_width))
    tp.y = cast(f32)(math.abs((cast(i32)tp.y) % t_map_height))//---------
    t_map_pos_x:=math.floor(mp.x/t_map_t_size/t_map_width)
    t_map_pos_y:=math.floor(mp.y/t_map_t_size/t_map_width)

    if rl.IsMouseButtonDown(.LEFT) {
        if world_map.t_maps[{cast(i32)t_map_pos_x,cast(i32)t_map_pos_y}].is_initialised{
            set_t_in_t_map(&world_map.t_maps[{cast(i32)t_map_pos_x,cast(i32)t_map_pos_y}],tp,as.texture_names.none,render_edit_bg,render_edit_mg,render_edit_fg)
        }
    }


}

add_t_map_to_world_map :: proc(t_map:^tile_map, World_map:^World_map  ){
    World_map.t_maps[t_map.pos] = t_map^
}

draw_world_bg_map :: proc(){
    for key in Curent_world_map.t_maps {
        draw_bg_t_map(&Curent_world_map.t_maps[key])
    }
}
draw_world_mg_map :: proc(){
    for key in Curent_world_map.t_maps {
        draw_mg_t_map(&Curent_world_map.t_maps[key])
    }
}
draw_world_fg_map :: proc(){
    for key in Curent_world_map.t_maps {
        draw_fg_t_map(&Curent_world_map.t_maps[key])
    }
}

