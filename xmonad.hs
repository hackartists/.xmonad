-- -- xmonad config used by Malcolm MD
-- -- https://github.com/randomthought/xmonad-config

-- import System.IO
-- import System.Exit
-- -- import System.Taffybar.Hooks.PagerHints (pagerHints)

-- import qualified Data.List as L

-- import XMonad
-- import XMonad.Actions.Navigation2D
-- import XMonad.Actions.UpdatePointer

-- import XMonad.Hooks.DynamicLog
-- import XMonad.Hooks.ManageDocks
-- import XMonad.Hooks.ManageHelpers
-- import XMonad.Hooks.SetWMName
-- import XMonad.Hooks.EwmhDesktops (ewmh)
-- import XMonad.Config.Gnome

-- import XMonad.Layout.Gaps
-- import XMonad.Layout.Fullscreen
-- import XMonad.Layout.BinarySpacePartition as BSP
-- import XMonad.Layout.NoBorders
-- import XMonad.Layout.Tabbed
-- import XMonad.Layout.ThreeColumns
-- import XMonad.Layout.Spacing
-- import XMonad.Layout.MultiToggle
-- import XMonad.Layout.MultiToggle.Instances
-- import XMonad.Layout.NoFrillsDecoration
-- import XMonad.Layout.Renamed
-- import XMonad.Layout.Simplest
-- import XMonad.Layout.SubLayouts
-- import XMonad.Layout.WindowNavigation
-- import XMonad.Layout.ZoomRow

-- import XMonad.Util.Run(spawnPipe)
-- import XMonad.Util.EZConfig(additionalKeys)
-- import XMonad.Util.Cursor
-- import XMonad.Util.Themes

-- import Graphics.X11.ExtraTypes.XF86
-- import qualified XMonad.StackSet as W
-- import qualified Data.Map        as M


-- ----------------------------mupdf--------------------------------------------
-- -- Terminimport XMonad.Hooks.EwmhDesktopsal
-- -- The preferred terminal program, which is used in a binding below and by
-- -- certain contrib modules.
-- --
-- myTerminal = "termite"

-- -- The command to lock the screen or show the screensaver.
-- myScreensaver = "dm-tool switch-to-greeter"

-- -- The command to take a selective screenshot, where you select
-- -- what you'd like to capture on the screen.
-- mySelectScreenshot = "select-screenshot"

-- -- The command to take a fullscreen screenshot.
-- myScreenshot = "xfce4-screen shooter"

-- -- The command to use as a launcher, to launch commands that don't have
-- -- preset keybindings.
-- myLauncher = "rofi -show"



-- ------------------------------------------------------------------------
-- -- Workspaces
-- -- The default number of workspaces (virtual screens) and their names.
-- --
-- myWorkspaces = ["1:emacs","2:web","3:mobile","4:testing","5:dev-misc","6:messenger","7:meeting","8:media","9:email"] ++ (map snd myExtraWorkspaces)
-- myExtraWorkspaces = [(xK_0, "0:misc")]

-- ------------------------------------------------------------------------
-- -- Window rules
-- -- Execute arbitrary actions and WindowSet manipulations when managing
-- -- a new window. You can use this to, for example, always float a
-- -- particular program, or have a client always appear on a particular
-- -- workspace.
-- --
-- -- To find the property name associated with a program, use
-- -- > xprop | grep WM_CLASS
-- -- and click on the client you're interested in.
-- --
-- -- To match on the WM_NAME, you can use 'title' in the same way that
-- -- 'className' and 'resource' are used below.
-- --
-- myManageHook = composeAll
--     [
--       className =? "Google-chrome"                --> doShift "2:web"
--     , stringProperty "_NET_WM_NAME" =? "Emulator" --> (doShift "3:mobile" <+> doFloat)
--     , stringProperty "_NET_WM_NAME" =? "Android Emulator - luffy:5554" --> doShift "3:mobile"
--     , stringProperty "_NET_WM_NAME" =? "Android Emulator - zoro:5556" --> doShift "3:mobile"
--     , className =? "Stoplight Studio"             --> doShift "4:testing"
--     , className =? "Slack"                        --> doShift "6:messenger"
--     , className =? "yakyak"                       --> doShift "6:messenger"
--     , className =? "Google-chrome-unstable"       --> doShift "7:meeting"
--     , className =? "Google-chrome-beta"           --> doShift "7:meeting"
--     , className =? "obs"                          --> doShift "8:media"
--     , className =? "kdenlive"                     --> doShift "8:media"
--     , className =? "Evolution"                    --> doShift "9:email"
--     , stringProperty "_NET_WM_NAME" =? "NoiseTorch" --> doShift "0:misc"
--     -- , className =? "Org.gnome.Nautilus"           --> doFloat
--     , className =? "Gimp-2.10"                    --> doCenterFloat
--     , resource  =? "gpicview"                     --> doCenterFloat
--     , className =? "MPlayer"                      --> doCenterFloat
--     , className =? "Pavucontrol"                  --> doCenterFloat
--     , className =? "systemsettings"               --> doCenterFloat
--     , resource  =? "desktop_window"               --> doIgnore
--     , className =? "stalonetray"                  --> doIgnore
--     , isFullscreen                                --> (doF W.focusDown <+> doFullFloat)
--     -- , isFullscreen                             --> doFullFloat
--     ]



-- ------------------------------------------------------------------------
-- -- Layouts
-- -- You can specify and transform your layouts by modifying these values.
-- -- If you change layout bindings be sure to use 'mod-shift-space' after
-- -- restarting (with 'mod-q') to reset your layout state to the new
-- -- defaults, as xmonad preserves your old layout settings by default.
-- --
-- -- The available layouts.  Note that each layout is separated by |||,
-- -- which denotes layout choice.

-- outerGaps    = 0
-- myGaps       = gaps [(U, outerGaps), (R, outerGaps), (L, outerGaps), (D, outerGaps)]
-- addSpace     = renamed [CutWordsLeft 2] . spacing gap
-- tab          =  avoidStruts
--                $ renamed [Replace "Tabbed"]
--                $ addTopBar
--                $ myGaps
--                $ tabbed shrinkText (theme adwaitaDarkTheme) -- myTabTheme

-- layouts      = avoidStruts (
--                 (
--                     renamed [CutWordsLeft 1]
--                   -- $ addTopBar
--                   $ windowNavigation
--                   $ renamed [Replace "BSP"]
--                   $ addTabs shrinkText (theme adwaitaDarkTheme) --  myTabTheme
--                   $ subLayout [] Simplest
--                   -- $ myGaps
--                   $ addSpace (BSP.emptyBSP)
--                 )
--                 ||| tab
--                )

-- myLayout    = smartBorders
--               $ mkToggle (NOBORDERS ?? FULL ?? EOT)
--               $ layouts

