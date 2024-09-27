package game_engin

import rl "vendor:raylib"
import as "../assets"
import "core:fmt"
import "core:math"
import "core:math/rand"

entity :: struct{
    pos:[2]i32,
    sprite:sprite,
    light:light,
}
