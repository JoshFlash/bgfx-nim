#[
  Much of this file's logic is derived from Zachary Carter's bgfx.nim Hello World example which can be found at
  https://github.com/zacharycarter/bgfx.nim/tree/master/examples/00-HelloWorld

  version       = "0.1.0"
  author        = "Zachary Carter"
  description   = "BGFX Examle 01 - Hello World"
  license       = "MIT"
]#


import
  bgfx,
  sdl2,
  logo,
  strutils
  
when defined(macosx):
  type
    SysWMInfoCocoaObj = object
      window: pointer ## The Cocoa window

    SysWMInfoKindObj = object
      cocoa: SysWMInfoCocoaObj

when defined(linux):
  import 
    x, 
    xlib

  type
    SysWMmsgX11Obj* = object  ## when defined(SDL_VIDEO_DRIVER_X11)
      display*: ptr xlib.TXDisplay  ##  The X11 display
      window*: ptr x.TWindow            ##  The X11 window


    SysWMInfoKindObj* = object ## when defined(SDL_VIDEO_DRIVER_X11)
      x11*: SysWMMsgX11Obj

when defined(windows):
  type
    SysWMMsgWinObj* = object  ##  when defined(SDL_VIDEO_DRIVER_WINDOWS)
      window*: pointer

    SysWMInfoKindObj* = object ##  when defined(SDL_VIDEO_DRIVER_WINDOWS)
      win*: SysWMMsgWinObj  

type 
  SDLException = object of Defect

template sdlFailIf (condition: typed, reason: string) =
  if condition: raise SDLException.newException(
    reason & $getError()
  )

const
  WIDTH = 1200
  HEIGHT = 750

var
  targetFrameTime = 10'u32
  timeElapsed = 0'u32
  gameWindow: WindowPtr

proc createGameWindow (width, height: cint, title: string): WindowPtr =
  result = sdl2.createWindow(
      title = title,
      x = SDL_WINDOWPOS_CENTERED,
      y = SDL_WINDOWPOS_CENTERED,
      w = width,
      h = height,
      flags = (SDL_WINDOW_SHOWN or SDL_WINDOW_RESIZABLE)
  )

template workaround_create[T]: ptr T = cast[ptr T](alloc0(sizeof(T)))
proc linkSDL2BGFX*(window: WindowPtr) =
    var pd: ptr bgfx_platform_data_t = workaround_create[bgfx_platform_data_t]() 
    var info: WMinfo
    assert getWMInfo(window, info)
    echo  "SDL2 version: $1.$2.$3 - Subsystem: $4".format(
      info.version.major.int, info.version.minor.int, info.version.patch.int, info.subsystem
    )
    
    case(info.subsystem):
        of SysWM_Windows:
          when defined(windows):
            let info = cast[ptr SysWMInfoKindObj](addr info.padding[0])
            pd.nwh = cast[pointer](info.win.window)
          pd.ndt = nil
        of SysWM_X11:
          when defined(linux):
            let info = cast[ptr SysWMInfoKindObj](addr info.padding[0])
            pd.nwh = info.x11.window
            pd.ndt = info.x11.display
        of SysWM_Cocoa:
          when defined(macosx):
            let info = cast[ptr SysWMInfoKindObj](addr info.padding[0])
            pd.nwh = info.cocoa.window
          pd.ndt = nil
        else:
          echo "SDL2 failed to get handle: $1".format(sdl2.getError())
          raise newException(OSError, "No structure for subsystem type")

    pd.backBuffer = nil
    pd.backBufferDS = nil
    pd.context = nil
    bgfx_set_platform_data(pd)

proc init(width: cint, height: cint, targetFps: int, title: string) =  
  targetFrameTime = (1000 div targetFps).uint32

  let sdlFailInit = not sdl2.init(INIT_TIMER or INIT_VIDEO or INIT_JOYSTICK or INIT_HAPTIC or INIT_GAMECONTROLLER or INIT_EVENTS)
  sdlFailIf sdlFailInit: "failed to initialize sdl2"

  gameWindow = createGameWindow(width, height, title) 
  sdlFailIf gameWindow.isNil: "failed to create the game window"

  linkSDL2BGFX(gameWindow)

  var init: bgfx_init_t
  bgfx_init_ctor(addr init)

  if not bgfx_init(addr init):
    echo "Error initializng BGFX."
    quit(QUIT_FAILURE)

  bgfx_set_debug(BGFX_DEBUG_TEXT)

  bgfx_reset(uint32 width, uint32 height, BGFX_RESET_NONE, BGFX_TEXTURE_FORMAT_COUNT)

  bgfx_set_view_rect(0, 0, 0, uint16 width, uint16 height)

proc limitFrameRate*() =
  let now = getTicks()
  if timeElapsed > now:
    delay(timeElapsed - now) 
  timeElapsed += targetFrameTime

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
    let time = getTime()
    last = now
    var toMs = 1000.0'f32

    bgfx_touch(0)

    bgfx_dbg_text_clear(0, false)
    bgfx_dbg_text_printf(1, 1, 0x0f, "Frame: %7.3f[ms] FPS: %7.3f", float32(frameTime), (1.0 / frameTime) * toMs)

    bgfx_set_view_clear(0, BGFX_CLEAR_COLOR or BGFX_CLEAR_DEPTH, 0x303030ff, 1.0, 0)

    bgfx_dbg_text_image(max(cast[uint16](WIDTH) div 2'u16 div 8'u16, 20'u16) - 20'u16,
                        max(cast[uint16](HEIGHT) div 2'u16 div 16'u16, 6'u16) - 6'u16,
                        40, 12, addr logo[0], 160
                        )

    discard bgfx_frame(false)
    
    limitFrameRate()
    
init(WIDTH, HEIGHT, 100, "HelloBGFX")
run()