-- myNav2DConf = def
--     { defaultTiledNavigation    = centerNavigation
--     , floatNavigation           = centerNavigation
--     , screenNavigation          = lineNavigation
--     , layoutNavigation          = [("Full",          centerNavigation)
--     -- line/center same results   ,("Tabs", lineNavigation)
--     --                            ,("Tabs", centerNavigation)
--                                   ]
--     , unmappedWindowRect        = [("Full", singleWindowRect)
--     -- works but breaks tab deco  ,("Tabs", singleWindowRect)
--     -- doesn't work but deco ok   ,("Tabs", fullScreenRect)
--                                   ]
--     }


-- ------------------------------------------------------------------------
-- -- Colors and borders

-- -- Color of current window title in xmobar.
-- xmobarTitleColor = "#C678DD"

-- -- Color of current workspace in xmobar.
-- xmobarCurrentWorkspaceColor = "#51AFEF"

-- -- Width of the window border in pixels.
-- myBorderWidth = 0

-- myNormalBorderColor     = "#000000"
-- myFocusedBorderColor    = active

-- base03  = "#002b36"
-- base02  = "#073642"
-- base01  = "#586e75"
-- base00  = "#657b83"
-- base0   = "#839496"
-- base1   = "#93a1a1"
-- base2   = "#eee8d5"
-- base3   = "#fdf6e3"
-- yellow  = "#b58900"
-- orange  = "#cb4b16"
-- red     = "#dc322f"
-- magenta = "#d33682"
-- violet  = "#6c71c4"
-- blue    = "#268bd2"
-- cyan    = "#2aa198"
-- green   = "#859900"

-- -- sizes
-- gap         = 0
-- topbar      = 10
-- border      = 0
-- prompt      = 20
-- status      = 20

-- active      = red
-- activeWarn  = red
-- inactive    = base02
-- focusColor  = blue
-- unfocusColor = base02

-- -- myFont      = "-*-Zekton-medium-*-*-*-*-160-*-*-*-*-*-*"
-- -- myBigFont   = "-*-Zekton-medium-*-*-*-*-240-*-*-*-*-*-*"
-- myFont      = "xft:NanumGothic:size=14:bold:antialias=true"
-- myBigFont   = "xft:NanumGothic:size=14:bold:antialias=true"
-- myWideFont  = "xft:Eurostar Black Extended:"
--             ++ "style=Regular:pixelsize=240:hinting=true"

-- -- this is a "fake title" used as a highlight bar in lieu of full borders
-- -- (I find this a cleaner and less visually intrusive solution)
-- topBarTheme = def
--     {
--       fontName              = myFont
--     , inactiveBorderColor   = base03
--     , inactiveColor         = base03
--     , inactiveTextColor     = base03
--     , activeBorderColor     = active
--     , activeColor           = active
--     , activeTextColor       = active
--     , urgentBorderColor     = red
--     , urgentTextColor       = yellow
--     , decoHeight            = topbar
--     }

-- addTopBar =  noFrillsDeco shrinkText topBarTheme

-- myTabTheme = def
--     { fontName              = myFont
--     , activeColor           = active
--     , inactiveColor         = base02
--     , activeBorderColor     = active
--     , inactiveBorderColor   = base02
--     , activeTextColor       = base03
--     , inactiveTextColor     = base00
--     }

-- ------------------------------------------------------------------------
-- -- Key bindings
-- --
-- -- modMask lets you specify which modkey you want to use. The default
-- -- is mod1Mask ("left alt").  You may also consider using mod3Mask
-- -- ("right alt"), which does not conflict with emacs keybindings. The
-- -- "windows key" is usually mod4Mask.
-- --
-- myModMask = mod4Mask
-- altMask = mod1Mask




-- ------------------------------------------------------------------------
-- -- Status bars and logging
-- -- Perform an arbitrary action on each internal state change or X event.
-- -- See the 'DynamicLog' extension for examples.
-- --
-- -- To emulate dwm's status bar
-- --
-- -- > logHook = dynamicLogDzen
-- --


-- ------------------------------------------------------------------------
-- -- Startup hook
-- -- Perform an arbitrary action each time xmonad starts or is restarted
-- -- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- -- per-workspace layout choices.
-- --
-- -- By default, do nothing.
-- myStartupHook = do
--   setWMName "LG3D"
--   spawn     "bash ~/.xmonad/startup.sh"
--   setDefaultCursor xC_left_ptr


-- ------------------------------------------------------------------------
-- -- Run xmonad with all the defaults we set up.
-- --
-- main = do
--   xmproc <- spawnPipe "xmobar ~/.xmonad/xmobarrc.hs"
--   -- xmproc <- spawnPipe "taffybar"
--   xmonad $ docks
--          $ additionalNav2DKeys (xK_k, xK_h, xK_j, xK_l)
--                                [
--                                   (mod4Mask,               windowGo  )
--                                 , (mod4Mask .|. shiftMask, windowSwap)
--                                ]
--                                False
--          $ ewmh -- 
--          -- $ pagerHints -- uncomment to use taffybar
--          $ defaults {
--          logHook = dynamicLogWithPP xmobarPP {
--                   ppCurrent = xmobarColor xmobarCurrentWorkspaceColor "" . wrap "[" "]"
--                 , ppTitle = xmobarColor xmobarTitleColor "" . shorten 50
--                 , ppSep = "   "
--                 , ppOutput = hPutStrLn xmproc
--          } >> updatePointer (0.75, 0.75) (0.75, 0.75)
--       }

-- toggleFloat w = windows (\s -> if M.member w (W.floating s)
--                             then W.sink w s
--                             else (W.float w (W.RationalRect (1/3) (1/4) (1/2) (4/5)) s))
-- ------------------------------------------------------------------------
-- -- Combine it all together
-- -- A structure containing your configuration settings, overriding
-- -- fields in the default config. Any you don't override, will
-- -- use the defaults defined in xmonad/XMonad/Config.hs
-- --
-- -- No need to modify this.
-- --
-- defaults = gnomeConfig {
--     -- simple stuff
--     terminal           = myTerminal,
--     focusFollowsMouse  = myFocusFollowsMouse,
--     borderWidth        = myBorderWidth,
--     modMask            = myModMask,
--     workspaces         = myWorkspaces,
--     normalBorderColor  = myNormalBorderColor,
--     focusedBorderColor = myFocusedBorderColor,

--     -- key bindings
--     keys               = myKeys,
--     mouseBindings      = myMouseBindings,

--     -- hooks, layouts
--     layoutHook         = myLayout,
--     -- handleEventHook    = E.fullscreenEventHook,
--     handleEventHook    = fullscreenEventHook,
--     manageHook         = myManageHook,
--     startupHook        = myStartupHook
-- }


-- Base
import XMonad
import XMonad.Config
import System.Directory
import System.IO (hPutStrLn)
import System.Exit (exitSuccess)
import qualified XMonad.StackSet as W

    -- Actions
import XMonad.Actions.CopyWindow (kill1)
import XMonad.Actions.CycleWS (Direction1D(..), moveTo, shiftTo, WSType(..), nextScreen, prevScreen)
import XMonad.Actions.GridSelect
import XMonad.Actions.MouseResize
import XMonad.Actions.Promote
import XMonad.Actions.RotSlaves (rotSlavesDown, rotAllDown)
import XMonad.Actions.WindowGo (runOrRaise)
import XMonad.Actions.WithAll (sinkAll, killAll)
import qualified XMonad.Actions.Search as S
import XMonad.Actions.Navigation2D
import XMonad.Actions.UpdatePointer

    -- Data
