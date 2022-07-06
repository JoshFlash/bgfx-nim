##  BGFX Copyright Notice
##  Copyright 2011-2022 Branimir Karadzic. All rights reserved.
##  License: https://github.com/bkaradzic/bgfx/blob/master/LICENSE
##

const
  BGFX_API_VERSION* = (115)

## *
##  Color RGB/alpha/depth write. When it's not specified write will be disabled.
##
##

const
  BGFX_STATE_WRITE_R* = (0x0000000000000001'u64) ## !< Enable R write.
  BGFX_STATE_WRITE_G* = (0x0000000000000002'u64) ## !< Enable G write.
  BGFX_STATE_WRITE_B* = (0x0000000000000004'u64) ## !< Enable B write.
  BGFX_STATE_WRITE_A* = (0x0000000000000008'u64) ## !< Enable alpha write.
  BGFX_STATE_WRITE_Z* = (0x0000004000000000'u64) ## !< Enable depth write.
                                                      ## / Enable RGB write.
  BGFX_STATE_WRITE_RGB* = (
    0 or BGFX_STATE_WRITE_R or BGFX_STATE_WRITE_G or BGFX_STATE_WRITE_B)

## / Write all channels mask.

const
  BGFX_STATE_WRITE_MASK* = (
    0 or BGFX_STATE_WRITE_RGB or BGFX_STATE_WRITE_A or BGFX_STATE_WRITE_Z)

## *
##  Depth test state. When `BGFX_STATE_DEPTH_` is not specified depth test will be disabled.
##
##

const
  BGFX_STATE_DEPTH_TEST_LESS* = (0x0000000000000010'u64) ## !< Enable depth test, less.
  BGFX_STATE_DEPTH_TEST_LEQUAL* = (0x0000000000000020'u64) ## !< Enable depth test, less or equal.
  BGFX_STATE_DEPTH_TEST_EQUAL* = (0x0000000000000030'u64) ## !< Enable depth test, equal.
  BGFX_STATE_DEPTH_TEST_GEQUAL* = (0x0000000000000040'u64) ## !< Enable depth test, greater or equal.
  BGFX_STATE_DEPTH_TEST_GREATER* = (0x0000000000000050'u64) ## !< Enable depth test, greater.
  BGFX_STATE_DEPTH_TEST_NOTEQUAL* = (0x0000000000000060'u64) ## !< Enable depth test, not equal.
  BGFX_STATE_DEPTH_TEST_NEVER* = (0x0000000000000070'u64) ## !< Enable depth test, never.
  BGFX_STATE_DEPTH_TEST_ALWAYS* = (0x0000000000000080'u64) ## !< Enable depth test, always.
  BGFX_STATE_DEPTH_TEST_SHIFT* = 4
  BGFX_STATE_DEPTH_TEST_MASK* = (0x00000000000000f0'u64) ## !< Depth test state bit mask

## *
##  Use BGFX_STATE_BLEND_FUNC(_src, _dst) or BGFX_STATE_BLEND_FUNC_SEPARATE(_srcRGB, _dstRGB, _srcA, _dstA)
##  helper macros.
##
##

const
  BGFX_STATE_BLEND_ZERO* = (0x0000000000001000'u64) ## !< 0, 0, 0, 0
  BGFX_STATE_BLEND_ONE* = (0x0000000000002000'u64) ## !< 1, 1, 1, 1
  BGFX_STATE_BLEND_SRC_COLOR* = (0x0000000000003000'u64) ## !< Rs, Gs, Bs, As
  BGFX_STATE_BLEND_INV_SRC_COLOR* = (0x0000000000004000'u64) ## !< 1-Rs, 1-Gs, 1-Bs, 1-As
  BGFX_STATE_BLEND_SRC_ALPHA* = (0x0000000000005000'u64) ## !< As, As, As, As
  BGFX_STATE_BLEND_INV_SRC_ALPHA* = (0x0000000000006000'u64) ## !< 1-As, 1-As, 1-As, 1-As
  BGFX_STATE_BLEND_DST_ALPHA* = (0x0000000000007000'u64) ## !< Ad, Ad, Ad, Ad
  BGFX_STATE_BLEND_INV_DST_ALPHA* = (0x0000000000008000'u64) ## !< 1-Ad, 1-Ad, 1-Ad ,1-Ad
  BGFX_STATE_BLEND_DST_COLOR* = (0x0000000000009000'u64) ## !< Rd, Gd, Bd, Ad
  BGFX_STATE_BLEND_INV_DST_COLOR* = (0x000000000000a000'u64) ## !< 1-Rd, 1-Gd, 1-Bd, 1-Ad
  BGFX_STATE_BLEND_SRC_ALPHA_SAT* = (0x000000000000b000'u64) ## !< f, f, f, 1; f = min(As, 1-Ad)
  BGFX_STATE_BLEND_FACTOR* = (0x000000000000c000'u64) ## !< Blend factor
  BGFX_STATE_BLEND_INV_FACTOR* = (0x000000000000d000'u64) ## !< 1-Blend factor
  BGFX_STATE_BLEND_SHIFT* = 12
  BGFX_STATE_BLEND_MASK* = (0x000000000ffff000'u64) ## !< Blend state bit mask

## *
##  Use BGFX_STATE_BLEND_EQUATION(_equation) or BGFX_STATE_BLEND_EQUATION_SEPARATE(_equationRGB, _equationA)
##  helper macros.
##
##

const
  BGFX_STATE_BLEND_EQUATION_ADD* = (0x0000000000000000'u64) ## !< Blend add: src + dst.
  BGFX_STATE_BLEND_EQUATION_SUB* = (0x0000000010000000'u64) ## !< Blend subtract: src - dst.
  BGFX_STATE_BLEND_EQUATION_REVSUB* = (0x0000000020000000'u64) ## !< Blend reverse subtract: dst - src.
  BGFX_STATE_BLEND_EQUATION_MIN* = (0x0000000030000000'u64) ## !< Blend min: min(src, dst).
  BGFX_STATE_BLEND_EQUATION_MAX* = (0x0000000040000000'u64) ## !< Blend max: max(src, dst).
  BGFX_STATE_BLEND_EQUATION_SHIFT* = 28
  BGFX_STATE_BLEND_EQUATION_MASK* = (0x00000003f0000000'u64) ## !< Blend equation bit mask

## *
##  Cull state. When `BGFX_STATE_CULL_*` is not specified culling will be disabled.
##
##

const
  BGFX_STATE_CULL_CW* = (0x0000001000000000'u64) ## !< Cull clockwise triangles.
  BGFX_STATE_CULL_CCW* = (0x0000002000000000'u64) ## !< Cull counter-clockwise triangles.
  BGFX_STATE_CULL_SHIFT* = 36
  BGFX_STATE_CULL_MASK* = (0x0000003000000000'u64) ## !< Culling mode bit mask

## *
##  Alpha reference value.
##
##

const
  BGFX_STATE_ALPHA_REF_SHIFT* = 40
  BGFX_STATE_ALPHA_REF_MASK* = (0x0000ff0000000000'u64) ## !< Alpha reference bit mask

template BGFX_STATE_ALPHA_REF*(v: untyped): untyped =
  (((uint64_t)(v) shl BGFX_STATE_ALPHA_REF_SHIFT) and BGFX_STATE_ALPHA_REF_MASK)

const
  BGFX_STATE_PT_TRISTRIP* = (0x0001000000000000'u64) ## !< Tristrip.
  BGFX_STATE_PT_LINES* = (0x0002000000000000'u64) ## !< Lines.
  BGFX_STATE_PT_LINESTRIP* = (0x0003000000000000'u64) ## !< Line strip.
  BGFX_STATE_PT_POINTS* = (0x0004000000000000'u64) ## !< Points.
  BGFX_STATE_PT_SHIFT* = 48
  BGFX_STATE_PT_MASK* = (0x0007000000000000'u64) ## !< Primitive type bit mask

## *
##  Point size value.
##
##

const
  BGFX_STATE_POINT_SIZE_SHIFT* = 52
  BGFX_STATE_POINT_SIZE_MASK* = (0x00f0000000000000'u64) ## !< Point size bit mask

template BGFX_STATE_POINT_SIZE*(v: untyped): untyped =
  (((uint64_t)(v) shl BGFX_STATE_POINT_SIZE_SHIFT) and
      BGFX_STATE_POINT_SIZE_MASK)

## *
##  Enable MSAA write when writing into MSAA frame buffer.
##  This flag is ignored when not writing into MSAA frame buffer.
##
##

const
  BGFX_STATE_MSAA* = (0x0100000000000000'u64) ## !< Enable MSAA rasterization.
  BGFX_STATE_LINEAA* = (0x0200000000000000'u64) ## !< Enable line AA rasterization.
  BGFX_STATE_CONSERVATIVE_RASTER* = (0x0400000000000000'u64) ## !< Enable conservative rasterization.
  BGFX_STATE_NONE* = (0x0000000000000000'u64) ## !< No state.
  BGFX_STATE_FRONT_CCW* = (0x0000008000000000'u64) ## !< Front counter-clockwise (default is clockwise).
  BGFX_STATE_BLEND_INDEPENDENT* = (0x0000000400000000'u64) ## !< Enable blend independent.
  BGFX_STATE_BLEND_ALPHA_TO_COVERAGE* = (0x0000000800000000'u64) ## !< Enable alpha to coverage.
                                                                      ## / Default state is write to RGB, alpha, and depth with depth test less enabled, with clockwise
                                                                      ## / culling and MSAA (when writing into MSAA frame buffer, otherwise this flag is ignored).
  BGFX_STATE_DEFAULT* = (0 or BGFX_STATE_WRITE_RGB or BGFX_STATE_WRITE_A or
      BGFX_STATE_WRITE_Z or BGFX_STATE_DEPTH_TEST_LESS or BGFX_STATE_CULL_CW or
      BGFX_STATE_MSAA)
  BGFX_STATE_MASK* = (0xffffffffffffffff'u64) ## !< State bit mask

## *
##  Do not use!
##
##

const
  BGFX_STATE_RESERVED_SHIFT* = 61
  BGFX_STATE_RESERVED_MASK* = (0xe000000000000000'u64)

## *
##  Set stencil ref value.
##
##

const
  BGFX_STENCIL_FUNC_REF_SHIFT* = 0
  BGFX_STENCIL_FUNC_REF_MASK* = (0x000000ff)

template BGFX_STENCIL_FUNC_REF*(v: untyped): untyped =
  (((uint32)(v) shl BGFX_STENCIL_FUNC_REF_SHIFT) and
      BGFX_STENCIL_FUNC_REF_MASK)

## *
##  Set stencil rmask value.
##
##

const
  BGFX_STENCIL_FUNC_RMASK_SHIFT* = 8
  BGFX_STENCIL_FUNC_RMASK_MASK* = (0x0000ff00)

template BGFX_STENCIL_FUNC_RMASK*(v: untyped): untyped =
  (((uint32)(v) shl BGFX_STENCIL_FUNC_RMASK_SHIFT) and
      BGFX_STENCIL_FUNC_RMASK_MASK)

const
  BGFX_STENCIL_NONE* = (0x00000000'u32)
  BGFX_STENCIL_MASK* = (0xffffffff'u32)
  BGFX_STENCIL_DEFAULT* = (0x00000000'u32)
  BGFX_STENCIL_TEST_LESS* = (0x00010000'u32) ## !< Enable stencil test, less.
  BGFX_STENCIL_TEST_LEQUAL* = (0x00020000'u32) ## !< Enable stencil test, less or equal.
  BGFX_STENCIL_TEST_EQUAL* = (0x00030000'u32) ## !< Enable stencil test, equal.
  BGFX_STENCIL_TEST_GEQUAL* = (0x00040000'u32) ## !< Enable stencil test, greater or equal.
  BGFX_STENCIL_TEST_GREATER* = (0x00050000'u32) ## !< Enable stencil test, greater.
  BGFX_STENCIL_TEST_NOTEQUAL* = (0x00060000'u32) ## !< Enable stencil test, not equal.
  BGFX_STENCIL_TEST_NEVER* = (0x00070000'u32) ## !< Enable stencil test, never.
  BGFX_STENCIL_TEST_ALWAYS* = (0x00080000'u32) ## !< Enable stencil test, always.
  BGFX_STENCIL_TEST_SHIFT* = 16
  BGFX_STENCIL_TEST_MASK* = (0x000f0000'u32) ## !< Stencil test bit mask
  BGFX_STENCIL_OP_FAIL_S_ZERO* = (0x00000000'u32) ## !< Zero.
  BGFX_STENCIL_OP_FAIL_S_KEEP* = (0x00100000'u32) ## !< Keep.
  BGFX_STENCIL_OP_FAIL_S_REPLACE* = (0x00200000'u32) ## !< Replace.
  BGFX_STENCIL_OP_FAIL_S_INCR* = (0x00300000'u32) ## !< Increment and wrap.
  BGFX_STENCIL_OP_FAIL_S_INCRSAT* = (0x00400000'u32) ## !< Increment and clamp.
  BGFX_STENCIL_OP_FAIL_S_DECR* = (0x00500000'u32) ## !< Decrement and wrap.
  BGFX_STENCIL_OP_FAIL_S_DECRSAT* = (0x00600000'u32) ## !< Decrement and clamp.
  BGFX_STENCIL_OP_FAIL_S_INVERT* = (0x00700000'u32) ## !< Invert.
  BGFX_STENCIL_OP_FAIL_S_SHIFT* = 20
  BGFX_STENCIL_OP_FAIL_S_MASK* = (0x00f00000'u32) ## !< Stencil operation fail bit mask
  BGFX_STENCIL_OP_FAIL_Z_ZERO* = (0x00000000'u32) ## !< Zero.
  BGFX_STENCIL_OP_FAIL_Z_KEEP* = (0x01000000'u32) ## !< Keep.
  BGFX_STENCIL_OP_FAIL_Z_REPLACE* = (0x02000000'u32) ## !< Replace.
  BGFX_STENCIL_OP_FAIL_Z_INCR* = (0x03000000'u32) ## !< Increment and wrap.
  BGFX_STENCIL_OP_FAIL_Z_INCRSAT* = (0x04000000'u32) ## !< Increment and clamp.
  BGFX_STENCIL_OP_FAIL_Z_DECR* = (0x05000000'u32) ## !< Decrement and wrap.
  BGFX_STENCIL_OP_FAIL_Z_DECRSAT* = (0x06000000'u32) ## !< Decrement and clamp.
  BGFX_STENCIL_OP_FAIL_Z_INVERT* = (0x07000000'u32) ## !< Invert.
  BGFX_STENCIL_OP_FAIL_Z_SHIFT* = 24
  BGFX_STENCIL_OP_FAIL_Z_MASK* = (0x0f000000'u32) ## !< Stencil operation depth fail bit mask
  BGFX_STENCIL_OP_PASS_Z_ZERO* = (0x00000000'u32) ## !< Zero.
  BGFX_STENCIL_OP_PASS_Z_KEEP* = (0x10000000'u32) ## !< Keep.
  BGFX_STENCIL_OP_PASS_Z_REPLACE* = (0x20000000'u32) ## !< Replace.
  BGFX_STENCIL_OP_PASS_Z_INCR* = (0x30000000'u32) ## !< Increment and wrap.
  BGFX_STENCIL_OP_PASS_Z_INCRSAT* = (0x40000000'u32) ## !< Increment and clamp.
  BGFX_STENCIL_OP_PASS_Z_DECR* = (0x50000000'u32) ## !< Decrement and wrap.
  BGFX_STENCIL_OP_PASS_Z_DECRSAT* = (0x60000000'u32) ## !< Decrement and clamp.
  BGFX_STENCIL_OP_PASS_Z_INVERT* = (0x70000000'u32) ## !< Invert.
  BGFX_STENCIL_OP_PASS_Z_SHIFT* = 28
  BGFX_STENCIL_OP_PASS_Z_MASK* = (0xf0000000'u32) ## !< Stencil operation depth pass bit mask
  BGFX_CLEAR_NONE* = (0x0000'u16) ## !< No clear flags.
  BGFX_CLEAR_COLOR* = (0x0001'u16) ## !< Clear color.
  BGFX_CLEAR_DEPTH* = (0x0002'u16) ## !< Clear depth.
  BGFX_CLEAR_STENCIL* = (0x0004'u16) ## !< Clear stencil.
  BGFX_CLEAR_DISCARD_COLOR_0* = (0x0008'u16) ## !< Discard frame buffer attachment 0.
  BGFX_CLEAR_DISCARD_COLOR_1* = (0x0010'u16) ## !< Discard frame buffer attachment 1.
  BGFX_CLEAR_DISCARD_COLOR_2* = (0x0020'u16) ## !< Discard frame buffer attachment 2.
  BGFX_CLEAR_DISCARD_COLOR_3* = (0x0040'u16) ## !< Discard frame buffer attachment 3.
  BGFX_CLEAR_DISCARD_COLOR_4* = (0x0080'u16) ## !< Discard frame buffer attachment 4.
  BGFX_CLEAR_DISCARD_COLOR_5* = (0x0100'u16) ## !< Discard frame buffer attachment 5.
  BGFX_CLEAR_DISCARD_COLOR_6* = (0x0200'u16) ## !< Discard frame buffer attachment 6.
  BGFX_CLEAR_DISCARD_COLOR_7* = (0x0400'u16) ## !< Discard frame buffer attachment 7.
  BGFX_CLEAR_DISCARD_DEPTH* = (0x0800'u16) ## !< Discard frame buffer depth attachment.
  BGFX_CLEAR_DISCARD_STENCIL* = (0x1000'u16) ## !< Discard frame buffer stencil attachment.
  BGFX_CLEAR_DISCARD_COLOR_MASK* = (0 or BGFX_CLEAR_DISCARD_COLOR_0 or
      BGFX_CLEAR_DISCARD_COLOR_1 or BGFX_CLEAR_DISCARD_COLOR_2 or
      BGFX_CLEAR_DISCARD_COLOR_3 or BGFX_CLEAR_DISCARD_COLOR_4 or
      BGFX_CLEAR_DISCARD_COLOR_5 or BGFX_CLEAR_DISCARD_COLOR_6 or
      BGFX_CLEAR_DISCARD_COLOR_7)
  BGFX_CLEAR_DISCARD_MASK* = (0 or BGFX_CLEAR_DISCARD_COLOR_MASK or
      BGFX_CLEAR_DISCARD_DEPTH or BGFX_CLEAR_DISCARD_STENCIL)

## *
##  Rendering state discard. When state is preserved in submit, rendering states can be discarded
##  on a finer grain.
##
##

const
  BGFX_DISCARD_NONE* = (0x00'u8) ## !< Preserve everything.
  BGFX_DISCARD_BINDINGS* = (0x01'u8) ## !< Discard texture sampler and buffer bindings.
  BGFX_DISCARD_INDEX_BUFFER* = (0x02'u8) ## !< Discard index buffer.
  BGFX_DISCARD_INSTANCE_DATA* = (0x04'u8) ## !< Discard instance data.
  BGFX_DISCARD_STATE* = (0x08'u8) ## !< Discard state and uniform bindings.
  BGFX_DISCARD_TRANSFORM* = (0x10'u8) ## !< Discard transform.
  BGFX_DISCARD_VERTEX_STREAMS* = (0x20'u8) ## !< Discard vertex streams.
  BGFX_DISCARD_ALL* = (0xff'u8) ## !< Discard all states.
  BGFX_DEBUG_NONE* = (0x00000000'u32) ## !< No debug.
  BGFX_DEBUG_WIREFRAME* = (0x00000001'u32) ## !< Enable wireframe for all primitives.

## / Enable infinitely fast hardware test. No draw calls will be submitted to driver.
## / It's useful when profiling to quickly assess bottleneck between CPU and GPU.

const
  BGFX_DEBUG_IFH* = (0x00000002'u32)
  BGFX_DEBUG_STATS* = (0x00000004'u32) ## !< Enable statistics display.
  BGFX_DEBUG_TEXT* = (0x00000008'u32) ## !< Enable debug text display.
  BGFX_DEBUG_PROFILER* = (0x00000010'u32) ## !< Enable profiler. This causes per-view statistics to be collected, available through `bgfx::Stats::ViewStats`. This is unrelated to the profiler functions in `bgfx::CallbackI`.
  BGFX_BUFFER_COMPUTE_FORMAT_8X1* = (0x0001'u16) ## !< 1 8-bit value
  BGFX_BUFFER_COMPUTE_FORMAT_8X2* = (0x0002'u16) ## !< 2 8-bit values
  BGFX_BUFFER_COMPUTE_FORMAT_8X4* = (0x0003'u16) ## !< 4 8-bit values
  BGFX_BUFFER_COMPUTE_FORMAT_16X1* = (0x0004'u16) ## !< 1 16-bit value
  BGFX_BUFFER_COMPUTE_FORMAT_16X2* = (0x0005'u16) ## !< 2 16-bit values
  BGFX_BUFFER_COMPUTE_FORMAT_16X4* = (0x0006'u16) ## !< 4 16-bit values
  BGFX_BUFFER_COMPUTE_FORMAT_32X1* = (0x0007'u16) ## !< 1 32-bit value
  BGFX_BUFFER_COMPUTE_FORMAT_32X2* = (0x0008'u16) ## !< 2 32-bit values
  BGFX_BUFFER_COMPUTE_FORMAT_32X4* = (0x0009'u16) ## !< 4 32-bit values
  BGFX_BUFFER_COMPUTE_FORMAT_SHIFT* = 0
  BGFX_BUFFER_COMPUTE_FORMAT_MASK* = (0x000f'u16)
  BGFX_BUFFER_COMPUTE_TYPE_INT* = (0x0010'u16) ## !< Type `int`.
  BGFX_BUFFER_COMPUTE_TYPE_UINT* = (0x0020'u16) ## !< Type `uint`.
  BGFX_BUFFER_COMPUTE_TYPE_FLOAT* = (0x0030'u16) ## !< Type `float`.
  BGFX_BUFFER_COMPUTE_TYPE_SHIFT* = 4
  BGFX_BUFFER_COMPUTE_TYPE_MASK* = (0x0030'u16)
  BGFX_BUFFER_NONE* = (0x0000'u16)
  BGFX_BUFFER_COMPUTE_READ* = (0x0100'u16) ## !< Buffer will be read by shader.
  BGFX_BUFFER_COMPUTE_WRITE* = (0x0200'u16) ## !< Buffer will be used for writing.
  BGFX_BUFFER_DRAW_INDIRECT* = (0x0400'u16) ## !< Buffer will be used for storing draw indirect commands.
  BGFX_BUFFER_ALLOW_RESIZE* = (0x0800'u16) ## !< Allow dynamic index/vertex buffer resize during update.
  BGFX_BUFFER_INDEX32* = (0x1000'u16) ## !< Index buffer contains 32-bit indices.
  BGFX_BUFFER_COMPUTE_READ_WRITE* = (0 or BGFX_BUFFER_COMPUTE_READ or BGFX_BUFFER_COMPUTE_WRITE)
  BGFX_TEXTURE_NONE* = (0x0000000000000000'u64)
  BGFX_TEXTURE_MSAA_SAMPLE* = (0x0000000800000000'u64) ## !< Texture will be used for MSAA sampling.
  BGFX_TEXTURE_RT* = (0x0000001000000000'u64) ## !< Render target no MSAA.
  BGFX_TEXTURE_COMPUTE_WRITE* = (0x0000100000000000'u64) ## !< Texture will be used for compute write.
  BGFX_TEXTURE_SRGB* = (0x0000200000000000'u64) ## !< Sample texture as sRGB.
  BGFX_TEXTURE_BLIT_DST* = (0x0000400000000000'u64) ## !< Texture will be used as blit destination.
  BGFX_TEXTURE_READ_BACK* = (0x0000800000000000'u64) ## !< Texture will be used for read back from GPU.
  BGFX_TEXTURE_RT_MSAA_X2* = (0x0000002000000000'u64) ## !< Render target MSAAx2 mode.
  BGFX_TEXTURE_RT_MSAA_X4* = (0x0000003000000000'u64) ## !< Render target MSAAx4 mode.
  BGFX_TEXTURE_RT_MSAA_X8* = (0x0000004000000000'u64) ## !< Render target MSAAx8 mode.
  BGFX_TEXTURE_RT_MSAA_X16* = (0x0000005000000000'u64) ## !< Render target MSAAx16 mode.
  BGFX_TEXTURE_RT_MSAA_SHIFT* = 36
  BGFX_TEXTURE_RT_MSAA_MASK* = (0x0000007000000000'u64)
  BGFX_TEXTURE_RT_WRITE_ONLY* = (0x0000008000000000'u64) ## !< Render target will be used for writing
  BGFX_TEXTURE_RT_SHIFT* = 36
  BGFX_TEXTURE_RT_MASK* = (0x000000f000000000'u64)

## *
##  Sampler flags.
##
##

const
  BGFX_SAMPLER_U_MIRROR* = (0x00000001'u32) ## !< Wrap U mode: Mirror
  BGFX_SAMPLER_U_CLAMP* = (0x00000002'u32) ## !< Wrap U mode: Clamp
  BGFX_SAMPLER_U_BORDER* = (0x00000003'u32) ## !< Wrap U mode: Border
  BGFX_SAMPLER_U_SHIFT* = 0
  BGFX_SAMPLER_U_MASK* = (0x00000003'u32)
  BGFX_SAMPLER_V_MIRROR* = (0x00000004'u32) ## !< Wrap V mode: Mirror
  BGFX_SAMPLER_V_CLAMP* = (0x00000008'u32) ## !< Wrap V mode: Clamp
  BGFX_SAMPLER_V_BORDER* = (0x0000000c'u32) ## !< Wrap V mode: Border
  BGFX_SAMPLER_V_SHIFT* = 2
  BGFX_SAMPLER_V_MASK* = (0x0000000c'u32)
  BGFX_SAMPLER_W_MIRROR* = (0x00000010'u32) ## !< Wrap W mode: Mirror
  BGFX_SAMPLER_W_CLAMP* = (0x00000020'u32) ## !< Wrap W mode: Clamp
  BGFX_SAMPLER_W_BORDER* = (0x00000030'u32) ## !< Wrap W mode: Border
  BGFX_SAMPLER_W_SHIFT* = 4
  BGFX_SAMPLER_W_MASK* = (0x00000030'u32)
  BGFX_SAMPLER_MIN_POINT* = (0x00000040'u32) ## !< Min sampling mode: Point
  BGFX_SAMPLER_MIN_ANISOTROPIC* = (0x00000080'u32) ## !< Min sampling mode: Anisotropic
  BGFX_SAMPLER_MIN_SHIFT* = 6
  BGFX_SAMPLER_MIN_MASK* = (0x000000c0'u32)
  BGFX_SAMPLER_MAG_POINT* = (0x00000100'u32) ## !< Mag sampling mode: Point
  BGFX_SAMPLER_MAG_ANISOTROPIC* = (0x00000200'u32) ## !< Mag sampling mode: Anisotropic
  BGFX_SAMPLER_MAG_SHIFT* = 8
  BGFX_SAMPLER_MAG_MASK* = (0x00000300'u32)
  BGFX_SAMPLER_MIP_POINT* = (0x00000400'u32) ## !< Mip sampling mode: Point
  BGFX_SAMPLER_MIP_SHIFT* = 10
  BGFX_SAMPLER_MIP_MASK* = (0x00000400'u32)
  BGFX_SAMPLER_COMPARE_LESS* = (0x00010000'u32) ## !< Compare when sampling depth texture: less.
  BGFX_SAMPLER_COMPARE_LEQUAL* = (0x00020000'u32) ## !< Compare when sampling depth texture: less or equal.
  BGFX_SAMPLER_COMPARE_EQUAL* = (0x00030000'u32) ## !< Compare when sampling depth texture: equal.
  BGFX_SAMPLER_COMPARE_GEQUAL* = (0x00040000'u32) ## !< Compare when sampling depth texture: greater or equal.
  BGFX_SAMPLER_COMPARE_GREATER* = (0x00050000'u32) ## !< Compare when sampling depth texture: greater.
  BGFX_SAMPLER_COMPARE_NOTEQUAL* = (0x00060000'u32) ## !< Compare when sampling depth texture: not equal.
  BGFX_SAMPLER_COMPARE_NEVER* = (0x00070000'u32) ## !< Compare when sampling depth texture: never.
  BGFX_SAMPLER_COMPARE_ALWAYS* = (0x00080000'u32) ## !< Compare when sampling depth texture: always.
  BGFX_SAMPLER_COMPARE_SHIFT* = 16
  BGFX_SAMPLER_COMPARE_MASK* = (0x000f0000'u32)
  BGFX_SAMPLER_BORDER_COLOR_SHIFT* = 24
  BGFX_SAMPLER_BORDER_COLOR_MASK* = (0x0f000000'u32)

template BGFX_SAMPLER_BORDER_COLOR*(v: untyped): untyped =
  (((uint32)(v) shl BGFX_SAMPLER_BORDER_COLOR_SHIFT) and
      BGFX_SAMPLER_BORDER_COLOR_MASK)

const
  BGFX_SAMPLER_RESERVED_SHIFT* = 28
  BGFX_SAMPLER_RESERVED_MASK* = (0xf0000000'u32)
  BGFX_SAMPLER_NONE* = (0x00000000'u32)
  BGFX_SAMPLER_SAMPLE_STENCIL* = (0x00100000'u32) ## !< Sample stencil instead of depth.
  BGFX_SAMPLER_POINT* = (0 or BGFX_SAMPLER_MIN_POINT or BGFX_SAMPLER_MAG_POINT or
      BGFX_SAMPLER_MIP_POINT)
  BGFX_SAMPLER_UVW_MIRROR* = (0 or BGFX_SAMPLER_U_MIRROR or BGFX_SAMPLER_V_MIRROR or
      BGFX_SAMPLER_W_MIRROR)
  BGFX_SAMPLER_UVW_CLAMP* = (
    0 or BGFX_SAMPLER_U_CLAMP or BGFX_SAMPLER_V_CLAMP or BGFX_SAMPLER_W_CLAMP)
  BGFX_SAMPLER_UVW_BORDER* = (0 or BGFX_SAMPLER_U_BORDER or BGFX_SAMPLER_V_BORDER or
      BGFX_SAMPLER_W_BORDER)
  BGFX_SAMPLER_BITS_MASK* = (0 or BGFX_SAMPLER_U_MASK or BGFX_SAMPLER_V_MASK or
      BGFX_SAMPLER_W_MASK or BGFX_SAMPLER_MIN_MASK or BGFX_SAMPLER_MAG_MASK or
      BGFX_SAMPLER_MIP_MASK or BGFX_SAMPLER_COMPARE_MASK)
  BGFX_RESET_MSAA_X2* = (0x00000010'u32) ## !< Enable 2x MSAA.
  BGFX_RESET_MSAA_X4* = (0x00000020'u32) ## !< Enable 4x MSAA.
  BGFX_RESET_MSAA_X8* = (0x00000030'u32) ## !< Enable 8x MSAA.
  BGFX_RESET_MSAA_X16* = (0x00000040'u32) ## !< Enable 16x MSAA.
  BGFX_RESET_MSAA_SHIFT* = 4
  BGFX_RESET_MSAA_MASK* = (0x00000070'u32)
  BGFX_RESET_NONE* = (0x00000000'u32) ## !< No reset flags.
  BGFX_RESET_FULLSCREEN* = (0x00000001'u32) ## !< Not supported yet.
  BGFX_RESET_VSYNC* = (0x00000080'u32) ## !< Enable V-Sync.
  BGFX_RESET_MAXANISOTROPY* = (0x00000100'u32) ## !< Turn on/off max anisotropy.
  BGFX_RESET_CAPTURE* = (0x00000200'u32) ## !< Begin screen capture.
  BGFX_RESET_FLUSH_AFTER_RENDER* = (0x00002000'u32) ## !< Flush rendering after submitting to GPU.

## / This flag specifies where flip occurs. Default behaviour is that flip occurs
## / before rendering new frame. This flag only has effect when `BGFX_CONFIG_MULTITHREADED=0`.

const
  BGFX_RESET_FLIP_AFTER_RENDER* = (0x00004000'u32)
  BGFX_RESET_SRGB_BACKBUFFER* = (0x00008000'u32) ## !< Enable sRGB backbuffer.
  BGFX_RESET_HDR10* = (0x00010000'u32) ## !< Enable HDR10 rendering.
  BGFX_RESET_HIDPI* = (0x00020000'u32) ## !< Enable HiDPI rendering.
  BGFX_RESET_DEPTH_CLAMP* = (0x00040000'u32) ## !< Enable depth clamp.
  BGFX_RESET_SUSPEND* = (0x00080000'u32) ## !< Suspend rendering.
  BGFX_RESET_FULLSCREEN_SHIFT* = 0
  BGFX_RESET_FULLSCREEN_MASK* = (0x00000001'u32)
  BGFX_RESET_RESERVED_SHIFT* = 31
  BGFX_RESET_RESERVED_MASK* = (0x80000000'u32) ## !< Internal bit mask
  BGFX_CAPS_ALPHA_TO_COVERAGE* = (0x0000000000000001'u64) ## !< Alpha to coverage is supported.
  BGFX_CAPS_BLEND_INDEPENDENT* = (0x0000000000000002'u64) ## !< Blend independent is supported.
  BGFX_CAPS_COMPUTE* = (0x0000000000000004'u64) ## !< Compute shaders are supported.
  BGFX_CAPS_CONSERVATIVE_RASTER* = (0x0000000000000008'u64) ## !< Conservative rasterization is supported.
  BGFX_CAPS_DRAW_INDIRECT* = (0x0000000000000010'u64) ## !< Draw indirect is supported.
  BGFX_CAPS_FRAGMENT_DEPTH* = (0x0000000000000020'u64) ## !< Fragment depth is available in fragment shader.
  BGFX_CAPS_FRAGMENT_ORDERING* = (0x0000000000000040'u64) ## !< Fragment ordering is available in fragment shader.
  BGFX_CAPS_GRAPHICS_DEBUGGER* = (0x0000000000000080'u64) ## !< Graphics debugger is present.
  BGFX_CAPS_HDR10* = (0x0000000000000100'u64) ## !< HDR10 rendering is supported.
  BGFX_CAPS_HIDPI* = (0x0000000000000200'u64) ## !< HiDPI rendering is supported.
  BGFX_CAPS_IMAGE_RW* = (0x0000000000000400'u64) ## !< Image Read/Write is supported.
  BGFX_CAPS_INDEX32* = (0x0000000000000800'u64) ## !< 32-bit indices are supported.
  BGFX_CAPS_INSTANCING* = (0x0000000000001000'u64) ## !< Instancing is supported.
  BGFX_CAPS_OCCLUSION_QUERY* = (0x0000000000002000'u64) ## !< Occlusion query is supported.
  BGFX_CAPS_RENDERER_MULTITHREADED* = (0x0000000000004000'u64) ## !< Renderer is on separate thread.
  BGFX_CAPS_SWAP_CHAIN* = (0x0000000000008000'u64) ## !< Multiple windows are supported.
  BGFX_CAPS_TEXTURE_2D_ARRAY* = (0x0000000000010000'u64) ## !< 2D texture array is supported.
  BGFX_CAPS_TEXTURE_3D* = (0x0000000000020000'u64) ## !< 3D textures are supported.
  BGFX_CAPS_TEXTURE_BLIT* = (0x0000000000040000'u64) ## !< Texture blit is supported.
  BGFX_CAPS_TEXTURE_COMPARE_RESERVED* = (0x0000000000080000'u64)
  BGFX_CAPS_TEXTURE_COMPARE_LEQUAL* = (0x0000000000100000'u64) ## !< Texture compare less equal mode is supported.
  BGFX_CAPS_TEXTURE_CUBE_ARRAY* = (0x0000000000200000'u64) ## !< Cubemap texture array is supported.
  BGFX_CAPS_TEXTURE_DIRECT_ACCESS* = (0x0000000000400000'u64) ## !< CPU direct access to GPU texture memory.
  BGFX_CAPS_TEXTURE_READ_BACK* = (0x0000000000800000'u64) ## !< Read-back texture is supported.
  BGFX_CAPS_VERTEX_ATTRIB_HALF* = (0x0000000001000000'u64) ## !< Vertex attribute half-float is supported.
  BGFX_CAPS_VERTEX_ATTRIB_UINT10* = (0x0000000002000000'u64) ## !< Vertex attribute 10_10_10_2 is supported.
  BGFX_CAPS_VERTEX_ID* = (0x0000000004000000'u64) ## !< Rendering with VertexID only is supported.
  BGFX_CAPS_VIEWPORT_LAYER_ARRAY* = (0x0000000008000000'u64) ## !< Viewport layer is available in vertex shader.
                                                                  ## / All texture compare modes are supported.
  BGFX_CAPS_TEXTURE_COMPARE_ALL* = (
    0 or BGFX_CAPS_TEXTURE_COMPARE_RESERVED or BGFX_CAPS_TEXTURE_COMPARE_LEQUAL)
  BGFX_CAPS_FORMAT_TEXTURE_NONE* = (0x00000000'u32) ## !< Texture format is not supported.
  BGFX_CAPS_FORMAT_TEXTURE_2D* = (0x00000001'u32) ## !< Texture format is supported.
  BGFX_CAPS_FORMAT_TEXTURE_2D_SRGB* = (0x00000002'u32) ## !< Texture as sRGB format is supported.
  BGFX_CAPS_FORMAT_TEXTURE_2D_EMULATED* = (0x00000004'u32) ## !< Texture format is emulated.
  BGFX_CAPS_FORMAT_TEXTURE_3D* = (0x00000008'u32) ## !< Texture format is supported.
  BGFX_CAPS_FORMAT_TEXTURE_3D_SRGB* = (0x00000010'u32) ## !< Texture as sRGB format is supported.
  BGFX_CAPS_FORMAT_TEXTURE_3D_EMULATED* = (0x00000020'u32) ## !< Texture format is emulated.
  BGFX_CAPS_FORMAT_TEXTURE_CUBE* = (0x00000040'u32) ## !< Texture format is supported.
  BGFX_CAPS_FORMAT_TEXTURE_CUBE_SRGB* = (0x00000080'u32) ## !< Texture as sRGB format is supported.
  BGFX_CAPS_FORMAT_TEXTURE_CUBE_EMULATED* = (0x00000100'u32) ## !< Texture format is emulated.
  BGFX_CAPS_FORMAT_TEXTURE_VERTEX* = (0x00000200'u32) ## !< Texture format can be used from vertex shader.
  BGFX_CAPS_FORMAT_TEXTURE_IMAGE_READ* = (0x00000400'u32) ## !< Texture format can be used as image and read from.
  BGFX_CAPS_FORMAT_TEXTURE_IMAGE_WRITE* = (0x00000800'u32) ## !< Texture format can be used as image and written to.
  BGFX_CAPS_FORMAT_TEXTURE_FRAMEBUFFER* = (0x00001000'u32) ## !< Texture format can be used as frame buffer.
  BGFX_CAPS_FORMAT_TEXTURE_FRAMEBUFFER_MSAA* = (0x00002000'u32) ## !< Texture format can be used as MSAA frame buffer.
  BGFX_CAPS_FORMAT_TEXTURE_MSAA* = (0x00004000'u32) ## !< Texture can be sampled as MSAA.
  BGFX_CAPS_FORMAT_TEXTURE_MIP_AUTOGEN* = (0x00008000'u32) ## !< Texture format supports auto-generated mips.
  BGFX_RESOLVE_NONE* = (0x00'u8) ## !< No resolve flags.
  BGFX_RESOLVE_AUTO_GEN_MIPS* = (0x01'u8) ## !< Auto-generate mip maps on resolve.
  BGFX_PCI_ID_NONE* = (0x0000'u16) ## !< Autoselect adapter.
  BGFX_PCI_ID_SOFTWARE_RASTERIZER* = (0x0001'u16) ## !< Software rasterizer.
  BGFX_PCI_ID_AMD* = (0x1002'u16) ## !< AMD adapter.
  BGFX_PCI_ID_APPLE* = (0x106b'u16) ## !< Apple adapter.
  BGFX_PCI_ID_INTEL* = (0x8086'u16) ## !< Intel adapter.
  BGFX_PCI_ID_NVIDIA* = (0x10de'u16) ## !< nVidia adapter.
  BGFX_PCI_ID_MICROSOFT* = (0x1414'u16) ## !< Microsoft adapter.
  BGFX_PCI_ID_ARM* = (0x13b5'u16) ## !< ARM adapter.
  BGFX_CUBE_MAP_POSITIVE_X* = (0x00'u8) ## !< Cubemap +x.
  BGFX_CUBE_MAP_NEGATIVE_X* = (0x01'u8) ## !< Cubemap -x.
  BGFX_CUBE_MAP_POSITIVE_Y* = (0x02'u8) ## !< Cubemap +y.
  BGFX_CUBE_MAP_NEGATIVE_Y* = (0x03'u8) ## !< Cubemap -y.
  BGFX_CUBE_MAP_POSITIVE_Z* = (0x04'u8) ## !< Cubemap +z.
  BGFX_CUBE_MAP_NEGATIVE_Z* = (0x05'u8) ## !< Cubemap -z.

## / Blend function separate.

template BGFX_STATE_BLEND_FUNC_SEPARATE*(srcRGB, dstRGB, srcA, dstA: untyped): untyped =
  ((0) or (((srcRGB).uint64 or ((dstRGB).uint64 shl 4))) or
      (((srcA).uint64 or ((dstA).uint64 shl 4)) shl 8))

## / Blend equation separate.

template BGFX_STATE_BLEND_EQUATION_SEPARATE*(equationRGB, equationA: untyped): untyped =
  ((equationRGB).uint64 or ((equationA).uint64 shl 3))

## / Blend function.

template BGFX_STATE_BLEND_FUNC*(src, dst: untyped): untyped =
  BGFX_STATE_BLEND_FUNC_SEPARATE(src, dst, src, dst)

## / Blend equation.

template BGFX_STATE_BLEND_EQUATION*(equation: untyped): untyped =
  BGFX_STATE_BLEND_EQUATION_SEPARATE(equation, equation)

## / Utility predefined blend modes.
## / Additive blending.

const
  BGFX_STATE_BLEND_ADD* = (
    0 or BGFX_STATE_BLEND_FUNC(BGFX_STATE_BLEND_ONE, BGFX_STATE_BLEND_ONE))

## / Alpha blend.

const
  BGFX_STATE_BLEND_ALPHA* = (0 or
      BGFX_STATE_BLEND_FUNC(BGFX_STATE_BLEND_SRC_ALPHA,
                            BGFX_STATE_BLEND_INV_SRC_ALPHA))

## / Selects darker color of blend.

const
  BGFX_STATE_BLEND_DARKEN* = (0 or
      BGFX_STATE_BLEND_FUNC(BGFX_STATE_BLEND_ONE, BGFX_STATE_BLEND_ONE) or
      BGFX_STATE_BLEND_EQUATION(BGFX_STATE_BLEND_EQUATION_MIN))

## / Selects lighter color of blend.

const
  BGFX_STATE_BLEND_LIGHTEN* = (0 or
      BGFX_STATE_BLEND_FUNC(BGFX_STATE_BLEND_ONE, BGFX_STATE_BLEND_ONE) or
      BGFX_STATE_BLEND_EQUATION(BGFX_STATE_BLEND_EQUATION_MAX))

## / Multiplies colors.

const
  BGFX_STATE_BLEND_MULTIPLY* = (0 or
      BGFX_STATE_BLEND_FUNC(BGFX_STATE_BLEND_DST_COLOR, BGFX_STATE_BLEND_ZERO))

## / Opaque pixels will cover the pixels directly below them without any math or algorithm applied to them.

const
  BGFX_STATE_BLEND_NORMAL* = (0 or
      BGFX_STATE_BLEND_FUNC(BGFX_STATE_BLEND_ONE, BGFX_STATE_BLEND_INV_SRC_ALPHA))

## / Multiplies the inverse of the blend and base colors.

const
  BGFX_STATE_BLEND_SCREEN* = (0 or
      BGFX_STATE_BLEND_FUNC(BGFX_STATE_BLEND_ONE, BGFX_STATE_BLEND_INV_SRC_COLOR))

## / Decreases the brightness of the base color based on the value of the blend color.

const
  BGFX_STATE_BLEND_LINEAR_BURN* = (0 or
      BGFX_STATE_BLEND_FUNC(BGFX_STATE_BLEND_DST_COLOR,
                            BGFX_STATE_BLEND_INV_DST_COLOR) or
      BGFX_STATE_BLEND_EQUATION(BGFX_STATE_BLEND_EQUATION_SUB))

## /

template BGFX_STATE_BLEND_FUNC_RT_x*(src, dst: untyped): untyped =
  (0 or
      ((uint32)((src) shr BGFX_STATE_BLEND_SHIFT) or
      ((uint32)((dst) shr BGFX_STATE_BLEND_SHIFT) shl 4)))

## /

template BGFX_STATE_BLEND_FUNC_RT_xE*(src, dst, equation: untyped): untyped =
  (0 or BGFX_STATE_BLEND_FUNC_RT_x(src, dst) or
      ((uint32)((equation) shr BGFX_STATE_BLEND_EQUATION_SHIFT) shl 8))

template BGFX_STATE_BLEND_FUNC_RT_1*(src, dst: untyped): untyped =
  (BGFX_STATE_BLEND_FUNC_RT_x(src, dst) shl 0)

template BGFX_STATE_BLEND_FUNC_RT_2*(src, dst: untyped): untyped =
  (BGFX_STATE_BLEND_FUNC_RT_x(src, dst) shl 11)

template BGFX_STATE_BLEND_FUNC_RT_3*(src, dst: untyped): untyped =
  (BGFX_STATE_BLEND_FUNC_RT_x(src, dst) shl 22)

template BGFX_STATE_BLEND_FUNC_RT_1E*(src, dst, equation: untyped): untyped =
  (BGFX_STATE_BLEND_FUNC_RT_xE(src, dst, equation) shl 0)

template BGFX_STATE_BLEND_FUNC_RT_2E*(src, dst, equation: untyped): untyped =
  (BGFX_STATE_BLEND_FUNC_RT_xE(src, dst, equation) shl 11)

template BGFX_STATE_BLEND_FUNC_RT_3E*(src, dst, equation: untyped): untyped =
  (BGFX_STATE_BLEND_FUNC_RT_xE(src, dst, equation) shl 22)
