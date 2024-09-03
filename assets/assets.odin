package assets


import "core:strings"
import "core:strconv"
import "core:fmt"
import "core:sort"
import "core:slice"
import rl "vendor:raylib"

//using import "main"


atlas_size:i32: 4096
buffer:i32:100


rendertextur_info::struct{
    render_texture:rl.RenderTexture,
    index:int,
    is_full:bool,

}
image_info::struct{
    image:rl.Image,
    name:texture_names,
    info: cstring,
}
textur_info::struct{
    name:texture_names,
    atlas_index:int,
    frames:int,
    curent_frame:int,
    frame_hieght:int,
    frame_whidth:int,
    frame_timer:f32,
    frame_rate:f64,
    rectangle:[dynamic]rl.Rectangle,
    

}
atlases := make([dynamic]rendertextur_info)
textures :[texture_names]textur_info

shader_test : rl.Shader

sounds:[sound_names]rl.Sound
init_sounds::proc(){
    for sound,i in all_sounds{
        if i != sound_names.none{
            sounds[i] = rl.LoadSoundFromWave(rl.LoadWaveFromMemory(".wav",&all_sounds[i].data[0],cast(i32)(len(all_sounds[i].data))))
        }
    }
}

init_texturs::proc(){
    all_images : [len(texture_names)]image_info
    clear(&atlases)
    assign_at(&atlases, 0, rendertextur_info{ rl.LoadRenderTexture( atlas_size, atlas_size), 0, false})
    cur_atlas:int = 0

    {
    index :=0
    for raw_texture,i in all_raw_textures{
        
        if i != texture_names.none{
        image := rl.LoadImageFromMemory(".png", &raw_texture.data[0], cast(i32)(len(raw_texture.data)))
        all_images[index] = image_info{image,i,raw_texture.info}
        index+=1
       
        }
    }
    }

    slice.sort_by(all_images[:],sort_image_by_height)

    bigist_y:i32=0
    atlas_x:i32=0
    atlas_y:i32=0
    for images,i in all_images{
        //fmt.println(images.image.height)
        //fmt.println(images.name)
        //fmt.println(i)
        //fmt.println(strings.split(cast(string)images.info,","))

        texture := rl.LoadTextureFromImage(images.image)
        
        if images.image.width + atlas_x > atlas_size{
            atlas_y+=bigist_y
            atlas_y += buffer
            bigist_y = images.image.height
            atlas_x = 0
        }
        if bigist_y < images.image.height{
            bigist_y = images.image.height
        }
        if images.image.height + atlas_y > atlas_size{
            atlases[cur_atlas].is_full = true
            cur_atlas += 1
            atlas_y = 0
            assign_at(&atlases, cur_atlas, rendertextur_info{ rl.LoadRenderTexture( atlas_size, atlas_size), cur_atlas, false})
        }
        rl.BeginTextureMode(atlases[cur_atlas].render_texture)
        rl.DrawTexturePro(texture, {0,0,cast(f32)images.image.width,cast(f32)images.image.height*-1}, {cast(f32)atlas_x,cast(f32)atlas_y,cast(f32)images.image.width,cast(f32)images.image.height}, {0,0}, 0, rl.WHITE)
        rl.EndTextureMode()

        {
            textures[images.name].atlas_index = cur_atlas
            textures[images.name].name = images.name
            textures[images.name].frames = 0
            info := strings.split(cast(string)images.info,",")
            if info[0] != ""{
                textures[images.name].frame_whidth = strconv.atoi(info[0])
                textures[images.name].frame_hieght = strconv.atoi(info[1])
                textures[images.name].frames = strconv.atoi(info[2])
                textures[images.name].frame_rate = strconv.atof(info[3])
                x_ofset:=0
                y_ofset:=0
                fmt.print("     ")
                fmt.print(cast(f32)atlas_x + cast(f32)x_ofset)
                fmt.print("     ")
                for i in 0..<textures[images.name].frames {
                if cast(i32)x_ofset>=images.image.width{
                    y_ofset += textures[images.name].frame_hieght
                    x_ofset=0
                }
                // fmt.print("  ")
                // fmt.print(i)
                // fmt.print("  ")
                // fmt.print(textures[images.name].name)
                // fmt.print("  ")
                // fmt.print(cast(f32)atlas_x)
                // fmt.print("  ")
                // fmt.print(cast(f32)atlas_y)
                // fmt.print("  ")
                append(&textures[images.name].rectangle,rl.Rectangle{
                    cast(f32)atlas_x + cast(f32)x_ofset,
                    cast(f32)(atlas_y * -1) - cast(f32)y_ofset - cast(f32)images.image.height,
                    cast(f32)textures[images.name].frame_whidth,
                    cast(f32)textures[images.name].frame_hieght,
                    })
                x_ofset += textures[images.name].frame_whidth
                }
            }else{
                // fmt.print("     ")
                // fmt.print("waffles4")
                // fmt.print("     ")
                // fmt.print(textures[images.name].name)
                // fmt.print("  ")
                // fmt.print(cast(f32)atlas_x)
                // fmt.print("  ")
                // fmt.print(cast(f32)atlas_y)
                // fmt.print("  ")
                append(&textures[images.name].rectangle, rl.Rectangle{
                    cast(f32)atlas_x,
                    cast(f32)(atlas_y * -1)-cast(f32)images.image.height,
                    cast(f32)images.image.width,
                    cast(f32)images.image.height})
                // atlas_x += buffer
            }
            
        }
        atlas_x += images.image.width
        atlas_x += buffer
        rl.UnloadTexture(texture)
    }
}

int_shaders::proc(){
    shader_test = rl.LoadShaderFromMemory(all_shaders[.vs_test].info,all_shaders[.test].info)
}


sort_image_by_height::proc(image_1: image_info,image_2: image_info)->(bool){

    return image_1.image.height > image_2.image.height
}