import Data.Char (isSpace, toUpper)
import Data.Maybe (fromJust)
import Data.Monoid
import Data.Maybe (isJust)
import Data.Tree
import qualified Data.Map as M

    -- Hooks
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops  -- for some fullscreen events, also for xcomposite in obs.
import XMonad.Hooks.ManageDocks (avoidStruts, docksEventHook, manageDocks, ToggleStruts(..))
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.ServerMode
import XMonad.Hooks.SetWMName
import XMonad.Hooks.WorkspaceHistory

    -- Layouts
import XMonad.Layout.Accordion
import XMonad.Layout.GridVariants (Grid(Grid))
import XMonad.Layout.SimplestFloat
import XMonad.Layout.Spiral
import XMonad.Layout.ResizableTile
import XMonad.Layout.Tabbed
import XMonad.Layout.ThreeColumns
import XMonad.Layout.BinarySpacePartition as BSP
-- import XMonad.Layout.Fullscreen
-- import XMonad.Layout.NoBorders
-- import XMonad.Layout.Spacing
-- import XMonad.Layout.MultiToggle
-- import XMonad.Layout.MultiToggle.Instances
-- import XMonad.Layout.NoFrillsDecoration
-- import XMonad.Layout.Renamed
-- import XMonad.Layout.Simplest
-- import XMonad.Layout.SubLayouts
-- import XMonad.Layout.WindowNavigation
-- import XMonad.Layout.ZoomRow

    -- Layouts modifiers
import XMonad.Layout.LayoutModifier
import XMonad.Layout.LimitWindows (limitWindows, increaseLimit, decreaseLimit)
import XMonad.Layout.Magnifier
import XMonad.Layout.MultiToggle (mkToggle, single, EOT(EOT), (??))
import XMonad.Layout.MultiToggle.Instances (StdTransformers(NBFULL, MIRROR, NOBORDERS))
import XMonad.Layout.NoBorders
import XMonad.Layout.Renamed
import XMonad.Layout.ShowWName
import XMonad.Layout.Simplest
import XMonad.Layout.Spacing
import XMonad.Layout.SubLayouts
import XMonad.Layout.WindowArranger (windowArrange, WindowArrangerMsg(..))
import qualified XMonad.Layout.ToggleLayouts as T (toggleLayouts, ToggleLayout(Toggle))
import qualified XMonad.Layout.MultiToggle as MT (Toggle(..))

   -- Utilities
import XMonad.Util.Dmenu
import XMonad.Util.EZConfig (additionalKeysP)
import XMonad.Util.NamedScratchpad
import XMonad.Util.Run (runProcessWithInput, safeSpawn, spawnPipe)
import XMonad.Util.SpawnOnce

myFont :: String
myFont  = "xft:NanumGothic:size=9:regular:antialias=true:hinting=true"
-- myFont = "xft:SauceCodePro Nerd Font Mono:regular:size=9:antialias=true:hinting=true"

myModMask :: KeyMask
myModMask = mod4Mask        -- Sets modkey to super/windows key

myTerminal :: String
myTerminal = "alacritty"    -- Sets default terminal

myBrowser :: String
myBrowser = "qutebrowser "  -- Sets qutebrowser as browser

myEmacs :: String
myEmacs = "emacsclient -c -a 'emacs' "  -- Makes emacs keybindings easier to type

myEditor :: String
myEditor = "emacsclient -c -a 'emacs' "  -- Sets emacs as editor
-- myEditor = myTerminal ++ " -e vim "    -- Sets vim as editor

myBorderWidth :: Dimension
myBorderWidth = 2           -- Sets border width for windows

myNormColor :: String
myNormColor   = "#282c34"   -- Border color of normal windows

myFocusColor :: String
myFocusColor  = "#46d9ff"   -- Border color of focused windows

windowCount :: X (Maybe String)
windowCount = gets $ Just . show . length . W.integrate' . W.stack . W.workspace . W.current . windowset

myStartupHook :: X ()
myStartupHook = do
    spawnOnce "lxsession &"
    spawnOnce "xset r rate 200 30"
    spawnOnce "xset -dpms"
    spawnOnce "setterm -blank 0 -powerdown 0"
    spawnOnce "xset s off"
    spawnOnce "/usr/lib/xfce4/notifyd/xfce4-notifyd &"

    spawnOnce "picom &"
    spawnOnce "nm-applet &"
    spawnOnce "volumeicon &"
    spawnOnce "conky -c $HOME/.config/conky/xmonad.conkyrc"
    spawnOnce "trayer --edge top --align center --widthtype request --padding 0 --SetDockType true --SetPartialStrut true --expand true --monitor 1 --transparent true --alpha 0 --tint 0x282c34  --height 22 --iconspacing 10&"
    -- spawnOnce "/usr/bin/emacs --daemon &" -- emacs daemon for the emacsclient
    -- spawnOnce "kak -d -s mysession &"  -- kakoune daemon for better performance
    -- spawnOnce "urxvtd -q -o -f &"      -- urxvt daemon for better performance

    -- spawnOnce "xargs xwallpaper --stretch < ~/.xwallpaper"  -- set last saved with xwallpaper
    -- spawnOnce "/bin/ls ~/wallpapers | shuf -n 1 | xargs xwallpaper --stretch"  -- set random xwallpaper
    spawnOnce "~/.fehbg &"  -- set last saved feh wallpaper
    -- spawnOnce "feh --randomize --bg-fill ~/wallpapers/*"  -- feh set random wallpaper
    -- spawnOnce "nitrogen --restore &"   -- if you prefer nitrogen to feh
    spawnOnce "google-chrome &"
    spawnOnce "google-chrome-beta &"
    spawnOnce "noisetorch &"
    spawnOnce "sudo rmmod pcspkr"
    spawnOnce "yakyak &"
    spawnOnce "slack &"
    spawnOnce "NO_AT_BRIDGE=1 evolution &"
    spawnOnce "/opt/appimages/stoplight-studio.AppImage &"
    -- spawnOnce "stalonetray -c ~/.xmonad/.stalonetrayrc &"
    spawnOnce "/opt/notifier/bin/notifier.AppImage &"
    spawnOnce "albert &"
    spawnOnce "export XMODIFIERS=@im=ibus"
    spawnOnce "export GTK_IM_MODULE=ibus"
    spawnOnce "ibus-daemon  -drx &"
    spawnOnce "(sleep 5 && copyq) &"

    setWMName "LG3D"

myColorizer :: Window -> Bool -> X (String, String)
myColorizer = colorRangeFromClassName
                  (0x28,0x2c,0x34) -- lowest inactive bg
                  (0x28,0x2c,0x34) -- highest inactive bg
                  (0xc7,0x92,0xea) -- active bg
                  (0xc0,0xa7,0x9a) -- inactive fg
                  (0x28,0x2c,0x34) -- active fg

