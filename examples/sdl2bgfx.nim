import bgfx, sdl2

when defined(macosx):
  type
    SysWMInfoCocoaObj = object
      window: pointer ## The Cocoa window

    SysWMInfoKindObj = object
      cocoa: SysWMInfoCocoaObj

when defined(linux):
  import 
    x11/x, 
    x11/xlib

  type
    SysWMmsgX11Obj* = object  ## when defined(SDL_VIDEO_DRIVER_X11)
      display*: ptr xlib.XDisplay  ##  The X11 display
      window*: ptr x.Window            ##  The X11 window

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
  PlatformData = bgfx_platform_data_t

template sdlFailIf (condition: typed, reason: string) =
  if condition: raise SDLException.newException(
    reason & $getError()
  )

proc createWindow (width, height: cint, title: string): WindowPtr =
  result = sdl2.createWindow(
      title = title,
      x = SDL_WINDOWPOS_CENTERED,
      y = SDL_WINDOWPOS_CENTERED,
      w = width,
      h = height,
      flags = (SDL_WINDOW_SHOWN or SDL_WINDOW_RESIZABLE)
  )

proc linkSDL2BGFX (window: WindowPtr) =
    var pd: PlatformData
    var info: WMinfo
    getVersion(info.version)
    assert getWMInfo(window, info)
    echo  "SDL2 version: " &
      $info.version.major.int & '.' &
      $info.version.minor.int & '.' &
      $info.version.patch.int &
      " - Subsystem: " & $info.subsystem
    
    let sysInfo = cast[ptr SysWMInfoKindObj](addr info.padding[0])
    case(info.subsystem):
        of SysWM_Windows:
          when defined(windows):
            pd.nwh = cast[pointer](sysInfo.win.window)
          pd.ndt = nil
        of SysWM_X11:
          when defined(linux):
            pd.nwh = sysInfo.x11.window
            pd.ndt = sysInfo.x11.display
        of SysWM_Cocoa:
          when defined(macosx):
            pd.nwh = sysInfo.cocoa.window
          pd.ndt = nil
        else:
          echo "SDL2 failed to get handle: " & $(sdl2.getError())
          raise newException(OSError, "No structure for subsystem type")

    pd.backBuffer = nil
    pd.backBufferDS = nil
    pd.context = nil
    bgfx_set_platform_data(addr pd)

proc createGameWindow* (width: cint, height: cint, title: string) : WindowPtr {.discardable} =  

  let sdlFailInit = not sdl2.init(INIT_TIMER or INIT_VIDEO or INIT_JOYSTICK or INIT_HAPTIC or INIT_GAMECONTROLLER or INIT_EVENTS)
  sdlFailIf sdlFailInit: "failed to initialize sdl2"

  result = createWindow(width, height, title) 
  sdlFailIf result.isNil: "failed to create the game window"

  linkSDL2BGFX(result)

  var init: bgfx_init_t
  bgfx_init_ctor(addr init)

  if not bgfx_init(addr init):
    echo "Error initializng BGFX."
    quit(QUIT_FAILURE)

  bgfx_set_debug(BGFX_DEBUG_TEXT)
  bgfx_reset(uint32 width, uint32 height, BGFX_RESET_NONE, BGFX_TEXTURE_FORMAT_COUNT)
  bgfx_set_view_rect(0, 0, 0, uint16 width, uint16 height)