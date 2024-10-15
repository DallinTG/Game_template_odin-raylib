package game_engin
import rl "vendor:raylib"
import as "../assets"
import "core:fmt"
import "core:math"
import "core:encoding/cbor"
import "core:os"
import "core:strings"
import "core:strconv"
import b2 "vendor:box2d"

t_map_width:: 32
t_map_height:: 32
t_map_t_size:: 32
t_map_zoom:: 1

alow_editer_mode::true
editer_mode := false
render_edit_bg:=true
render_edit_mg:=true
render_edit_fg:=true
render_edit_debug:=true
draw_hb_mode := true

curent_brush_t:tile_id

tile_layer_id::enum{
    bg,
    mg,
    fg,
    debug,
}

tile :: struct{
    tile_layer:[tile_layer_id]tile_id,
    hb: bool,
}

tile_map :: struct{
    pos:[2]i32,
    is_initialised:bool,
    tiles :[t_map_width][t_map_height]tile,
    hb_body_id :[t_map_width][t_map_height]b2.BodyId,
    // hb_shape_id :[t_map_width][t_map_height]b2.ShapeId,
    tile_layer_texture:[tile_layer_id]rl.RenderTexture,
}
tile_map_save_data :: struct{
    pos:[2]i32,
    tiles :[t_map_width][t_map_height]tile,
}

World_map :: struct{
    t_maps : map[[2]i32]tile_map,
}

all_tile_data:[tile_id]tile_data
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
    //fmt.print(data_to_save)
    new_t_map :tile_map
    new_t_map.pos = data_to_save.pos
    new_t_map.tiles = data_to_save.tiles
return new_t_map
}


init_t_map :: proc(t_map:^tile_map){
    t_map.tile_layer_texture[.bg] = rl.LoadRenderTexture(t_map_width * t_map_t_size, t_map_height * t_map_t_size)
    t_map.tile_layer_texture[.mg] = rl.LoadRenderTexture(t_map_width * t_map_t_size, t_map_height * t_map_t_size)
    t_map.tile_layer_texture[.fg] = rl.LoadRenderTexture(t_map_width * t_map_t_size, t_map_height * t_map_t_size)
    t_map.tile_layer_texture[.debug] = rl.LoadRenderTexture(t_map_width * t_map_t_size, t_map_height * t_map_t_size)

    if alow_editer_mode {
        for x in 0..<t_map_width {
            for y in 0..<t_map_height {
                if t_map.tiles[x][y].hb {
                    body_id,shape_id : = create_static_tile({cast(i32)x+(t_map_width*t_map.pos.x),cast(i32)y+(t_map_height*t_map.pos.y)})
                    t_map.hb_body_id[x][y] = body_id
                    // t_map.hb_shape_id[x][y] = shape_id 
                    t_map.tiles[x][y].tile_layer[.debug] = tile_id.hb
                }else{
                    t_map.tiles[x][y].tile_layer[.debug] = tile_id.none
                }
            }
        }
    }
    
    redraw_t_map(t_map)
    t_map.is_initialised = true
}

draw_bg_t_map :: proc(t_map:^tile_map){
    if render_edit_bg && t_map.is_initialised{
        rl.DrawTextureRec(t_map.tile_layer_texture[.bg].texture, {0,0,t_map_t_size*t_map_width,+t_map_t_size*t_map_height*-1}, {cast(f32)t_map.pos[0]*t_map_width*t_map_t_size,cast(f32)t_map.pos[1]*t_map_height*t_map_t_size,},rl.WHITE)
    }
}

draw_mg_t_map :: proc(t_map:^tile_map){
    if render_edit_mg && t_map.is_initialised{
        rl.DrawTextureRec(t_map.tile_layer_texture[.mg].texture, {0,0,t_map_t_size*t_map_width,+t_map_t_size*t_map_height*-1}, {cast(f32)t_map.pos[0]*t_map_width*t_map_t_size,cast(f32)t_map.pos[1]*t_map_height*t_map_t_size,},rl.WHITE)
    }
}

draw_fg_t_map :: proc(t_map:^tile_map){
    if render_edit_fg  && t_map.is_initialised{
        rl.DrawTextureRec(t_map.tile_layer_texture[.fg].texture, {0,0,t_map_t_size*t_map_width,+t_map_t_size*t_map_height*-1}, {cast(f32)t_map.pos[0]*t_map_width*t_map_t_size,cast(f32)t_map.pos[1]*t_map_height*t_map_t_size,},rl.WHITE)
    }
}