-- gridSelect menu layout
mygridConfig :: p -> GSConfig Window
mygridConfig colorizer = (buildDefaultGSConfig myColorizer)
    { gs_cellheight   = 40
    , gs_cellwidth    = 200
    , gs_cellpadding  = 6
    , gs_originFractX = 0.5
    , gs_originFractY = 0.5
    , gs_font         = myFont
    }

spawnSelected' :: [(String, String)] -> X ()
spawnSelected' lst = gridselect conf lst >>= flip whenJust spawn
    where conf = def
                   { gs_cellheight   = 40
                   , gs_cellwidth    = 200
                   , gs_cellpadding  = 6
                   , gs_originFractX = 0.5
                   , gs_originFractY = 0.5
                   , gs_font         = myFont
                   }

myAppGrid = [ ("Audacity", "audacity")
                 , ("Deadbeef", "deadbeef")
                 , ("Emacs", "emacsclient -c -a emacs")
                 , ("Firefox", "firefox")
                 , ("Geany", "geany")
                 , ("Geary", "geary")
                 , ("Gimp", "gimp")
                 , ("Kdenlive", "kdenlive")
                 , ("LibreOffice Impress", "loimpress")
                 , ("LibreOffice Writer", "lowriter")
                 , ("OBS", "obs")
                 , ("PCManFM", "pcmanfm")
                 ]

myScratchPads :: [NamedScratchpad]
myScratchPads = [ NS "terminal" spawnTerm findTerm manageTerm
                , NS "mocp" spawnMocp findMocp manageMocp
                , NS "calculator" spawnCalc findCalc manageCalc
                ]
  where
    spawnTerm  = myTerminal ++ " -t scratchpad"
    findTerm   = title =? "scratchpad"
    manageTerm = customFloating $ W.RationalRect l t w h
               where
                 h = 0.9
                 w = 0.9
                 t = 0.95 -h
                 l = 0.95 -w
    spawnMocp  = myTerminal ++ " -t mocp -e mocp"
    findMocp   = title =? "mocp"
    manageMocp = customFloating $ W.RationalRect l t w h
               where
                 h = 0.9
                 w = 0.9
                 t = 0.95 -h
                 l = 0.95 -w
    spawnCalc  = "qalculate-gtk"
    findCalc   = className =? "Qalculate-gtk"
    manageCalc = customFloating $ W.RationalRect l t w h
               where
                 h = 0.5
                 w = 0.4
                 t = 0.75 -h
                 l = 0.70 -w

--Makes setting the spacingRaw simpler to write. The spacingRaw module adds a configurable amount of space around windows.
mySpacing :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing i = spacingRaw False (Border i i i i) True (Border i i i i) True

-- Below is a variation of the above except no borders are applied
-- if fewer than two windows. So a single window has no gaps.
mySpacing' :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing' i = spacingRaw True (Border i i i i) True (Border i i i i) True

-- Defining a bunch of layouts, many that I don't use.
-- limitWindows n sets maximum number of windows displayed for layout.
-- mySpacing n sets the gap size around the windows.
tall     = renamed [Replace "tall"]
           $ smartBorders
           $ addTabs shrinkText myTabTheme
           -- $ subLayout [] (smartBorders Simplest)
           $ limitWindows 12
           $ mySpacing 0
           $ ResizableTall 1 (3/100) (1/2) []
magnify  = renamed [Replace "magnify"]
           $ smartBorders
           $ addTabs shrinkText myTabTheme
           $ subLayout [] (smartBorders Simplest)
           $ magnifier
           $ limitWindows 12
           $ mySpacing 8
           $ ResizableTall 1 (3/100) (1/2) []
monocle  = renamed [Replace "monocle"]
           $ smartBorders
           $ addTabs shrinkText myTabTheme
           $ subLayout [] (smartBorders Simplest)
           $ limitWindows 20 Full
floats   = renamed [Replace "floats"]
           $ smartBorders
           $ limitWindows 20 simplestFloat
grid     = renamed [Replace "grid"]
           $ smartBorders
           $ addTabs shrinkText myTabTheme
           $ subLayout [] (smartBorders Simplest)
           $ limitWindows 12
           $ mySpacing 8
           $ mkToggle (single MIRROR)
           $ Grid (16/10)
spirals  = renamed [Replace "spirals"]
           $ smartBorders
           $ addTabs shrinkText myTabTheme
           $ subLayout [] (smartBorders Simplest)
           $ mySpacing' 8
           $ spiral (6/7)
threeCol = renamed [Replace "threeCol"]
           $ smartBorders
           $ addTabs shrinkText myTabTheme
           $ subLayout [] (smartBorders Simplest)
           $ limitWindows 7
           $ ThreeCol 1 (3/100) (1/2)
threeRow = renamed [Replace "threeRow"]
           $ smartBorders
           $ addTabs shrinkText myTabTheme
           $ subLayout [] (smartBorders Simplest)
           $ limitWindows 7
           -- Mirror takes a layout and rotates it by 90 degrees.
           -- So we are applying Mirror to the ThreeCol layout.
           $ Mirror
           $ ThreeCol 1 (3/100) (1/2)
tabs     = renamed [Replace "tabs"]
           -- I cannot add spacing to this layout because it will
           -- add spacing between window and tabs which looks bad.
           $ tabbed shrinkText myTabTheme
tallAccordion  = renamed [Replace "tallAccordion"]
           $ Accordion
wideAccordion  = renamed [Replace "wideAccordion"]
           $ Mirror Accordion

-- setting colors for tabs layout and tabs sublayout.
myTabTheme = def { fontName            = myFont
                 , activeColor         = "#46d9ff"
                 , inactiveColor       = "#313846"
                 , activeBorderColor   = "#46d9ff"
                 , inactiveBorderColor = "#282c34"
                 , activeTextColor     = "#282c34"
                 , inactiveTextColor   = "#d0d0d0"
                 }

-- Theme for showWName which prints current workspace when you change workspaces.
myShowWNameTheme :: SWNConfig
myShowWNameTheme = def
    { swn_font              = "xft:Ubuntu:bold:size=60"
    , swn_fade              = 1.0
    , swn_bgcolor           = "#1c1f24"
    , swn_color             = "#ffffff"
    }

-- The layout hook
myLayoutHook = avoidStruts $ mouseResize $ windowArrange $ T.toggleLayouts floats
               $ mkToggle (NBFULL ?? NOBORDERS ?? EOT) myDefaultLayout
             where
               myDefaultLayout =     withBorder myBorderWidth tall
                                 ||| magnify
                                 ||| noBorders monocle
                                 ||| floats
                                 ||| noBorders tabs
                                 ||| grid
                                 ||| spirals
                                 ||| threeCol
                                 ||| threeRow
                                 ||| tallAccordion
                                 ||| wideAccordion


-- Config
myGoToSelectedColorizer  :: Window -> Bool -> X (String, String)
myGoToSelectedColorizer  = colorRangeFromClassName
                  (0x31,0x2e,0x39) -- lowest inactive bg
                  (0x31,0x2e,0x39) -- highest inactive bg
                  (0x78,0x3e,0x57) -- active bg
                  (0xc0,0xa7,0x9a) -- inactive fg
                  (0xff,0xff,0xff) -- active fg

