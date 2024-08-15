{-# OPTIONS_GHC -Wno-unused-matches #-}
{-# LANGUAGE ParallelListComp #-}
{-# LANGUAGE DataKinds #-}
{-# OPTIONS_GHC -Wno-deprecations #-}
import XMonad hiding ( (|||) )
import XMonad.Config
import XMonad.Config.Kde

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
import Data.Ratio
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
import XMonad.Hooks.Focus

-- Layouts
import XMonad.Layout hiding ( (|||) )
import XMonad.Layout.LayoutScreens
import XMonad.Layout.Fullscreen
import XMonad.Layout.Accordion
import XMonad.Layout.GridVariants (Grid(Grid))
import XMonad.Layout.SimplestFloat
import XMonad.Layout.Spiral
import XMonad.Layout.ResizableTile
import XMonad.Layout.Tabbed
import XMonad.Layout.ThreeColumns
import XMonad.Layout.MultiColumns
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
import XMonad.Util.EZConfig
import XMonad.Util.NamedScratchpad
import XMonad.Util.Run (runProcessWithInput, safeSpawn, spawnPipe)
import XMonad.Util.SpawnOnce
import XMonad.Util.Themes
import XMonad.Prompt
import XMonad.Prompt.Window
import qualified XMonad.Prompt.Window as W
import Data.HashMap.Strict (toList)

myFont :: String
myFont  = "xft:NanumGothic:size=9:regular:antialias=true:hinting=true"

myModMask :: KeyMask
myModMask = mod4Mask        -- Sets modkey to super/windows key

myTerminal :: String
myTerminal = "kitty"    -- Sets default terminal

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

-- addCustomWSGroup :: WSGroupId -> WorkspaceId -> WorkspaceId  -> WorkspaceId -> X()
-- addCustomWSGroup n s1 s0 s2 = addRawWSGroup n [(S 0, s0), (S 2, s2), (S 1, s1)]

addCustomWSGroup :: WSGroupId -> WorkspaceId -> WorkspaceId  -> X()
addCustomWSGroup n s0 s1 = addRawWSGroup n [(S 0, s0), (S 1, s1)]

myStartupHook :: X ()
myStartupHook = do
    addCustomWSGroup "dev" ( myWorkspaces !! 1 ) ( head myWorkspaces ) 
    addCustomWSGroup "vir"  ( myWorkspaces !! 4 ) ( myWorkspaces !! 10 )
    addCustomWSGroup "wtask" ( myWorkspaces !! 3 ) ( myWorkspaces !! 6 )
    addCustomWSGroup "meet" ( myWorkspaces !! 6 ) ( myWorkspaces !! 1 )
    addCustomWSGroup "chat" ( myWorkspaces !! 1 ) ( myWorkspaces !! 5 )

    spawnOnce "/bin/bash $HOME/.xmonad/tray.sh"
    spawnOnce "/bin/bash $HOME/.xmonad/startup.sh"

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
    -- spawnEmacsanywhere  = "emacsclient --eval '(emacs-everywhere)'"
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
           -- $ subLayout [] (smartBorders Simplest)
           $ limitWindows 12
           $ mySpacing 2
           $ mkToggle (single MIRROR)
           $ Grid (16/10)
spirals  = renamed [Replace "spirals"]
           $ smartBorders
           $ addTabs shrinkText myTabTheme
           $ subLayout [] (smartBorders Simplest)
           $ mySpacing' 8
           $ spiral (6/7)
fourCol = renamed [Replace "fourCol"]
           $ multiCol [1] 4 0.01 0.5
threeCol = renamed [Replace "threeCol"]
           $ smartBorders
           $ addTabs shrinkText myTabTheme
           -- $ subLayout [] (smartBorders Simplest)
           $ limitWindows 12
           $ mySpacing 0
           $ ThreeColMid 1 (4/100) (1/2)
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

myTabTheme =
  def
    { fontName = myFont,
      activeColor = "#2d2d2d",
      inactiveColor = "#353535",
      urgentColor = "#15539e",
      activeBorderColor = "#070707",
      inactiveBorderColor = "#1c1c1c",
      urgentBorderColor = "#030c17",
      activeTextColor = "#eeeeec",
      inactiveTextColor = "#929291",
      urgentTextColor = "#ffffff",
      decoWidth = 400,
      decoHeight = 35
    }

-- Theme for showWName which prints current workspace when you change workspaces.
myShowWNameTheme :: SWNConfig
myShowWNameTheme = def
    { swn_font              = "xft:NanumGothic:bold:size=60"
    , swn_fade              = 1.0
    , swn_color           = "#1c1f24"
    , swn_bgcolor             = "#ffffff"
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

myColorizer a active = if active then return ("#faff69", "black") else return ("#888888", "white")
myColorizer1 a active = if active then return ("#faff69", "black") else return ("#666666", "white")
myColorizer2 a active = if active then return ("#faff69", "black") else return ("#444444", "white")
myColorizer3 a active = if active then return ("#faff69", "black") else return ("#222222", "white")

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
                ("split screen into three", (0, 0), layoutScreens 3 (ThreeColMid 1 (4/100) (1/2)))
                , ("(SPC)toggle full screen", (0, xK_space), sendMessage (MT.Toggle FULL) >> sendMessage ToggleStruts)
                , ("(TAB)next layout", (0, xK_Tab),  sendMessage NextLayout)
                , ("(M)erge all windows", (shiftMask, xK_m), withFocused (sendMessage . MergeAll))
                , ("(u)nmerge a window", (0, xK_u), withFocused (sendMessage . UnMerge))
                , ("(U)nmerge all windows", (shiftMask, xK_u), withFocused (sendMessage . UnMergeAll))
                , ("(.)focus up", (0, xK_period), onGroup W.focusUp')
                , ("(,)focus down", (0, xK_comma), onGroup W.focusDown')
                ] ++ [
                (ln, key, sendMessage $ JumpToLayout l)
                | (ln, key, l) <- [
                    ("(t)all",(0,xK_t),"tall")
                    , ("fourCol(M)",(shiftMask,xK_m),"fourCol")
                    , ("(m)agnify",(0,xK_m),"magnify")
                    , ("mo(n)ocle",(0,xK_n),"monocle")
                    , ("(f)loats",(0,xK_f),"floats")
                    , ("(g)rid",(0,xK_g),"grid")
                    , ("(s)pirals",(0,xK_s),"spirals")
                    , ("three(C)ol",(shiftMask,xK_c),"threeCol")
                    , ("three(R)ow",(shiftMask,xK_r),"threeRow")
                    , ("ta(b)s",(0,xK_b),"tabs")
                    , ("t(a)llAccordion",(0,xK_a),"tallAccordion")
                    , ("(w)ideAccordion",(0,xK_w),"wideAccordion")
                    , ("(z)oomRow",(0,xK_z),"zoomRow")
                    ]
                ]

appFavoriteAction = makeAction 2 [
  (name, key, spawn cmd)
  | (name, key, cmd) <- [ ("ranger", (0, xK_1), "kitty -e ranger")
                        , ("(c)hrome", (0, xK_c), "google-chrome-stable")
                        , ("(d)iscord", (0, xK_d), "discord")
                        , ("call(g)rind", (0, xK_g), "kcachegrind")
                        , ("(g)imp", (0, xK_1), "gimp")
                        , ("(k)denlive", (0, xK_k), "kdenlive")
                        , ("(o)bs", (0, xK_o), "obs")
                        , ("(p)cmanfm", (0, xK_p), "pcmanfm")
                        , ("sc(r)cpy", (0, xK_r), "scrcpy -K")
                        , ("(s)lack", (0, xK_s), "slack")
                        , ("(w)hatapps", (0, xK_w), "QT_IM_MODULE='uim' GTK_IM_MODULE='uim' XMODIFIERS='@im=uim' whatsdesk")
                        , ("(m)ain emacs", (0, xK_m), "emacs --name emacs-main")
                        ]
  ]

appRotateAction = makeAction 2 [
  ("rotate (s)laves", (0, xK_s), rotSlavesDown)
  , ("rotate (a)ll windows", (0, xK_a), rotAllDown)
  ]

appSendAction = makeAction 2 [
  ("shift to (n)ext workspace", (0, xK_n), shiftTo Next nonNSP >> moveTo Next nonNSP)
  , ("shift to (p)rev workspace", (0, xK_p), shiftTo Prev nonNSP >> moveTo Prev nonNSP)
  , ("(w)shift to leftest screen", (0, xK_w), sendToScreen def 0)
  , ("(e)shift to center screen", (0, xK_e), sendToScreen def 1)
  , ("(r)shift to rightest screen", (0, xK_r), sendToScreen def 2)
  ] where nonNSP          = WSIs (return (\ws -> W.tag ws /= "NSP"))
          nonEmptyNonNSP  = WSIs (return (\ws -> isJust (W.stack ws) && W.tag ws /= "NSP"))

appToggleAction = makeAction 2 [
  ("toggle a (f)loating window", (0, xK_f),  withFocused toggleFloat)
  , ("push a window to (t)ile", (0, xK_t),  withFocused pushTile)
  , ("push all windows to (T)ile", (shiftMask, xK_t), sinkAll)                       -- Push ALL floating windows to tile
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
              ("send a window to ("++num++"):"++ws, (0,key), windows $ W.shift $ myWorkspaces !! ((read num - 1) `mod` 10) )
              | (num, key, ws) <- myAllWorkspaces
              ]

screenAction = makeAction 1 [
  ("(e)center screen", (0, xK_e), viewScreen def  1)
  , ("(w)left screen", (0, xK_w), viewScreen def 0)
  , ("(r)right screen", (0, xK_r), viewScreen def 2)
  , ("(n)ext screen", (0, xK_n), nextScreen)
  , ("(p)revious screen", (0, xK_p), prevScreen)
  ]

workspaceAction = makeAction 1 [
  ("(d)evelop", (0, xK_d), viewCenteredWSGroup "dev")
  , ("(v)irtual-machine", (0, xK_v), viewCenteredWSGroup "vir")
  , ("(m)eet", (0, xK_m), viewCenteredWSGroup "meet")
  , ("(c)hat", (0, xK_c), viewCenteredWSGroup "chat")
  , ("(w)eb task", (0, xK_w), viewCenteredWSGroup "wtask")
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
  , ("e(M)ms", (shiftMask, xK_m), spawn (myEmacs ++ "--eval '(emms)' --eval '(emms-play-directory-tree \"~/Music/Non-Classical/70s-80s/\")'"))

  ]

scratchPadAction = makeAction 1 [
                ("(t)erminal",(0, xK_t), namedScratchpadAction myScratchPads "terminal")
                , ("(e)macs", (0, xK_e), namedScratchpadAction myScratchPads "emacs")
                , ("(w)hatsapp", (0, xK_w), namedScratchpadAction myScratchPads "whatsapp")
                , ("(f)ile manager", (0, xK_f), namedScratchpadAction myScratchPads "ranger")
                ]

systemAction = makeAction 1 [
                ("(r)eboot",(0, xK_r), spawn "shutdown -r now")
                , ("(s)hut down",(0, xK_s), spawn "shutdown -h now")
                , ("screen (b)lank", (0, xK_b), spawn "xset dpms force off")
                ]

hotkeyAction = makeAction 0
               $ [
                ("emacs anywhere",(0, xK_semicolon), namedScratchpadAction myScratchPads "emacsanywhere")
                , ("(a)pplication window", (0, xK_a), appAction)
                , ("(s)creen", (0, xK_s), screenAction)
                , ("la(y)out", (0, xK_y), layoutAction)
                , ("(SPC)show windows", (0, xK_space), spawn "rofi -show window")
                , ("(.)run", (0, xK_period), spawn "rofi -show combi")
                , ("(`)terminal", (0, xK_grave ), spawn myTerminal)
                , ("(w)orkspace", (0, xK_w), workspaceAction)
                , ("(e)macs", (0, xK_e), emacsAction)
                , ("s(c)ratch pads", (0, xK_c), scratchPadAction)
                , ("(Q)logout", (shiftMask , xK_q), io exitSuccess)
                , ("(R)estart xmonad", (shiftMask, xK_r), spawn "xmonad --restart")
                , ("(K)ill all wapps", (shiftMask, xK_k), killAll)
                , ("(/)file manager", (0, xK_slash), namedScratchpadAction myScratchPads "ranger")
                , ("(S)ystem", (shiftMask, xK_s), systemAction)
                ] ++ [
                ("("++num++"):"++ws++" workspace", (0, key), windows $ W.greedyView $ num++":"++ws)
                | (num, key, ws) <- myAllWorkspaces
                ]

-- Workspaces
myAllWorkspaces = [("1",xK_1,"emacs")
                   , ("2",xK_2,"web")
                   , ("3",xK_3,"dbg")
                   , ("4",xK_4,"test")
                   , ("5",xK_5,"vm")
                   , ("6",xK_6,"msg")
                   , ("7",xK_7,"meet")
                   , ("8",xK_8,"media")
                   , ("9",xK_9,"db")
                   , ("0",xK_0,"misc")
                   -- no hotkey
                   , ("",0,"vm-ext")
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
       title =? "emacs-main" --> doShift ( head myWorkspaces )
     , className =? "Google-chrome"                --> doShift ( myWorkspaces !! 1 )
     , title =? "Emulator" --> (doShift ( myWorkspaces !! 2 ))
     , title =? "Android Emulator - luffy:5554" --> doShift ( myWorkspaces !! 2 )
     , title =? "Android Emulator - zoro:5556" --> doShift ( myWorkspaces !! 2 )
     , className =? "chatall"                     --> doShift ( myWorkspaces !! 2 )
     , className =? "Electron"                     --> doShift ( myWorkspaces !! 2 )
     , className =? "kcachegrind"                  --> doShift ( myWorkspaces !! 2 )
     , className =? "Wireshark"                    --> doShift ( myWorkspaces !! 2 )
     , className =? "Stoplight Studio"             --> doShift "4:test"
     , className =? "Postman"                      --> doShift "4:test"
     , className =? "libreoffice"                  --> doShift "4:test"
     , className =? "unityhub"                     --> doShift "5:vm"
     , className =? "vmware"                       --> doShift "5:vm"
     , className =? "Vmware"                       --> doShift "5:vm"
     , className =? "org.remmina.Remmina"          --> doShift "5:vm"
     , className =? "zoom"                         --> doShift "6:msg"
     , className =? "whatsdesk"                    --> doShift "6:msg"
     , className =? "TelegramDesktop"              --> doShift "6:msg"
     , className =? "yakyak"                       --> doShift "6:msg"
     , title =? "WhatsApp" --> doShift "6:msg"
     , className =? "Whatsapp-for-linux"           --> doShift "6:msg"
     , className =? "Gitter"                       --> doShift "6:msg"
     , className =? "google-chat-linux"            --> doShift "6:msg"
     , className =? "qtwaw"           --> doShift "6:msg"
     , title =? "win11 on QEMU/KVM" --> doShift "7"
     , className =? "google-chrome-unstable"       --> doShift "7:meet"
     , className =? "Google-chrome-unstable"       --> doShift "7:meet"
     , className =? "google-chrome-beta"           --> doShift "7:meet"
     , className =? "Google-chrome-beta"           --> doShift "7:meet"
     , className =? "obs"                          --> doShift "8:media"
     , className =? "kdenlive"                     --> doShift "8:media"
     , className =? "SimpleScreenRecorder"         --> doShift "8:media"
     , resource =? "mysql-workbench-bin"          --> doShift "9:db"
     , title =? "MongoDB Compass"             --> doShift "9:db"
     , title =? "NoiseTorch" --> doShift "0:misc"
     , className =? "RustDesk"               --> doShift "0:misc"
     , className =? "Blueman-manager"               --> doShift "0:misc"
     , className =? "libreoffice-writer"           --> doShift "0:misc"
     , className =? "kakaotalk.exe"                --> doFloat
     , className =? "VirtualBox Manager"           --> doShift "0:misc"
     , className =? "PulseUI"                      --> doShift "0:misc"
     -- , className =? "org.remmina.Remmina"          --> doShift "0:misc"
     , className =? "Virt-manager"                 --> doShift "0:misc"
     , title =? "Oracle VM VirtualBox Manager"     --> doShift "0:misc"
     -- , className =? "Org.gnome.Nautilus"           --> doFloat
     , className =? "Gimp-2.10"                    --> doCenterFloat
     , resource  =? "gpicview"                     --> doCenterFloat
     , className =? "MPlayer"                      --> doCenterFloat
     , className =? "Pavucontrol"                  --> doCenterFloat
     , className =? "systemsettings"               --> doCenterFloat
     , title =? "ranger"                      --> doRectFloat (W.RationalRect 0.05 0.05 0.9 0.9)
     , className =? "kitty"                      --> doRectFloat (W.RationalRect 0.05 0.05 0.9 0.9)
     , className =? "dolphin"                  --> doRectFloat (W.RationalRect 0.05 0.05 0.9 0.9)
     , className =? "thunar"                  --> doRectFloat (W.RationalRect 0.05 0.05 0.9 0.9)
     , className =? "Thunar"                  --> doRectFloat (W.RationalRect 0.05 0.05 0.9 0.9)
     , className =? "Slack"                        --> doRectFloat (W.RationalRect 0.05 0.05 0.9 0.9)
     , className =? "discord"                      --> doRectFloat (W.RationalRect 0.05 0.05 0.9 0.9)
     , resource  =? "desktop_window"               --> doIgnore
     , className =? "stalonetray"                  --> doIgnore
     , className =? "scrcpy"          --> doFloat
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
  where chatApps = [
          "discord", "slack"
          ]

myKeys conf@XConfig {XMonad.modMask = modMask} = M.fromList
  [
  ((modMask, key), windows $ W.greedyView $ num++":"++name)
  | (num,key,name) <- myAllWorkspaces
  ]

-- Mouse bindings
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

myMouseBindings XConfig {XMonad.modMask = modMask} = M.fromList
  [
    ((modMask, button1), \w -> focus w >> mouseMoveWindow w)
    , ((modMask, button2), \w -> focus w >> windows W.swapMaster)
    , ((modMask, button3), \w -> focus w >> mouseResizeWindow w)
    , ((0, 11), \w -> spawn "rofi -show combi")
    , ((0, 10), \w -> spawn "rofi -show window")
  ]


pushTile w = do
  windows (W.float w (W.RationalRect 1 1 1 1))
  windows (W.sink w)

toggleFloat w = windows (\s -> if M.member w (W.floating s)
                            then W.sink w s
                            else W.float w (W.RationalRect (1/3) (1/4) (1/2) (4/5)) s)

myAdditionalKeys :: [(String, X ())]
myAdditionalKeys  =
  [
    ("M-C-q", kill)
  , ("C-<Space>", hotkeyAction)
  , ("M1-<Space>", spawn "rofi -show combi")

  , ("M-C-h", sendMessage Shrink)
  , ("M-C-l", sendMessage Expand)
  , ("M-C-j", sendMessage MirrorShrink)
  , ("M-C-k", sendMessage MirrorExpand)

  , ("C-M1-j", decWindowSpacing 4)
  , ("C-M1-k", incWindowSpacing 4)
  , ("C-M1-h", decScreenSpacing 4)
  , ("C-M1-l", incScreenSpacing 4)

  , ("M-<Tab>", windows W.focusDown)
  , ("M-S-<Tab>", windows W.focusUp)

  , ("<XF86AudioPlay>", spawn (myTerminal ++ "mocp --play"))
  , ("<XF86AudioPrev>", spawn (myTerminal ++ "mocp --previous"))
  , ("<XF86AudioNext>", spawn (myTerminal ++ "mocp --next"))
  , ("<XF86AudioMute>", spawn "amixer set Master toggle")
  , ("<XF86MonBrightnessUp>", spawn "brightnessctl s +10")
  , ("<XF86MonBrightnessDown>", spawn "brightnessctl s 10-")
  , ("<XF86AudioLowerVolume>", spawn "amixer set Master 5%- unmute")
  , ("<XF86AudioRaiseVolume>", spawn "amixer set Master 5%+ unmute")
  , ("<XF86HomePage>", spawn "qutebrowser https://www.youtube.com/c/DistroTube")
  , ("<XF86Search>", spawn "dmsearch")
  , ("<XF86Mail>", runOrRaise "thunderbird" (resource =? "thunderbird"))
  , ("<XF86Calculator>", runOrRaise "qalculate-gtk" (resource =? "qalculate-gtk"))
  , ("<XF86Eject>", spawn "toggleeject")
  , ("<Print>", spawn "dmscrot")

  , ("C-M1-S-1", windows $ W.greedyView (head myWorkspaces))
  , ("C-M1-S-2", windows $ W.greedyView (myWorkspaces !! 1))
  , ("C-M1-S-3", windows $ W.greedyView (myWorkspaces !! 2))
  , ("C-M1-S-4", windows $ W.greedyView (myWorkspaces !! 3))
  , ("C-M1-S-5", windows $ W.greedyView (myWorkspaces !! 4))
  , ("C-M1-S-6", windows $ W.greedyView (myWorkspaces !! 5))
  , ("C-M1-S-7", windows $ W.greedyView (myWorkspaces !! 6))
  , ("C-M1-S-8", windows $ W.greedyView (myWorkspaces !! 7))
  , ("C-M1-S-9", windows $ W.greedyView (myWorkspaces !! 8))
  , ("C-M1-S-0", windows $ W.greedyView (myWorkspaces !! 9))
  ]
  where nonNSP          = WSIs (return (\ws -> W.tag ws /= "NSP"))
        nonEmptyNonNSP  = WSIs (return (\ws -> isJust (W.stack ws) && W.tag ws /= "NSP"))

newFocusHook :: FocusHook
newFocusHook      = composeOne
        -- Always switch focus to 'gmrun'.
        [ new (className =? "Gmrun")        -?> switchFocus
        ,  new (resource =? "xfce4-notifyd")        -?> keepFocus
        -- And always keep focus on 'gmrun'. Note, that
        -- another 'gmrun' will steal focus from already
        -- running one.
        , focused (className =? "Gmrun")    -?> keepFocus
        -- If firefox dialog prompt (e.g. master password
        -- prompt) is focused on current workspace and new
        -- window appears here too, keep focus unchanged
        -- (note, used predicates: @newOnCur <&&> focused@ is
        -- the same as @newOnCur <&&> focusedCur@, but is
        -- /not/ the same as just 'focusedCur' )
        , newOnCur <&&> focused
            ((className =? "Firefox" <||> className =? "Firefox-esr" <||> className =? "Iceweasel") <&&> isDialog)
                                            -?> keepFocus
        -- Default behavior for new windows: switch focus.
        , return True                       -?> switchFocus
        ]

activateFocusHook :: FocusHook
activateFocusHook = composeAll
        -- If 'gmrun' is focused on workspace, on which
        -- /activated window/ is, keep focus unchanged. But i
        -- may still switch workspace (thus, i use 'composeAll').
        -- See 'keepFocus' properties in the docs below.
        [ focused (className =? "Gmrun") --> keepFocus
        ,  new (resource =? "xfce4-notifyd")        --> keepFocus
        -- Default behavior for activated windows: switch
        -- workspace and focus.
        , return True   --> switchWorkspace <> switchFocus
        ]

main :: IO ()
main = do
    xmproc0 <- spawnPipe "/bin/bash $HOME/.xmonad/xmobar.sh"
    let newFh :: ManageHook
        newFh = manageFocus newFocusHook
        acFh :: ManageHook
        acFh = manageFocus activateFocusHook
    xmonad 
      $ additionalNav2DKeys (xK_k, xK_h, xK_j, xK_l)
                               [
                                  (mod4Mask,               windowGo  )
                                , (mod4Mask .|. shiftMask, windowSwap)
                               ]
                               False
      $ setEwmhActivateHook acFh
      $ ewmhFullscreen . ewmh
      $ def
      -- $ kdeConfig
        -- { manageHook         = newFh <> manageHook kdeConfig <+> myManageHook <+> manageDocks
        { manageHook         = newFh <+> myManageHook <+> manageDocks
        , handleEventHook    = docksEventHook
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