draw_debug_t_map :: proc(t_map:^tile_map){
    if render_edit_debug && t_map.is_initialised{
        rl.DrawTextureRec(t_map.tile_layer_texture[.debug].texture, {0,0,t_map_t_size*t_map_width,+t_map_t_size*t_map_height*-1}, {cast(f32)t_map.pos[0]*t_map_width*t_map_t_size,cast(f32)t_map.pos[1]*t_map_height*t_map_t_size,},rl.WHITE)
    }
}

fill_t_map :: proc(t_map:^tile_map,tile_id:tile_id){
    for x in 0..<t_map_width {
        for y in 0..<t_map_height {
            t_map.tiles[x][y].tile_layer[.bg]=tile_id
            t_map.tiles[x][y].tile_layer[.mg]=tile_id
            t_map.tiles[x][y].tile_layer[.fg]=tile_id
        }
    }
}
fill_t_map_layer :: proc(t_map:^tile_map,tile_id:tile_id,tile_layer:tile_layer_id){
    for x in 0..<t_map_width {
        for y in 0..<t_map_height {
            t_map.tiles[x][y].tile_layer[tile_layer]=tile_id
        }
    }
}
set_t_in_t_map :: proc(t_map: ^tile_map, t_pos:[2]f32, new_tile_id: tile_id,tile_layer:tile_layer_id,){
    x_shift:=t_map_width*t_map.pos.x
    y_shift:=t_map_width*t_map.pos.y

    d_t_pos :[2]i32 = {cast(i32)t_pos.x,cast(i32)t_pos.y}
    box_offset_x:i32=1
    box_offset_y:i32=1

    if t_map.pos.x < 0 { d_t_pos.x=math.abs(d_t_pos.x-t_map_width)-1 }
    if t_map.pos.y < 0 { d_t_pos.y=math.abs(d_t_pos.y-t_map_height)-1 }

    if cast(i32)math.abs(t_pos.x)<t_map_width && cast(i32)math.abs(t_pos.x)>-1 && cast(i32)math.abs(t_pos.y)<t_map_height && cast(i32)math.abs(t_pos.y)>-1{
        t_map.tiles[d_t_pos.x][d_t_pos.y].tile_layer[tile_layer]= new_tile_id
        if tile_layer == tile_layer_id.debug {
            if b2.Body_IsValid(t_map.hb_body_id[d_t_pos.x][d_t_pos.y]) { b2.DestroyBody(t_map.hb_body_id[d_t_pos.x][d_t_pos.y]) } 
            body_id,shape_id : =create_static_tile({d_t_pos.x+(t_map_width*t_map.pos.x),d_t_pos.y+(t_map_height*t_map.pos.y)})
            t_map.hb_body_id[d_t_pos.x][d_t_pos.y] = body_id
            // t_map.hb_shape_id[d_t_pos.x][d_t_pos.y] = shape_id 
            t_map.tiles[d_t_pos.x][d_t_pos.y].hb = true
            t_map.tiles[d_t_pos.x][d_t_pos.y].tile_layer[.debug]= tile_id.hb
        }
    }
}
redraw_t_map_layer::proc(t_map: ^tile_map,tile_layer:tile_layer_id){
    rl.BeginTextureMode(t_map.tile_layer_texture[tile_layer])
    rl.ClearBackground({0,0,0,0})
    for x in 0..<t_map_width {
        for y in 0..<t_map_height {
            draw_tile(t_map,cast(i32)x,cast(i32)y,t_map.tiles[x][y].tile_layer[tile_layer],tile_layer)
        }
    }
    rl.EndTextureMode()
}
redraw_t_map::proc(t_map: ^tile_map,){
    redraw_t_map_layer(t_map,tile_layer_id.bg)
    redraw_t_map_layer(t_map,tile_layer_id.mg)
    redraw_t_map_layer(t_map,tile_layer_id.fg)
    redraw_t_map_layer(t_map,tile_layer_id.debug)
    // for layer_id in tile_layer_id{

    // }
}
redraw_3x3_tmap_layer::proc(t_map: ^tile_map,pos:[2]i32,tile_layer:tile_layer_id){
    xy:[2]i32
    g_xy:[2]i32
    g_xy=get_g_xy_t_maps(t_map,pos)+{0,0}
    xy=get_xy_frome_g_xy_tmap(g_xy)
    if t_map.tiles[pos.x][pos.y].tile_layer[tile_layer] == tile_id.none{ rl.BeginBlendMode(.SUBTRACT_COLORS) } 
    rl.BeginTextureMode(Curent_world_map.t_maps[get_q_frome_g_xy(g_xy)].tile_layer_texture[tile_layer])
    draw_tile(&Curent_world_map.t_maps[get_q_frome_g_xy(g_xy)],cast(i32)xy.x,cast(i32)xy.y,Curent_world_map.t_maps[get_q_frome_g_xy(g_xy)].tiles[xy.x][xy.y].tile_layer[tile_layer],tile_layer)
    rl.EndTextureMode()
    if t_map.tiles[pos.x][pos.y].tile_layer[tile_layer] == tile_id.none{ rl.EndBlendMode() } 

//new working code
    for x in -1..<2 {
        for y in -1..<2 {
            g_xy=get_g_xy_t_maps(t_map,pos)+{cast(i32)x,cast(i32)y}
            xy=get_xy_frome_g_xy_tmap(g_xy)
            rl.BeginTextureMode(Curent_world_map.t_maps[get_q_frome_g_xy(g_xy)].tile_layer_texture[tile_layer])
            draw_tile(&Curent_world_map.t_maps[get_q_frome_g_xy(g_xy)],cast(i32)xy.x,cast(i32)xy.y,Curent_world_map.t_maps[get_q_frome_g_xy(g_xy)].tiles[xy.x][xy.y].tile_layer[tile_layer],tile_layer)
            rl.EndTextureMode()
        }
    }

    // g_xy=get_g_xy_t_maps(t_map,pos)+{1,0}
    // xy=get_xy_frome_g_xy_tmap(g_xy)
    // rl.BeginTextureMode(Curent_world_map.t_maps[get_q_frome_g_xy(g_xy)].tile_layer_texture[tile_layer])
    // draw_tile(&Curent_world_map.t_maps[get_q_frome_g_xy(g_xy)],cast(i32)xy.x,cast(i32)xy.y,Curent_world_map.t_maps[get_q_frome_g_xy(g_xy)].tiles[xy.x][xy.y].tile_layer[tile_layer],tile_layer)
    // rl.EndTextureMode()
    // g_xy=get_g_xy_t_maps(t_map,pos)+{-1,0}
    // xy=get_xy_frome_g_xy_tmap(g_xy)
    // rl.BeginTextureMode(Curent_world_map.t_maps[get_q_frome_g_xy(g_xy)].tile_layer_texture[tile_layer])
    // draw_tile(&Curent_world_map.t_maps[get_q_frome_g_xy(g_xy)],cast(i32)xy.x,cast(i32)xy.y,Curent_world_map.t_maps[get_q_frome_g_xy(g_xy)].tiles[xy.x][xy.y].tile_layer[tile_layer],tile_layer)
    // rl.EndTextureMode()
    // g_xy=get_g_xy_t_maps(t_map,pos)+{0,1}
    // xy=get_xy_frome_g_xy_tmap(g_xy)
    // rl.BeginTextureMode(Curent_world_map.t_maps[get_q_frome_g_xy(g_xy)].tile_layer_texture[tile_layer])
    // draw_tile(&Curent_world_map.t_maps[get_q_frome_g_xy(g_xy)],cast(i32)xy.x,cast(i32)xy.y,Curent_world_map.t_maps[get_q_frome_g_xy(g_xy)].tiles[xy.x][xy.y].tile_layer[tile_layer],tile_layer)
    // rl.EndTextureMode()
    // g_xy=get_g_xy_t_maps(t_map,pos)+{0,-1}
    // xy=get_xy_frome_g_xy_tmap(g_xy)
    // rl.BeginTextureMode(Curent_world_map.t_maps[get_q_frome_g_xy(g_xy)].tile_layer_texture[tile_layer])
    // draw_tile(&Curent_world_map.t_maps[get_q_frome_g_xy(g_xy)],cast(i32)xy.x,cast(i32)xy.y,Curent_world_map.t_maps[get_q_frome_g_xy(g_xy)].tiles[xy.x][xy.y].tile_layer[tile_layer],tile_layer)
    // rl.EndTextureMode()
    // g_xy=get_g_xy_t_maps(t_map,pos)+{1,-1}
    // xy=get_xy_frome_g_xy_tmap(g_xy)
    // rl.BeginTextureMode(Curent_world_map.t_maps[get_q_frome_g_xy(g_xy)].tile_layer_texture[tile_layer])
    // draw_tile(&Curent_world_map.t_maps[get_q_frome_g_xy(g_xy)],cast(i32)xy.x,cast(i32)xy.y,Curent_world_map.t_maps[get_q_frome_g_xy(g_xy)].tiles[xy.x][xy.y].tile_layer[tile_layer],tile_layer)
    // rl.EndTextureMode()
    // g_xy=get_g_xy_t_maps(t_map,pos)+{-1,-1}
    // xy=get_xy_frome_g_xy_tmap(g_xy)
    // rl.BeginTextureMode(Curent_world_map.t_maps[get_q_frome_g_xy(g_xy)].tile_layer_texture[tile_layer])
    // draw_tile(&Curent_world_map.t_maps[get_q_frome_g_xy(g_xy)],cast(i32)xy.x,cast(i32)xy.y,Curent_world_map.t_maps[get_q_frome_g_xy(g_xy)].tiles[xy.x][xy.y].tile_layer[tile_layer],tile_layer)
    // rl.EndTextureMode()
    // g_xy=get_g_xy_t_maps(t_map,pos)+{1,1}
    // xy=get_xy_frome_g_xy_tmap(g_xy)
    // rl.BeginTextureMode(Curent_world_map.t_maps[get_q_frome_g_xy(g_xy)].tile_layer_texture[tile_layer])
    // draw_tile(&Curent_world_map.t_maps[get_q_frome_g_xy(g_xy)],cast(i32)xy.x,cast(i32)xy.y,Curent_world_map.t_maps[get_q_frome_g_xy(g_xy)].tiles[xy.x][xy.y].tile_layer[tile_layer],tile_layer)
    // rl.EndTextureMode()
    // g_xy=get_g_xy_t_maps(t_map,pos)+{-1,1}
    // xy=get_xy_frome_g_xy_tmap(g_xy)
    // rl.BeginTextureMode(Curent_world_map.t_maps[get_q_frome_g_xy(g_xy)].tile_layer_texture[tile_layer])
    // draw_tile(&Curent_world_map.t_maps[get_q_frome_g_xy(g_xy)],cast(i32)xy.x,cast(i32)xy.y,Curent_world_map.t_maps[get_q_frome_g_xy(g_xy)].tiles[xy.x][xy.y].tile_layer[tile_layer],tile_layer)
    // rl.EndTextureMode()
}