wsconfig = defaultGSConfig
    { gs_cellheight   = 30
    , gs_cellwidth    = 200
    , gs_cellpadding  = 16
    , gs_originFractX = 0.5
    , gs_originFractY = 0.5
    , gs_font         = myFont
  }

-- wsconfig            = def
--     { gs_cellheight   = 30
--     , gs_cellwidth    = 300
--     , gs_cellpadding  = 16
--     , gs_originFractX = 0.5
--     , gs_originFractY = 0.0
--     , gs_font         = myFont
--     }

-- -- gridSelect move Workspace layout
-- wsconfig2           = def
--     { gs_cellheight   = 30
--     , gs_cellwidth    = 300
--     , gs_cellpadding  = 16
--     , gs_originFractX = 1.5
--     , gs_originFractY = 0.0
--     , gs_font         = myFont
--     }

-- myWorkspaces = [" 1 ", " 2 ", " 3 ", " 4 ", " 5 ", " 6 ", " 7 ", " 8 ", " 9 "]
-- myWorkspaces = [" dev ", " www ", " sys ", " doc ", " vbox ", " chat ", " mus ", " vid ", " gfx "]
myWorkspaces = ["1:emacs","2:web","3:mobile","4:testing","5:dev-misc","6:messenger","7:meeting","8:media","9:email"] ++ (map snd myExtraWorkspaces)
myExtraWorkspaces = [("0", "0:misc")]
myAllWorkspaces = [("1","1:emacs"),("2","2:web"),("3","3:mobile"),("4","4:testing"),("5","5:dev-misc"),("6","6:messenger"),("7","7:meeting"),("8","8:media"),("9", "9:email"),("0", "0:misc")]

myWorkspaceIndices = M.fromList $ zipWith (,) myWorkspaces [1..] -- (,) == \x y -> (x,y)

clickable ws = "<action=xdotool key super+"++show i++">"++ws++"</action>"
    where i = fromJust $ M.lookup ws myWorkspaceIndices

myManageHook :: XMonad.Query (Data.Monoid.Endo WindowSet)
myManageHook = composeAll
     -- 'doFloat' forces a window to float.  Useful for dialog boxes and such.
     -- using 'doShift ( myWorkspaces !! 7)' sends program to workspace 8!
     -- I'm doing it this way because otherwise I would have to write out the full
     -- name of my workspaces and the names would be very long if using clickable workspaces.
     [
       className =? "Google-chrome"                --> doShift "2:web"
     , stringProperty "_NET_WM_NAME" =? "Emulator" --> (doShift "3:mobile" <+> doFloat)
     , stringProperty "_NET_WM_NAME" =? "Android Emulator - luffy:5554" --> doShift "3:mobile"
     , stringProperty "_NET_WM_NAME" =? "Android Emulator - zoro:5556" --> doShift "3:mobile"
     , className =? "Stoplight Studio"             --> doShift "4:testing"
     , className =? "Slack"                        --> doShift "6:messenger"
     , className =? "yakyak"                       --> doShift "6:messenger"
     , className =? "Google-chrome-unstable"       --> doShift "7:meeting"
     , className =? "Google-chrome-beta"           --> doShift "7:meeting"
     , className =? "obs"                          --> doShift "8:media"
     , className =? "kdenlive"                     --> doShift "8:media"
     , className =? "Evolution"                    --> doShift "9:email"
     , stringProperty "_NET_WM_NAME" =? "NoiseTorch" --> doShift "0:misc"
     -- , className =? "Org.gnome.Nautilus"           --> doFloat
     , className =? "Gimp-2.10"                    --> doCenterFloat
     , resource  =? "gpicview"                     --> doCenterFloat
     , className =? "MPlayer"                      --> doCenterFloat
     , className =? "Pavucontrol"                  --> doCenterFloat
     , className =? "systemsettings"               --> doCenterFloat
     , resource  =? "desktop_window"               --> doIgnore
     , className =? "stalonetray"                  --> doIgnore
     , isFullscreen                                --> (doF W.focusDown <+> doFullFloat)
     , className =? "confirm"         --> doFloat
     , className =? "file_progress"   --> doFloat
     , className =? "dialog"          --> doFloat
     , className =? "download"        --> doFloat
     , className =? "error"           --> doFloat
     , className =? "Gimp"            --> doFloat
     , className =? "notification"    --> doFloat
     , className =? "pinentry-gtk-2"  --> doFloat
     , className =? "splash"          --> doFloat
     , className =? "toolbar"         --> doFloat
     , title =? "Oracle VM VirtualBox Manager"  --> doFloat
     , title =? "Mozilla Firefox"     --> doShift ( myWorkspaces !! 1 )
     , className =? "brave-browser"   --> doShift ( myWorkspaces !! 1 )
     , className =? "qutebrowser"     --> doShift ( myWorkspaces !! 1 )
     , className =? "mpv"             --> doShift ( myWorkspaces !! 7 )
     , className =? "Gimp"            --> doShift ( myWorkspaces !! 8 )
     , className =? "VirtualBox Manager" --> doShift  ( myWorkspaces !! 4 )
     , (className =? "firefox" <&&> resource =? "Dialog") --> doFloat  -- Float Firefox Dialog
     , isFullscreen -->  doFullFloat
     ] <+> namedScratchpadManageHook myScratchPads

