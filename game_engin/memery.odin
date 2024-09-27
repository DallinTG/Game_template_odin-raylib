package game_engin

import as "../assets"


init_memery::proc(){
   //all_particles=new(#soa[max_particles]Particle,context.allocator)

}
free_memery::proc(){
    //free(all_particles)
    delete(light_rendering_q)
    delete(temp_light_buffer)
    delete(light_buffer)
    free(all_particles)
    delete(as.atlases)
}