draw_tile::proc(t_map:^tile_map,x:i32,y:i32,tile_id:tile_id,tile_layer:tile_layer_id){

    switch tile_i in all_tile_data[tile_id].tile_type {
        case tt_bace:
            draw_texture(all_tile_data[tile_id].bace_t_name ,{cast(f32)(x * t_map_t_size),cast(f32)(y * t_map_t_size), t_map_t_size, t_map_t_size})
        case tt_wall_s:
            draw_texture(all_tile_data[tile_id].bace_t_name ,{cast(f32)(x * t_map_t_size),cast(f32)(y * t_map_t_size), t_map_t_size, t_map_t_size})
            ofset :[2]i32= {0,-1}
            if get_tile_frome_g_xy(get_g_xy_t_maps(t_map,{x,y},ofset)).tile_layer[tile_layer] != tile_id{
                draw_texture(all_tile_data[tile_id].overlay_self_t_name ,{cast(f32)(x * t_map_t_size)+(t_map_t_size/2),cast(f32)(y * t_map_t_size)+(t_map_t_size/2), t_map_t_size, t_map_t_size , },rotation= 0 ,origin = {t_map_t_size/2,t_map_t_size/2})
            }
            ofset= {0,1}
            if get_tile_frome_g_xy(get_g_xy_t_maps(t_map,{x,y},ofset)).tile_layer[tile_layer] != tile_id{
                draw_texture(all_tile_data[tile_id].overlay_self_t_name ,{cast(f32)(x * t_map_t_size)+(t_map_t_size/2),cast(f32)(y * t_map_t_size)+(t_map_t_size/2), t_map_t_size, t_map_t_size , },rotation= 180 ,origin = {t_map_t_size/2,t_map_t_size/2})
            }
            ofset= {-1,0}
            if get_tile_frome_g_xy(get_g_xy_t_maps(t_map,{x,y},ofset)).tile_layer[tile_layer] != tile_id{
                draw_texture(all_tile_data[tile_id].overlay_self_t_name ,{cast(f32)(x * t_map_t_size)+(t_map_t_size/2),cast(f32)(y * t_map_t_size)+(t_map_t_size/2), t_map_t_size, t_map_t_size , },rotation= 270 ,origin = {t_map_t_size/2,t_map_t_size/2})
            }
            ofset= {1,0}
            if get_tile_frome_g_xy(get_g_xy_t_maps(t_map,{x,y},ofset)).tile_layer[tile_layer] != tile_id{
                draw_texture(all_tile_data[tile_id].overlay_self_t_name ,{cast(f32)(x * t_map_t_size)+(t_map_t_size/2),cast(f32)(y * t_map_t_size)+(t_map_t_size/2), t_map_t_size, t_map_t_size , },rotation= 90 ,origin = {t_map_t_size/2,t_map_t_size/2})
            }
        case tt_pipe:

        case tt_mix:

        case tt_spill:

        case:
            // Default case
            // In this case, it is `nil`
        }
}