myKeys conf@(XConfig {XMonad.modMask = modMask}) = M.fromList $
  ----------------------------------------------------------------------
  -- Custom key bindings
  --

  -- Start a terminal.  Terminal to start is specified by myTerminal variable.
  [
    -- ((modMask .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf)

  -- Lock the screen using command specified by myScreensaver.
  -- , ((modMask, xK_0), spawn myScreensaver)

  -- , ((controlMask, xK_grave), spawn "~/.emacs_anywhere/bin/run")

  -- Spawn the launcher using command specified by myLauncher.
  -- Use this to launch programs without a key binding.
  -- , ((modMask, xK_p), spawn myLauncher)

  -- Take a selective screenshot using the command specified by mySelectScreenshot.
  -- , ((modMask .|. shiftMask, xK_p), spawn mySelectScreenshot)

  -- Take a full screenshot using the command specified by myScreenshot.
  -- , ((modMask .|. controlMask .|. shiftMask, xK_p), spawn myScreenshot)

  -- Toggle current focus window to fullscreen
  -- , ((modMask, xK_f), sendMessage $ Toggle FULL)

  -- Mute volume.
  -- , ((0, xF86XK_AudioMute),
  --    spawn "amixer -q set Master toggle")

  -- -- Decrease volume.
  -- , ((0, xF86XK_AudioLowerVolume),
  --    spawn "amixer -q set Master 5%-")

  -- -- Increase volume.
  -- , ((0, xF86XK_AudioRaiseVolume),
  --    spawn "amixer -q set Master 5%+")

  -- Audio previous.
  -- , ((0, 0x1008FF16), spawn "")

  -- -- Play/pause.
  -- , ((0, 0x1008FF14), spawn "")

  -- -- Audio next.
  -- , ((0, 0x1008FF17), spawn "")

  -- Eject CD tray.
  -- , ((0, 0x1008FF2C), spawn "eject -T")

  --------------------------------------------------------------------
  -- "Standard" xmonad key bindings
  --

  -- Close focused window.
  -- , ((controlMask, xK_q), kill)

  -- Cycle through the available layout algorithms.
  -- , ((modMask, xK_space), sendMessage NextLayout)

  --  Reset the layouts on the current workspace to default.
  -- , ((modMask .|. shiftMask, xK_space), setLayout $ XMonad.layoutHook conf)

  -- Resize viewed windows to the correct size.
  -- , ((modMask, xK_n), refresh)

  -- Move focus to the next window.
  -- , ((modMask, xK_j), windows W.focusDown)

  -- Move focus to the previous window.
  -- , ((modMask, xK_k), windows W.focusUp  )

  -- Move focus to the master window.
  ((modMask, xK_m), windows W.focusMaster  )

  -- Swap the focused window and the master window.
  , ((modMask, xK_Return), windows W.swapMaster)

  -- Swap the focused window with the next window.
  , ((modMask .|. shiftMask, xK_j), windows W.swapDown  )

  -- Swap the focused window with the previous window.
  , ((modMask .|. shiftMask, xK_k), windows W.swapUp    )

  -- Shrink the master area.
  , ((modMask, xK_h), sendMessage Shrink)

  -- Expand the master area.
  , ((modMask, xK_comma), sendMessage Expand)

  -- Push window back into tiling.
  -- , ((modMask, xK_t), withFocused toggleFloat)
     -- withFocused $ windows . W.sink)

  -- Increment the number of windows in the master area. , ((modMask, xK_comma), sendMessage (IncMasterN 1))

  -- Decrement the number of windows in the master area.
  , ((modMask, xK_period), sendMessage (IncMasterN (-1)))

  -- Toggle the status bar gap.
  -- TODO: update this binding with avoidStruts, ((modMask, xK_b),

  -- Quit xmonad.
  -- , ((modMask .|. shiftMask, xK_q), io (exitWith ExitSuccess))

  -- Restart xmonad.
  -- , ((modMask, xK_q), restart "xmonad" True)
  ]
  ++

  -- mod-[1..9], Switch to workspace N
  -- mod-shift-[1..9], Move client to workspace N
  [((m .|. modMask, k), windows $ f i)
      | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
      , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
  ++

  -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
  -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
  [((m .|. modMask, key), screenWorkspace sc >>= flip whenJust (windows . f))
      | (key, sc) <- zip [xK_e, xK_r, xK_w] [0..]
      , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]


  ++
  -- Bindings for manage sub tabs in layouts please checkout the link below for reference
  -- https://hackage.haskell.org/package/xmonad-contrib-0.13/docs/XMonad-Layout-SubLayouts.html
  -- [
  --   -- Tab current focused window with the window to the left
  -- --   ((modMask .|. controlMask, xK_h), sendMessage $ pullGroup L)
  -- --   -- Tab current focused window with the window to the right
  -- -- , ((modMask .|. controlMask, xK_l), sendMessage $ pullGroup R)
  -- --   -- Tab current focused window with the window above
  -- -- , ((modMask .|. controlMask, xK_k), sendMessage $ pullGroup U)
  -- --   -- Tab current focused window with the window below
  -- -- , ((modMask .|. controlMask, xK_j), sendMessage $ pullGroup D)

  -- -- Tab all windows in the current workspace with current window as the focus
  -- -- , ((modMask .|. controlMask, xK_m), withFocused (sendMessage . MergeAll))
  -- -- -- Group the current tabbed windows
  -- -- , ((modMask .|. controlMask, xK_u), withFocused (sendMessage . UnMerge))

  -- -- Toggle through tabes from the right
  -- , ((modMask, xK_Tab), onGroup W.focusDown')
  -- ]

  -- ++
  -- Some bindings for BinarySpacePartition
  -- https://github.com/benweitzman/BinarySpacePartition
  [
    ((modMask .|. controlMask,               xK_l ), sendMessage $ ExpandTowards R)
  , ((modMask .|. controlMask .|. shiftMask, xK_l ), sendMessage $ ShrinkFrom R)
  , ((modMask .|. controlMask,               xK_h  ), sendMessage $ ExpandTowards L)
  , ((modMask .|. controlMask .|. shiftMask, xK_h  ), sendMessage $ ShrinkFrom L)
  , ((modMask .|. controlMask,               xK_j  ), sendMessage $ ExpandTowards D)
  , ((modMask .|. controlMask .|. shiftMask, xK_j  ), sendMessage $ ShrinkFrom D)
  , ((modMask .|. controlMask,               xK_k    ), sendMessage $ ExpandTowards U)
  , ((modMask .|. controlMask .|. shiftMask, xK_k    ), sendMessage $ ShrinkFrom U)
  -- , ((modMask,                               xK_r     ), sendMessage BSP.Rotate)
  , ((modMask,                               xK_s     ), sendMessage BSP.Swap)
  -- , ((modMask,                               xK_n     ), sendMessage BSP.FocusParent)
  -- , ((modMask .|. controlMask,               xK_n     ), sendMessage BSP.SelectNode)
  -- , ((modMask .|. shiftMask,                 xK_n     ), sendMessage BSP.MoveNode)
  ]
  -- ++
  -- [
  --     ((myModMask, key), (windows $ W.greedyView ws))
  --     | (key, ws) <- myExtraWorkspaces
  -- ] ++ [
  --     ((myModMask .|. shiftMask, key), (windows $ W.shift ws))
  --     | (key, ws) <- myExtraWorkspaces
  -- ]

-- ------------------------------------------------------------------------
-- -- Mouse bindings
-- --
-- -- Focus rules
-- -- True if your focus should follow your mouse cursor.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

myMouseBindings (XConfig {XMonad.modMask = modMask}) = M.fromList $
  [
    -- mod-button1, Set the window to floating mode and move by dragging
    ((modMask, button1),
     (\w -> focus w >> mouseMoveWindow w))

    -- mod-button2, Raise the window to the top of the stack
    , ((modMask, button2),
       (\w -> focus w >> windows W.swapMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modMask, button3),
       (\w -> focus w >> mouseResizeWindow w))
    -- you may also bind events to the mouse scroll wheel (button4 and button5)
  ]

myAdditionalKeys :: [(String, X ())]
myAdditionalKeys  = 
        [ -- ("M-C-r", spawn "xmonad --recompile")  -- Recompiles xmonad
        ("M-C-r", spawn "xmonad --restart")    -- Restarts xmonad
        , ("M-C-q", io exitSuccess)              -- Quits xmonad


    -- Other Dmenu Prompts
    -- In Xmonad and many tiling window managers, M-p is the default keybinding to
    -- launch dmenu_run, so I've decided to use M-p plus KEY for these dmenu scripts.
        , ("M-p a", spawn "dm-sounds")    -- choose an ambient background
        , ("M-p b", spawn "dm-setbg")     -- set a background
        , ("M-p c", spawn "dm-colpick")   -- pick color from our scheme
        , ("M-p e", spawn "dm-confedit")  -- edit config files
        , ("M-p i", spawn "dm-maim")      -- screenshots (images)
        , ("M-p k", spawn "dm-kill")      -- kill processes
        , ("M-p m", spawn "dm-man")       -- manpages
        , ("M-p o", spawn "dm-bookman")   -- qutebrowser bookmarks/history
        , ("M-p p", spawn "passmenu")     -- passmenu
        , ("M-p q", spawn "dm-logout")    -- logout menu
        , ("M-p r", spawn "dm-reddit")    -- reddio (a reddit viewer)
        , ("M-p s", spawn "dm-websearch") -- search various search engines

    -- Useful programs to have a keybinding for launch
        , ("M-<Return>", spawn (myTerminal))
        , ("M-b", spawn (myBrowser ++ " www.youtube.com/c/DistroTube/"))
        , ("M-M1-h", spawn (myTerminal ++ " -e htop"))

    -- Windows
        , ("C-q", kill)     -- Kill the currently focused client
        , ("M-S-c", kill)     -- Kill the currently focused client
        , ("M-S-a", killAll)   -- Kill all windows on current workspace

    -- Floating windows
        , ("M-f", sendMessage (T.Toggle "floats")) -- Toggles my 'floats' layout
        , ("M-t", withFocused $ windows . W.sink)  -- Push floating window back to tile
        , ("M-S-t", sinkAll)                       -- Push ALL floating windows to tile

    -- Increase/decrease spacing (gaps)
        , ("C-M1-j", decWindowSpacing 4)         -- Decrease window spacing
        , ("C-M1-k", incWindowSpacing 4)         -- Increase window spacing
        , ("C-M1-h", decScreenSpacing 4)         -- Decrease screen spacing
        , ("C-M1-l", incScreenSpacing 4)         -- Increase screen spacing

    -- Run Prompt
        , ("C-<Space> .", spawn "dmenu_run -i -p \"Run: \"") -- Dmenu
        , ("C-<Space> <Return>", spawn "~/.emacs_anywhere/bin/run")

    -- Windows (Application)
        , ("C-<Space> a .", windows W.focusMaster)  -- Move focus to the master window
        , ("C-<Space> a m", windows W.swapMaster) -- Swap the focused window and the master window
        , ("C-<Space> a j", windows W.swapDown)   -- Swap focused window with next window
        , ("C-<Space> a k", windows W.swapUp)     -- Swap focused window with prev window
        , ("C-<Space> a p", promote)      -- Moves focused window to master, others maintain order
        , ("C-<Space> a r s", rotSlavesDown)    -- Rotate all windows except master and keep focus in place
        , ("C-<Space> a r a", rotAllDown)       -- Rotate all the windows in the current stack
        , ("C-<Space> a <Return>", refresh)
        , ("M-j", windows W.focusDown)    -- Move focus to the next window
        , ("M-k", windows W.focusUp)      -- Move focus to the prev window

    -- Grid Select (CTR-g followed by a key)
        , ("C-<Space> g n", spawnSelected' myAppGrid)                 -- grid select favorite apps
        , ("C-<Space> g a", goToSelected $ mygridConfig myColorizer)  -- goto selected window
        , ("C-<Space> g b a", bringSelected $ mygridConfig myColorizer) -- bring selected window
        , ("C-<Space> g b w", gridselectWorkspace wsconfig (\ws -> W.greedyView ws . W.shift ws))
        , ("C-<Space> g w", gridselectWorkspace wsconfig (\ws -> W.greedyView ws))

    -- Layouts
        , ("C-<Space> l n", sendMessage NextLayout)           -- Switch to next layout
        , ("C-<Space> l f", sendMessage (MT.Toggle NBFULL) >> sendMessage ToggleStruts) -- Toggles noborder/full
        , ("C-<Space> l m", withFocused (sendMessage . MergeAll))
        , ("C-<Space> l u", withFocused (sendMessage . UnMerge))
        , ("C-<Space> l U", withFocused (sendMessage . UnMergeAll))
        , ("C-<Space> l .", onGroup W.focusUp')    -- Switch focus to next tab
        , ("C-<Space> l ,", onGroup W.focusDown')  -- Switch focus to prev tab
        -- , ("M-S-<Space>", setLayout $ XMonad.layoutHook conf)

    -- Screen
        , ("C-<Space> s n", nextScreen)  -- Switch focus to next monitor
        , ("C-<Space> s p", prevScreen)  -- Switch focus to prev monitor
        , ("C-<Space> s m n", shiftTo Next nonNSP >> moveTo Next nonNSP)       -- Shifts focused window to next ws
        , ("C-<Space> s m p", shiftTo Prev nonNSP >> moveTo Prev nonNSP)  -- Shifts focused window to prev ws

    -- Increase/decrease windows in the master pane or the stack
        , ("M-S-<Up>", sendMessage (IncMasterN 1))      -- Increase # of clients master pane
        , ("M-S-<Down>", sendMessage (IncMasterN (-1))) -- Decrease # of clients master pane
        , ("M-C-<Up>", increaseLimit)                   -- Increase # of windows
        , ("M-C-<Down>", decreaseLimit)                 -- Decrease # of windows

    -- Window resizing
        , ("M-C-h", sendMessage Shrink)                   -- Shrink horiz window width
        , ("M-C-l", sendMessage Expand)                   -- Expand horiz window width
        , ("M-M1-j", sendMessage MirrorShrink)          -- Shrink vert window width
        , ("M-M1-k", sendMessage MirrorExpand)          -- Expand vert window width

    -- Sublayouts
    -- This is used to push windows to tabbed sublayouts, or pull them out of it.
        -- , ("M-C-h", sendMessage $ pullGroup L)
        -- , ("M-C-l", sendMessage $ pullGroup R)
        -- , ("M-C-k", sendMessage $ pullGroup U)
        -- , ("M-C-j", sendMessage $ pullGroup D)

    -- Scratchpads
    -- Toggle show/hide these programs.  They run on a hidden workspace.
    -- When you toggle them to show, it brings them to your current workspace.
    -- Toggle them to hide and it sends them back to hidden workspace (NSP).
        , ("C-s t", namedScratchpadAction myScratchPads "terminal")
        , ("C-s m", namedScratchpadAction myScratchPads "mocp")
        , ("C-s c", namedScratchpadAction myScratchPads "calculator")

    -- Set wallpaper with 'feh'. Type 'SUPER+F1' to launch sxiv in the wallpapers directory.
    -- Then in sxiv, type 'C-x w' to set the wallpaper that you choose.
        , ("M-<F1>", spawn "sxiv -r -q -t -o ~/wallpapers/*")
        , ("M-<F2>", spawn "/bin/ls ~/wallpapers | shuf -n 1 | xargs xwallpaper --stretch")
        --, ("M-<F2>", spawn "feh --randomize --bg-fill ~/wallpapers/*")

    -- Controls for mocp music player (SUPER-u followed by a key)
        , ("M-u p", spawn "mocp --play")
        , ("M-u l", spawn "mocp --next")
        , ("M-u h", spawn "mocp --previous")
        , ("M-u <Space>", spawn "mocp --toggle-pause")

    -- Emacs (CTRL-e followed by a key)
        -- , ("C-e e", spawn myEmacs)                 -- start emacs
        , ("C-e e", spawn (myEmacs ++ ("--eval '(dashboard-refresh-buffer)'")))   -- emacs dashboard
        , ("C-e b", spawn (myEmacs ++ ("--eval '(ibuffer)'")))   -- list buffers
        , ("C-e d", spawn (myEmacs ++ ("--eval '(dired nil)'"))) -- dired
        , ("C-e i", spawn (myEmacs ++ ("--eval '(erc)'")))       -- erc irc client
        , ("C-e m", spawn (myEmacs ++ ("--eval '(mu4e)'")))      -- mu4e email
        , ("C-e n", spawn (myEmacs ++ ("--eval '(elfeed)'")))    -- elfeed rss
        , ("C-e s", spawn (myEmacs ++ ("--eval '(eshell)'")))    -- eshell
        , ("C-e t", spawn (myEmacs ++ ("--eval '(mastodon)'")))  -- mastodon.el
        -- , ("C-e v", spawn (myEmacs ++ ("--eval '(vterm nil)'"))) -- vterm if on GNU Emacs
        , ("C-e v", spawn (myEmacs ++ ("--eval '(+vterm/here nil)'"))) -- vterm if on Doom Emacs
        -- , ("C-e w", spawn (myEmacs ++ ("--eval '(eww \"distrotube.com\")'"))) -- eww browser if on GNU Emacs
        , ("C-e w", spawn (myEmacs ++ ("--eval '(doom/window-maximize-buffer(eww \"distrotube.com\"))'"))) -- eww browser if on Doom Emacs
        -- emms is an emacs audio player. I set it to auto start playing in a specific directory.
        , ("C-e a", spawn (myEmacs ++ ("--eval '(emms)' --eval '(emms-play-directory-tree \"~/Music/Non-Classical/70s-80s/\")'")))

    -- Multimedia Keys
        , ("<XF86AudioPlay>", spawn (myTerminal ++ "mocp --play"))
        , ("<XF86AudioPrev>", spawn (myTerminal ++ "mocp --previous"))
        , ("<XF86AudioNext>", spawn (myTerminal ++ "mocp --next"))
        , ("<XF86AudioMute>", spawn "amixer set Master toggle")
        , ("<XF86AudioLowerVolume>", spawn "amixer set Master 5%- unmute")
        , ("<XF86AudioRaiseVolume>", spawn "amixer set Master 5%+ unmute")
        , ("<XF86HomePage>", spawn "qutebrowser https://www.youtube.com/c/DistroTube")
        , ("<XF86Search>", spawn "dmsearch")
        , ("<XF86Mail>", runOrRaise "thunderbird" (resource =? "thunderbird"))
        , ("<XF86Calculator>", runOrRaise "qalculate-gtk" (resource =? "qalculate-gtk"))
        , ("<XF86Eject>", spawn "toggleeject")
        , ("<Print>", spawn "dmscrot")

        -- , ("M-w", screenWorkspace 0)
        -- , ("M-e", screenWorkspace 1)
        -- , ("M-r", screenWorkspace 1)
        ]
        ++
        [
          ("C-<Space> "++key, windows $ W.greedyView ws)
          | (key, ws) <- myAllWorkspaces
        ] ++ [
          ("C-<Space> a "++key, windows $ W.shift ws)
          | (key, ws) <- myAllWorkspaces
        ]
          where nonNSP          = WSIs (return (\ws -> W.tag ws /= "NSP"))
                nonEmptyNonNSP  = WSIs (return (\ws -> isJust (W.stack ws) && W.tag ws /= "NSP"))

main :: IO ()
main = do
    -- Launching three instances of xmobar on their monitors.
    xmproc0 <- spawnPipe "xmobar -x 0 $HOME/.xmonad/xmobarrc.hs"
    -- xmproc1 <- spawnPipe "xmobar -x 1 $HOME/.config/xmobar/xmobarrc1"
    -- xmproc2 <- spawnPipe "xmobar -x 2 $HOME/.config/xmobar/xmobarrc2"
    -- the xmonad, ya know...what the WM is named after!
    xmonad
      $ additionalNav2DKeys (xK_k, xK_h, xK_j, xK_l)
                               [
                                  (mod4Mask,               windowGo  )
                                , (mod4Mask .|. shiftMask, windowSwap)
                               ]
                               False
      $ ewmh def
        { manageHook         = myManageHook <+> manageDocks
        , handleEventHook    = docksEventHook
                               -- Uncomment this line to enable fullscreen support on things like YouTube/Netflix.
                               -- This works perfect on SINGLE monitor systems. On multi-monitor systems,
                               -- it adds a border around the window if screen does not have focus. So, my solution
                               -- is to use a keybinding to toggle fullscreen noborders instead.  (M-<Space>)
                               -- <+> fullscreenEventHook
        , modMask            = myModMask
        , terminal           = myTerminal
        , startupHook        = myStartupHook
        , layoutHook         = showWName' myShowWNameTheme $ myLayoutHook
        , workspaces         = myWorkspaces
        , borderWidth        = myBorderWidth
        , normalBorderColor  = myNormColor
        , focusedBorderColor = myFocusColor
        , keys               = myKeys
        -- , focusFollowsMouse  = myFocusFollowsMouse
        , mouseBindings      = myMouseBindings
        , logHook = dynamicLogWithPP $ namedScratchpadFilterOutWorkspacePP $ xmobarPP
              -- the following variables beginning with 'pp' are settings for xmobar.
              { ppOutput = hPutStrLn xmproc0 -- \x -> hPutStrLn xmproc0 x                          -- xmobar on monitor 1
                              -- >> hPutStrLn xmproc1 x                          -- xmobar on monitor 2
                              -- >> hPutStrLn xmproc2 x                          -- xmobar on monitor 3
              , ppCurrent = xmobarColor "#98be65" "" . wrap "[" "]"           -- Current workspace
              , ppVisible = xmobarColor "#98be65" "" . clickable              -- Visible but not current workspace
              , ppHidden = xmobarColor "#82AAFF" "" . wrap "*" "" . clickable -- Hidden workspaces
              , ppHiddenNoWindows = xmobarColor "#c792ea" ""  . clickable     -- Hidden workspaces (no windows)
              , ppTitle = xmobarColor "#b3afc2" "" . shorten 60               -- Title of active window
              , ppSep =  "<fc=#666666> <fn=1>|</fn> </fc>"                    -- Separator character
              , ppUrgent = xmobarColor "#C45500" "" . wrap "!" "!"            -- Urgent workspace
              , ppExtras  = [windowCount]                                     -- # of windows current workspace
              , ppOrder  = \(ws:l:t:ex) -> [ws,l]++ex++[t]                    -- order of things in xmobar
              }
        } `additionalKeysP` myAdditionalKeys
