#[
  Portions of code were derived from Zachary Carter's bgfx.nim Hello World example which can be found at
  https://github.com/zacharycarter/bgfx.nim/tree/master/examples/00-HelloWorld

  version       = "0.1.0"
  author        = "Zachary Carter"
  description   = "BGFX Examle 01 - Hello World"
  license       = "MIT"
]#

import
  bgfx, sdl2, logo,
  ../sdl2bgfx,
  std/math
  
const
  Width = 1200
  Height = 750
  AvgFpsUpdateFreq = 8 # update average fps value eight times a second

var
  targetFrameTime = 10'u32
  timeElapsed = 0'u32
  gameWindow: WindowPtr

var
  avgFps = 0'u32
  avgFrameTime = 0'f32
  frameTimes : seq[float32]
let
  toMs = 1000'f32

proc updateAverageFramerate(dt: float32) = 
  frameTimes.add(dt)
  if (frameTimes.len > (1000 div AvgFpsUpdateFreq) div int targetFrameTime):
    var sum: float32 = 0
    for ft in frameTimes:
      sum += ft
    avgFrameTime = sum / frameTimes.len.float32
    avgFps = (1.0 / avgFrameTime * toMs).round.uint32
    frameTimes = @[]

proc init(width: cint, height: cint, targetFps: int, title: string) =  
  targetFrameTime = (1000 div targetFps).uint32
  gameWindow = sdl2bgfx.createGameWindow(Width, Height, "HelloBGFX")

proc limitFrameRate*() =
    timeElapsed = getTicks()
    while (getTicks() - timeElapsed < targetFrameTime):
      discard

proc getTime(): float64 =
    return float64(getPerformanceCounter()*1000) / float64 getPerformanceFrequency()

proc run() = 
  defer: sdl2.quit()
  defer: gameWindow.destroy()

  var
    event = sdl2.defaultEvent
    runGame = true

  while runGame:
    while pollEvent(event):
      case event.kind
      of QuitEvent:
        runGame = false
        break
      else:
        discard

    var now = getTime()
    var last {.global.} = getTime()
    let frameTime: float32 = now - last
    last = now
    
    updateAverageFramerate(frameTime)

    bgfx_touch(0)

    bgfx_dbg_text_clear(0, false)
    bgfx_dbg_text_printf(1, 1, 0x0f, "Frame (average): %7.3f[ms] FPS (average): %i", avgFrameTime, avgFps)

    bgfx_set_view_clear(0, BGFX_CLEAR_COLOR or BGFX_CLEAR_DEPTH, 0x303030ff, 1.0, 0)

    bgfx_dbg_text_image(max(cast[uint16](Width) div 2'u16 div 8'u16, 20'u16) - 20'u16,
                        max(cast[uint16](Height) div 2'u16 div 16'u16, 6'u16) - 6'u16,
                        40, 12, addr logo[0], 160
                        )

    discard bgfx_frame(false)
    limitFrameRate()
     
init(Width, Height, 100, "HelloBGFX")
run()