#[
  Portions of code were derived from Rose Noll Crimmins' nim-bfgx Metacubes example which can be found at
  https://github.com/auRose94/nim-bgfx/tree/master/examples/02-metaballs

  version = "0.2.2"
  author = "Cory Noll Crimmins - Golden"
  description = "Wrapper for the graphics library; BGFX."
  license = "BSD"
]#

import 
  vmath, std/math, tables,
  bgfx, sdl2, ../sdl2bgfx,
  vs_metaballs, fs_metaballs

const kMaxDims: int = 32
const kMaxDimsF*: cfloat = float(kMaxDims)

type 
  PosNormalColorVertex = ref object
    position: vmath.Vec3
    normal: vmath.Vec3
    color: vmath.Vec3
  Grid = ref object
    val: float32
    normal: vmath.Vec3
  Metaball = ref object
    width*: uint32
    height*: uint32
    reset*: uint32
    program*: bgfx.bgfx_program_handle_t
    grid*: array[kMaxDims*kMaxDims*kMaxDims, Grid]
    ticksOffset*: uint32
  GameWindow = ref object
    width, height: int

##
##  Copyright 2011-2022 Branimir Karadzic. All rights reserved.
##  License: https://github.com/bkaradzic/bgfx/blob/master/LICENSE
##
##  Reference(s):
##  - Polygonising a scalar field
##    https://web.archive.org/web/20181127124338/http://paulbourke.net/geometry/polygonise/

var gameWindow: GameWindow

var s_edges*: array[0 .. 255, uint16] =
                                 [0x000'u16, 0x109'u16, 0x203'u16, 0x30a'u16, 0x406'u16, 0x50f'u16, 0x605'u16,
                                 0x70c'u16, 0x80c'u16, 0x905'u16, 0xa0f'u16, 0xb06'u16, 0xc0a'u16, 0xd03'u16,
                                 0xe09'u16, 0xf00'u16, 0x190'u16, 0x099'u16, 0x393'u16, 0x29a'u16, 0x596'u16,
                                 0x49f'u16, 0x795'u16, 0x69c'u16, 0x99c'u16, 0x895'u16, 0xb9f'u16, 0xa96'u16,
                                 0xd9a'u16, 0xc93'u16, 0xf99'u16, 0xe90'u16, 0x230'u16, 0x339'u16, 0x033'u16,
                                 0x13a'u16, 0x636'u16, 0x73f'u16, 0x435'u16, 0x53c'u16, 0xa3c'u16, 0xb35'u16,
                                 0x83f'u16, 0x936'u16, 0xe3a'u16, 0xf33'u16, 0xc39'u16, 0xd30'u16, 0x3a0'u16,
                                 0x2a9'u16, 0x1a3'u16, 0x0aa'u16, 0x7a6'u16, 0x6af'u16, 0x5a5'u16, 0x4ac'u16,
                                 0xbac'u16, 0xaa5'u16, 0x9af'u16, 0x8a6'u16, 0xfaa'u16, 0xea3'u16, 0xda9'u16,
                                 0xca0'u16, 0x460'u16, 0x569'u16, 0x663'u16, 0x76a'u16, 0x66'u16, 0x16f'u16, 0x265'u16,
                                 0x36c'u16, 0xc6c'u16, 0xd65'u16, 0xe6f'u16, 0xf66'u16, 0x86a'u16, 0x963'u16,
                                 0xa69'u16, 0xb60'u16, 0x5f0'u16, 0x4f9'u16, 0x7f3'u16, 0x6fa'u16, 0x1f6'u16,
                                 0x0ff'u16, 0x3f5'u16, 0x2fc'u16, 0xdfc'u16, 0xcf5'u16, 0xfff'u16, 0xef6'u16,
                                 0x9fa'u16, 0x8f3'u16, 0xbf9'u16, 0xaf0'u16, 0x650'u16, 0x759'u16, 0x453'u16,
                                 0x55a'u16, 0x256'u16, 0x35f'u16, 0x055'u16, 0x15c'u16, 0xe5c'u16, 0xf55'u16,
                                 0xc5f'u16, 0xd56'u16, 0xa5a'u16, 0xb53'u16, 0x859'u16, 0x950'u16, 0x7c0'u16,
                                 0x6c9'u16, 0x5c3'u16, 0x4ca'u16, 0x3c6'u16, 0x2cf'u16, 0x1c5'u16, 0x0cc'u16,
                                 0xfcc'u16, 0xec5'u16, 0xdcf'u16, 0xcc6'u16, 0xbca'u16, 0xac3'u16, 0x9c9'u16,
                                 0x8c0'u16, 0x8c0'u16, 0x9c9'u16, 0xac3'u16, 0xbca'u16, 0xcc6'u16, 0xdcf'u16,
                                 0xec5'u16, 0xfcc'u16, 0x0cc'u16, 0x1c5'u16, 0x2cf'u16, 0x3c6'u16, 0x4ca'u16,
                                 0x5c3'u16, 0x6c9'u16, 0x7c0'u16, 0x950'u16, 0x859'u16, 0xb53'u16, 0xa5a'u16,
                                 0xd56'u16, 0xc5f'u16, 0xf55'u16, 0xe5c'u16, 0x15c'u16, 0x55'u16, 0x35f'u16, 0x256'u16,
                                 0x55a'u16, 0x453'u16, 0x759'u16, 0x650'u16, 0xaf0'u16, 0xbf9'u16, 0x8f3'u16,
                                 0x9fa'u16, 0xef6'u16, 0xfff'u16, 0xcf5'u16, 0xdfc'u16, 0x2fc'u16, 0x3f5'u16,
                                 0x0ff'u16, 0x1f6'u16, 0x6fa'u16, 0x7f3'u16, 0x4f9'u16, 0x5f0'u16, 0xb60'u16,
                                 0xa69'u16, 0x963'u16, 0x86a'u16, 0xf66'u16, 0xe6f'u16, 0xd65'u16, 0xc6c'u16,
                                 0x36c'u16, 0x265'u16, 0x16f'u16, 0x066'u16, 0x76a'u16, 0x663'u16, 0x569'u16,
                                 0x460'u16, 0xca0'u16, 0xda9'u16, 0xea3'u16, 0xfaa'u16, 0x8a6'u16, 0x9af'u16,
                                 0xaa5'u16, 0xbac'u16, 0x4ac'u16, 0x5a5'u16, 0x6af'u16, 0x7a6'u16, 0x0aa'u16,
                                 0x1a3'u16, 0x2a9'u16, 0x3a0'u16, 0xd30'u16, 0xc39'u16, 0xf33'u16, 0xe3a'u16,
                                 0x936'u16, 0x83f'u16, 0xb35'u16, 0xa3c'u16, 0x53c'u16, 0x435'u16, 0x73f'u16,
                                 0x636'u16, 0x13a'u16, 0x033'u16, 0x339'u16, 0x230'u16, 0xe90'u16, 0xf99'u16,
                                 0xc93'u16, 0xd9a'u16, 0xa96'u16, 0xb9f'u16, 0x895'u16, 0x99c'u16, 0x69c'u16,
                                 0x795'u16, 0x49f'u16, 0x596'u16, 0x29a'u16, 0x393'u16, 0x099'u16, 0x190'u16,
                                 0xf00'u16, 0xe09'u16, 0xd03'u16, 0xc0a'u16, 0xb06'u16, 0xa0f'u16, 0x905'u16,
                                 0x80c'u16, 0x70c'u16, 0x605'u16, 0x50f'u16, 0x406'u16, 0x30a'u16, 0x203'u16,
                                 0x109'u16, 0x000'u16]

