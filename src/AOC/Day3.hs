{-# LANGUAGE QuasiQuotes #-}
{-# OPTIONS_GHC -Wno-missing-signatures #-}
{-# OPTIONS_GHC -Wno-unused-imports #-}

module AOC.Day3 where

import Control.Applicative (optional)
import Data.Array
import Data.Maybe
import Data.Text (Text)
import Data.Void (Void)
import Numeric.Natural (Natural)
import qualified Text.Megaparsec as P
import qualified Text.Megaparsec.Char as P
import qualified Text.Megaparsec.Char.Lexer as P
import Text.RawString.QQ

input :: [String]
input =
  lines
    [r|..##.......
#...#...#..
.#....#..#.
..#.#...#.#
.#...##..#.
..#.##.....
.#.#.#....#
.#........#
#.##...#...
#...##....#
.#..#...#.#|]

inputTreePresence :: [String] -> [[Bool]]
inputTreePresence ss =
  fmap
    ( \case
        '.' -> False
        '#' -> True
        _ -> undefined
    )
    . cycle
    <$> ss

treeHits1 :: [[Bool]] -> [Bool]
treeHits1 = fmap head . zipWith drop [0, 1 ..]

treeHits2 :: [[Bool]] -> [Bool]
treeHits2 = fmap head . zipWith drop [0, 3 ..]

treeHits3 :: [[Bool]] -> [Bool]
treeHits3 = fmap head . zipWith drop [0, 5 ..]

treeHits4 :: [[Bool]] -> [Bool]
treeHits4 = fmap head . zipWith drop [0, 7 ..]

treeHits5 :: [[Bool]] -> [Bool]
treeHits5 = fmap head . zipWith drop [0, 1 ..] . catMaybes . zipWith ($) (cycle [Just, const Nothing])

soln2 =
  product $
    length . filter id . ($ inputTreePresence input2)
      <$> [treeHits1, treeHits2, treeHits3, treeHits4, treeHits5]

input2 =
  lines
    [r|........#....#..##..#...#.....#
...............#....##........#
.#....##...##..#...............
.#.......#......#.##..##...#...
.....#.#....#..##...#.....#....
...#.#..##...###......#..#..#.#
.....#..##........#.##......#..
..##.....###.........##........
..............##..#.#.#.#......
.#....##..#.##.#....#..#.#..#..
.#.#....#.##.#...#....#.....#..
..#...#.#.....#....#.......##..
.#.#..##.....#...........#.....
.#.##...#.....#......#.##......
..#..#..........#.....#..###.#.
##....##....#.#...........#..#.
.....#.#.......#.#.#..#.##....#
...##.#....#..#.....#.........#
.....#........#.##...#.........
.....#................#.#...#..
...#....##.....##....#.......#.
....##.#.....#.#.......#.......
#...............#..#...........
.......###.#.......#.##....#.#.
..#........###........#......#.
.#.......#...##.....####....##.
..##.#....#.....#..#....#......
..#...#..#.#..##...#.....#.....
.#.......###.......#....#......
...#...#.......#........#...#.#
..#....#...#.......#.#..##.....
##............#.#..#..........#
.......###...##..#.....#....#..
##..######.#..#.......###....##
###..#...#.##......##....#...#.
..............##.###..........#
.....#........##.#.###....#....
..#...#.....##.#......#.#..#.#.
#....#.............#.#.........
.........##.#........#...#.....
..........#..##.#.#.....#..##..
........##......#..#..#...#.#..
.##.......#..#.#...#.####..#...
##...#........#.###...##....#..
....###.####...#..#..#......###
#....#....#.#.....##.........#.
#.......#....#....##...........
##...##.#.......#....#...#....#
....#....#........##..#.#..#.#.
..##.....##...#..........#...#.
.#.#.#...#.....##..#........#..
#....#.....#..........#....#...
...##.#.......#.#.........#....
##.##.........##.....##.....##.
##.#..##..#...##........##.....
.........##.......#....#...#...
.#.....#........####.#.#.....#.
...........##..#.###...........
..#....##....#...#.............
#.#............#.......#.......
.##........#...#..##.....#.#...
#.##..............##..##.......
##.........#......#......#..#..
##.#....#...#....##....#..#.##.
......#...#..#.#...#.#....#.##.
##.......#.....#.........#.....
...##...#................#.#...
....#.####...#.#.....##....##.#
#...#..#.#.##................##
.........##.....##...#..#......
......####....#.##.#.....#.....
...#..#.#....#.#.#..#..........
.....#........##...#.##....#.#.
..##......#...................#
.....#..#...............#..#...
....#........#..#.#...##...#.##
..#.#.......#.##.........#...#.
...##......#.#.................
.#....#...#.............##.#...
........#.##...#..#...###.....#
#....#.#........##....#......##
.###.......#..#..........#..#..
#....#..#....#........#...#...#
##.#.###.##.#...##.#......#.#.#
#..#..#..##........#..###.#...#
....#..#..#.....#...##....#...#
.......##.......#..#.##...##..#
.##....#..###................##
#...#.##.##...#.##......##.....
...##.....##..##...#..#........
...............##.....##.......
.#..#.#..#....#.....#..#...#...
.#....#..#........#.#...#.....#
##.....####..#......#..........
........#.........#.........#..
#...####....#.##...#....#...##.
.#....####..#...##..#......####
...........##.##..#.##...##....
..#..#.......#.##....#.#...#.##
#...........#..#...............
.......#.##..#.....##......#...
....##.#.##.....#...........#.#
.............#.##..#...#......#
#......#...........#........#..
#.#..#.............#...#.......
#.........##...#....#...##.....
##...#..#..#..#....#...........
.#.....#........#.....#.##..#.#
...#..............##.####.#..#.
##.....#..#.#..#..##...........
...#...#.......#...............
..#..................###..#..##
....###..........#.#..#...#.#.#
..#..#..#.#..........#.#......#
....#....#.#...#.###...##..#...
....#.......#...#....##........
.#.....#.......###....#........
....#..#..#.....#......#.......
......#...#..#....#.#.......#..
.##.#..#...#.#.#...........#...
..#....##.#....#.#....#...#.#.#
...##..#.......#....#.#.....##.
##.#......#.#.......##...#.....
......#...#.##..............#..
.##.........#......##.#..#....#
#.......#.....#...##...#..#...#
..#..##.......#......#......##.
#..##...###.#.#...........#....
##......#.....####..#..#....#.#
.......##...##.#...#...........
....#..#.##.#.....#.#....#.#...
....#.....#.....####...#..#.##.
.##..#..#..###...#....#.##.#.#.
..#.#.##..........##...........
#.##.#.#....#.##....#..#...##.#
#...#....#...###....#.......#..
.......#..#............#.......
................##.#.#.....#..#
..........................#....
.##....##...#.#....####..#....#
......#...#....#...#.##..###.#.
.........#............#.......#
.#.#..#........#..#.........#..
#..#...#......#.#....#..#.#....
...........#.................#.
.#.#..#...##..###......##....##
.#.#.##......####.........##...
..#....#.#..#................#.
##.......#....#.........##.#.#.
##..#.###...........#..#.#..#.#
...#............##.#....#......
...#................##.#..#....
....#..##.#...#.#.....#.......#
......#......#.#........#..##..
...##...#.....#.##.......#.....
##...#...#.............#..#....
..#...##.....#..........#..#.##
#.##...#..................#.###
.........#..........#.###...#.#
#..#.....#.#.#....#......#...#.
.............#.##..###.....#.##
..#..#.....#..#.............#..
.#.....##.#.#..#.........#.....
..#.......#....#.....##.#......
.#.........#..#....##...#.##...
.##..##................###....#
.#..##..............#...#......
.#..............#.##....##.....
.#......#..#..##..#...###.....#
................##...#.#..#...#
##.#.......#...................
....#.#.......#..#.##..........
....###............##...#......
.......#....#.#.....##.#.....#.
....#...............#.#........
..#.##....#.#.#......##..#.....
.##......#...#.#..#..#.......#.
....#...#........#.#..##.......
.##...###.#....#..........##..#
..#.......##..#.....###......#.
...#.#..##.#.#...........#.....
##........#.#..##.........#..#.
.....###.......#..#.#.....##.#.
..#...##.#..............#......
......#...#...............##.#.
##...#..#....#...#.####.##.....
...#............#.##...........
...#........##.#.##.......#....
...#..#..##....#...#......#..#.
#.....#..#......#.#.....##.#.#.
.....#.##......#...#..#..###..#
...........##..##.#.#..........
...#........##........##..##.#.
......###...#.....#..###.#..#..
#.....#.#....#...##....##.....#
.##....#......#.....#.#..##.##.
##....###.......#...##.......##
...##......#....###............
..#...#...#.#..#..........##.#.
#.#.###...#..#.....#....#.###..
..##.....#.#.#.......#.........
...####..#....#..#.........#...
.##...........#.##.#...#.#.##..
...#.#....#.##......#........#.
##....##....#..#...#..#.#......
#......#..#...#...#.#.#.#.####.
....##.#.#.....#.###........#..
....##..#.#.#.#....#....#.#..#.
..#.###..#............##..#.#..
...#...#..#...#.#.#.....#.....#
..........#.....#..#.......##.#
..............##...........#...
.......#.....#...#.....#.....#.
.#.###.....##......##....#...#.
.....#.........#.#....#........
..#.#....#.##...#.##....##...#.
...#......#.#.....#.......###..
#.##....##.....#.#.#...#......#
#..#...#..........#.........##.
....#.#.#.#.....#...###........
#.#..#...#......#...#.##...####
.#...#......#....##...#........
..#.........#............#...#.
##......#..#...#....#.##....#..
.#...##..#..##.#.#.#........#.#
.##.........###...#......#..###
...##.....##..#.#.........#....
...........##........#...#.....
..##..#...#..#..#.....#......#.
..#..#.#....#.....#..#.##...#..
#....#........##..........#.###
......#...#...#....#...##.#....
...#......#.#.....##......##...
#....#..##............#....#.#.
...#...##.#..........##........
......#.###......#...#.#.......
..................#.##..#..#..#
....#.....#...#.....#...#....#.
.#....##.#..#..#.....###.##...#
#.......#..#....##.##.#.....##.
..##........##...#.....#....##.
#.........#...........##.#.....
.#....#.#...##..###..........#.
....##..##....####...#......#..
##.##..#..#....#....####...#...
..#...............#.##.........
...#.#....#..#....#......#.....
.#..#...#........#...#.....##..
#.....###.......#.....#........
...#.##..#.......#....#........
....##..###.##...#.#....#.#....
#.####...#.......#.....#.#....#
#.......#......#.......#.#.#...
##....#......#..#...#..#..####.
.##.....#........#..#...#......
#.#.#....#....#...#.##..##.....
....#..#.........###.##.##.....
...##...##.###..#..##.....#.###
..###.......................#..
......##..#.#.........#......#.
.###......##....#.....#.......#
.....#..#..##........#......##.
..##.....#....#.#.............#
..##.........##.#..#.........##
......#......#.#......#........
.#...#..#......##...#..#....#..
...............###............#
#.####.#....#...#...........#.#
............................#.#
.#..#...#.#.#.###..##.....##...
....##...#.................##..
......##....#...............##.
.#......#.##.#..#.....##...##..
.............#........#......#.
#..........#.#....#####.#...#.#
.#.#...##..#.#...#.#..#.#..#...
#.##.......##......#.#.#....#..
##.....##.#.#.##..........##..#
....##..#.#.......#....#.##....
..#.#.#...#.....#.......#......
.#....#..#...........###.......
#.#...#.....#......#...#.....#.
#........#.#..........#...#.#..
...#...#....#.........#........
.....................#..##.....
...#......##........#.##.#.#.##
.............###...#.#...#..#..
.#..##........##....#...###..##
.#..#.#...............#.....##.
...........##.#....#..##.#....#
.##.#.#..#.#..#...#.#.#..#.#.##
.......#.#..#..#..#..#...#.....
.#......##............#.#..#...
..#...#..##..#..#...##......#..
...##......##....#............#
.......#.....##...##.#...#..#..
......#.......#..##.........#..
..#...#.#.....#.#.......#.#...#
.#......##.##.#.#.#.##..#....##
#.....#.........#.#....#....##.
.......#.........#....#..#.#.##
.....##....#..#.#.#...#.....##.
#####.#.......######......#....
..##.#.......#.#..............#
..#.##....#.....#...#.#...##...
.....#...#..#....#.#..#........
.#....#.#..#.#.#.##..#.......#.
....#..#..#..........##...#....
.......#.#......#........#.....
##.#.#.###....##.#..#..#....#..
#.##......#..#.......#.#...#...
..##...#.......#.......#...#...
........##.........#.#....#.#..
..#...#..##.#.#.#...#....#.....
.###......#........#....#...#..
.#.......##......###..##.......
#....#.#....#.##.........####..
......#..........#..##.....#...
.............#......#..##.#....
...................#....#...#..
.#..........#...#.#..##...#....
.....#...#..........##.##......
#...#..#.##........#...#.......|]
