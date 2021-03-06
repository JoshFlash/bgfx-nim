# Copyright 2017 Cory Noll Crimmins - Golden
# License: BSD-2
# Port of bgfx metaballs example 02 embedded shaders

import tables

var vs_metaballs* = initTable[string, seq[uint8]]()
vs_metaballs["glsl"] = @[
    0x56'u8, 0x53'u8, 0x48'u8, 0x04'u8, 0x03'u8, 0x2c'u8, 0xf5'u8, 0x3f'u8, 0x02'u8, 0x00'u8, 0x07'u8, 0x75'u8, 0x5f'u8, 0x6d'u8, 0x6f'u8, 0x64'u8, # VSH..,.?...u_mod
    0x65'u8, 0x6c'u8, 0x04'u8, 0x20'u8, 0x00'u8, 0x00'u8, 0x20'u8, 0x00'u8, 0x0f'u8, 0x75'u8, 0x5f'u8, 0x6d'u8, 0x6f'u8, 0x64'u8, 0x65'u8, 0x6c'u8, # el. .. ..u_model
    0x56'u8, 0x69'u8, 0x65'u8, 0x77'u8, 0x50'u8, 0x72'u8, 0x6f'u8, 0x6a'u8, 0x04'u8, 0x01'u8, 0x00'u8, 0x00'u8, 0x01'u8, 0x00'u8, 0xe6'u8, 0x01'u8, # ViewProj........
    0x00'u8, 0x00'u8, 0x61'u8, 0x74'u8, 0x74'u8, 0x72'u8, 0x69'u8, 0x62'u8, 0x75'u8, 0x74'u8, 0x65'u8, 0x20'u8, 0x68'u8, 0x69'u8, 0x67'u8, 0x68'u8, # ..attribute high
    0x70'u8, 0x20'u8, 0x76'u8, 0x65'u8, 0x63'u8, 0x34'u8, 0x20'u8, 0x61'u8, 0x5f'u8, 0x63'u8, 0x6f'u8, 0x6c'u8, 0x6f'u8, 0x72'u8, 0x30'u8, 0x3b'u8, # p vec4 a_color0;
    0x0a'u8, 0x61'u8, 0x74'u8, 0x74'u8, 0x72'u8, 0x69'u8, 0x62'u8, 0x75'u8, 0x74'u8, 0x65'u8, 0x20'u8, 0x68'u8, 0x69'u8, 0x67'u8, 0x68'u8, 0x70'u8, # .attribute highp
    0x20'u8, 0x76'u8, 0x65'u8, 0x63'u8, 0x33'u8, 0x20'u8, 0x61'u8, 0x5f'u8, 0x6e'u8, 0x6f'u8, 0x72'u8, 0x6d'u8, 0x61'u8, 0x6c'u8, 0x3b'u8, 0x0a'u8, #  vec3 a_normal;.
    0x61'u8, 0x74'u8, 0x74'u8, 0x72'u8, 0x69'u8, 0x62'u8, 0x75'u8, 0x74'u8, 0x65'u8, 0x20'u8, 0x68'u8, 0x69'u8, 0x67'u8, 0x68'u8, 0x70'u8, 0x20'u8, # attribute highp 
    0x76'u8, 0x65'u8, 0x63'u8, 0x33'u8, 0x20'u8, 0x61'u8, 0x5f'u8, 0x70'u8, 0x6f'u8, 0x73'u8, 0x69'u8, 0x74'u8, 0x69'u8, 0x6f'u8, 0x6e'u8, 0x3b'u8, # vec3 a_position;
    0x0a'u8, 0x76'u8, 0x61'u8, 0x72'u8, 0x79'u8, 0x69'u8, 0x6e'u8, 0x67'u8, 0x20'u8, 0x68'u8, 0x69'u8, 0x67'u8, 0x68'u8, 0x70'u8, 0x20'u8, 0x76'u8, # .varying highp v
    0x65'u8, 0x63'u8, 0x34'u8, 0x20'u8, 0x76'u8, 0x5f'u8, 0x63'u8, 0x6f'u8, 0x6c'u8, 0x6f'u8, 0x72'u8, 0x30'u8, 0x3b'u8, 0x0a'u8, 0x76'u8, 0x61'u8, # ec4 v_color0;.va
    0x72'u8, 0x79'u8, 0x69'u8, 0x6e'u8, 0x67'u8, 0x20'u8, 0x68'u8, 0x69'u8, 0x67'u8, 0x68'u8, 0x70'u8, 0x20'u8, 0x76'u8, 0x65'u8, 0x63'u8, 0x33'u8, # rying highp vec3
    0x20'u8, 0x76'u8, 0x5f'u8, 0x6e'u8, 0x6f'u8, 0x72'u8, 0x6d'u8, 0x61'u8, 0x6c'u8, 0x3b'u8, 0x0a'u8, 0x75'u8, 0x6e'u8, 0x69'u8, 0x66'u8, 0x6f'u8, #  v_normal;.unifo
    0x72'u8, 0x6d'u8, 0x20'u8, 0x6d'u8, 0x61'u8, 0x74'u8, 0x34'u8, 0x20'u8, 0x75'u8, 0x5f'u8, 0x6d'u8, 0x6f'u8, 0x64'u8, 0x65'u8, 0x6c'u8, 0x5b'u8, # rm mat4 u_model[
    0x33'u8, 0x32'u8, 0x5d'u8, 0x3b'u8, 0x0a'u8, 0x75'u8, 0x6e'u8, 0x69'u8, 0x66'u8, 0x6f'u8, 0x72'u8, 0x6d'u8, 0x20'u8, 0x68'u8, 0x69'u8, 0x67'u8, # 32];.uniform hig
    0x68'u8, 0x70'u8, 0x20'u8, 0x6d'u8, 0x61'u8, 0x74'u8, 0x34'u8, 0x20'u8, 0x75'u8, 0x5f'u8, 0x6d'u8, 0x6f'u8, 0x64'u8, 0x65'u8, 0x6c'u8, 0x56'u8, # hp mat4 u_modelV
    0x69'u8, 0x65'u8, 0x77'u8, 0x50'u8, 0x72'u8, 0x6f'u8, 0x6a'u8, 0x3b'u8, 0x0a'u8, 0x76'u8, 0x6f'u8, 0x69'u8, 0x64'u8, 0x20'u8, 0x6d'u8, 0x61'u8, # iewProj;.void ma
    0x69'u8, 0x6e'u8, 0x20'u8, 0x28'u8, 0x29'u8, 0x0a'u8, 0x7b'u8, 0x0a'u8, 0x20'u8, 0x20'u8, 0x68'u8, 0x69'u8, 0x67'u8, 0x68'u8, 0x70'u8, 0x20'u8, # in ().{.  highp 
    0x76'u8, 0x65'u8, 0x63'u8, 0x34'u8, 0x20'u8, 0x74'u8, 0x6d'u8, 0x70'u8, 0x76'u8, 0x61'u8, 0x72'u8, 0x5f'u8, 0x31'u8, 0x3b'u8, 0x0a'u8, 0x20'u8, # vec4 tmpvar_1;. 
    0x20'u8, 0x74'u8, 0x6d'u8, 0x70'u8, 0x76'u8, 0x61'u8, 0x72'u8, 0x5f'u8, 0x31'u8, 0x2e'u8, 0x77'u8, 0x20'u8, 0x3d'u8, 0x20'u8, 0x31'u8, 0x2e'u8, #  tmpvar_1.w = 1.
    0x30'u8, 0x3b'u8, 0x0a'u8, 0x20'u8, 0x20'u8, 0x74'u8, 0x6d'u8, 0x70'u8, 0x76'u8, 0x61'u8, 0x72'u8, 0x5f'u8, 0x31'u8, 0x2e'u8, 0x78'u8, 0x79'u8, # 0;.  tmpvar_1.xy
    0x7a'u8, 0x20'u8, 0x3d'u8, 0x20'u8, 0x61'u8, 0x5f'u8, 0x70'u8, 0x6f'u8, 0x73'u8, 0x69'u8, 0x74'u8, 0x69'u8, 0x6f'u8, 0x6e'u8, 0x3b'u8, 0x0a'u8, # z = a_position;.
    0x20'u8, 0x20'u8, 0x67'u8, 0x6c'u8, 0x5f'u8, 0x50'u8, 0x6f'u8, 0x73'u8, 0x69'u8, 0x74'u8, 0x69'u8, 0x6f'u8, 0x6e'u8, 0x20'u8, 0x3d'u8, 0x20'u8, #   gl_Position = 
    0x28'u8, 0x75'u8, 0x5f'u8, 0x6d'u8, 0x6f'u8, 0x64'u8, 0x65'u8, 0x6c'u8, 0x56'u8, 0x69'u8, 0x65'u8, 0x77'u8, 0x50'u8, 0x72'u8, 0x6f'u8, 0x6a'u8, # (u_modelViewProj
    0x20'u8, 0x2a'u8, 0x20'u8, 0x74'u8, 0x6d'u8, 0x70'u8, 0x76'u8, 0x61'u8, 0x72'u8, 0x5f'u8, 0x31'u8, 0x29'u8, 0x3b'u8, 0x0a'u8, 0x20'u8, 0x20'u8, #  * tmpvar_1);.  
    0x68'u8, 0x69'u8, 0x67'u8, 0x68'u8, 0x70'u8, 0x20'u8, 0x76'u8, 0x65'u8, 0x63'u8, 0x34'u8, 0x20'u8, 0x74'u8, 0x6d'u8, 0x70'u8, 0x76'u8, 0x61'u8, # highp vec4 tmpva
    0x72'u8, 0x5f'u8, 0x32'u8, 0x3b'u8, 0x0a'u8, 0x20'u8, 0x20'u8, 0x74'u8, 0x6d'u8, 0x70'u8, 0x76'u8, 0x61'u8, 0x72'u8, 0x5f'u8, 0x32'u8, 0x2e'u8, # r_2;.  tmpvar_2.
    0x77'u8, 0x20'u8, 0x3d'u8, 0x20'u8, 0x30'u8, 0x2e'u8, 0x30'u8, 0x3b'u8, 0x0a'u8, 0x20'u8, 0x20'u8, 0x74'u8, 0x6d'u8, 0x70'u8, 0x76'u8, 0x61'u8, # w = 0.0;.  tmpva
    0x72'u8, 0x5f'u8, 0x32'u8, 0x2e'u8, 0x78'u8, 0x79'u8, 0x7a'u8, 0x20'u8, 0x3d'u8, 0x20'u8, 0x61'u8, 0x5f'u8, 0x6e'u8, 0x6f'u8, 0x72'u8, 0x6d'u8, # r_2.xyz = a_norm
    0x61'u8, 0x6c'u8, 0x3b'u8, 0x0a'u8, 0x20'u8, 0x20'u8, 0x76'u8, 0x5f'u8, 0x6e'u8, 0x6f'u8, 0x72'u8, 0x6d'u8, 0x61'u8, 0x6c'u8, 0x20'u8, 0x3d'u8, # al;.  v_normal =
    0x20'u8, 0x28'u8, 0x75'u8, 0x5f'u8, 0x6d'u8, 0x6f'u8, 0x64'u8, 0x65'u8, 0x6c'u8, 0x5b'u8, 0x30'u8, 0x5d'u8, 0x20'u8, 0x2a'u8, 0x20'u8, 0x74'u8, #  (u_model[0] * t
    0x6d'u8, 0x70'u8, 0x76'u8, 0x61'u8, 0x72'u8, 0x5f'u8, 0x32'u8, 0x29'u8, 0x2e'u8, 0x78'u8, 0x79'u8, 0x7a'u8, 0x3b'u8, 0x0a'u8, 0x20'u8, 0x20'u8, # mpvar_2).xyz;.  
    0x76'u8, 0x5f'u8, 0x63'u8, 0x6f'u8, 0x6c'u8, 0x6f'u8, 0x72'u8, 0x30'u8, 0x20'u8, 0x3d'u8, 0x20'u8, 0x61'u8, 0x5f'u8, 0x63'u8, 0x6f'u8, 0x6c'u8, # v_color0 = a_col
    0x6f'u8, 0x72'u8, 0x30'u8, 0x3b'u8, 0x0a'u8, 0x7d'u8, 0x0a'u8, 0x0a'u8, 0x00'u8]                                                                # or0;.}...
vs_metaballs["spv"] = @[
    0x56'u8, 0x53'u8, 0x48'u8, 0x04'u8, 0x03'u8, 0x2c'u8, 0xf5'u8, 0x3f'u8, 0xa4'u8, 0x04'u8, 0x03'u8, 0x02'u8, 0x23'u8, 0x07'u8, 0x00'u8, 0x00'u8, # VSH..,.?....#...
    0x01'u8, 0x00'u8, 0x01'u8, 0x00'u8, 0x08'u8, 0x00'u8, 0xe8'u8, 0x3e'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x11'u8, 0x00'u8, # .......>........
    0x02'u8, 0x00'u8, 0x01'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x0b'u8, 0x00'u8, 0x06'u8, 0x00'u8, 0x01'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x47'u8, 0x4c'u8, # ..............GL
    0x53'u8, 0x4c'u8, 0x2e'u8, 0x73'u8, 0x74'u8, 0x64'u8, 0x2e'u8, 0x34'u8, 0x35'u8, 0x30'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x0e'u8, 0x00'u8, # SL.std.450......
    0x03'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x01'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x0f'u8, 0x00'u8, 0x04'u8, 0x00'u8, 0x00'u8, 0x00'u8, # ................
    0x00'u8, 0x00'u8, 0x42'u8, 0x13'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x05'u8, 0x00'u8, 0x03'u8, 0x00'u8, 0x42'u8, 0x13'u8, # ..B...........B.
    0x00'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x05'u8, 0x00'u8, 0x04'u8, 0x00'u8, 0x60'u8, 0x01'u8, 0x00'u8, 0x00'u8, 0x24'u8, 0x47'u8, # ..........`...$G
    0x6c'u8, 0x6f'u8, 0x62'u8, 0x61'u8, 0x6c'u8, 0x00'u8, 0x06'u8, 0x00'u8, 0x06'u8, 0x00'u8, 0x60'u8, 0x01'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x00'u8, # lobal.....`.....
    0x00'u8, 0x00'u8, 0x75'u8, 0x5f'u8, 0x76'u8, 0x69'u8, 0x65'u8, 0x77'u8, 0x52'u8, 0x65'u8, 0x63'u8, 0x74'u8, 0x00'u8, 0x00'u8, 0x06'u8, 0x00'u8, # ..u_viewRect....
    0x06'u8, 0x00'u8, 0x60'u8, 0x01'u8, 0x00'u8, 0x00'u8, 0x01'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x75'u8, 0x5f'u8, 0x76'u8, 0x69'u8, 0x65'u8, 0x77'u8, # ..`.......u_view
    0x54'u8, 0x65'u8, 0x78'u8, 0x65'u8, 0x6c'u8, 0x00'u8, 0x06'u8, 0x00'u8, 0x05'u8, 0x00'u8, 0x60'u8, 0x01'u8, 0x00'u8, 0x00'u8, 0x02'u8, 0x00'u8, # Texel.....`.....
    0x00'u8, 0x00'u8, 0x75'u8, 0x5f'u8, 0x76'u8, 0x69'u8, 0x65'u8, 0x77'u8, 0x00'u8, 0x00'u8, 0x06'u8, 0x00'u8, 0x06'u8, 0x00'u8, 0x60'u8, 0x01'u8, # ..u_view......`.
    0x00'u8, 0x00'u8, 0x03'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x75'u8, 0x5f'u8, 0x69'u8, 0x6e'u8, 0x76'u8, 0x56'u8, 0x69'u8, 0x65'u8, 0x77'u8, 0x00'u8, # ......u_invView.
    0x00'u8, 0x00'u8, 0x06'u8, 0x00'u8, 0x05'u8, 0x00'u8, 0x60'u8, 0x01'u8, 0x00'u8, 0x00'u8, 0x04'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x75'u8, 0x5f'u8, # ......`.......u_
    0x70'u8, 0x72'u8, 0x6f'u8, 0x6a'u8, 0x00'u8, 0x00'u8, 0x06'u8, 0x00'u8, 0x06'u8, 0x00'u8, 0x60'u8, 0x01'u8, 0x00'u8, 0x00'u8, 0x05'u8, 0x00'u8, # proj......`.....
    0x00'u8, 0x00'u8, 0x75'u8, 0x5f'u8, 0x69'u8, 0x6e'u8, 0x76'u8, 0x50'u8, 0x72'u8, 0x6f'u8, 0x6a'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x06'u8, 0x00'u8, # ..u_invProj.....
    0x06'u8, 0x00'u8, 0x60'u8, 0x01'u8, 0x00'u8, 0x00'u8, 0x06'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x75'u8, 0x5f'u8, 0x76'u8, 0x69'u8, 0x65'u8, 0x77'u8, # ..`.......u_view
    0x50'u8, 0x72'u8, 0x6f'u8, 0x6a'u8, 0x00'u8, 0x00'u8, 0x06'u8, 0x00'u8, 0x07'u8, 0x00'u8, 0x60'u8, 0x01'u8, 0x00'u8, 0x00'u8, 0x07'u8, 0x00'u8, # Proj......`.....
    0x00'u8, 0x00'u8, 0x75'u8, 0x5f'u8, 0x69'u8, 0x6e'u8, 0x76'u8, 0x56'u8, 0x69'u8, 0x65'u8, 0x77'u8, 0x50'u8, 0x72'u8, 0x6f'u8, 0x6a'u8, 0x00'u8, # ..u_invViewProj.
    0x00'u8, 0x00'u8, 0x06'u8, 0x00'u8, 0x05'u8, 0x00'u8, 0x60'u8, 0x01'u8, 0x00'u8, 0x00'u8, 0x08'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x75'u8, 0x5f'u8, # ......`.......u_
    0x6d'u8, 0x6f'u8, 0x64'u8, 0x65'u8, 0x6c'u8, 0x00'u8, 0x06'u8, 0x00'u8, 0x06'u8, 0x00'u8, 0x60'u8, 0x01'u8, 0x00'u8, 0x00'u8, 0x09'u8, 0x00'u8, # model.....`.....
    0x00'u8, 0x00'u8, 0x75'u8, 0x5f'u8, 0x6d'u8, 0x6f'u8, 0x64'u8, 0x65'u8, 0x6c'u8, 0x56'u8, 0x69'u8, 0x65'u8, 0x77'u8, 0x00'u8, 0x06'u8, 0x00'u8, # ..u_modelView...
    0x07'u8, 0x00'u8, 0x60'u8, 0x01'u8, 0x00'u8, 0x00'u8, 0x0a'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x75'u8, 0x5f'u8, 0x6d'u8, 0x6f'u8, 0x64'u8, 0x65'u8, # ..`.......u_mode
    0x6c'u8, 0x56'u8, 0x69'u8, 0x65'u8, 0x77'u8, 0x50'u8, 0x72'u8, 0x6f'u8, 0x6a'u8, 0x00'u8, 0x06'u8, 0x00'u8, 0x06'u8, 0x00'u8, 0x60'u8, 0x01'u8, # lViewProj.....`.
    0x00'u8, 0x00'u8, 0x0b'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x75'u8, 0x5f'u8, 0x61'u8, 0x6c'u8, 0x70'u8, 0x68'u8, 0x61'u8, 0x52'u8, 0x65'u8, 0x66'u8, # ......u_alphaRef
    0x34'u8, 0x00'u8, 0x47'u8, 0x00'u8, 0x04'u8, 0x00'u8, 0x9f'u8, 0x05'u8, 0x00'u8, 0x00'u8, 0x06'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x40'u8, 0x00'u8, # 4.G...........@.
    0x00'u8, 0x00'u8, 0x48'u8, 0x00'u8, 0x05'u8, 0x00'u8, 0x60'u8, 0x01'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x23'u8, 0x00'u8, # ..H...`.......#.
    0x00'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x48'u8, 0x00'u8, 0x05'u8, 0x00'u8, 0x60'u8, 0x01'u8, 0x00'u8, 0x00'u8, 0x01'u8, 0x00'u8, # ......H...`.....
    0x00'u8, 0x00'u8, 0x23'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x10'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x48'u8, 0x00'u8, 0x04'u8, 0x00'u8, 0x60'u8, 0x01'u8, # ..#.......H...`.
    0x00'u8, 0x00'u8, 0x02'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x04'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x48'u8, 0x00'u8, 0x05'u8, 0x00'u8, 0x60'u8, 0x01'u8, # ..........H...`.
    0x00'u8, 0x00'u8, 0x02'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x23'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x20'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x48'u8, 0x00'u8, # ......#... ...H.
    0x05'u8, 0x00'u8, 0x60'u8, 0x01'u8, 0x00'u8, 0x00'u8, 0x02'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x07'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x10'u8, 0x00'u8, # ..`.............
    0x00'u8, 0x00'u8, 0x48'u8, 0x00'u8, 0x04'u8, 0x00'u8, 0x60'u8, 0x01'u8, 0x00'u8, 0x00'u8, 0x03'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x04'u8, 0x00'u8, # ..H...`.........
    0x00'u8, 0x00'u8, 0x48'u8, 0x00'u8, 0x05'u8, 0x00'u8, 0x60'u8, 0x01'u8, 0x00'u8, 0x00'u8, 0x03'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x23'u8, 0x00'u8, # ..H...`.......#.
    0x00'u8, 0x00'u8, 0x60'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x48'u8, 0x00'u8, 0x05'u8, 0x00'u8, 0x60'u8, 0x01'u8, 0x00'u8, 0x00'u8, 0x03'u8, 0x00'u8, # ..`...H...`.....
    0x00'u8, 0x00'u8, 0x07'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x10'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x48'u8, 0x00'u8, 0x04'u8, 0x00'u8, 0x60'u8, 0x01'u8, # ..........H...`.
    0x00'u8, 0x00'u8, 0x04'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x04'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x48'u8, 0x00'u8, 0x05'u8, 0x00'u8, 0x60'u8, 0x01'u8, # ..........H...`.
    0x00'u8, 0x00'u8, 0x04'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x23'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0xa0'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x48'u8, 0x00'u8, # ......#.......H.
    0x05'u8, 0x00'u8, 0x60'u8, 0x01'u8, 0x00'u8, 0x00'u8, 0x04'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x07'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x10'u8, 0x00'u8, # ..`.............
    0x00'u8, 0x00'u8, 0x48'u8, 0x00'u8, 0x04'u8, 0x00'u8, 0x60'u8, 0x01'u8, 0x00'u8, 0x00'u8, 0x05'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x04'u8, 0x00'u8, # ..H...`.........
    0x00'u8, 0x00'u8, 0x48'u8, 0x00'u8, 0x05'u8, 0x00'u8, 0x60'u8, 0x01'u8, 0x00'u8, 0x00'u8, 0x05'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x23'u8, 0x00'u8, # ..H...`.......#.
    0x00'u8, 0x00'u8, 0xe0'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x48'u8, 0x00'u8, 0x05'u8, 0x00'u8, 0x60'u8, 0x01'u8, 0x00'u8, 0x00'u8, 0x05'u8, 0x00'u8, # ......H...`.....
    0x00'u8, 0x00'u8, 0x07'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x10'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x48'u8, 0x00'u8, 0x04'u8, 0x00'u8, 0x60'u8, 0x01'u8, # ..........H...`.
    0x00'u8, 0x00'u8, 0x06'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x04'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x48'u8, 0x00'u8, 0x05'u8, 0x00'u8, 0x60'u8, 0x01'u8, # ..........H...`.
    0x00'u8, 0x00'u8, 0x06'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x23'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x20'u8, 0x01'u8, 0x00'u8, 0x00'u8, 0x48'u8, 0x00'u8, # ......#... ...H.
    0x05'u8, 0x00'u8, 0x60'u8, 0x01'u8, 0x00'u8, 0x00'u8, 0x06'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x07'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x10'u8, 0x00'u8, # ..`.............
    0x00'u8, 0x00'u8, 0x48'u8, 0x00'u8, 0x04'u8, 0x00'u8, 0x60'u8, 0x01'u8, 0x00'u8, 0x00'u8, 0x07'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x04'u8, 0x00'u8, # ..H...`.........
    0x00'u8, 0x00'u8, 0x48'u8, 0x00'u8, 0x05'u8, 0x00'u8, 0x60'u8, 0x01'u8, 0x00'u8, 0x00'u8, 0x07'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x23'u8, 0x00'u8, # ..H...`.......#.
    0x00'u8, 0x00'u8, 0x60'u8, 0x01'u8, 0x00'u8, 0x00'u8, 0x48'u8, 0x00'u8, 0x05'u8, 0x00'u8, 0x60'u8, 0x01'u8, 0x00'u8, 0x00'u8, 0x07'u8, 0x00'u8, # ..`...H...`.....
    0x00'u8, 0x00'u8, 0x07'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x10'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x48'u8, 0x00'u8, 0x04'u8, 0x00'u8, 0x60'u8, 0x01'u8, # ..........H...`.
    0x00'u8, 0x00'u8, 0x08'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x04'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x48'u8, 0x00'u8, 0x05'u8, 0x00'u8, 0x60'u8, 0x01'u8, # ..........H...`.
    0x00'u8, 0x00'u8, 0x08'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x23'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0xa0'u8, 0x01'u8, 0x00'u8, 0x00'u8, 0x48'u8, 0x00'u8, # ......#.......H.
    0x05'u8, 0x00'u8, 0x60'u8, 0x01'u8, 0x00'u8, 0x00'u8, 0x08'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x07'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x10'u8, 0x00'u8, # ..`.............
    0x00'u8, 0x00'u8, 0x48'u8, 0x00'u8, 0x04'u8, 0x00'u8, 0x60'u8, 0x01'u8, 0x00'u8, 0x00'u8, 0x09'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x04'u8, 0x00'u8, # ..H...`.........
    0x00'u8, 0x00'u8, 0x48'u8, 0x00'u8, 0x05'u8, 0x00'u8, 0x60'u8, 0x01'u8, 0x00'u8, 0x00'u8, 0x09'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x23'u8, 0x00'u8, # ..H...`.......#.
    0x00'u8, 0x00'u8, 0xa0'u8, 0x09'u8, 0x00'u8, 0x00'u8, 0x48'u8, 0x00'u8, 0x05'u8, 0x00'u8, 0x60'u8, 0x01'u8, 0x00'u8, 0x00'u8, 0x09'u8, 0x00'u8, # ......H...`.....
    0x00'u8, 0x00'u8, 0x07'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x10'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x48'u8, 0x00'u8, 0x04'u8, 0x00'u8, 0x60'u8, 0x01'u8, # ..........H...`.
    0x00'u8, 0x00'u8, 0x0a'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x04'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x48'u8, 0x00'u8, 0x05'u8, 0x00'u8, 0x60'u8, 0x01'u8, # ..........H...`.
    0x00'u8, 0x00'u8, 0x0a'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x23'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0xe0'u8, 0x09'u8, 0x00'u8, 0x00'u8, 0x48'u8, 0x00'u8, # ......#.......H.
    0x05'u8, 0x00'u8, 0x60'u8, 0x01'u8, 0x00'u8, 0x00'u8, 0x0a'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x07'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x10'u8, 0x00'u8, # ..`.............
    0x00'u8, 0x00'u8, 0x48'u8, 0x00'u8, 0x05'u8, 0x00'u8, 0x60'u8, 0x01'u8, 0x00'u8, 0x00'u8, 0x0b'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x23'u8, 0x00'u8, # ..H...`.......#.
    0x00'u8, 0x00'u8, 0x20'u8, 0x0a'u8, 0x00'u8, 0x00'u8, 0x47'u8, 0x00'u8, 0x03'u8, 0x00'u8, 0x60'u8, 0x01'u8, 0x00'u8, 0x00'u8, 0x02'u8, 0x00'u8, # .. ...G...`.....
    0x00'u8, 0x00'u8, 0x13'u8, 0x00'u8, 0x02'u8, 0x00'u8, 0x08'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x21'u8, 0x00'u8, 0x03'u8, 0x00'u8, 0x02'u8, 0x05'u8, # ..........!.....
    0x00'u8, 0x00'u8, 0x08'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x16'u8, 0x00'u8, 0x03'u8, 0x00'u8, 0x0d'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x20'u8, 0x00'u8, # .............. .
    0x00'u8, 0x00'u8, 0x17'u8, 0x00'u8, 0x04'u8, 0x00'u8, 0x1d'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x0d'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x04'u8, 0x00'u8, # ................
    0x00'u8, 0x00'u8, 0x18'u8, 0x00'u8, 0x04'u8, 0x00'u8, 0x65'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x1d'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x04'u8, 0x00'u8, # ......e.........
    0x00'u8, 0x00'u8, 0x15'u8, 0x00'u8, 0x04'u8, 0x00'u8, 0x0b'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x20'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x00'u8, # .......... .....
    0x00'u8, 0x00'u8, 0x2b'u8, 0x00'u8, 0x04'u8, 0x00'u8, 0x0b'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x6a'u8, 0x0a'u8, 0x00'u8, 0x00'u8, 0x20'u8, 0x00'u8, # ..+.......j... .
    0x00'u8, 0x00'u8, 0x1c'u8, 0x00'u8, 0x04'u8, 0x00'u8, 0x9f'u8, 0x05'u8, 0x00'u8, 0x00'u8, 0x65'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x6a'u8, 0x0a'u8, # ..........e...j.
    0x00'u8, 0x00'u8, 0x1e'u8, 0x00'u8, 0x0e'u8, 0x00'u8, 0x60'u8, 0x01'u8, 0x00'u8, 0x00'u8, 0x1d'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x1d'u8, 0x00'u8, # ......`.........
    0x00'u8, 0x00'u8, 0x65'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x65'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x65'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x65'u8, 0x00'u8, # ..e...e...e...e.
    0x00'u8, 0x00'u8, 0x65'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x65'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x9f'u8, 0x05'u8, 0x00'u8, 0x00'u8, 0x65'u8, 0x00'u8, # ..e...e.......e.
    0x00'u8, 0x00'u8, 0x65'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x1d'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x36'u8, 0x00'u8, 0x05'u8, 0x00'u8, 0x08'u8, 0x00'u8, # ..e.......6.....
    0x00'u8, 0x00'u8, 0x42'u8, 0x13'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x02'u8, 0x05'u8, 0x00'u8, 0x00'u8, 0xf8'u8, 0x00'u8, # ..B.............
    0x02'u8, 0x00'u8, 0xe7'u8, 0x3e'u8, 0x00'u8, 0x00'u8, 0xfd'u8, 0x00'u8, 0x01'u8, 0x00'u8, 0x38'u8, 0x00'u8, 0x01'u8, 0x00'u8, 0x00'u8]          # ...>......8....
vs_metaballs["dx11"] = @[
    0x56'u8, 0x53'u8, 0x48'u8, 0x04'u8, 0x03'u8, 0x2c'u8, 0xf5'u8, 0x3f'u8, 0x02'u8, 0x00'u8, 0x07'u8, 0x75'u8, 0x5f'u8, 0x6d'u8, 0x6f'u8, 0x64'u8, # VSH..,.?...u_mod
    0x65'u8, 0x6c'u8, 0x04'u8, 0x20'u8, 0x00'u8, 0x00'u8, 0x80'u8, 0x00'u8, 0x0f'u8, 0x75'u8, 0x5f'u8, 0x6d'u8, 0x6f'u8, 0x64'u8, 0x65'u8, 0x6c'u8, # el. .....u_model
    0x56'u8, 0x69'u8, 0x65'u8, 0x77'u8, 0x50'u8, 0x72'u8, 0x6f'u8, 0x6a'u8, 0x04'u8, 0x00'u8, 0x00'u8, 0x08'u8, 0x04'u8, 0x00'u8, 0x9c'u8, 0x02'u8, # ViewProj........
    0x44'u8, 0x58'u8, 0x42'u8, 0x43'u8, 0xc6'u8, 0x4d'u8, 0x04'u8, 0x38'u8, 0x93'u8, 0x20'u8, 0x89'u8, 0x1c'u8, 0xbe'u8, 0x68'u8, 0xbc'u8, 0xd4'u8, # DXBC.M.8. ...h..
    0xee'u8, 0x2f'u8, 0x8a'u8, 0xe9'u8, 0x01'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x9c'u8, 0x02'u8, 0x00'u8, 0x00'u8, 0x03'u8, 0x00'u8, 0x00'u8, 0x00'u8, # ./..............
    0x2c'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x9c'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x10'u8, 0x01'u8, 0x00'u8, 0x00'u8, 0x49'u8, 0x53'u8, 0x47'u8, 0x4e'u8, # ,...........ISGN
    0x68'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x03'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x08'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x50'u8, 0x00'u8, 0x00'u8, 0x00'u8, # h...........P...
    0x00'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x03'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x00'u8, # ................
    0x0f'u8, 0x0f'u8, 0x00'u8, 0x00'u8, 0x56'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x00'u8, # ....V...........
    0x03'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x01'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x07'u8, 0x07'u8, 0x00'u8, 0x00'u8, 0x5d'u8, 0x00'u8, 0x00'u8, 0x00'u8, # ............]...
    0x00'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x03'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x02'u8, 0x00'u8, 0x00'u8, 0x00'u8, # ................
    0x07'u8, 0x07'u8, 0x00'u8, 0x00'u8, 0x43'u8, 0x4f'u8, 0x4c'u8, 0x4f'u8, 0x52'u8, 0x00'u8, 0x4e'u8, 0x4f'u8, 0x52'u8, 0x4d'u8, 0x41'u8, 0x4c'u8, # ....COLOR.NORMAL
    0x00'u8, 0x50'u8, 0x4f'u8, 0x53'u8, 0x49'u8, 0x54'u8, 0x49'u8, 0x4f'u8, 0x4e'u8, 0x00'u8, 0xab'u8, 0xab'u8, 0x4f'u8, 0x53'u8, 0x47'u8, 0x4e'u8, # .POSITION...OSGN
    0x6c'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x03'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x08'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x50'u8, 0x00'u8, 0x00'u8, 0x00'u8, # l...........P...
    0x00'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x01'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x03'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x00'u8, # ................
    0x0f'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x5c'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x00'u8, # ................
    0x03'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x01'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x0f'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x62'u8, 0x00'u8, 0x00'u8, 0x00'u8, # ............b...
    0x01'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x03'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x02'u8, 0x00'u8, 0x00'u8, 0x00'u8, # ................
    0x07'u8, 0x08'u8, 0x00'u8, 0x00'u8, 0x53'u8, 0x56'u8, 0x5f'u8, 0x50'u8, 0x4f'u8, 0x53'u8, 0x49'u8, 0x54'u8, 0x49'u8, 0x4f'u8, 0x4e'u8, 0x00'u8, # ....SV_POSITION.
    0x43'u8, 0x4f'u8, 0x4c'u8, 0x4f'u8, 0x52'u8, 0x00'u8, 0x54'u8, 0x45'u8, 0x58'u8, 0x43'u8, 0x4f'u8, 0x4f'u8, 0x52'u8, 0x44'u8, 0x00'u8, 0xab'u8, # COLOR.TEXCOORD..
    0x53'u8, 0x48'u8, 0x44'u8, 0x52'u8, 0x84'u8, 0x01'u8, 0x00'u8, 0x00'u8, 0x40'u8, 0x00'u8, 0x01'u8, 0x00'u8, 0x61'u8, 0x00'u8, 0x00'u8, 0x00'u8, # SHDR....@...a...
    0x59'u8, 0x00'u8, 0x00'u8, 0x04'u8, 0x46'u8, 0x8e'u8, 0x20'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x84'u8, 0x00'u8, 0x00'u8, 0x00'u8, # Y...F. .........
    0x5f'u8, 0x00'u8, 0x00'u8, 0x03'u8, 0xf2'u8, 0x10'u8, 0x10'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x5f'u8, 0x00'u8, 0x00'u8, 0x03'u8, # _..........._...
    0x72'u8, 0x10'u8, 0x10'u8, 0x00'u8, 0x01'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x5f'u8, 0x00'u8, 0x00'u8, 0x03'u8, 0x72'u8, 0x10'u8, 0x10'u8, 0x00'u8, # r......._...r...
    0x02'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x67'u8, 0x00'u8, 0x00'u8, 0x04'u8, 0xf2'u8, 0x20'u8, 0x10'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x00'u8, # ....g.... ......
    0x01'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x65'u8, 0x00'u8, 0x00'u8, 0x03'u8, 0xf2'u8, 0x20'u8, 0x10'u8, 0x00'u8, 0x01'u8, 0x00'u8, 0x00'u8, 0x00'u8, # ....e.... ......
    0x65'u8, 0x00'u8, 0x00'u8, 0x03'u8, 0x72'u8, 0x20'u8, 0x10'u8, 0x00'u8, 0x02'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x68'u8, 0x00'u8, 0x00'u8, 0x02'u8, # e...r ......h...
    0x01'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x38'u8, 0x00'u8, 0x00'u8, 0x08'u8, 0xf2'u8, 0x00'u8, 0x10'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x00'u8, # ....8...........
    0x56'u8, 0x15'u8, 0x10'u8, 0x00'u8, 0x02'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x46'u8, 0x8e'u8, 0x20'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x00'u8, # V.......F. .....
    0x81'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x32'u8, 0x00'u8, 0x00'u8, 0x0a'u8, 0xf2'u8, 0x00'u8, 0x10'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x00'u8, # ....2...........
    0x46'u8, 0x8e'u8, 0x20'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x80'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x06'u8, 0x10'u8, 0x10'u8, 0x00'u8, # F. .............
    0x02'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x46'u8, 0x0e'u8, 0x10'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x32'u8, 0x00'u8, 0x00'u8, 0x0a'u8, # ....F.......2...
    0xf2'u8, 0x00'u8, 0x10'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x46'u8, 0x8e'u8, 0x20'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x00'u8, # ........F. .....
    0x82'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0xa6'u8, 0x1a'u8, 0x10'u8, 0x00'u8, 0x02'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x46'u8, 0x0e'u8, 0x10'u8, 0x00'u8, # ............F...
    0x00'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x08'u8, 0xf2'u8, 0x20'u8, 0x10'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x00'u8, # ......... ......
    0x46'u8, 0x0e'u8, 0x10'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x46'u8, 0x8e'u8, 0x20'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x00'u8, # F.......F. .....
    0x83'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x36'u8, 0x00'u8, 0x00'u8, 0x05'u8, 0xf2'u8, 0x20'u8, 0x10'u8, 0x00'u8, 0x01'u8, 0x00'u8, 0x00'u8, 0x00'u8, # ....6.... ......
    0x46'u8, 0x1e'u8, 0x10'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x38'u8, 0x00'u8, 0x00'u8, 0x08'u8, 0x72'u8, 0x00'u8, 0x10'u8, 0x00'u8, # F.......8...r...
    0x00'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x56'u8, 0x15'u8, 0x10'u8, 0x00'u8, 0x01'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x46'u8, 0x82'u8, 0x20'u8, 0x00'u8, # ....V.......F. .
    0x00'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x01'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x32'u8, 0x00'u8, 0x00'u8, 0x0a'u8, 0x72'u8, 0x00'u8, 0x10'u8, 0x00'u8, # ........2...r...
    0x00'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x46'u8, 0x82'u8, 0x20'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x00'u8, # ....F. .........
    0x06'u8, 0x10'u8, 0x10'u8, 0x00'u8, 0x01'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x46'u8, 0x02'u8, 0x10'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x00'u8, # ........F.......
    0x32'u8, 0x00'u8, 0x00'u8, 0x0a'u8, 0x72'u8, 0x20'u8, 0x10'u8, 0x00'u8, 0x02'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x46'u8, 0x82'u8, 0x20'u8, 0x00'u8, # 2...r ......F. .
    0x00'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x02'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0xa6'u8, 0x1a'u8, 0x10'u8, 0x00'u8, 0x01'u8, 0x00'u8, 0x00'u8, 0x00'u8, # ................
    0x46'u8, 0x02'u8, 0x10'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x3e'u8, 0x00'u8, 0x00'u8, 0x01'u8, 0x00'u8, 0x03'u8, 0x05'u8, 0x00'u8, # F.......>.......
    0x02'u8, 0x00'u8, 0x01'u8, 0x00'u8, 0x40'u8, 0x08'u8]                                                                                           # ....@.
vs_metaballs["mtl"] = @[
    0x56'u8, 0x53'u8, 0x48'u8, 0x04'u8, 0x03'u8, 0x2c'u8, 0xf5'u8, 0x3f'u8, 0x02'u8, 0x00'u8, 0x07'u8, 0x75'u8, 0x5f'u8, 0x6d'u8, 0x6f'u8, 0x64'u8, # VSH..,.?...u_mod
    0x65'u8, 0x6c'u8, 0x04'u8, 0x20'u8, 0x00'u8, 0x00'u8, 0x20'u8, 0x00'u8, 0x0f'u8, 0x75'u8, 0x5f'u8, 0x6d'u8, 0x6f'u8, 0x64'u8, 0x65'u8, 0x6c'u8, # el. .. ..u_model
    0x56'u8, 0x69'u8, 0x65'u8, 0x77'u8, 0x50'u8, 0x72'u8, 0x6f'u8, 0x6a'u8, 0x04'u8, 0x01'u8, 0x00'u8, 0x00'u8, 0x01'u8, 0x00'u8, 0x50'u8, 0x03'u8, # ViewProj......P.
    0x00'u8, 0x00'u8, 0x75'u8, 0x73'u8, 0x69'u8, 0x6e'u8, 0x67'u8, 0x20'u8, 0x6e'u8, 0x61'u8, 0x6d'u8, 0x65'u8, 0x73'u8, 0x70'u8, 0x61'u8, 0x63'u8, # ..using namespac
    0x65'u8, 0x20'u8, 0x6d'u8, 0x65'u8, 0x74'u8, 0x61'u8, 0x6c'u8, 0x3b'u8, 0x0a'u8, 0x73'u8, 0x74'u8, 0x72'u8, 0x75'u8, 0x63'u8, 0x74'u8, 0x20'u8, # e metal;.struct 
    0x78'u8, 0x6c'u8, 0x61'u8, 0x74'u8, 0x4d'u8, 0x74'u8, 0x6c'u8, 0x53'u8, 0x68'u8, 0x61'u8, 0x64'u8, 0x65'u8, 0x72'u8, 0x49'u8, 0x6e'u8, 0x70'u8, # xlatMtlShaderInp
    0x75'u8, 0x74'u8, 0x20'u8, 0x7b'u8, 0x0a'u8, 0x20'u8, 0x20'u8, 0x66'u8, 0x6c'u8, 0x6f'u8, 0x61'u8, 0x74'u8, 0x34'u8, 0x20'u8, 0x61'u8, 0x5f'u8, # ut {.  float4 a_
    0x63'u8, 0x6f'u8, 0x6c'u8, 0x6f'u8, 0x72'u8, 0x30'u8, 0x20'u8, 0x5b'u8, 0x5b'u8, 0x61'u8, 0x74'u8, 0x74'u8, 0x72'u8, 0x69'u8, 0x62'u8, 0x75'u8, # color0 [[attribu
    0x74'u8, 0x65'u8, 0x28'u8, 0x30'u8, 0x29'u8, 0x5d'u8, 0x5d'u8, 0x3b'u8, 0x0a'u8, 0x20'u8, 0x20'u8, 0x66'u8, 0x6c'u8, 0x6f'u8, 0x61'u8, 0x74'u8, # te(0)]];.  float
    0x33'u8, 0x20'u8, 0x61'u8, 0x5f'u8, 0x6e'u8, 0x6f'u8, 0x72'u8, 0x6d'u8, 0x61'u8, 0x6c'u8, 0x20'u8, 0x5b'u8, 0x5b'u8, 0x61'u8, 0x74'u8, 0x74'u8, # 3 a_normal [[att
    0x72'u8, 0x69'u8, 0x62'u8, 0x75'u8, 0x74'u8, 0x65'u8, 0x28'u8, 0x31'u8, 0x29'u8, 0x5d'u8, 0x5d'u8, 0x3b'u8, 0x0a'u8, 0x20'u8, 0x20'u8, 0x66'u8, # ribute(1)]];.  f
    0x6c'u8, 0x6f'u8, 0x61'u8, 0x74'u8, 0x33'u8, 0x20'u8, 0x61'u8, 0x5f'u8, 0x70'u8, 0x6f'u8, 0x73'u8, 0x69'u8, 0x74'u8, 0x69'u8, 0x6f'u8, 0x6e'u8, # loat3 a_position
    0x20'u8, 0x5b'u8, 0x5b'u8, 0x61'u8, 0x74'u8, 0x74'u8, 0x72'u8, 0x69'u8, 0x62'u8, 0x75'u8, 0x74'u8, 0x65'u8, 0x28'u8, 0x32'u8, 0x29'u8, 0x5d'u8, #  [[attribute(2)]
    0x5d'u8, 0x3b'u8, 0x0a'u8, 0x7d'u8, 0x3b'u8, 0x0a'u8, 0x73'u8, 0x74'u8, 0x72'u8, 0x75'u8, 0x63'u8, 0x74'u8, 0x20'u8, 0x78'u8, 0x6c'u8, 0x61'u8, # ];.};.struct xla
    0x74'u8, 0x4d'u8, 0x74'u8, 0x6c'u8, 0x53'u8, 0x68'u8, 0x61'u8, 0x64'u8, 0x65'u8, 0x72'u8, 0x4f'u8, 0x75'u8, 0x74'u8, 0x70'u8, 0x75'u8, 0x74'u8, # tMtlShaderOutput
    0x20'u8, 0x7b'u8, 0x0a'u8, 0x20'u8, 0x20'u8, 0x66'u8, 0x6c'u8, 0x6f'u8, 0x61'u8, 0x74'u8, 0x34'u8, 0x20'u8, 0x67'u8, 0x6c'u8, 0x5f'u8, 0x50'u8, #  {.  float4 gl_P
    0x6f'u8, 0x73'u8, 0x69'u8, 0x74'u8, 0x69'u8, 0x6f'u8, 0x6e'u8, 0x20'u8, 0x5b'u8, 0x5b'u8, 0x70'u8, 0x6f'u8, 0x73'u8, 0x69'u8, 0x74'u8, 0x69'u8, # osition [[positi
    0x6f'u8, 0x6e'u8, 0x5d'u8, 0x5d'u8, 0x3b'u8, 0x0a'u8, 0x20'u8, 0x20'u8, 0x66'u8, 0x6c'u8, 0x6f'u8, 0x61'u8, 0x74'u8, 0x34'u8, 0x20'u8, 0x76'u8, # on]];.  float4 v
    0x5f'u8, 0x63'u8, 0x6f'u8, 0x6c'u8, 0x6f'u8, 0x72'u8, 0x30'u8, 0x3b'u8, 0x0a'u8, 0x20'u8, 0x20'u8, 0x66'u8, 0x6c'u8, 0x6f'u8, 0x61'u8, 0x74'u8, # _color0;.  float
    0x33'u8, 0x20'u8, 0x76'u8, 0x5f'u8, 0x6e'u8, 0x6f'u8, 0x72'u8, 0x6d'u8, 0x61'u8, 0x6c'u8, 0x3b'u8, 0x0a'u8, 0x7d'u8, 0x3b'u8, 0x0a'u8, 0x73'u8, # 3 v_normal;.};.s
    0x74'u8, 0x72'u8, 0x75'u8, 0x63'u8, 0x74'u8, 0x20'u8, 0x78'u8, 0x6c'u8, 0x61'u8, 0x74'u8, 0x4d'u8, 0x74'u8, 0x6c'u8, 0x53'u8, 0x68'u8, 0x61'u8, # truct xlatMtlSha
    0x64'u8, 0x65'u8, 0x72'u8, 0x55'u8, 0x6e'u8, 0x69'u8, 0x66'u8, 0x6f'u8, 0x72'u8, 0x6d'u8, 0x20'u8, 0x7b'u8, 0x0a'u8, 0x20'u8, 0x20'u8, 0x66'u8, # derUniform {.  f
    0x6c'u8, 0x6f'u8, 0x61'u8, 0x74'u8, 0x34'u8, 0x78'u8, 0x34'u8, 0x20'u8, 0x75'u8, 0x5f'u8, 0x6d'u8, 0x6f'u8, 0x64'u8, 0x65'u8, 0x6c'u8, 0x5b'u8, # loat4x4 u_model[
    0x33'u8, 0x32'u8, 0x5d'u8, 0x3b'u8, 0x0a'u8, 0x20'u8, 0x20'u8, 0x66'u8, 0x6c'u8, 0x6f'u8, 0x61'u8, 0x74'u8, 0x34'u8, 0x78'u8, 0x34'u8, 0x20'u8, # 32];.  float4x4 
    0x75'u8, 0x5f'u8, 0x6d'u8, 0x6f'u8, 0x64'u8, 0x65'u8, 0x6c'u8, 0x56'u8, 0x69'u8, 0x65'u8, 0x77'u8, 0x50'u8, 0x72'u8, 0x6f'u8, 0x6a'u8, 0x3b'u8, # u_modelViewProj;
    0x0a'u8, 0x7d'u8, 0x3b'u8, 0x0a'u8, 0x76'u8, 0x65'u8, 0x72'u8, 0x74'u8, 0x65'u8, 0x78'u8, 0x20'u8, 0x78'u8, 0x6c'u8, 0x61'u8, 0x74'u8, 0x4d'u8, # .};.vertex xlatM
    0x74'u8, 0x6c'u8, 0x53'u8, 0x68'u8, 0x61'u8, 0x64'u8, 0x65'u8, 0x72'u8, 0x4f'u8, 0x75'u8, 0x74'u8, 0x70'u8, 0x75'u8, 0x74'u8, 0x20'u8, 0x78'u8, # tlShaderOutput x
    0x6c'u8, 0x61'u8, 0x74'u8, 0x4d'u8, 0x74'u8, 0x6c'u8, 0x4d'u8, 0x61'u8, 0x69'u8, 0x6e'u8, 0x20'u8, 0x28'u8, 0x78'u8, 0x6c'u8, 0x61'u8, 0x74'u8, # latMtlMain (xlat
    0x4d'u8, 0x74'u8, 0x6c'u8, 0x53'u8, 0x68'u8, 0x61'u8, 0x64'u8, 0x65'u8, 0x72'u8, 0x49'u8, 0x6e'u8, 0x70'u8, 0x75'u8, 0x74'u8, 0x20'u8, 0x5f'u8, # MtlShaderInput _
    0x6d'u8, 0x74'u8, 0x6c'u8, 0x5f'u8, 0x69'u8, 0x20'u8, 0x5b'u8, 0x5b'u8, 0x73'u8, 0x74'u8, 0x61'u8, 0x67'u8, 0x65'u8, 0x5f'u8, 0x69'u8, 0x6e'u8, # mtl_i [[stage_in
    0x5d'u8, 0x5d'u8, 0x2c'u8, 0x20'u8, 0x63'u8, 0x6f'u8, 0x6e'u8, 0x73'u8, 0x74'u8, 0x61'u8, 0x6e'u8, 0x74'u8, 0x20'u8, 0x78'u8, 0x6c'u8, 0x61'u8, # ]], constant xla
    0x74'u8, 0x4d'u8, 0x74'u8, 0x6c'u8, 0x53'u8, 0x68'u8, 0x61'u8, 0x64'u8, 0x65'u8, 0x72'u8, 0x55'u8, 0x6e'u8, 0x69'u8, 0x66'u8, 0x6f'u8, 0x72'u8, # tMtlShaderUnifor
    0x6d'u8, 0x26'u8, 0x20'u8, 0x5f'u8, 0x6d'u8, 0x74'u8, 0x6c'u8, 0x5f'u8, 0x75'u8, 0x20'u8, 0x5b'u8, 0x5b'u8, 0x62'u8, 0x75'u8, 0x66'u8, 0x66'u8, # m& _mtl_u [[buff
    0x65'u8, 0x72'u8, 0x28'u8, 0x30'u8, 0x29'u8, 0x5d'u8, 0x5d'u8, 0x29'u8, 0x0a'u8, 0x7b'u8, 0x0a'u8, 0x20'u8, 0x20'u8, 0x78'u8, 0x6c'u8, 0x61'u8, # er(0)]]).{.  xla
    0x74'u8, 0x4d'u8, 0x74'u8, 0x6c'u8, 0x53'u8, 0x68'u8, 0x61'u8, 0x64'u8, 0x65'u8, 0x72'u8, 0x4f'u8, 0x75'u8, 0x74'u8, 0x70'u8, 0x75'u8, 0x74'u8, # tMtlShaderOutput
    0x20'u8, 0x5f'u8, 0x6d'u8, 0x74'u8, 0x6c'u8, 0x5f'u8, 0x6f'u8, 0x3b'u8, 0x0a'u8, 0x20'u8, 0x20'u8, 0x66'u8, 0x6c'u8, 0x6f'u8, 0x61'u8, 0x74'u8, #  _mtl_o;.  float
    0x34'u8, 0x20'u8, 0x74'u8, 0x6d'u8, 0x70'u8, 0x76'u8, 0x61'u8, 0x72'u8, 0x5f'u8, 0x31'u8, 0x20'u8, 0x3d'u8, 0x20'u8, 0x30'u8, 0x3b'u8, 0x0a'u8, # 4 tmpvar_1 = 0;.
    0x20'u8, 0x20'u8, 0x74'u8, 0x6d'u8, 0x70'u8, 0x76'u8, 0x61'u8, 0x72'u8, 0x5f'u8, 0x31'u8, 0x2e'u8, 0x77'u8, 0x20'u8, 0x3d'u8, 0x20'u8, 0x31'u8, #   tmpvar_1.w = 1
    0x2e'u8, 0x30'u8, 0x3b'u8, 0x0a'u8, 0x20'u8, 0x20'u8, 0x74'u8, 0x6d'u8, 0x70'u8, 0x76'u8, 0x61'u8, 0x72'u8, 0x5f'u8, 0x31'u8, 0x2e'u8, 0x78'u8, # .0;.  tmpvar_1.x
    0x79'u8, 0x7a'u8, 0x20'u8, 0x3d'u8, 0x20'u8, 0x5f'u8, 0x6d'u8, 0x74'u8, 0x6c'u8, 0x5f'u8, 0x69'u8, 0x2e'u8, 0x61'u8, 0x5f'u8, 0x70'u8, 0x6f'u8, # yz = _mtl_i.a_po
    0x73'u8, 0x69'u8, 0x74'u8, 0x69'u8, 0x6f'u8, 0x6e'u8, 0x3b'u8, 0x0a'u8, 0x20'u8, 0x20'u8, 0x5f'u8, 0x6d'u8, 0x74'u8, 0x6c'u8, 0x5f'u8, 0x6f'u8, # sition;.  _mtl_o
    0x2e'u8, 0x67'u8, 0x6c'u8, 0x5f'u8, 0x50'u8, 0x6f'u8, 0x73'u8, 0x69'u8, 0x74'u8, 0x69'u8, 0x6f'u8, 0x6e'u8, 0x20'u8, 0x3d'u8, 0x20'u8, 0x28'u8, # .gl_Position = (
    0x5f'u8, 0x6d'u8, 0x74'u8, 0x6c'u8, 0x5f'u8, 0x75'u8, 0x2e'u8, 0x75'u8, 0x5f'u8, 0x6d'u8, 0x6f'u8, 0x64'u8, 0x65'u8, 0x6c'u8, 0x56'u8, 0x69'u8, # _mtl_u.u_modelVi
    0x65'u8, 0x77'u8, 0x50'u8, 0x72'u8, 0x6f'u8, 0x6a'u8, 0x20'u8, 0x2a'u8, 0x20'u8, 0x74'u8, 0x6d'u8, 0x70'u8, 0x76'u8, 0x61'u8, 0x72'u8, 0x5f'u8, # ewProj * tmpvar_
    0x31'u8, 0x29'u8, 0x3b'u8, 0x0a'u8, 0x20'u8, 0x20'u8, 0x66'u8, 0x6c'u8, 0x6f'u8, 0x61'u8, 0x74'u8, 0x34'u8, 0x20'u8, 0x74'u8, 0x6d'u8, 0x70'u8, # 1);.  float4 tmp
    0x76'u8, 0x61'u8, 0x72'u8, 0x5f'u8, 0x32'u8, 0x20'u8, 0x3d'u8, 0x20'u8, 0x30'u8, 0x3b'u8, 0x0a'u8, 0x20'u8, 0x20'u8, 0x74'u8, 0x6d'u8, 0x70'u8, # var_2 = 0;.  tmp
    0x76'u8, 0x61'u8, 0x72'u8, 0x5f'u8, 0x32'u8, 0x2e'u8, 0x77'u8, 0x20'u8, 0x3d'u8, 0x20'u8, 0x30'u8, 0x2e'u8, 0x30'u8, 0x3b'u8, 0x0a'u8, 0x20'u8, # var_2.w = 0.0;. 
    0x20'u8, 0x74'u8, 0x6d'u8, 0x70'u8, 0x76'u8, 0x61'u8, 0x72'u8, 0x5f'u8, 0x32'u8, 0x2e'u8, 0x78'u8, 0x79'u8, 0x7a'u8, 0x20'u8, 0x3d'u8, 0x20'u8, #  tmpvar_2.xyz = 
    0x5f'u8, 0x6d'u8, 0x74'u8, 0x6c'u8, 0x5f'u8, 0x69'u8, 0x2e'u8, 0x61'u8, 0x5f'u8, 0x6e'u8, 0x6f'u8, 0x72'u8, 0x6d'u8, 0x61'u8, 0x6c'u8, 0x3b'u8, # _mtl_i.a_normal;
    0x0a'u8, 0x20'u8, 0x20'u8, 0x5f'u8, 0x6d'u8, 0x74'u8, 0x6c'u8, 0x5f'u8, 0x6f'u8, 0x2e'u8, 0x76'u8, 0x5f'u8, 0x6e'u8, 0x6f'u8, 0x72'u8, 0x6d'u8, # .  _mtl_o.v_norm
    0x61'u8, 0x6c'u8, 0x20'u8, 0x3d'u8, 0x20'u8, 0x28'u8, 0x5f'u8, 0x6d'u8, 0x74'u8, 0x6c'u8, 0x5f'u8, 0x75'u8, 0x2e'u8, 0x75'u8, 0x5f'u8, 0x6d'u8, # al = (_mtl_u.u_m
    0x6f'u8, 0x64'u8, 0x65'u8, 0x6c'u8, 0x5b'u8, 0x30'u8, 0x5d'u8, 0x20'u8, 0x2a'u8, 0x20'u8, 0x74'u8, 0x6d'u8, 0x70'u8, 0x76'u8, 0x61'u8, 0x72'u8, # odel[0] * tmpvar
    0x5f'u8, 0x32'u8, 0x29'u8, 0x2e'u8, 0x78'u8, 0x79'u8, 0x7a'u8, 0x3b'u8, 0x0a'u8, 0x20'u8, 0x20'u8, 0x5f'u8, 0x6d'u8, 0x74'u8, 0x6c'u8, 0x5f'u8, # _2).xyz;.  _mtl_
    0x6f'u8, 0x2e'u8, 0x76'u8, 0x5f'u8, 0x63'u8, 0x6f'u8, 0x6c'u8, 0x6f'u8, 0x72'u8, 0x30'u8, 0x20'u8, 0x3d'u8, 0x20'u8, 0x5f'u8, 0x6d'u8, 0x74'u8, # o.v_color0 = _mt
    0x6c'u8, 0x5f'u8, 0x69'u8, 0x2e'u8, 0x61'u8, 0x5f'u8, 0x63'u8, 0x6f'u8, 0x6c'u8, 0x6f'u8, 0x72'u8, 0x30'u8, 0x3b'u8, 0x0a'u8, 0x20'u8, 0x20'u8, # l_i.a_color0;.  
    0x72'u8, 0x65'u8, 0x74'u8, 0x75'u8, 0x72'u8, 0x6e'u8, 0x20'u8, 0x5f'u8, 0x6d'u8, 0x74'u8, 0x6c'u8, 0x5f'u8, 0x6f'u8, 0x3b'u8, 0x0a'u8, 0x7d'u8, # return _mtl_o;.}
    0x0a'u8, 0x0a'u8, 0x00'u8]                                                                                                                      # ...