var s_indices*: array[256, array[016, int]] = [[-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
    -1, -1, -1, -1, -1],
    [0, 8, 3, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
    [0, 1, 9, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
    [1, 8, 3, 9, 8, 1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1], [1, 2, 10, -1, -1, -1, -1, -1, -1, -1,
    -1, -1, -1, -1, -1, -1],
    [0, 8, 3, 1, 2, 10, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
    [9, 2, 10, 0, 2, 9, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
    [2, 8, 3, 2, 10, 8, 10, 9, 8, -1, -1, -1, -1, -1, -1, -1], [3, 11, 2, -1, -1, -1, -1, -1, -1, -1, -1,
    -1, -1, -1, -1, -1],
    [0, 11, 2, 8, 11, 0, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
    [1, 9, 0, 2, 3, 11, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
    [1, 11, 2, 1, 9, 11, 9, 8, 11, -1, -1, -1, -1, -1, -1, -1],
    [3, 10, 1, 11, 10, 3, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
    [0, 10, 1, 0, 8, 10, 8, 11, 10, -1, -1, -1, -1, -1, -1, -1],
    [3, 9, 0, 3, 11, 9, 11, 10, 9, -1, -1, -1, -1, -1, -1, -1],
    [9, 8, 10, 10, 8, 11, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
    [4, 7, 8, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
    [4, 3, 0, 7, 3, 4, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
    [0, 1, 9, 8, 4, 7, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
    [4, 1, 9, 4, 7, 1, 7, 3, 1, -1, -1, -1, -1, -1, -1, -1],
    [1, 2, 10, 8, 4, 7, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
    [3, 4, 7, 3, 0, 4, 1, 2, 10, -1, -1, -1, -1, -1, -1, -1],
    [9, 2, 10, 9, 0, 2, 8, 4, 7, -1, -1, -1, -1, -1, -1, -1],
    [2, 10, 9, 2, 9, 7, 2, 7, 3, 7, 9, 4, -1, -1, -1, -1],
    [8, 4, 7, 3, 11, 2, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
    [11, 4, 7, 11, 2, 4, 2, 0, 4, -1, -1, -1, -1, -1, -1, -1],
    [9, 0, 1, 8, 4, 7, 2, 3, 11, -1, -1, -1, -1, -1, -1, -1],
    [4, 7, 11, 9, 4, 11, 9, 11, 2, 9, 2, 1, -1, -1, -1, -1],
    [3, 10, 1, 3, 11, 10, 7, 8, 4, -1, -1, -1, -1, -1, -1, -1],
    [1, 11, 10, 1, 4, 11, 1, 0, 4, 7, 11, 4, -1, -1, -1, -1],
    [4, 7, 8, 9, 0, 11, 9, 11, 10, 11, 0, 3, -1, -1, -1, -1],
    [4, 7, 11, 4, 11, 9, 9, 11, 10, -1, -1, -1, -1, -1, -1, -1],
    [9, 5, 4, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
    [9, 5, 4, 0, 8, 3, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
    [0, 5, 4, 1, 5, 0, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
    [8, 5, 4, 8, 3, 5, 3, 1, 5, -1, -1, -1, -1, -1, -1, -1],
    [1, 2, 10, 9, 5, 4, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
    [3, 0, 8, 1, 2, 10, 4, 9, 5, -1, -1, -1, -1, -1, -1, -1],
    [5, 2, 10, 5, 4, 2, 4, 0, 2, -1, -1, -1, -1, -1, -1, -1],
    [2, 10, 5, 3, 2, 5, 3, 5, 4, 3, 4, 8, -1, -1, -1, -1],
    [9, 5, 4, 2, 3, 11, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
    [0, 11, 2, 0, 8, 11, 4, 9, 5, -1, -1, -1, -1, -1, -1, -1],
    [0, 5, 4, 0, 1, 5, 2, 3, 11, -1, -1, -1, -1, -1, -1, -1],
    [2, 1, 5, 2, 5, 8, 2, 8, 11, 4, 8, 5, -1, -1, -1, -1],
    [10, 3, 11, 10, 1, 3, 9, 5, 4, -1, -1, -1, -1, -1, -1, -1],
    [4, 9, 5, 0, 8, 1, 8, 10, 1, 8, 11, 10, -1, -1, -1, -1],
    [5, 4, 0, 5, 0, 11, 5, 11, 10, 11, 0, 3, -1, -1, -1, -1],
    [5, 4, 8, 5, 8, 10, 10, 8, 11, -1, -1, -1, -1, -1, -1, -1],
    [9, 7, 8, 5, 7, 9, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
    [9, 3, 0, 9, 5, 3, 5, 7, 3, -1, -1, -1, -1, -1, -1, -1],
    [0, 7, 8, 0, 1, 7, 1, 5, 7, -1, -1, -1, -1, -1, -1, -1],
    [1, 5, 3, 3, 5, 7, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
    [9, 7, 8, 9, 5, 7, 10, 1, 2, -1, -1, -1, -1, -1, -1, -1],
    [10, 1, 2, 9, 5, 0, 5, 3, 0, 5, 7, 3, -1, -1, -1, -1],
    [8, 0, 2, 8, 2, 5, 8, 5, 7, 10, 5, 2, -1, -1, -1, -1],
    [2, 10, 5, 2, 5, 3, 3, 5, 7, -1, -1, -1, -1, -1, -1, -1],
    [7, 9, 5, 7, 8, 9, 3, 11, 2, -1, -1, -1, -1, -1, -1, -1],
    [9, 5, 7, 9, 7, 2, 9, 2, 0, 2, 7, 11, -1, -1, -1, -1],
    [2, 3, 11, 0, 1, 8, 1, 7, 8, 1, 5, 7, -1, -1, -1, -1],
    [11, 2, 1, 11, 1, 7, 7, 1, 5, -1, -1, -1, -1, -1, -1, -1],
    [9, 5, 8, 8, 5, 7, 10, 1, 3, 10, 3, 11, -1, -1, -1, -1],
    [5, 7, 0, 5, 0, 9, 7, 11, 0, 1, 0, 10, 11, 10, 0, -1],
    [11, 10, 0, 11, 0, 3, 10, 5, 0, 8, 0, 7, 5, 7, 0, -1],
    [11, 10, 5, 7, 11, 5, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1], [10, 6, 5, -1, -1, -1, -1, -1, -1,
    -1, -1, -1, -1, -1, -1, -1],
    [0, 8, 3, 5, 10, 6, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
    [9, 0, 1, 5, 10, 6, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
    [1, 8, 3, 1, 9, 8, 5, 10, 6, -1, -1, -1, -1, -1, -1, -1],
    [1, 6, 5, 2, 6, 1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
    [1, 6, 5, 1, 2, 6, 3, 0, 8, -1, -1, -1, -1, -1, -1, -1],
    [9, 6, 5, 9, 0, 6, 0, 2, 6, -1, -1, -1, -1, -1, -1, -1],
    [5, 9, 8, 5, 8, 2, 5, 2, 6, 3, 2, 8, -1, -1, -1, -1],
    [2, 3, 11, 10, 6, 5, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
    [11, 0, 8, 11, 2, 0, 10, 6, 5, -1, -1, -1, -1, -1, -1, -1],
    [0, 1, 9, 2, 3, 11, 5, 10, 6, -1, -1, -1, -1, -1, -1, -1],
    [5, 10, 6, 1, 9, 2, 9, 11, 2, 9, 8, 11, -1, -1, -1, -1],
    [6, 3, 11, 6, 5, 3, 5, 1, 3, -1, -1, -1, -1, -1, -1, -1],
    [0, 8, 11, 0, 11, 5, 0, 5, 1, 5, 11, 6, -1, -1, -1, -1],
    [3, 11, 6, 0, 3, 6, 0, 6, 5, 0, 5, 9, -1, -1, -1, -1],
    [6, 5, 9, 6, 9, 11, 11, 9, 8, -1, -1, -1, -1, -1, -1, -1],
    [5, 10, 6, 4, 7, 8, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
    [4, 3, 0, 4, 7, 3, 6, 5, 10, -1, -1, -1, -1, -1, -1, -1],
    [1, 9, 0, 5, 10, 6, 8, 4, 7, -1, -1, -1, -1, -1, -1, -1],
    [10, 6, 5, 1, 9, 7, 1, 7, 3, 7, 9, 4, -1, -1, -1, -1],
    [6, 1, 2, 6, 5, 1, 4, 7, 8, -1, -1, -1, -1, -1, -1, -1],
    [1, 2, 5, 5, 2, 6, 3, 0, 4, 3, 4, 7, -1, -1, -1, -1],
    [8, 4, 7, 9, 0, 5, 0, 6, 5, 0, 2, 6, -1, -1, -1, -1],
    [7, 3, 9, 7, 9, 4, 3, 2, 9, 5, 9, 6, 2, 6, 9, -1],
    [3, 11, 2, 7, 8, 4, 10, 6, 5, -1, -1, -1, -1, -1, -1, -1],
    [5, 10, 6, 4, 7, 2, 4, 2, 0, 2, 7, 11, -1, -1, -1, -1],
    [0, 1, 9, 4, 7, 8, 2, 3, 11, 5, 10, 6, -1, -1, -1, -1],
    [9, 2, 1, 9, 11, 2, 9, 4, 11, 7, 11, 4, 5, 10, 6, -1],
    [8, 4, 7, 3, 11, 5, 3, 5, 1, 5, 11, 6, -1, -1, -1, -1],
    [5, 1, 11, 5, 11, 6, 1, 0, 11, 7, 11, 4, 0, 4, 11, -1],
    [0, 5, 9, 0, 6, 5, 0, 3, 6, 11, 6, 3, 8, 4, 7, -1],
    [6, 5, 9, 6, 9, 11, 4, 7, 9, 7, 11, 9, -1, -1, -1, -1],
    [10, 4, 9, 6, 4, 10, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
    [4, 10, 6, 4, 9, 10, 0, 8, 3, -1, -1, -1, -1, -1, -1, -1],
    [10, 0, 1, 10, 6, 0, 6, 4, 0, -1, -1, -1, -1, -1, -1, -1],
    [8, 3, 1, 8, 1, 6, 8, 6, 4, 6, 1, 10, -1, -1, -1, -1],
    [1, 4, 9, 1, 2, 4, 2, 6, 4, -1, -1, -1, -1, -1, -1, -1],
    [3, 0, 8, 1, 2, 9, 2, 4, 9, 2, 6, 4, -1, -1, -1, -1],
    [0, 2, 4, 4, 2, 6, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
    [8, 3, 2, 8, 2, 4, 4, 2, 6, -1, -1, -1, -1, -1, -1, -1],
    [10, 4, 9, 10, 6, 4, 11, 2, 3, -1, -1, -1, -1, -1, -1, -1],
    [0, 8, 2, 2, 8, 11, 4, 9, 10, 4, 10, 6, -1, -1, -1, -1],
    [3, 11, 2, 0, 1, 6, 0, 6, 4, 6, 1, 10, -1, -1, -1, -1],
    [6, 4, 1, 6, 1, 10, 4, 8, 1, 2, 1, 11, 8, 11, 1, -1],
    [9, 6, 4, 9, 3, 6, 9, 1, 3, 11, 6, 3, -1, -1, -1, -1],
    [8, 11, 1, 8, 1, 0, 11, 6, 1, 9, 1, 4, 6, 4, 1, -1],
    [3, 11, 6, 3, 6, 0, 0, 6, 4, -1, -1, -1, -1, -1, -1, -1],
    [6, 4, 8, 11, 6, 8, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
    [7, 10, 6, 7, 8, 10, 8, 9, 10, -1, -1, -1, -1, -1, -1, -1],
    [0, 7, 3, 0, 10, 7, 0, 9, 10, 6, 7, 10, -1, -1, -1, -1],
    [10, 6, 7, 1, 10, 7, 1, 7, 8, 1, 8, 0, -1, -1, -1, -1],
    [10, 6, 7, 10, 7, 1, 1, 7, 3, -1, -1, -1, -1, -1, -1, -1],
    [1, 2, 6, 1, 6, 8, 1, 8, 9, 8, 6, 7, -1, -1, -1, -1],
    [2, 6, 9, 2, 9, 1, 6, 7, 9, 0, 9, 3, 7, 3, 9, -1],
    [7, 8, 0, 7, 0, 6, 6, 0, 2, -1, -1, -1, -1, -1, -1, -1],
    [7, 3, 2, 6, 7, 2, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
    [2, 3, 11, 10, 6, 8, 10, 8, 9, 8, 6, 7, -1, -1, -1, -1],
    [2, 0, 7, 2, 7, 11, 0, 9, 7, 6, 7, 10, 9, 10, 7, -1],
    [1, 8, 0, 1, 7, 8, 1, 10, 7, 6, 7, 10, 2, 3, 11, -1],
    [11, 2, 1, 11, 1, 7, 10, 6, 1, 6, 7, 1, -1, -1, -1, -1],
    [8, 9, 6, 8, 6, 7, 9, 1, 6, 11, 6, 3, 1, 3, 6, -1],
    [0, 9, 1, 11, 6, 7, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
    [7, 8, 0, 7, 0, 6, 3, 11, 0, 11, 6, 0, -1, -1, -1, -1], [7, 11, 6, -1, -1, -1, -1, -1, -1, -1, -1, -1,
    -1, -1, -1, -1], [7, 6, 11, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
    [3, 0, 8, 11, 7, 6, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
    [0, 1, 9, 11, 7, 6, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
    [8, 1, 9, 8, 3, 1, 11, 7, 6, -1, -1, -1, -1, -1, -1, -1],
    [10, 1, 2, 6, 11, 7, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
    [1, 2, 10, 3, 0, 8, 6, 11, 7, -1, -1, -1, -1, -1, -1, -1],
    [2, 9, 0, 2, 10, 9, 6, 11, 7, -1, -1, -1, -1, -1, -1, -1],
    [6, 11, 7, 2, 10, 3, 10, 8, 3, 10, 9, 8, -1, -1, -1, -1],
    [7, 2, 3, 6, 2, 7, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
    [7, 0, 8, 7, 6, 0, 6, 2, 0, -1, -1, -1, -1, -1, -1, -1],
    [2, 7, 6, 2, 3, 7, 0, 1, 9, -1, -1, -1, -1, -1, -1, -1],
    [1, 6, 2, 1, 8, 6, 1, 9, 8, 8, 7, 6, -1, -1, -1, -1],
    [10, 7, 6, 10, 1, 7, 1, 3, 7, -1, -1, -1, -1, -1, -1, -1],
    [10, 7, 6, 1, 7, 10, 1, 8, 7, 1, 0, 8, -1, -1, -1, -1],
    [0, 3, 7, 0, 7, 10, 0, 10, 9, 6, 10, 7, -1, -1, -1, -1],
    [7, 6, 10, 7, 10, 8, 8, 10, 9, -1, -1, -1, -1, -1, -1, -1],
    [6, 8, 4, 11, 8, 6, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
    [3, 6, 11, 3, 0, 6, 0, 4, 6, -1, -1, -1, -1, -1, -1, -1],
    [8, 6, 11, 8, 4, 6, 9, 0, 1, -1, -1, -1, -1, -1, -1, -1],
    [9, 4, 6, 9, 6, 3, 9, 3, 1, 11, 3, 6, -1, -1, -1, -1],
    [6, 8, 4, 6, 11, 8, 2, 10, 1, -1, -1, -1, -1, -1, -1, -1],
    [1, 2, 10, 3, 0, 11, 0, 6, 11, 0, 4, 6, -1, -1, -1, -1],
    [4, 11, 8, 4, 6, 11, 0, 2, 9, 2, 10, 9, -1, -1, -1, -1],
    [10, 9, 3, 10, 3, 2, 9, 4, 3, 11, 3, 6, 4, 6, 3, -1],
    [8, 2, 3, 8, 4, 2, 4, 6, 2, -1, -1, -1, -1, -1, -1, -1],
    [0, 4, 2, 4, 6, 2, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
    [1, 9, 0, 2, 3, 4, 2, 4, 6, 4, 3, 8, -1, -1, -1, -1],
    [1, 9, 4, 1, 4, 2, 2, 4, 6, -1, -1, -1, -1, -1, -1, -1],
    [8, 1, 3, 8, 6, 1, 8, 4, 6, 6, 10, 1, -1, -1, -1, -1],
    [10, 1, 0, 10, 0, 6, 6, 0, 4, -1, -1, -1, -1, -1, -1, -1],
    [4, 6, 3, 4, 3, 8, 6, 10, 3, 0, 3, 9, 10, 9, 3, -1],
    [10, 9, 4, 6, 10, 4, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
    [4, 9, 5, 7, 6, 11, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
    [0, 8, 3, 4, 9, 5, 11, 7, 6, -1, -1, -1, -1, -1, -1, -1],
    [5, 0, 1, 5, 4, 0, 7, 6, 11, -1, -1, -1, -1, -1, -1, -1],
    [11, 7, 6, 8, 3, 4, 3, 5, 4, 3, 1, 5, -1, -1, -1, -1],
    [9, 5, 4, 10, 1, 2, 7, 6, 11, -1, -1, -1, -1, -1, -1, -1],
    [6, 11, 7, 1, 2, 10, 0, 8, 3, 4, 9, 5, -1, -1, -1, -1],
    [7, 6, 11, 5, 4, 10, 4, 2, 10, 4, 0, 2, -1, -1, -1, -1],
    [3, 4, 8, 3, 5, 4, 3, 2, 5, 10, 5, 2, 11, 7, 6, -1],
    [7, 2, 3, 7, 6, 2, 5, 4, 9, -1, -1, -1, -1, -1, -1, -1],
    [9, 5, 4, 0, 8, 6, 0, 6, 2, 6, 8, 7, -1, -1, -1, -1],
    [3, 6, 2, 3, 7, 6, 1, 5, 0, 5, 4, 0, -1, -1, -1, -1],
    [6, 2, 8, 6, 8, 7, 2, 1, 8, 4, 8, 5, 1, 5, 8, -1],
    [9, 5, 4, 10, 1, 6, 1, 7, 6, 1, 3, 7, -1, -1, -1, -1],
    [1, 6, 10, 1, 7, 6, 1, 0, 7, 8, 7, 0, 9, 5, 4, -1],
    [4, 0, 10, 4, 10, 5, 0, 3, 10, 6, 10, 7, 3, 7, 10, -1],
    [7, 6, 10, 7, 10, 8, 5, 4, 10, 4, 8, 10, -1, -1, -1, -1],
    [6, 9, 5, 6, 11, 9, 11, 8, 9, -1, -1, -1, -1, -1, -1, -1],
    [3, 6, 11, 0, 6, 3, 0, 5, 6, 0, 9, 5, -1, -1, -1, -1],
    [0, 11, 8, 0, 5, 11, 0, 1, 5, 5, 6, 11, -1, -1, -1, -1],
    [6, 11, 3, 6, 3, 5, 5, 3, 1, -1, -1, -1, -1, -1, -1, -1],
    [1, 2, 10, 9, 5, 11, 9, 11, 8, 11, 5, 6, -1, -1, -1, -1],
    [0, 11, 3, 0, 6, 11, 0, 9, 6, 5, 6, 9, 1, 2, 10, -1],
    [11, 8, 5, 11, 5, 6, 8, 0, 5, 10, 5, 2, 0, 2, 5, -1],
    [6, 11, 3, 6, 3, 5, 2, 10, 3, 10, 5, 3, -1, -1, -1, -1],
    [5, 8, 9, 5, 2, 8, 5, 6, 2, 3, 8, 2, -1, -1, -1, -1],
    [9, 5, 6, 9, 6, 0, 0, 6, 2, -1, -1, -1, -1, -1, -1, -1],
    [1, 5, 8, 1, 8, 0, 5, 6, 8, 3, 8, 2, 6, 2, 8, -1],
    [1, 5, 6, 2, 1, 6, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
    [1, 3, 6, 1, 6, 10, 3, 8, 6, 5, 6, 9, 8, 9, 6, -1],
    [10, 1, 0, 10, 0, 6, 9, 5, 0, 5, 6, 0, -1, -1, -1, -1],
    [0, 3, 8, 5, 6, 10, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1], [10, 5, 6, -1, -1, -1, -1, -1, -1, -1,
    -1, -1, -1, -1, -1, -1],
    [11, 5, 10, 7, 5, 11, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
    [11, 5, 10, 11, 7, 5, 8, 3, 0, -1, -1, -1, -1, -1, -1, -1],
    [5, 11, 7, 5, 10, 11, 1, 9, 0, -1, -1, -1, -1, -1, -1, -1],
    [10, 7, 5, 10, 11, 7, 9, 8, 1, 8, 3, 1, -1, -1, -1, -1],
    [11, 1, 2, 11, 7, 1, 7, 5, 1, -1, -1, -1, -1, -1, -1, -1],
    [0, 8, 3, 1, 2, 7, 1, 7, 5, 7, 2, 11, -1, -1, -1, -1],
    [9, 7, 5, 9, 2, 7, 9, 0, 2, 2, 11, 7, -1, -1, -1, -1],
    [7, 5, 2, 7, 2, 11, 5, 9, 2, 3, 2, 8, 9, 8, 2, -1],
    [2, 5, 10, 2, 3, 5, 3, 7, 5, -1, -1, -1, -1, -1, -1, -1],
    [8, 2, 0, 8, 5, 2, 8, 7, 5, 10, 2, 5, -1, -1, -1, -1],
    [9, 0, 1, 5, 10, 3, 5, 3, 7, 3, 10, 2, -1, -1, -1, -1],
    [9, 8, 2, 9, 2, 1, 8, 7, 2, 10, 2, 5, 7, 5, 2, -1],
    [1, 3, 5, 3, 7, 5, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
    [0, 8, 7, 0, 7, 1, 1, 7, 5, -1, -1, -1, -1, -1, -1, -1],
    [9, 0, 3, 9, 3, 5, 5, 3, 7, -1, -1, -1, -1, -1, -1, -1],
    [9, 8, 7, 5, 9, 7, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
    [5, 8, 4, 5, 10, 8, 10, 11, 8, -1, -1, -1, -1, -1, -1, -1],
    [5, 0, 4, 5, 11, 0, 5, 10, 11, 11, 3, 0, -1, -1, -1, -1],
    [0, 1, 9, 8, 4, 10, 8, 10, 11, 10, 4, 5, -1, -1, -1, -1],
    [10, 11, 4, 10, 4, 5, 11, 3, 4, 9, 4, 1, 3, 1, 4, -1],
    [2, 5, 1, 2, 8, 5, 2, 11, 8, 4, 5, 8, -1, -1, -1, -1],
    [0, 4, 11, 0, 11, 3, 4, 5, 11, 2, 11, 1, 5, 1, 11, -1],
    [0, 2, 5, 0, 5, 9, 2, 11, 5, 4, 5, 8, 11, 8, 5, -1],
    [9, 4, 5, 2, 11, 3, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
    [2, 5, 10, 3, 5, 2, 3, 4, 5, 3, 8, 4, -1, -1, -1, -1],
    [5, 10, 2, 5, 2, 4, 4, 2, 0, -1, -1, -1, -1, -1, -1, -1],
    [3, 10, 2, 3, 5, 10, 3, 8, 5, 4, 5, 8, 0, 1, 9, -1],
    [5, 10, 2, 5, 2, 4, 1, 9, 2, 9, 4, 2, -1, -1, -1, -1],
    [8, 4, 5, 8, 5, 3, 3, 5, 1, -1, -1, -1, -1, -1, -1, -1],
    [0, 4, 5, 1, 0, 5, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
    [8, 4, 5, 8, 5, 3, 9, 0, 5, 0, 3, 5, -1, -1, -1, -1],
    [9, 4, 5, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
    [4, 11, 7, 4, 9, 11, 9, 10, 11, -1, -1, -1, -1, -1, -1, -1],
    [0, 8, 3, 4, 9, 7, 9, 11, 7, 9, 10, 11, -1, -1, -1, -1],
    [1, 10, 11, 1, 11, 4, 1, 4, 0, 7, 4, 11, -1, -1, -1, -1],
    [3, 1, 4, 3, 4, 8, 1, 10, 4, 7, 4, 11, 10, 11, 4, -1],
    [4, 11, 7, 9, 11, 4, 9, 2, 11, 9, 1, 2, -1, -1, -1, -1],
    [9, 7, 4, 9, 11, 7, 9, 1, 11, 2, 11, 1, 0, 8, 3, -1],
    [11, 7, 4, 11, 4, 2, 2, 4, 0, -1, -1, -1, -1, -1, -1, -1],
    [11, 7, 4, 11, 4, 2, 8, 3, 4, 3, 2, 4, -1, -1, -1, -1],
    [2, 9, 10, 2, 7, 9, 2, 3, 7, 7, 4, 9, -1, -1, -1, -1],
    [9, 10, 7, 9, 7, 4, 10, 2, 7, 8, 7, 0, 2, 0, 7, -1],
    [3, 7, 10, 3, 10, 2, 7, 4, 10, 1, 10, 0, 4, 0, 10, -1],
    [1, 10, 2, 8, 7, 4, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
    [4, 9, 1, 4, 1, 7, 7, 1, 3, -1, -1, -1, -1, -1, -1, -1],
    [4, 9, 1, 4, 1, 7, 0, 8, 1, 8, 7, 1, -1, -1, -1, -1],
    [4, 0, 3, 7, 4, 3, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
    [4, 8, 7, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
    [9, 10, 8, 10, 11, 8, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
    [3, 0, 9, 3, 9, 11, 11, 9, 10, -1, -1, -1, -1, -1, -1, -1],
    [0, 1, 10, 0, 10, 8, 8, 10, 11, -1, -1, -1, -1, -1, -1, -1],
    [3, 1, 10, 11, 3, 10, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
    [1, 2, 11, 1, 11, 9, 9, 11, 8, -1, -1, -1, -1, -1, -1, -1],
    [3, 0, 9, 3, 9, 11, 1, 2, 9, 2, 11, 9, -1, -1, -1, -1],
    [0, 2, 11, 8, 0, 11, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1], [3, 2, 11, -1, -1, -1, -1, -1, -1, -1,
    -1, -1, -1, -1, -1, -1],
    [2, 3, 8, 2, 8, 10, 10, 8, 9, -1, -1, -1, -1, -1, -1, -1],
    [9, 10, 2, 0, 9, 2, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
    [2, 3, 8, 2, 8, 10, 0, 1, 8, 1, 10, 8, -1, -1, -1, -1], [1, 10, 2, -1, -1, -1, -1, -1, -1, -1, -1, -1,
    -1, -1, -1, -1],
    [1, 3, 8, 9, 1, 8, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
    [0, 9, 1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
    [0, 3, 8, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1], [-1, -1, -1, -1, -1, -1, -1, -1, -1,
    -1, -1, -1, -1, -1, -1, -1]]

var s_cube*: array[8, array[3, cfloat]] = 
                                    [[0.0f, 1.0f, 1.0f], [1.0f, 1.0f, 1.0f],
                                     [1.0f, 1.0f, 0.0f], [0.0f, 1.0f, 0.0f],
                                     [0.0f, 0.0f, 1.0f], [1.0f, 0.0f, 1.0f],
                                     [1.0f, 0.0f, 0.0f], [0.0f, 0.0f, 0.0f]]

proc vertLerp(vertices: var Vec3, iso: float32, idx0: uint32, v0: float32, idx1: uint32, v1: float32): float32 =
    let edge0 = s_cube[idx0]
    let edge1 = s_cube[idx1]

    const c_epsilon = 1e-05

    if abs(iso-v1) < c_epsilon:
        vertices[0] = edge1[0]
        vertices[1] = edge1[1]
        vertices[2] = edge1[2]
        return 1.0'f32

    if abs(iso-v0) < c_epsilon or abs(v0-v1) < c_epsilon:
        vertices[0] = edge0[0]
        vertices[1] = edge0[1]
        vertices[2] = edge0[2]
        return 0.0'f32

    let lerp = (iso-v0)/(v1-v0)
    vertices[0] = edge0[0]+lerp*(edge1[0]-edge0[0])
    vertices[1] = edge0[1]+lerp*(edge1[1]-edge0[1])
    vertices[2] = edge0[2]+lerp*(edge1[2]-edge0[2])
    return lerp

proc triangulate*(vert_result: var ptr PosNormalColorVertex; stride: int; rgb: array[6, float32];
                  xyz: Vec3; val: array[8, ptr Grid]; iso: float32): uint32 =
    var cubeindex: uint8 = 0
    cubeindex = cubeindex or (if (val[0].val < iso): 0x00000001 else: 0)
    cubeindex = cubeindex or (if (val[1].val < iso): 0x00000002 else: 0)
    cubeindex = cubeindex or (if (val[2].val < iso): 0x00000004 else: 0)
    cubeindex = cubeindex or (if (val[3].val < iso): 0x00000008 else: 0)
    cubeindex = cubeindex or (if (val[4].val < iso): 0x00000010 else: 0)
    cubeindex = cubeindex or (if (val[5].val < iso): 0x00000020 else: 0)
    cubeindex = cubeindex or (if (val[6].val < iso): 0x00000040 else: 0)
    cubeindex = cubeindex or (if (val[7].val < iso): 0x00000080 else: 0)
    if 0'u16 == s_edges[cubeindex]:
        return 0
    var verts: array[12, array[2, Vec3]]
    let flags: uint16 = s_edges[cubeindex]
    var ii: uint16 = 0'u16
    while ii < 12'u16:
        if (flags and (1'u16 shl ii)) == 1:
            let idx0: uint32 = ii and 7
            let idx1: uint32 = [
                0x00000001'u32, 0x00000002'u32, 0x00000003'u32, 0x00000000'u32,
                0x00000005'u32, 0x00000006'u32, 0x00000007'u32, 0x00000004'u32,
                0x00000004'u32, 0x00000005'u32, 0x00000006'u32, 0x00000007'u32][ii]
            let lerp: float32 = vertLerp(verts[ii][0], iso, idx0, val[idx0].val, idx1,
                                        val[idx1].val)
            let na: Vec3 = val[idx0].normal
            let nb: Vec3 = val[idx1].normal
            verts[ii][1][0] = na[0]+lerp*(nb[0]-na[0])
            verts[ii][1][1] = na[1]+lerp*(nb[1]-na[1])
            verts[ii][1][2] = na[2]+lerp*(nb[2]-na[2])
        ii = ii+1
    let dr: float32 = rgb[3]-rgb[0]
    let dg: float32 = rgb[4]-rgb[1]
    let db: float32 = rgb[5]-rgb[2]
    var num: uint32 = 0
    let indices: array[16, int] = s_indices[cubeindex]
    ii = 0'u16
    while indices[ii] != -1'i8:
        let vertex = verts[indices[ii]]
        vert_result.position[0] = xyz[0]+vertex[0][0]
        vert_result.position[1] = xyz[1]+vertex[0][1]
        vert_result.position[2] = xyz[2]+vertex[0][2]
        vert_result.normal[0] = vertex[1][0]
        vert_result.normal[1] = vertex[1][1]
        vert_result.normal[2] = vertex[1][2]
        vert_result.color[0] = 0xff
        vert_result.color[1] = ((rgb[2]+vertex[0][2]*db)*255.0)
        vert_result.color[2] = ((rgb[1]+vertex[0][1]*dg)*255.0)
        vert_result.color[3] = ((rgb[0]+vertex[0][0]*dr)*255.0)
        vert_result = cast[ptr PosNormalColorVertex](cast[ByteAddress](vert_result)+stride)
        num = num+1
        ii = ii+1
    return num

proc init*(width: cint; height: cint) =
  sdl2bgfx.createGameWindow(width, height, "Metaballs")
  gameWindow = GameWindow(width: width.int, height: height.int)
  bgfx_set_view_clear(0, BGFX_CLEAR_COLOR or BGFX_CLEAR_DEPTH, 0x303030ff, 1.0f, 0)

proc shutdown*(): cint =
  bgfx_shutdown()

proc toMemory*(data: var seq[uint8]): ptr bgfx_memory_t = 
    var size = data.len()
    var mem = bgfx_alloc(cast[uint32](size+1))
    copyMem(mem.data, addr(data[0]), size)
    cast[ptr uint8](cast[int](mem.data) + cast[int](size))[] = cast[uint8]('\0')
    return mem 

#todo fix this
proc createShader(platform: string, shaderType: string): bgfx_shader_handle_t =
  var shaderMem: ptr bgfx_memory_t
  case shaderType
  of "fs", "fragment", "frag":
    var shaderData = fs_metaballs["dx11"]
    shaderMem = toMemory(shaderData)
  of "vs", "vertex", "vert":
    var shaderData = vs_metaballs["dx11"]
    shaderMem = toMemory(shaderData)
  bgfx_create_shader(shaderMem)

var metaballVertexLayout: ptr bgfx_vertex_layout_t
proc start(mb: Metaball) =
  var mbVertLayout: bgfx_vertex_layout_t
  metaballVertexLayout = addr mbVertLayout
  let rendererType = bgfx_get_renderer_type()
  let layoutHandle = bgfx_create_vertex_layout(metaballVertexLayout)  
  discard metaballVertexLayout.bgfx_vertex_layout_begin(rendererType)
  discard metaballVertexLayout.bgfx_vertex_layout_add(BGFX_ATTRIB_POSITION, 3, BGFX_ATTRIB_TYPE_FLOAT, false, false)
  discard metaballVertexLayout.bgfx_vertex_layout_add(BGFX_ATTRIB_NORMAL, 3, BGFX_ATTRIB_TYPE_FLOAT, false, false)
  discard metaballVertexLayout.bgfx_vertex_layout_add(BGFX_ATTRIB_COLOR0, 4, BGFX_ATTRIB_TYPE_UINT8, true, false)
  metaballVertexLayout.bgfx_vertex_layout_end()

  var vertex_shader_data: bgfx_shader_handle_t
  var fragment_shader_data: bgfx_shader_handle_t;

  case rendererType
  of BGFX_RENDERER_TYPE_DIRECT3D11, BGFX_RENDERER_TYPE_DIRECT3D12:
    vertex_shader_data = createShader("dx11", "vert")
    fragment_shader_data = createShader("dx11", "frag")
  of bgfx.BGFX_RENDERER_TYPE_OPENGL:
    vertex_shader_data = createShader("glsl", "vert")
    fragment_shader_data = createShader("glsl", "frag")
  of bgfx.BGFX_RENDERER_TYPE_METAL:
    vertex_shader_data = createShader("mtl", "vert")
    fragment_shader_data = createShader("mtl", "frag")
  of bgfx.BGFX_RENDERER_TYPE_VULKAN:
    vertex_shader_data = createShader("spv", "vert")
    fragment_shader_data = createShader("spv", "frag")
  of bgfx.BGFX_RENDERER_TYPE_DIRECT3D9:
    raise newException(ValueError, "Direct3D9 not supported")
  else:
    raise newException(ValueError, "Invalid bgfx renderer type: " & $rendererType)

  mb.program = bgfx_create_program(vertex_shader_data, fragment_shader_data, false)
  mb.ticksOffset = getTicks() 

proc cleanUp(program: bgfx_program_handle_t) =
  bgfx_destroy_program(program)
  bgfx_shutdown()

proc update(mb: Metaball) =
    const y_pitch = kMaxDims
    const z_pitch = kMaxDims*kMaxDims
    const inv_dim = 1.0'f32/kMaxDimsF-1
    let stride = int metaballVertexLayout.stride

    # Set view 0 default viewport
    bgfx_set_view_rect(0, 0, 0, cast[uint16](mb.width), cast[uint16](mb.height))

    var now = getTicks()
    var last {.global.} = getTicks()
    let frameTime: uint32 = now - last
    var time = getTicks()
    last = now
    const toMs = 1000.0'f64

    # Use debug font to print information about this example.
    bgfx_dbg_text_clear(0, false)
    bgfx_dbg_text_printf(1, 1, 0x4f, "examples/02-metaballs")

    const center: Vec3  = vec3(0.0'f32, 0.0'f32,   0.0'f32)
    const eye: Vec3 = vec3(0.0'f32, 0.0'f32, -50.0'f32)
    const up: Vec3 = vec3(0.0'f32, 1.0'f32, 0.0'f32)

    var idx: bgfx_view_id_t = 0'u16
    var view = vmath.lookAt(eye, center, up) 
    var proj: Mat4
    # math.mtxProj(proj, 60.0'f32, cast[float32](gameWindow.width)/cast[float32](gameWindow.height), 0.1'f32, 100.0'f32) todo : projection matrix
    bgfx_set_view_transform(idx, addr view, addr proj)

    bgfx_touch(0)

    var num_vertices = 0
    var prof_update = 0'f64
    var prof_normal = 0'f64
    var prof_triangulate = 0'f64

    const max_vertices = 32 shl 10
    var tvb: bgfx_transient_vertex_buffer_t
    bgfx_alloc_transient_vertex_buffer(addr tvb, max_vertices, metaballVertexLayout)

    const num_spheres = 16
    var sphere: array[num_spheres, Vec4]
    var index = 0
    while index < num_spheres:
        let fii = float32(index)
        let HDIM = kMaxDimsF * 0.5'f32
        sphere[index][0] = math.sin(time.float32 * (fii * 0.21'f32) + fii * 0.37'f32) * (HDIM - 8.0'f32)
        sphere[index][1] = math.sin(time.float32 * (fii * 0.37'f32) + fii * 0.67'f32) * (HDIM - 8.0'f32)
        sphere[index][2] = math.cos(time.float32 * (fii * 0.11'f32) + fii * 0.13'f32) * (HDIM - 8.0'f32)
        sphere[index][3] = 1.0'f32/(2.0'f32 + (math.sin(time.float32 * (fii * 0.13'f32)) * 0.5'f32 + 0.5'f32) * 2.0'f32)
        index = index + 1

    prof_update = getTicks().float64

    var zz = 0
    var yy = 0
    var xx = 0
    while zz < kMaxDims:
        yy = 0
        while yy < kMaxDims:
            xx = 0
            while xx < kMaxDims:
                let offset = (zz * kMaxDims + yy) * kMaxDims
                var dist = 0.0'f32
                var prod = 1.0'f32
                index = 0
                while index < num_spheres:
                    const HFDIMS = -kMaxDimsF * 0.5'f32 # 16
                    let dx = sphere[index][0] - (HFDIMS + float32(xx))
                    let dy = sphere[index][1] - (HFDIMS + float32(yy))
                    let dz = sphere[index][2] - (HFDIMS + float32(zz))
                    let invr = sphere[index][3]
                    var dot = dx * dx + dy * dy + dz * dz
                    dot = dot*invr*invr

                    dist = dist*dot
                    dist = dist+prod
                    prod = prod*dot
                    index = index+1
                mb.grid[offset + xx].val = (dist/prod) - 1.0'f32
                xx = xx+1
            yy = yy+1
        zz = zz+1

    prof_update = getTicks().float64 - prof_update

    prof_normal = getTicks().float64

    zz = 1
    while zz < kMaxDims - 1:
        yy = 1
        while yy < kMaxDims - 1:
            xx = 1
            let offset = (zz * kMaxDims + yy) * kMaxDims
            while xx < kMaxDims - 1:
                let xoffset = offset + xx
                let normal = vec3(
                    float32(mb.grid[xoffset - 1  ].val - mb.grid[xoffset+1  ].val),
                    mb.grid[xoffset - y_pitch].val - mb.grid[xoffset+y_pitch].val,
                    mb.grid[xoffset - z_pitch].val - mb.grid[xoffset+z_pitch].val
                )
                # normalize
                var invLen: float32 = 1.0'f32 / length(normal)
                mb.grid[xoffset].normal[0] = normal[0] * invLen
                mb.grid[xoffset].normal[1] = normal[1] * invLen
                mb.grid[xoffset].normal[2] = normal[2] * invLen
                xx = xx+1
            yy = yy+1
        zz = zz+1
    prof_normal = getTicks().float64 - prof_normal

    prof_triangulate = getTicks().float64

    var current_pos = cast[ptr PosNormalColorVertex](tvb.data)

    zz = 0
    while zz < kMaxDims-1 and num_vertices+12 < max_vertices:
        let fzz = float32(zz)
        var rgb: array[6, float32]
        rgb[2] = fzz*inv_dim
        rgb[5] = (fzz+1)*inv_dim
        yy = 0
        while yy < kMaxDims-1 and num_vertices+12 < max_vertices:
            let fyy = float32(yy)
            let offset = (zz*kMaxDims+yy)*kMaxDims
            rgb[1] = fyy*inv_dim
            rgb[4] = (fyy+1)*inv_dim
            xx = 0
            while xx < kMaxDims-1 and num_vertices+12 < max_vertices:
                let fxx = float32(xx)
                let xoffset = offset+xx
                rgb[0] = fxx*inv_dim
                rgb[3] = (fxx+1'f32)*inv_dim
                
                const HFDIMS = -kMaxDimsF*0.5'f32 # -16
                let pos: Vec3 = vec3(
                    HFDIMS+fxx,
                    HFDIMS+fyy,
                    HFDIMS+fzz
                )

                let val = [
                    addr(mb.grid[xoffset+z_pitch+y_pitch]),
                    addr(mb.grid[xoffset+z_pitch+y_pitch+1]),
                    addr(mb.grid[xoffset+y_pitch+1]),
                    addr(mb.grid[xoffset+y_pitch]),
                    addr(mb.grid[xoffset+z_pitch]),
                    addr(mb.grid[xoffset+z_pitch+1]),
                    addr(mb.grid[xoffset+1]),
                    addr(mb.grid[xoffset])
                ]
                let num = triangulate(current_pos, stride, rgb, pos, val, 0.5'f32)
                current_pos = cast[ptr PosNormalColorVertex](cast[ByteAddress](current_pos)+int(num))
                num_vertices = num_vertices+int(num)
                xx = xx+1
            yy = yy+1
        zz = zz+1

    prof_triangulate = getTicks().float64 - prof_triangulate

    var mtx: Mat4 = rotateZ(time.float32 * 0.67'f32)
    discard bgfx_set_transform(addr mtx, 0'u16)

    bgfx_set_transient_vertex_buffer(tvb.data[], addr tvb, 0'u32, uint32(num_vertices))

    bgfx_set_state(BGFX_STATE_DEFAULT)

    bgfx_submit(0, mb.program)

    # bgfxDebugTextPrintf(1, 4, 0x0f, "Num vertices: %5d (%6.4f%%)", num_vertices, num_vertices.toFloat()/max_vertices.toFloat()*100)
    # bgfxDebugTextPrintf(1, 5, 0x0f, "      Update: % 7.3f[ms]", prof_update*toMs)
    # bgfxDebugTextPrintf(1, 6, 0x0f, "Calc Normals: % 7.3f[ms]", prof_normal*toMs)
    # bgfxDebugTextPrintf(1, 7, 0x0f, " Triangulate: % 7.3f[ms]", prof_triangulate*toMs)
    # bgfxDebugTextPrintf(1, 8, 0x0f, "       Frame: %7.3f[ms]", frameTime*toMs);
    # bgfxDebugTextPrintf(1, 9, 0x0f, "         FPS: %7.3f", 1.0'f32/frameTime);

    discard bgfx_frame(false)

proc run() = 
  defer: sdl2.quit()
  var
    event = sdl2.defaultEvent
    runGame = true
    mb: Metaball = Metaball()
    
  mb.start()

  while runGame:
    while pollEvent(event):
      case event.kind
      of QuitEvent:
        runGame = false
        break
      else:
        discard
        # update(mb)
  
  cleanUp(mb.program)

init(1600, 1000)
run()