get_g_xy_t_maps::proc(t_map:^tile_map,pos:[2]i32,ofset:[2]i32={0,0})->(g_xy:[2]i32){
   
    return {((t_map.pos.x*t_map_width)+pos.x)+ofset.x,((t_map.pos.y*t_map_height)+pos.y)+ofset.y}
}

get_xy_frome_g_xy_tmap::proc(pos:[2]i32)->(xy:[2]i32){
    x:i32=pos.x%t_map_width
    y:i32=pos.y%t_map_height
    if pos.x <0{
        x += t_map_width
        if x == t_map_width{x=0}
    }
    if pos.y <0{
        y += t_map_height
        if y == t_map_height{y=0}
    }
    return {x ,y}
}
get_q_frome_g_xy::proc(pos:[2]i32)->(q_pos:[2]i32){
    q_pos.x = pos.x/t_map_width
    q_pos.y = pos.y/t_map_height
    if pos.x <0{
        q_pos.x = (pos.x+1)/t_map_width
        q_pos.x -= 1
    }
    if pos.y <0{
        q_pos.y = (pos.y+1)/t_map_height
        q_pos.y -= 1
    }
    return q_pos 
}
get_tile_frome_g_xy::proc(pos:[2]i32)->(new_tile:tile){
    xy:=get_xy_frome_g_xy_tmap(pos)
    return Curent_world_map.t_maps[get_q_frome_g_xy(pos)].tiles[xy.x][xy.y]
}


