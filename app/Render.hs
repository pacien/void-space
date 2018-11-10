{-# LANGUAGE OverloadedStrings #-}

module Render where

import           Control.Lens
import           Data.Monoid
import           Brick
import           Brick.Widgets.Core
import           Brick.Widgets.Border
import           Brick.Widgets.Center
import           Data.Text.Markup
import           Words
import           Dashboard
import qualified Data.Text                     as T
import           Stars
import           GameState
import           Enemies
import           Control.Lens.Selection
import           Data.Functor.Selection
import           Data.Functor.Compose

drawCorridor :: GameState -> Widget n
drawCorridor s = txt (s ^. ship . coerced) <+> drawEnemies s

drawGame :: GameState -> [Widget n]
drawGame s =
  [header, vCenterLayer $ drawCorridor s, stars <=> dashboard, stars]

drawEnemies :: GameState -> Widget n
drawEnemies s =
  let rows =
        s
          ^.. enemiesState
          .   enemies
          .   to (unify txt focusedWordWidget)
          .   _Wrapped'
          .   ifolded
          .   withIndex
          .   to addPadding
      addPadding (i, e) =
        txt (T.pack $ take (e ^. distance) (infiniteStarField i))
          <+> (e ^. word)
  in  vBox rows

header :: Widget n
header = hCenterLayer (txt "VOIDSPACE")


-- shipText :: T.Text
-- shipText
--   = "\
-- \        //-A-\\\\\n\
-- \  ___---=======---___\n\
-- \(=__\\   /.. ..\\   /__=)\n\
-- \     ---\\__O__/---"


--        //-A-\\
--  ___---=======---___
--(=__\   /.. ..\   /__=)
--     ---\__O__/---

-- ship :: Widget n
-- ship = txt "\
-- \   /\\\n\
-- \  8  8\n\
-- \  8  8\n\
-- \ /|/\\|\\\n\
-- \/_||||_\\\n"
