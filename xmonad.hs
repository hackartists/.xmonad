{-# OPTIONS_GHC -Wno-unused-matches #-}
{-# LANGUAGE ParallelListComp #-}
{-# LANGUAGE DataKinds #-}
{-# OPTIONS_GHC -Wno-deprecations #-}
import XMonad hiding ( (|||) )
import XMonad.Config
-- import System.Directory
import System.IO (hPutStrLn)
import System.Exit (exitSuccess)
import qualified XMonad.StackSet as W
import Control.Concurrent
import Control.Monad

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
import XMonad.Actions.PhysicalScreens

-- Data
import Data.Char (isSpace, toUpper)
import Data.Maybe ( fromJust, isJust )
import Data.Monoid
import Data.Tree
import qualified Data.Map as M
-- import Data.Default

-- Hooks
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops  -- for some fullscreen events, also for xcomposite in obs.
import XMonad.Hooks.ManageDocks (avoidStruts, docksEventHook, manageDocks, ToggleStruts(..))
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.ServerMode
import XMonad.Hooks.SetWMName
import XMonad.Hooks.WorkspaceHistory
import XMonad.Hooks.RefocusLast

-- Layouts
import XMonad.Layout hiding ( (|||) )
import XMonad.Layout.Fullscreen
import XMonad.Layout.Accordion
import XMonad.Layout.GridVariants (Grid(Grid))
import XMonad.Layout.SimplestFloat
import XMonad.Layout.Spiral
import XMonad.Layout.ResizableTile
import XMonad.Layout.Tabbed
import XMonad.Layout.ThreeColumns
import XMonad.Layout.BinarySpacePartition as BSP
import XMonad.Layout.ZoomRow
import XMonad.Layout.Master
import XMonad.Layout.PerWorkspace

-- import XMonad.Layout.NoFrillsDecoration
import XMonad.Layout.WindowNavigation
import XMonad.Layout.LayoutCombinators
import XMonad.Layout.LayoutHints
import XMonad.Actions.DynamicWorkspaceGroups

-- Layouts modifiers
import XMonad.Layout.LayoutModifier
import XMonad.Layout.LimitWindows (limitWindows, increaseLimit, decreaseLimit)
import XMonad.Layout.Magnifier hiding (magnify)
import XMonad.Layout.MultiToggle (mkToggle, single, EOT(EOT), (??))
-- import XMonad.Layout.MultiToggle
import XMonad.Layout.MultiToggle.Instances
import XMonad.Layout.NoBorders
import XMonad.Layout.Named
import XMonad.Util.NamedWindows
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
import XMonad.Prompt
import XMonad.Prompt.Window 
import qualified XMonad.Prompt.Window as W
import Data.HashMap.Strict (toList)

myFont :: String
myFont  = "xft:NanumGothic:size=9:regular:antialias=true:hinting=true"

myModMask :: KeyMask
myModMask = mod4Mask        -- Sets modkey to super/windows key

myTerminal :: String
myTerminal = "xterm"    -- Sets default terminal

myEmacs :: String
myEmacs = "emacsclient -c -a 'emacs' "  -- Makes emacs keybindings easier to type

myBorderWidth :: Dimension
myBorderWidth = 2           -- Sets border width for windows

myNormColor :: String
myNormColor   = "#282c34"   -- Border color of normal windows

myFocusColor :: String
myFocusColor  = "#ff0000" -- "#46d9ff"   -- Border color of focused windows

windowCount :: X (Maybe String)
windowCount = gets $ Just . show . length . W.integrate' . W.stack . W.workspace . W.current . windowset

addCustomWSGroup :: WSGroupId -> WorkspaceId -> WorkspaceId  -> WorkspaceId -> X()
addCustomWSGroup n s1 s0 s2 = addRawWSGroup n [(S 0, s0), (S 2, s2), (S 1, s1)]

myStartupHook :: X ()
myStartupHook = do
    addCustomWSGroup "devb" "1:emacs" "2:web"      "6:messenger"
    addCustomWSGroup "devf" "1:emacs" "2:web"      "3:debugging"
    addCustomWSGroup "stdh" "1:emacs" "2:web"      "5:study"
    addCustomWSGroup "mtdv" "1:emacs" "7:meeting"  "6:messenger"

    addCustomWSGroup "webd" "2:web" "1:emacs"  "6:messenger"
    addCustomWSGroup "mtht" "2:web" "7:meeting"  "6:messenger"

    addCustomWSGroup "test" "4:testing" "1:emacs" "2:web"

    addCustomWSGroup "stde"  "5:study" "1:emacs" "2:web"

    addCustomWSGroup "meet"  "7:meeting" "1:emacs"  "6:messenger"

    addCustomWSGroup "medi"  "2:web" "8:media" "1:emacs"

    spawnOnce "lxsession"
    spawn "xrdb ~/.Xresources && xrdb -merge ~/.Xresources"
    -- spawnOnce  "setxkbmap dvorak"
    spawnOnce "xset r rate 200 30"
    spawnOnce "xset -dpms"
    spawnOnce "setterm -blank 0 -powerdown 0"
    spawnOnce "setxkbmap -option caps:escape"
    spawnOnce "xset s off"
    spawnOnce "/usr/lib/xfce4/notifyd/xfce4-notifyd"
    -- spawnOnce "/usr/bin/emacs --daemon &"
    spawnOnce "picom"
    spawnOnce "nm-applet"
    spawnOnce "volumeicon"
    spawnOnce "blueman-manager"
    -- spawnOnce "conky -c $HOME/.config/conky/xmonad.conkyrc"
    spawnOnce "/bin/bash $HOME/.xmonad/tray.sh"
    -- spawnOnce "~/.fehbg"
    spawnOnce "google-chrome-stable"
    -- spawnOnce "google-chrome-beta"
    spawnOnce "sudo rmmod pcspkr"
    -- spawnOnce "yakyak"
    -- spawnOnce "zoom"
    spawnOnce "slack"
    -- spawnOnce "gitter"
    -- spawnOnce "telegram-desktop"
    -- spawnOnce "NO_AT_BRIDGE=1 evolution &"
    -- spawnOnce "/opt/appimages/stoplight-studio.AppImage &"
    spawnOnce "/opt/notifier/bin/notifier.AppImage &"
    spawnOnce "albert &"
    -- spawnOnce "export XMODIFIERS=@im=ibus"
    -- spawnOnce "export GTK_IM_MODULE=ibus"
    spawnOnce "ibus-daemon -drx --panel /usr/lib/ibus/ibus-ui-gtk3"
    -- spawnOnce "nabi"
    spawnOnce "(sleep 5 && copyq)"
    spawnOnce "emacs --name emacs-main"
    spawnOnce "whatsdesk --force-device-scale-factor=1.5"
    -- spawnOnce "pidgin"
    -- spawnOnce "whatsapp-for-linux"
    -- gromit block capturing screen
    -- spawnOnce "gromit-mpx"
    -- spawnOnce "autokey-gtk"
    -- spawnOnce "discord"
    -- spawnOnce "sudo virsh net-start default"
    -- spawnOnce "remmina"
    -- spawnOnce "sleep 10 && $HOME/.local/customized_start.sh"
    -- spawnOnce "wine \"/home/hackartist/.wine/drive_c/Program Files (x86)/Kakao/KakaoTalk/KakaoTalk.exe\""

    setWMName "LG3D"
    viewCenteredWSGroup "devb"

myScratchPads :: [NamedScratchpad]
myScratchPads = [ NS "terminal" spawnTerm findTerm manageDefault
                , NS "mocp" spawnMocp findMocp manageDefault
                , NS "calculator" spawnCalc findCalc manageCalc
                , NS "emacs" spawnEmacs findEmacs manageDefault
                , NS "emacsanywhere" spawnEmacsanywhere findEmacsanywhere manageDefault
                , NS "whatsapp" spawnWhatsdesk findWhatsdesk manageDefault
                , NS "ranger" spawnRanger findRanger manageDefault
                ]
  where
    spawnTerm  = myTerminal ++ " -t scratchpad"
    findTerm   = title =? "scratchpad"
    manageDefault = customFloating $ W.RationalRect l t w h
               where
                 h = 0.9
                 w = 0.9
                 t = 0.95 -h
                 l = 0.95 -w
    spawnMocp  = myTerminal ++ " -t mocp -e mocp"
    findMocp   = title =? "mocp"
    spawnCalc  = "qalculate-gtk"
    findCalc   = className =? "Qalculate-gtk"
    manageCalc = customFloating $ W.RationalRect l t w h
               where
                 h = 0.5
                 w = 0.4
                 t = 0.75 -h
                 l = 0.70 -w
    spawnEmacs  = myEmacs ++ " -e '(hackartist/scratch-buffer-only)' -F '((name . \"scratchpad-emacs\"))'"
    findEmacs   = title =? "scratchpad-emacs"
    spawnEmacsanywhere  = "EA_TITLE='scratchpad-ea' ~/.emacs_anywhere/bin/run"
    spawnWhatsdesk  = "whatsdesk"
    findWhatsdesk  = title =? "WhatsDesk"
    findEmacsanywhere   = title =? "scratchpad-ea"
    spawnRanger = "ranger"
    findRanger = className =? "gnome-terminal-server"

mySpacing :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing i = spacingRaw False (Border i i i i) True (Border i i i i) True

mySpacing' :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing' i = spacingRaw True (Border i i i i) True (Border i i i i) True

tall     = renamed [Replace "tall"]
           $ smartBorders
           $ addTabs shrinkText myTabTheme
           -- $ subLayout [] (smartBorders Simplest)
           $ limitWindows 12
           $ mySpacing 0
           -- $ mastered (3/100) (1/2)
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
tallAccordion  = renamed [Replace "tallAccordion"] Accordion
wideAccordion  = renamed [Replace "wideAccordion"]
           $ Mirror Accordion

myTabTheme = def { fontName            = myFont
                 , activeColor         = "#46d9ff"
                 , inactiveColor       = "#313846"
                 -- , activeBorderColor   = "#ff0000"
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
-- myLayoutHook = avoidStruts $ onWorkspace "6:messenger" (noBorders tabs) $ mouseResize $ windowArrange
myLayoutHook = avoidStruts $ mouseResize $ windowArrange
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
                                 ||| Mirror zoomRow

-- workspace grid config
wsconfig = def {
  gs_cellwidth    = 350
  , gs_font =  "xft:NanumGothic:size=11:regular:antialias=true:hinting=true"
  }

myColorizer a active = if active then return ("#faff69", "black") else return ("#aaaaaa", "white")
myColorizer1 a active = if active then return ("#faff69", "black") else return ("#888888", "white")
myColorizer2 a active = if active then return ("#faff69", "black") else return ("#666666", "white")
myColorizer3 a active = if active then return ("#faff69", "black") else return ("#444444", "white")

mygridConfig :: Int -> GSConfig a
mygridConfig depth = do
  let conf
        | depth == 0 = buildDefaultGSConfig myColorizer
        | depth == 1 = buildDefaultGSConfig myColorizer1
        | depth == 2 = buildDefaultGSConfig myColorizer2
        | otherwise = buildDefaultGSConfig myColorizer3
  conf{ gs_cellwidth    = 200
       , gs_font =  "xft:NanumGothic:size=11:regular:antialias=true:hinting=true"
       }

viewCenteredWSGroup :: String -> X()
viewCenteredWSGroup wid = do
  viewWSGroup wid
  viewScreen def 1

makeAction :: Int -> [(String, (KeyMask, KeySym), X())] -> X()
makeAction depth lst = do
  let l = length lst
  let grid = [
        (name, cmd)  | (name, key, cmd) <- lst
        ] ++ [
        ("", spawn "") | _ <- [1..25-l]
                       ]
  runSelectedAction conf grid
    where
      conf = (mygridConfig depth) {
        gs_navigate = nav
        }
        where
        nav = makeXEventhandler $ shadowWithKeymap navKeyMap navDefaultHandler
          where navKeyMap = M.fromList $ keymap [
                  ((0,xK_Escape), cancel)
                  ,((0,xK_Return), select)
                  ,((0,xK_slash) , substringSearch nav)
                  ,((0,xK_Left)  , move (-1,0) >> nav)
                  ,((0,xK_h)     , move (-1,0) >> nav)
                  ,((0,xK_Right) , move (1,0)   >> nav)
                  ,((0,xK_l)     , move (1,0)   >> nav)
                  ,((0,xK_Down)  , move (0,1)   >> nav)
                  ,((0,xK_j)     , move (0,1)   >> nav)
                  ,((0,xK_Up)    , move (0,-1)  >> nav)
                  ,((0,xK_k)     , move (0,-1)  >> nav)
                  ] lst
                                    -- The navigation handler ignores unknown key symbols
                navDefaultHandler = const nav

keymap ::  [((KeyMask,KeySym), TwoD a0 (Maybe a0))] -> [(String, (KeyMask, KeySym), X())]-> [((KeyMask,KeySym), TwoD a0 (Maybe a0))]
keymap keys lst = take 25 [
        if i < length lst then (key, setPos(x,y) >> select) else ((0,xK_asterisk), cancel)
        | (_, key,_) <- lst
        | i <- [0..25]
          -- let (q,r) = i `divMod` 4,
          -- let si = 4 * (q +1),
          -- let (ssi,_) = si `divMod` 2
        | (x,y) <- [ (0,0),
                     (0,1),(1,0),(0,-1),(-1,0)
                   , (0,2),(1,1),(2,0),(1,-1),(0,-2),(-1,-1),(-2,0),(-1,1)
                   , (0,3),(1,2),(2,1),(3,0),(2,-1),(1,-2),(0,-3),(-1,-2),(-2,-1),(-3,0),(-2,1),(-1,2)]
        ] ++ keys

layoutAction = makeAction 1
               $ [
                ("(SPC)toggle full screen", (0, xK_space), sendMessage (MT.Toggle FULL) >> sendMessage ToggleStruts)
                , ("(TAB)next layout", (0, xK_Tab),  sendMessage NextLayout)
                , ("(M)erge all windows", (shiftMask, xK_M), withFocused (sendMessage . MergeAll))
                , ("(u)nmerge a window", (0, xK_u), withFocused (sendMessage . UnMerge))
                , ("(U)nmerge all windows", (shiftMask, xK_U), withFocused (sendMessage . UnMergeAll))
                , ("(.)focus up", (0, xK_period), onGroup W.focusUp')
                , ("(,)focus down", (0, xK_comma), onGroup W.focusDown')
                ] ++ [
                (ln, key, sendMessage $ JumpToLayout l)
                | (ln, key, l) <- [
                    ("(t)all",(0,xK_t),"tall")
                    , ("(m)agnify",(0,xK_m),"magnify")
                    , ("mo(n)ocle",(0,xK_n),"monocle")
                    , ("(f)loats",(0,xK_f),"floats")
                    , ("(g)rid",(0,xK_g),"grid")
                    , ("(s)pirals",(0,xK_s),"spirals")
                    , ("three(C)ol",(shiftMask,xK_C),"threeCol")
                    , ("three(R)ow",(shiftMask,xK_R),"threeRow")
                    , ("ta(b)s",(0,xK_b),"tabs")
                    , ("t(a)llAccordion",(0,xK_a),"tallAccordion")
                    , ("(w)ideAccordion",(0,xK_w),"wideAccordion")
                    , ("(z)oomRow",(0,xK_z),"zoomRow")
                    ]
                ]

appFavoriteAction = makeAction 2 [
  (name, key, spawn cmd)
  | (name, key, cmd) <- [ ("(a)udacity", (0, xK_a), "audacity")
                        , ("(c)hrome", (0, xK_c), "google-chrome")
                        , ("(d)eadbeef", (0, xK_d), "deadbeef")
                        , ("(e)macsclient", (0, xK_e), "emacsclient -c -a emacs")
                        , ("geany", (0, xK_1), "geany")
                        , ("geary", (0, xK_1), "geary")
                        , ("call(g)rind", (0, xK_g), "kcachegrind")
                        , ("(g)imp", (0, xK_1), "gimp")
                        , ("(k)denlive", (0, xK_k), "kdenlive")
                        , ("LibreOffice (i)mpress", (0, xK_i), "loimpress")
                        , ("LibreOffice w(r)iter", (0, xK_r), "lowriter")
                        , ("(o)bs", (0, xK_o), "obs")
                        , ("(p)cmanfm", (0, xK_p), "pcmanfm")
                        , ("(w)ireshark", (0, xK_w), "sudo wireshark")
                        , ("(m)ain emacs", (0, xK_m), "emacs --name emacs-main")
                        ]
  ]

appRotateAction = makeAction 2 [
  ("rotate (s)laves", (0, xK_s), rotSlavesDown)
  , ("rotate (a)ll windows", (0, xK_a), rotAllDown)
  ]

appSendAction = makeAction 2 [
  ("shift to (n)ext workspace", (0, xK_n), shiftTo Next nonNSP >> moveTo Next nonNSP)       -- Shifts focused window to next ws
  , ("shift to (p)rev workspace", (0, xK_p), shiftTo Prev nonNSP >> moveTo Prev nonNSP)  -- Shifts focused window to prev ws
  , ("(w)shift to leftest screen", (0, xK_w), sendToScreen def 0)
  , ("(e)shift to center screen", (0, xK_e), sendToScreen def 1)
  , ("(r)shift to rightest screen", (0, xK_r), sendToScreen def 2)
  ] where nonNSP          = WSIs (return (\ws -> W.tag ws /= "NSP"))
          nonEmptyNonNSP  = WSIs (return (\ws -> isJust (W.stack ws) && W.tag ws /= "NSP"))

appToggleAction = makeAction 2 [
  ("toggle a (f)loating window", (0, xK_f),  withFocused toggleFloat)
  , ("push a window to (t)ile", (0, xK_t),  withFocused pushTile)
  , ("push all windows to (T)ile", (shiftMask, xK_T), sinkAll)                       -- Push ALL floating windows to tile
  ]

appConfig:: XMonad.Prompt.XPConfig
appConfig = XMonad.Prompt.def  {
  -- autoComplete = Just 500000
  font =  "xft:NanumGothic:size=11:regular:antialias=true:hinting=true"
  , position = Top 
  , height = 50
  , maxComplRows = Just 10
  , alwaysHighlight = True
  -- , complCaseSensitivity  = CaseInsensitive
  }

toMaster w = do
  XMonad.focus  w
  windows W.swapMaster

-- wsWindowsList :: [(String, (KeyMask, KeySym), X())]
-- wsWindowsList = wsWindows >>= pair
--   where
--     pair wm = [
--       (n, (0,xK_grave), toMaster w)
--       | (n,w) <- wm
--       ]

-- wsMasterCandidateAction = makeAction 2 wsWindowsList

appAction = makeAction 1
            $ [
              ("refresh", (0,xK_semicolon), refresh)
              , ("(.)focus master", (0, xK_period), windows W.focusMaster)
              , ("swap (m)aster", (0, xK_m), windows W.swapMaster)
              , ("(j)swap down", (0, xK_j), windows W.swapDown)
              , ("(k)swap up", (0, xK_k), windows W.swapUp)
              , ("(r)otate windows", (0, xK_r), appRotateAction)
              , ("(s)end window", (0, xK_s), appSendAction)
              , ("(t)oggle", (0, xK_t), appToggleAction)
              , ("(f)avorite apps", (0, xK_f), appFavoriteAction)
              , ("(g)o to a window", (0, xK_g), goToSelected $ mygridConfig 2)
              , ("(b)ring a window", (0, xK_b), bringSelected $ mygridConfig 2)
              , ("(SPC)bring to master", (0, xK_space), windowPrompt appConfig BringToMaster wsWindows)
              ] ++ [
              ("send a window to ("++num++"):"++ws, (0,key), windows $ W.shift $ num++":"++ws)
              | (num, key, ws) <- myAllWorkspaces
              ]

screenAction = makeAction 1 [
  ("(e)center screen", (0, xK_e), viewScreen def  1)
  , ("(w)left screen", (0, xK_w), viewScreen def 0)
  , ("(r)right screen", (0, xK_r), viewScreen def 2)
  , ("(n)ext screen", (0, xK_n), nextScreen)
  , ("(p)revious screen", (0, xK_p), prevScreen)
  ]

workscreenAction = makeAction 2 [
  ("medi(a)", (0, xK_a), viewCenteredWSGroup "medi")
  , ("(d)evelop", (0, xK_d), viewCenteredWSGroup "devb")
  , ("(D)eeting with develop", (shiftMask , xK_D), viewCenteredWSGroup "mtdv")
  , ("(e)nglish study", (0, xK_e), viewCenteredWSGroup "stde")
  , ("english (H)omework", (shiftMask , xK_H), viewCenteredWSGroup "stdh")
  , ("(f)rontend develop", (0, xK_f), viewCenteredWSGroup "devf")
  , ("(M)eeting", (shiftMask , xK_M), viewCenteredWSGroup "meet")
  , ("h(o)sted meeting", (0 , xK_o), viewCenteredWSGroup "mtht")
  , ("(t)esting", (0, xK_t), viewCenteredWSGroup "test")
  , ("(w)eb", (0, xK_w), viewCenteredWSGroup "webd")
  ]

workspaceAction = makeAction 1 [
  ("(RET)workscreen", (0, xK_semicolon), workscreenAction)
  , ("(g)o to workspace", (0, xK_g), gridselectWorkspace wsconfig W.greedyView)
  , ("(b)ring workspace", (0, xK_b), gridselectWorkspace wsconfig (\ws -> W.greedyView ws . W.shift ws))
  ]

emacsAction = makeAction 1 [
  ("(s)cratch buffer", (0, xK_s), spawn (myEmacs ++ "--eval '(hackartist/scratch-buffer-only)'"))
  , ("(i)buffer", (0, xK_i), spawn (myEmacs ++ "--eval '(ibuffer)'"))   -- list buffers
  , ("(d)ired", (0, xK_d), spawn (myEmacs ++ "--eval '(dired nil)'")) -- dired
  , ("(e)rc", (0, xK_e), spawn (myEmacs ++ "--eval '(erc)'"))       -- erc irc client
  , ("(m)u4e", (0, xK_m), spawn (myEmacs ++ "--eval '(mu4e)'"))      -- mu4e email
  , ("rss (f)eed", (0, xK_f), spawn (myEmacs ++ "--eval '(elfeed)'"))    -- elfeed rss
  , ("es(h)ell", (0, xK_h), spawn (myEmacs ++ "--eval '(eshell)'"))    -- eshell
  , ("m(a)stodon", (0, xK_a), spawn (myEmacs ++ "--eval '(mastodon)'"))  -- mastodon.el
  , ("(v)term", (0, xK_v), spawn (myEmacs ++ "--eval '(vterm nil)'")) -- vterm if on GNU Emacs
  -- emms is an emacs audio player. I set it to auto start playing in a specific directory.
  , ("e(M)ms", (shiftMask, xK_M), spawn (myEmacs ++ "--eval '(emms)' --eval '(emms-play-directory-tree \"~/Music/Non-Classical/70s-80s/\")'"))

  ]

scratchPadAction = makeAction 0 [
                ("(t)erminal",(0, xK_t), namedScratchpadAction myScratchPads "terminal")
                , ("(e)macs", (0, xK_e), namedScratchpadAction myScratchPads "emacs")
                , ("(w)hatsapp", (0, xK_w), namedScratchpadAction myScratchPads "whatsapp")
                , ("(f)ile manager", (0, xK_f), namedScratchpadAction myScratchPads "ranger")
                ]

hotkeyAction = makeAction 0
               $ [
                ("emacs anywhere",(0, xK_semicolon), namedScratchpadAction myScratchPads "emacsanywhere")
                , ("(a)pplication window", (0, xK_a), appAction)
                , ("(s)creen", (0, xK_s), screenAction)
                , ("la(y)out", (0, xK_y), layoutAction)
                , ("(SPC)show windows", (0, xK_space), spawn "rofi -show window")
                , ("(.)run", (0, xK_period), spawn "rofi -show run")
                , ("(`)terminal", (0, xK_grave ), spawn myTerminal)
                , ("(w)orkspace", (0, xK_w), workspaceAction)
                , ("(e)macs", (0, xK_e), emacsAction)
                , ("s(c)ratch pads", (0, xK_c), scratchPadAction)
                , ("(Q)logout", (shiftMask , xK_Q), io exitSuccess)
                , ("(R)estart xmonad", (shiftMask, xK_R), spawn "xmonad --restart")
                , ("(K)ill all wapps", (shiftMask, xK_K), killAll)
                , ("(/)file manager", (0, xK_slash), namedScratchpadAction myScratchPads "ranger")
                ] ++ [
                ("("++num++"):"++ws++" workspace", (0, key), windows $ W.greedyView $ num++":"++ws)
                | (num, key, ws) <- myAllWorkspaces
                ]

-- Workspaces
myAllWorkspaces = [("1",xK_1,"emacs")
                   , ("2",xK_2,"web")
                   , ("3",xK_3,"debugging")
                   , ("4",xK_4,"testing")
                   , ("5",xK_5,"study")
                   , ("6",xK_6,"messenger")
                   , ("7",xK_7,"meeting")
                   , ("8",xK_8,"media")
                   , ("9",xK_9,"database")
                   , ("0",xK_0,"misc")
                  ]

myWorkspaces = [ num++":"++name | (num,_,name) <- myAllWorkspaces]

myWorkspaceIndices = M.fromList $ zip myWorkspaces [1..] -- (,) == \x y -> (x,y)

clickable ws = "<action=xdotool key super+"++show i++">"++ws++"</action>"
    where i = fromJust $ M.lookup ws myWorkspaceIndices

-- Manage hook
myManageHook :: XMonad.Query (Data.Monoid.Endo WindowSet)
myManageHook = composeAll
     -- 'doFloat' forces a window to float.  Useful for dialog boxes and such.
     -- using 'doShift ( myWorkspaces !! 7)' sends program to workspace 8!
     -- I'm doing it this way because otherwise I would have to write out the full
     -- name of my workspaces and the names would be very long if using clickable workspaces.
     [
       title =? "emacs-main" --> doShift "1:emacs"
     , className =? "Google-chrome"                --> doShift "2:web"
     , title =? "Emulator" --> (doShift "3:debugging" <+> doFloat)
     , title =? "Android Emulator - luffy:5554" --> doShift "3:debugging"
     , title =? "Android Emulator - zoro:5556" --> doShift "3:debugging"
     , className =? "Electron"                     --> doShift "3:debugging"
     , className =? "kcachegrind"                  --> doShift "3:debugging"
     , className =? "Wireshark"                    --> doShift "3:debugging"
     , className =? "Stoplight Studio"             --> doShift "4:testing"
     , className =? "Postman"                      --> doShift "4:testing"
     , className =? "zoom"                         --> doShift "5:study"
     , className =? "Slack"                        --> doShift "6:messenger"
     , className =? "whatsdesk"                    --> doShift "6:messenger"
     , className =? "discord"                      --> doShift "6:messenger"
     , className =? "TelegramDesktop"              --> doShift "6:messenger"
     , className =? "yakyak"                       --> doShift "6:messenger"
     , title =? "WhatsApp" --> doShift "6:messenger"
     , className =? "Whatsapp-for-linux"           --> doShift "6:messenger"
     , className =? "Gitter"                       --> doShift "6:messenger"
     , className =? "qtwaw"           --> doShift "6:messenger"
     , className =? "Google-chrome-unstable"       --> doShift "7:meeting"
     , className =? "Google-chrome-beta"           --> doShift "7:meeting"
     , className =? "obs"                          --> doShift "8:media"
     , className =? "kdenlive"                     --> doShift "8:media"
     , className =? "SimpleScreenRecorder"         --> doShift "8:media"
     , resource =? "mysql-workbench-bin"          --> doShift "9:database"
     , title =? "NoiseTorch" --> doShift "0:misc"
     , className =? "Blueman-manager"               --> doShift "0:misc"
     , className =? "scrcpy"                       --> (doShift "0:misc" <+> doFloat)
     , className =? "libreoffice-writer"           --> doShift "0:misc"
     , className =? "kakaotalk.exe"                --> (doShift "0:misc" <+> doFloat)
     , className =? "VirtualBox Manager"           --> doShift "0:misc"
     , className =? "PulseUI"                      --> doShift "0:misc"
     , className =? "org.remmina.Remmina"          --> doShift "0:misc"
     , className =? "Virt-manager"                 --> (doShift "0:misc" <+> doFloat)
     , title =? "Oracle VM VirtualBox Manager"     --> (doShift "0:misc" <+> doFloat)
     -- , className =? "Org.gnome.Nautilus"           --> doFloat
     , className =? "Gimp-2.10"                    --> doCenterFloat
     , resource  =? "gpicview"                     --> doCenterFloat
     , className =? "MPlayer"                      --> doCenterFloat
     , className =? "Pavucontrol"                  --> doCenterFloat
     , className =? "systemsettings"               --> doCenterFloat
     , resource  =? "desktop_window"               --> doIgnore
     , className =? "stalonetray"                  --> doIgnore
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
     , title =? "Mozilla Firefox"     --> doShift ( myWorkspaces !! 1 )
     , className =? "brave-browser"   --> doShift ( myWorkspaces !! 1 )
     , className =? "qutebrowser"     --> doShift ( myWorkspaces !! 1 )
     , className =? "mpv"             --> doShift ( myWorkspaces !! 7 )
     , (className =? "firefox" <&&> resource =? "Dialog") --> doFloat  -- Float Firefox Dialog
     -- , isFullscreen                                --> (doF W.focusDown <+> doFullFloat)
     -- , isFullscreen -->  doFullFloat
     ] <+> namedScratchpadManageHook myScratchPads

myKeys conf@XConfig {XMonad.modMask = modMask} = M.fromList
  -- Start a terminal.  Terminal to start is specified by myTerminal variable.
  [
    -- Increment the number of windows in the master area. , ((modMask, xK_comma), sendMessage (IncMasterN 1))
    -- Decrement the number of windows in the master area.
    ((modMask, xK_period), sendMessage (IncMasterN (-1)))
  -- Increase the size occupied by the focused window
    , ((modMask, xK_equal), sendMessage zoomIn)
  -- Decrease the size occupied by the focused window
    , ((modMask, xK_minus), sendMessage zoomOut)
  -- Reset the size occupied by the focused window
    , ((modMask, xK_0), sendMessage zoomReset)
  -- (Un)Maximize the focused window
    -- , ((modMask             , xK_f    ), sendMessage ToggleZoomFull)
  ]

-- Mouse bindings
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

myMouseBindings XConfig {XMonad.modMask = modMask} = M.fromList
  [
    ((modMask, button1), \w -> focus w >> mouseMoveWindow w)
    , ((modMask, button2), \w -> focus w >> windows W.swapMaster)
    , ((modMask, button3), \w -> focus w >> mouseResizeWindow w)
  ]


pushTile w = do
  windows (W.float w (W.RationalRect 1 1 1 1))
  windows (W.sink w)

toggleFloat w = windows (\s -> if M.member w (W.floating s)
                            then W.sink w s
                            else W.float w (W.RationalRect (1/3) (1/4) (1/2) (4/5)) s)

myAdditionalKeys :: [(String, X ())]
myAdditionalKeys  =
  [ -- ("M-C-r", spawn "xmonad --recompile")  -- Recompiles xmonad
    ("M-C-q", kill)              -- Quits xmonad
  , ("C-<Space>", hotkeyAction)

  -- , ("C-q", kill)     -- Kill the currently focused client
  -- , ("M-S-a", killAll)   -- Kill all windows on current workspace

  , ("M-C-h", sendMessage Shrink)                -- Shrink horiz window width
  , ("M-C-l", sendMessage Expand)                -- Expand horiz window width
  , ("M-C-j", sendMessage MirrorShrink)          -- Shrink vert window width
  , ("M-C-k", sendMessage MirrorExpand)          -- Expand vert window width

    -- Increase/decrease spacing (gaps)
  , ("C-M1-j", decWindowSpacing 4)         -- Decrease window spacing
  , ("C-M1-k", incWindowSpacing 4)         -- Increase window spacing
  , ("C-M1-h", decScreenSpacing 4)         -- Decrease screen spacing
  , ("C-M1-l", incScreenSpacing 4)         -- Increase screen spacing

  , ("M-<Tab>", windows W.focusDown)
  , ("M-S-<Tab>", windows W.focusUp)
    -- Increase/decrease windows in the master pane or the stack
  -- , ("M-S-<Up>", sendMessage (IncMasterN 1))      -- Increase # of clients master pane
  -- , ("M-S-<Down>", sendMessage (IncMasterN (-1))) -- Decrease # of clients master pane
  -- , ("M-C-<Up>", increaseLimit)                   -- Increase # of windows
  -- , ("M-C-<Down>", decreaseLimit)                 -- Decrease # of windows


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
  -- , ("C-s t", namedScratchpadAction myScratchPads "terminal")
  -- , ("C-s m", namedScratchpadAction myScratchPads "mocp")
  -- , ("C-s c", namedScratchpadAction myScratchPads "calculator")

    -- Set wallpaper with 'feh'. Type 'SUPER+F1' to launch sxiv in the wallpapers directory.
  -- Then in sxiv, type 'C-x w' to set the wallpaper that you choose.
  -- , ("M-<F1>", spawn "sxiv -r -q -t -o ~/wallpapers/*")
  -- , ("M-<F2>", spawn "/bin/ls ~/wallpapers | shuf -n 1 | xargs xwallpaper --stretch")
  --, ("M-<F2>", spawn "feh --randomize --bg-fill ~/wallpapers/*")

    -- Emacs (CTRL-e followed by a key)
    -- , ("C-e e", spawn myEmacs)                 -- start emacs

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
  ]
  where nonNSP          = WSIs (return (\ws -> W.tag ws /= "NSP"))
        nonEmptyNonNSP  = WSIs (return (\ws -> isJust (W.stack ws) && W.tag ws /= "NSP"))

main :: IO ()
main = do
    xmproc0 <- spawnPipe "/bin/bash $HOME/.xmonad/xmobar.sh"
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
        , layoutHook         = showWName' myShowWNameTheme myLayoutHook
        , workspaces         = myWorkspaces
        , borderWidth        = myBorderWidth
        , normalBorderColor  = myNormColor
        , focusedBorderColor = myFocusColor
        , keys               = myKeys
        , focusFollowsMouse  = myFocusFollowsMouse
        , mouseBindings      = myMouseBindings
        , logHook = dynamicLogWithPP xmobarPP
        -- , logHook = dynamicLogWithPP $ namedScratchpadFilterOutWorkspacePP $ xmobarPP
              -- the following variables beginning with 'pp' are settings for xmobar.
              { ppOutput = hPutStrLn xmproc0 
              , ppCurrent = xmobarColor "#ff9999" "" . wrap "[" "]"           -- Current workspace
              , ppVisible = xmobarColor "#ff9999" "" . clickable              -- Visible but not current workspace
              , ppHidden = xmobarColor "#c792ea" "" . wrap "" "" . clickable -- Hidden workspaces
              , ppHiddenNoWindows = xmobarColor "#999999" ""  . clickable     -- Hidden workspaces (no windows)
              , ppTitle = xmobarColor "#b3afc2" "" . shorten 60               -- Title of active window
              , ppSep =  "<fc=#666666> <fn=1>|</fn> </fc>"                    -- Separator character
              , ppUrgent = xmobarColor "#C45500" "" . wrap "!" "!"            -- Urgent workspace
              , ppExtras  = [windowCount]                                     -- # of windows current workspace
              , ppOrder  = \(ws:l:t:ex) -> [ws,l]++ex++[t]                    -- order of things in xmobar
              } >> updatePointer (0.5, 0.5) (0, 0)
        } `additionalKeysP` myAdditionalKeys