unlode_t_map::proc(t_map: ^tile_map){
    if t_map.is_initialised {
        for layer_id in tile_layer_id{
            rl.UnloadRenderTexture(t_map.tile_layer_texture[layer_id])
        }
        for x in 0..<t_map_width {
            for y in 0..<t_map_height {
                
                if b2.Body_IsValid(t_map.hb_body_id[x][y]) { b2.DestroyBody(t_map.hb_body_id[x][y]) } 
            }
            t_map.is_initialised = false
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
                if rl.IsKeyPressed(.TAB){
                    editor_show = !editor_show
                    
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

    d_t_pos :[2]i32 = {cast(i32)tp.x,cast(i32)tp.y}

    if t_map_pos_x < 0 { d_t_pos.x=math.abs(d_t_pos.x-t_map_width)-1 }
    if t_map_pos_y < 0 { d_t_pos.y=math.abs(d_t_pos.y-t_map_height)-1 }

    if key.m_left_d {
        key.m_left_d = false
        if world_map.t_maps[{cast(i32)t_map_pos_x,cast(i32)t_map_pos_y}].is_initialised{
            if render_edit_bg{
                set_t_in_t_map(&world_map.t_maps[{cast(i32)t_map_pos_x,cast(i32)t_map_pos_y}],tp,curent_brush_t,tile_layer_id.bg)
                redraw_3x3_tmap_layer(&world_map.t_maps[{cast(i32)t_map_pos_x,cast(i32)t_map_pos_y}],{cast(i32)d_t_pos.x,cast(i32)d_t_pos.y},tile_layer_id.bg)
                // redraw_t_map_layer(&world_map.t_maps[{cast(i32)t_map_pos_x,cast(i32)t_map_pos_y}],tile_layer_id.bg)

            }
            if render_edit_mg{
                set_t_in_t_map(&world_map.t_maps[{cast(i32)t_map_pos_x,cast(i32)t_map_pos_y}],tp,curent_brush_t,tile_layer_id.mg)
                redraw_3x3_tmap_layer(&world_map.t_maps[{cast(i32)t_map_pos_x,cast(i32)t_map_pos_y}],{cast(i32)d_t_pos.x,cast(i32)d_t_pos.y},tile_layer_id.mg)
                // redraw_t_map_layer(&world_map.t_maps[{cast(i32)t_map_pos_x,cast(i32)t_map_pos_y}],tile_layer_id.mg)

            }
            if render_edit_fg{
                set_t_in_t_map(&world_map.t_maps[{cast(i32)t_map_pos_x,cast(i32)t_map_pos_y}],tp,curent_brush_t,tile_layer_id.fg)
                redraw_3x3_tmap_layer(&world_map.t_maps[{cast(i32)t_map_pos_x,cast(i32)t_map_pos_y}],{cast(i32)d_t_pos.x,cast(i32)d_t_pos.y},tile_layer_id.fg)
                // redraw_t_map_layer(&world_map.t_maps[{cast(i32)t_map_pos_x,cast(i32)t_map_pos_y}],tile_layer_id.fg)
            
            }
            if draw_hb_mode{
                set_t_in_t_map(&world_map.t_maps[{cast(i32)t_map_pos_x,cast(i32)t_map_pos_y}],tp,curent_brush_t,tile_layer_id.debug)
                redraw_3x3_tmap_layer(&world_map.t_maps[{cast(i32)t_map_pos_x,cast(i32)t_map_pos_y}],{cast(i32)d_t_pos.x,cast(i32)d_t_pos.y},tile_layer_id.debug)
                // redraw_t_map_layer(&world_map.t_maps[{cast(i32)t_map_pos_x,cast(i32)t_map_pos_y}],tile_layer_id.debug)
            }
            // redraw_t_map(&world_map.t_maps[{cast(i32)t_map_pos_x,cast(i32)t_map_pos_y}])
        }else{
            new_t_map:tile_map
            new_t_map.pos = {cast(i32)t_map_pos_x,cast(i32)t_map_pos_y}
            fill_t_map(&new_t_map,tile_id.none)
            init_t_map(&new_t_map)
            world_map.t_maps[{cast(i32)t_map_pos_x,cast(i32)t_map_pos_y}] = new_t_map
        }
    }


}

add_t_map_to_world_map :: proc(t_map:^tile_map, World_map:^World_map  ){
    if World_map.t_maps[t_map.pos].is_initialised {
        unlode_t_map(t_map)
    }
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
draw_world_debug_map :: proc(){
    for key in Curent_world_map.t_maps {
        draw_debug_t_map(&Curent_world_map.t_maps[key])
    }
}

tile_id::enum{
    none,
    hb,
    test,
    sand,
    dirt,
    stone_brick,
    smooth_stone_brick,
}
tile_type::union{
    tt_bace,
    tt_wall_s,
    tt_pipe,
    tt_mix,
    tt_spill,
}
tt_bace::struct{

}
tt_wall_s::struct{
    
}
tt_pipe::struct{

}
tt_mix::struct{

}
tt_spill::struct{

}
// tile_type::enum{
//     bace,
//     wall_s,
//     pipe,
//     mix,
//     spill,
// }
tile_data::struct{
    bace_t_name:as.texture_names,
    overlay_self_t_name:as.texture_names,
    overlay_other_t_name:as.texture_names,
    tile_type:tile_type,

}

init_all_tile_data::proc(){
    all_tile_data[tile_id.none]={
        bace_t_name=as.texture_names.none,
        tile_type=tt_bace{},
    }
    all_tile_data[tile_id.hb]={
        bace_t_name=as.texture_names.debug_hb,
        tile_type=tt_bace{},
    }
    all_tile_data[tile_id.stone_brick]={
        bace_t_name=as.texture_names.stone_brick,
        tile_type=tt_bace{},
    }
    all_tile_data[tile_id.smooth_stone_brick]={
        bace_t_name = as.texture_names.smooth_stone_brick,
        overlay_self_t_name = as.texture_names.smooth_stone_brick_side,
        tile_type = tt_wall_s{}
    }

    curent_brush_t = tile_id.none
}
