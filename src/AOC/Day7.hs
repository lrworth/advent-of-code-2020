{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}
{-# OPTIONS_GHC -Wno-missing-signatures #-}
{-# OPTIONS_GHC -Wno-unused-imports #-}

module AOC.Day7 where

import Control.Applicative (optional)
import Control.Arrow
import Control.Monad
import Data.Array
import Data.Graph as Graph
import Data.List
import Data.List.Split
import Data.Maybe
import qualified Data.Text as T
import Data.Tree as Tree
import Data.Void (Void)
import Numeric.Natural (Natural)
import qualified Text.Megaparsec as P
import qualified Text.Megaparsec.Char as P
import qualified Text.Megaparsec.Char.Lexer as P
import Text.RawString.QQ

keyValueStrings :: String -> [(String, [String])]
keyValueStrings =
  fmap
    ( ( \[k, vstring] ->
          ( k,
            fmap snd
              . filter ((> 0) . fst)
              . fmap
                ( ( \(num : description) ->
                      ( case num of
                          "no" -> 0
                          number -> read number,
                        unwords description
                      )
                  )
                    . words
                )
              . splitOn ", "
              $ vstring
          )
      )
        . splitOn " contain "
        . T.unpack
        . T.replace " bag" ""
        . T.replace " bags" ""
        . T.replace "." ""
        . T.pack
    )
    . lines

keyValueStringsB :: String -> [(String, [(Int, String)])]
keyValueStringsB =
  fmap
    ( ( \[k, vstring] ->
          ( k,
            filter ((> 0) . fst)
              . fmap
                ( ( \(num : description) ->
                      ( case num of
                          "no" -> 0
                          number -> read number,
                        unwords description
                      )
                  )
                    . words
                )
              . splitOn ", "
              $ vstring
          )
      )
        . splitOn " contain "
        . T.unpack
        . T.replace " bag" ""
        . T.replace " bags" ""
        . T.replace "." ""
        . T.pack
    )
    . lines

graphFromData :: String -> (Graph.Graph, Graph.Vertex -> ((), String, [String]), String -> Maybe Graph.Vertex)
graphFromData = Graph.graphFromEdges . fmap (\(k, vs) -> ((), k, vs)) . keyValueStrings

solutionA d =
  let (graph, vertexToNode, keyToVertex) = graphFromData d
      Just shinyGoldVertex = keyToVertex "shiny gold"
      validBags = filter (\v -> Graph.path graph v shinyGoldVertex) $ Graph.vertices graph
   in (length $ fmap vertexToNode validBags) - 1

solutionB d = go "shiny gold" - 1
  where
    structure = keyValueStringsB d
    go :: String -> Int
    go bagType =
      1
        + ( sum $ do
              let subBags = maybe [] id $ lookup bagType structure
              (n, subBagType) <- subBags
              let subBagTotal = go subBagType
              pure $ subBagTotal * n
          )

sample =
  [r|light red bags contain 1 bright white bag, 2 muted yellow bags.
dark orange bags contain 3 bright white bags, 4 muted yellow bags.
bright white bags contain 1 shiny gold bag.
muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.
shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.
dark olive bags contain 3 faded blue bags, 4 dotted black bags.
vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
faded blue bags contain no other bags.
dotted black bags contain no other bags.|]

input :: String
input =
  [r|faded yellow bags contain 4 mirrored fuchsia bags, 4 dotted indigo bags, 3 faded orange bags, 5 plaid crimson bags.
striped olive bags contain 4 dark crimson bags.
dotted indigo bags contain 4 faded black bags, 4 clear cyan bags, 5 vibrant teal bags.
plaid crimson bags contain 3 shiny gold bags, 3 plaid gray bags.
muted fuchsia bags contain 3 shiny bronze bags.
plaid gray bags contain no other bags.
dull maroon bags contain 2 posh maroon bags, 3 wavy aqua bags, 2 faded white bags, 5 posh bronze bags.
dull red bags contain 3 striped silver bags, 2 dark tan bags.
muted lavender bags contain 3 striped red bags.
shiny lime bags contain 1 dotted olive bag.
dim violet bags contain 5 faded orange bags, 4 plaid green bags, 1 faded black bag.
wavy indigo bags contain 4 bright aqua bags, 2 dotted orange bags, 2 vibrant yellow bags.
vibrant purple bags contain 3 plaid indigo bags, 3 dark gold bags, 3 striped yellow bags, 3 light tomato bags.
plaid plum bags contain 1 faded silver bag.
striped teal bags contain 2 shiny crimson bags, 1 dull gray bag, 3 vibrant teal bags.
posh crimson bags contain 2 light violet bags.
pale maroon bags contain 2 wavy maroon bags, 1 dotted white bag.
drab cyan bags contain 4 dim violet bags, 5 pale tan bags, 3 faded black bags.
bright black bags contain 2 faded magenta bags.
dotted green bags contain 3 muted cyan bags.
striped chartreuse bags contain 5 posh silver bags, 5 wavy violet bags.
drab olive bags contain 5 dull blue bags.
drab green bags contain 2 vibrant violet bags, 2 dim violet bags, 2 light brown bags.
dark violet bags contain 5 drab brown bags, 4 dim chartreuse bags, 4 dark salmon bags.
faded orange bags contain 4 dull lavender bags.
dark fuchsia bags contain 2 clear tomato bags.
plaid gold bags contain 3 clear tomato bags.
muted red bags contain 1 muted green bag.
dark coral bags contain 5 muted white bags, 3 mirrored indigo bags, 1 shiny blue bag, 2 drab green bags.
dark chartreuse bags contain 2 bright teal bags.
dim silver bags contain 4 shiny white bags, 2 vibrant plum bags, 3 clear plum bags.
clear silver bags contain 1 dull gray bag.
pale gray bags contain no other bags.
plaid chartreuse bags contain 3 dull brown bags.
dotted crimson bags contain 3 pale olive bags, 2 pale black bags.
dark blue bags contain 1 light red bag, 5 striped turquoise bags.
dim white bags contain 5 bright white bags, 4 light magenta bags, 4 wavy chartreuse bags.
striped magenta bags contain 3 dull coral bags.
drab bronze bags contain 4 bright red bags.
light gray bags contain 1 mirrored coral bag.
wavy brown bags contain 4 clear lime bags, 1 plaid lavender bag, 1 faded lavender bag.
bright violet bags contain 5 clear indigo bags, 1 plaid indigo bag, 3 light beige bags.
drab tan bags contain 4 drab chartreuse bags.
shiny teal bags contain 1 bright tan bag.
dark silver bags contain 1 drab orange bag, 1 striped plum bag, 2 bright gold bags.
wavy turquoise bags contain 3 striped gray bags, 1 dotted lime bag, 4 pale plum bags, 2 vibrant orange bags.
wavy red bags contain 1 dim gold bag, 1 striped turquoise bag, 1 bright red bag.
mirrored yellow bags contain 5 faded cyan bags, 2 wavy green bags.
wavy blue bags contain 5 dark violet bags, 4 vibrant gray bags.
mirrored olive bags contain 5 faded orange bags, 2 posh aqua bags, 3 dotted silver bags, 2 striped plum bags.
faded crimson bags contain 3 striped maroon bags, 4 pale tomato bags.
vibrant olive bags contain 2 wavy yellow bags, 2 mirrored orange bags.
vibrant fuchsia bags contain 4 dim yellow bags, 3 drab tan bags.
dotted tan bags contain 2 faded fuchsia bags, 2 pale turquoise bags, 4 mirrored gray bags.
mirrored beige bags contain 1 mirrored olive bag.
faded turquoise bags contain 5 dull yellow bags, 5 clear gray bags, 5 muted lavender bags.
wavy violet bags contain 5 dotted gold bags, 5 dull cyan bags.
light tan bags contain 1 dull salmon bag, 1 dull bronze bag, 1 dull tan bag.
wavy tan bags contain 4 drab black bags.
muted silver bags contain 1 dark lavender bag, 5 pale tan bags, 2 clear violet bags, 3 drab coral bags.
dull blue bags contain 5 muted olive bags, 2 drab salmon bags, 3 clear red bags.
bright chartreuse bags contain 5 dim teal bags.
posh bronze bags contain 3 plaid black bags, 1 clear lavender bag, 3 dim chartreuse bags, 1 plaid gray bag.
striped orange bags contain 5 dull turquoise bags, 2 dotted olive bags, 5 bright coral bags, 1 mirrored aqua bag.
posh white bags contain 4 dim tomato bags, 5 light salmon bags.
faded cyan bags contain 2 plaid crimson bags, 5 muted green bags, 4 bright olive bags.
dark red bags contain 2 bright blue bags, 5 faded turquoise bags, 5 bright black bags.
pale magenta bags contain 4 drab chartreuse bags, 2 light tomato bags, 5 dull lavender bags.
posh orange bags contain 3 muted gray bags.
clear tan bags contain 2 dim crimson bags, 3 light olive bags.
dark green bags contain 4 muted maroon bags, 5 striped gold bags, 2 drab indigo bags, 2 dotted silver bags.
dim blue bags contain 5 wavy coral bags, 4 shiny chartreuse bags, 5 bright teal bags, 2 drab beige bags.
dim indigo bags contain 2 dull cyan bags, 3 dark maroon bags.
dotted gold bags contain 4 drab tomato bags, 1 light cyan bag, 2 pale tan bags, 2 light tomato bags.
faded gold bags contain 2 drab tan bags, 5 mirrored chartreuse bags, 2 striped gold bags, 3 bright silver bags.
muted olive bags contain 2 plaid black bags, 3 shiny gold bags, 4 vibrant crimson bags.
shiny gray bags contain 4 clear violet bags.
dim teal bags contain no other bags.
drab fuchsia bags contain 4 dim purple bags, 4 striped beige bags.
dark cyan bags contain 3 drab salmon bags.
clear lavender bags contain 2 dim olive bags, 4 mirrored gold bags, 4 striped plum bags.
posh lime bags contain 4 mirrored teal bags, 3 wavy chartreuse bags, 2 pale cyan bags, 5 pale indigo bags.
vibrant gold bags contain 5 dim chartreuse bags, 1 mirrored red bag, 3 dark lime bags, 4 shiny silver bags.
light crimson bags contain 3 muted lavender bags.
dark lime bags contain 1 faded chartreuse bag, 3 shiny crimson bags, 2 drab aqua bags.
dotted beige bags contain 1 faded white bag, 5 vibrant yellow bags.
dim chartreuse bags contain 4 striped lime bags, 2 faded black bags.
wavy bronze bags contain 5 muted cyan bags, 3 light yellow bags, 4 dotted purple bags.
striped plum bags contain 2 drab black bags, 1 faded silver bag.
posh chartreuse bags contain 4 faded blue bags, 2 vibrant crimson bags, 4 dotted purple bags, 4 posh tan bags.
vibrant yellow bags contain 4 dim tan bags, 1 mirrored fuchsia bag.
pale salmon bags contain 2 dull tan bags, 2 mirrored crimson bags, 1 drab chartreuse bag, 3 muted crimson bags.
drab gray bags contain 2 vibrant coral bags.
mirrored teal bags contain 5 vibrant violet bags.
striped maroon bags contain 2 dim violet bags, 3 dotted gold bags, 4 bright olive bags.
clear turquoise bags contain 4 plaid green bags.
vibrant white bags contain 5 dotted beige bags.
wavy chartreuse bags contain 1 faded orange bag, 4 shiny lavender bags.
mirrored gray bags contain 1 clear magenta bag.
bright aqua bags contain 3 mirrored gold bags, 5 shiny magenta bags, 1 shiny silver bag, 5 posh tan bags.
plaid violet bags contain 2 muted olive bags, 2 dotted chartreuse bags, 2 faded magenta bags, 1 drab cyan bag.
plaid olive bags contain 3 wavy lime bags, 2 faded cyan bags, 2 posh tan bags.
bright crimson bags contain 4 clear beige bags, 1 plaid teal bag, 3 shiny magenta bags.
shiny salmon bags contain 3 light silver bags, 3 faded orange bags, 3 dim tomato bags, 3 shiny gold bags.
mirrored red bags contain 5 shiny black bags.
shiny fuchsia bags contain 1 faded yellow bag, 1 plaid teal bag.
wavy tomato bags contain 4 light crimson bags, 3 clear blue bags.
clear lime bags contain 4 dark gray bags, 5 drab tomato bags.
light maroon bags contain 3 dark plum bags, 4 plaid crimson bags.
drab yellow bags contain 3 vibrant aqua bags, 5 pale red bags.
mirrored fuchsia bags contain 3 pale purple bags, 1 clear yellow bag, 1 wavy black bag, 4 pale gray bags.
clear black bags contain 1 plaid lavender bag, 4 muted indigo bags.
drab silver bags contain 1 faded green bag, 3 pale black bags.
clear teal bags contain 2 dotted silver bags.
plaid indigo bags contain 4 dotted purple bags.
striped indigo bags contain 1 mirrored indigo bag, 4 faded plum bags, 4 wavy crimson bags.
light salmon bags contain no other bags.
dull plum bags contain 4 plaid cyan bags.
muted tomato bags contain 4 dark violet bags.
mirrored orange bags contain no other bags.
striped tomato bags contain 5 dotted chartreuse bags, 2 dark white bags.
dotted magenta bags contain 2 wavy gold bags, 5 pale gray bags, 2 bright chartreuse bags.
vibrant blue bags contain 3 dotted cyan bags, 4 clear gold bags, 2 dark cyan bags.
mirrored crimson bags contain 1 dim salmon bag, 4 posh aqua bags.
shiny turquoise bags contain 2 striped blue bags, 2 light orange bags, 3 dim fuchsia bags, 2 dark olive bags.
muted gray bags contain 3 dotted yellow bags, 4 dim orange bags, 3 clear beige bags, 3 posh tan bags.
dim bronze bags contain 1 light magenta bag, 4 shiny purple bags, 1 light red bag.
dotted olive bags contain 2 dark crimson bags.
plaid bronze bags contain 4 bright silver bags, 1 faded lime bag, 3 striped lime bags, 3 drab coral bags.
posh blue bags contain 2 clear tomato bags.
plaid coral bags contain 4 clear turquoise bags, 1 plaid brown bag, 1 drab indigo bag.
faded magenta bags contain 2 wavy gray bags, 4 dark gold bags, 4 shiny white bags, 4 faded black bags.
light brown bags contain 3 striped red bags, 4 faded black bags, 5 vibrant violet bags.
dotted turquoise bags contain 2 mirrored orange bags.
pale bronze bags contain 2 mirrored silver bags, 1 faded cyan bag.
dark purple bags contain 1 muted lavender bag, 1 dull yellow bag, 5 vibrant tan bags, 1 dark gold bag.
plaid white bags contain 2 pale turquoise bags, 4 clear green bags.
wavy magenta bags contain 3 shiny blue bags, 1 dark yellow bag.
wavy gold bags contain 1 dotted indigo bag.
dull lavender bags contain 1 striped plum bag, 5 pale gray bags.
shiny silver bags contain 5 shiny lavender bags, 1 plaid crimson bag, 1 wavy black bag.
clear blue bags contain 2 plaid bronze bags, 1 shiny purple bag.
faded chartreuse bags contain 3 dull bronze bags.
pale blue bags contain 3 plaid yellow bags, 1 pale black bag, 4 clear magenta bags, 3 mirrored silver bags.
vibrant green bags contain 4 bright magenta bags, 4 dark black bags, 5 wavy chartreuse bags.
drab tomato bags contain 3 drab orange bags, 4 striped coral bags.
clear cyan bags contain 3 wavy chartreuse bags, 1 light salmon bag, 2 dim purple bags.
dim magenta bags contain 4 dim turquoise bags, 1 clear gray bag, 4 dim lime bags, 3 mirrored tomato bags.
wavy maroon bags contain 5 pale plum bags, 3 pale black bags, 3 striped red bags, 4 drab salmon bags.
posh gold bags contain 3 dim chartreuse bags, 1 faded blue bag, 4 mirrored teal bags.
muted aqua bags contain 2 faded maroon bags, 1 mirrored blue bag, 5 pale crimson bags.
muted orange bags contain 1 muted olive bag.
posh tan bags contain 4 muted lavender bags, 2 plaid crimson bags, 4 striped lime bags.
mirrored indigo bags contain 1 muted olive bag, 2 vibrant chartreuse bags, 4 light cyan bags.
wavy crimson bags contain 4 mirrored violet bags, 2 vibrant olive bags, 5 dull lavender bags, 1 drab cyan bag.
dim lavender bags contain 4 light salmon bags, 5 plaid tomato bags, 4 drab fuchsia bags.
dotted yellow bags contain 4 vibrant chartreuse bags.
light fuchsia bags contain 2 wavy red bags, 2 faded lime bags, 1 pale brown bag, 5 dotted green bags.
clear beige bags contain 5 drab chartreuse bags, 4 dark olive bags, 5 dim gold bags.
shiny gold bags contain 1 pale turquoise bag.
dim tomato bags contain no other bags.
plaid salmon bags contain 1 striped tan bag, 5 plaid purple bags, 1 mirrored crimson bag.
dotted lavender bags contain 3 striped teal bags, 1 vibrant gray bag.
light olive bags contain 3 posh tomato bags, 5 dim coral bags, 4 posh white bags, 2 dark turquoise bags.
striped silver bags contain 1 clear tomato bag, 1 drab cyan bag.
striped lavender bags contain 4 posh chartreuse bags, 5 faded coral bags.
faded beige bags contain 5 muted gold bags, 5 clear gold bags, 2 posh white bags.
drab indigo bags contain 1 pale magenta bag.
light blue bags contain 2 light chartreuse bags, 4 drab black bags, 2 dull bronze bags.
dull gold bags contain 5 dark blue bags, 2 bright green bags.
faded bronze bags contain 5 dim olive bags.
mirrored lime bags contain 5 pale crimson bags.
shiny coral bags contain 3 drab green bags, 3 posh white bags, 4 clear gray bags, 3 muted orange bags.
clear magenta bags contain 3 plaid olive bags, 4 plaid indigo bags, 1 dull blue bag.
wavy black bags contain 3 clear cyan bags, 3 dull bronze bags, 2 wavy chartreuse bags.
pale green bags contain 2 mirrored silver bags, 3 drab blue bags, 5 drab green bags, 4 pale tomato bags.
drab violet bags contain 1 drab orange bag, 1 vibrant indigo bag, 2 mirrored chartreuse bags.
light chartreuse bags contain 4 posh white bags, 5 dull bronze bags, 4 wavy coral bags.
dull black bags contain 4 muted red bags, 4 faded white bags, 5 plaid tomato bags, 2 dark blue bags.
dark gray bags contain 2 bright green bags, 5 light blue bags, 3 light tan bags, 2 shiny gold bags.
light turquoise bags contain 5 shiny coral bags, 3 dull brown bags, 3 striped tan bags, 4 striped silver bags.
mirrored magenta bags contain 3 vibrant silver bags, 4 vibrant crimson bags, 4 shiny coral bags, 1 shiny indigo bag.
dull lime bags contain 3 pale turquoise bags, 2 bright olive bags.
mirrored gold bags contain 1 faded silver bag, 4 pale gray bags.
clear chartreuse bags contain 4 dark gray bags, 1 pale lime bag, 1 plaid fuchsia bag.
dull indigo bags contain 4 posh silver bags.
dull yellow bags contain 3 wavy lavender bags, 3 muted maroon bags.
bright silver bags contain 2 wavy black bags, 1 dim coral bag.
clear indigo bags contain 1 posh black bag, 4 muted teal bags, 1 wavy maroon bag.
bright brown bags contain 3 shiny cyan bags, 5 clear green bags, 1 wavy magenta bag.
shiny crimson bags contain 1 faded black bag, 2 vibrant chartreuse bags.
striped white bags contain 4 light red bags, 3 dotted cyan bags.
pale tomato bags contain 1 posh white bag.
posh salmon bags contain 2 striped white bags, 5 clear purple bags, 5 bright yellow bags.
faded blue bags contain 5 drab cyan bags, 1 plaid crimson bag, 5 light crimson bags.
mirrored black bags contain 4 light tan bags, 3 faded blue bags.
bright red bags contain 3 pale magenta bags, 4 faded chartreuse bags.
drab lavender bags contain 5 dim red bags, 4 wavy black bags, 4 dull cyan bags, 5 clear gray bags.
light coral bags contain 4 dark lavender bags, 2 clear orange bags, 2 dull maroon bags.
bright plum bags contain 1 shiny blue bag, 5 striped salmon bags, 2 plaid olive bags.
faded tomato bags contain 4 pale turquoise bags.
wavy purple bags contain 1 light red bag.
striped crimson bags contain 2 shiny tan bags, 1 striped salmon bag, 5 dotted cyan bags.
posh olive bags contain 3 vibrant indigo bags.
plaid red bags contain 4 dotted violet bags, 1 plaid black bag, 4 light chartreuse bags.
pale aqua bags contain 3 plaid brown bags.
dotted silver bags contain 5 striped plum bags.
plaid magenta bags contain 4 clear lime bags, 1 muted chartreuse bag, 1 dark gray bag.
vibrant plum bags contain 3 clear yellow bags, 1 striped salmon bag.
faded lime bags contain 5 dull plum bags.
wavy lavender bags contain 3 dull bronze bags.
clear olive bags contain 5 pale bronze bags.
striped cyan bags contain 2 dotted gray bags.
drab black bags contain no other bags.
posh turquoise bags contain 1 clear teal bag.
plaid lime bags contain 5 pale gray bags, 5 shiny black bags, 2 faded tan bags, 4 clear lavender bags.
drab maroon bags contain 4 posh maroon bags, 3 drab lavender bags, 2 shiny lavender bags.
dull beige bags contain 3 mirrored coral bags, 2 faded fuchsia bags, 5 bright fuchsia bags.
dull bronze bags contain 2 mirrored olive bags.
striped violet bags contain 2 vibrant orange bags, 3 muted indigo bags, 5 light plum bags, 2 dark lavender bags.
striped fuchsia bags contain 3 striped salmon bags, 4 posh brown bags, 1 posh maroon bag.
light aqua bags contain 4 clear plum bags, 1 dull orange bag, 5 wavy magenta bags, 5 pale chartreuse bags.
wavy lime bags contain 1 mirrored teal bag, 1 posh tan bag, 5 clear teal bags, 4 plaid crimson bags.
plaid fuchsia bags contain 4 dark gold bags, 1 muted red bag, 4 light tomato bags.
muted white bags contain 5 plaid brown bags, 4 dotted plum bags, 3 dim crimson bags, 3 dim aqua bags.
pale white bags contain 4 mirrored chartreuse bags, 2 bright lavender bags, 5 striped teal bags.
vibrant aqua bags contain 3 faded green bags, 4 muted tomato bags, 2 clear lavender bags.
posh red bags contain 4 bright chartreuse bags, 1 clear red bag.
striped yellow bags contain 2 faded aqua bags, 3 light fuchsia bags, 5 dotted purple bags, 5 drab coral bags.
shiny lavender bags contain 2 faded orange bags.
dull coral bags contain 1 dull tan bag, 2 dull beige bags, 3 faded maroon bags, 1 wavy aqua bag.
faded violet bags contain 5 clear red bags.
dark turquoise bags contain 3 light chartreuse bags.
plaid silver bags contain 2 drab cyan bags, 1 dotted gray bag, 4 pale orange bags.
pale tan bags contain no other bags.
light white bags contain 2 shiny lime bags, 5 dull lavender bags, 4 plaid white bags.
dim beige bags contain 5 dotted silver bags, 5 dark gold bags, 1 muted turquoise bag, 1 pale olive bag.
muted crimson bags contain 2 faded silver bags, 2 dark olive bags.
shiny tan bags contain 2 dotted salmon bags.
dull magenta bags contain 3 drab black bags, 5 dim purple bags, 3 mirrored bronze bags.
dull white bags contain 1 clear teal bag, 2 faded violet bags, 4 dull bronze bags, 2 dotted gold bags.
clear green bags contain 3 pale crimson bags.
dark bronze bags contain 4 shiny cyan bags, 5 shiny white bags.
vibrant red bags contain 2 dark tomato bags, 3 muted crimson bags.
striped brown bags contain 4 pale yellow bags.
light bronze bags contain 5 drab silver bags, 5 wavy purple bags.
vibrant tomato bags contain 4 mirrored orange bags, 3 faded teal bags.
bright coral bags contain 4 clear maroon bags, 3 dim chartreuse bags.
shiny green bags contain 2 muted crimson bags, 5 pale tan bags, 3 drab black bags, 3 striped teal bags.
mirrored green bags contain 2 light black bags, 5 posh purple bags, 1 posh tan bag, 1 mirrored orange bag.
dull tan bags contain 3 bright tomato bags.
muted indigo bags contain 3 wavy coral bags.
shiny blue bags contain 1 wavy black bag, 2 dull maroon bags.
posh beige bags contain 5 dim crimson bags, 1 posh white bag, 2 mirrored teal bags, 2 vibrant chartreuse bags.
dim plum bags contain 2 vibrant chartreuse bags, 2 posh teal bags, 3 drab white bags.
vibrant teal bags contain 2 dim tomato bags, 2 dim teal bags, 4 drab chartreuse bags.
wavy olive bags contain 5 vibrant gold bags, 2 drab black bags, 2 shiny lime bags, 2 light coral bags.
faded white bags contain 4 posh cyan bags, 1 bright red bag, 2 pale olive bags, 3 plaid olive bags.
pale indigo bags contain 5 dim crimson bags, 1 dim tan bag, 5 plaid green bags.
pale fuchsia bags contain 4 light purple bags, 4 clear beige bags, 3 muted teal bags, 3 light blue bags.
faded gray bags contain 1 clear maroon bag, 2 dim fuchsia bags, 5 bright purple bags, 4 striped turquoise bags.
dark lavender bags contain 1 muted lavender bag, 2 vibrant crimson bags, 1 clear yellow bag.
light magenta bags contain 5 faded coral bags, 3 muted green bags, 4 mirrored fuchsia bags, 1 clear coral bag.
plaid cyan bags contain 1 muted crimson bag.
dim gold bags contain 3 clear cyan bags, 3 dim tomato bags, 3 shiny lavender bags, 2 vibrant teal bags.
bright tomato bags contain 1 striped red bag, 1 vibrant violet bag, 4 striped turquoise bags.
drab teal bags contain 2 posh turquoise bags, 1 shiny black bag.
pale olive bags contain 2 shiny gold bags, 3 posh bronze bags, 4 bright tomato bags, 2 bright olive bags.
pale brown bags contain 3 clear tomato bags.
dark yellow bags contain 3 light brown bags.
pale black bags contain 4 bright silver bags.
muted brown bags contain 2 light crimson bags, 4 drab chartreuse bags, 5 pale turquoise bags, 4 posh white bags.
wavy beige bags contain 2 posh maroon bags, 5 dark turquoise bags.
shiny olive bags contain 1 light salmon bag, 2 light crimson bags.
dotted teal bags contain 4 pale turquoise bags.
clear bronze bags contain 1 dotted tomato bag, 5 striped maroon bags, 5 shiny plum bags, 4 clear lime bags.
dim lime bags contain 3 dim lavender bags.
shiny aqua bags contain 2 clear plum bags, 1 plaid lavender bag, 2 faded aqua bags, 1 dim purple bag.
vibrant lime bags contain 4 dotted plum bags, 2 muted gray bags, 1 posh beige bag.
muted beige bags contain 1 mirrored lavender bag, 4 muted plum bags.
wavy yellow bags contain 4 posh cyan bags, 5 dim gold bags, 3 vibrant violet bags.
bright purple bags contain 1 bright chartreuse bag, 5 posh violet bags, 2 pale purple bags.
vibrant violet bags contain 2 wavy coral bags, 2 pale gray bags.
faded indigo bags contain 5 muted tomato bags, 2 dull tomato bags.
mirrored brown bags contain 1 shiny white bag, 4 dotted lavender bags, 3 striped cyan bags, 5 clear crimson bags.
bright beige bags contain 2 bright salmon bags.
bright gold bags contain 4 plaid crimson bags.
drab gold bags contain 5 pale tan bags.
bright orange bags contain 1 vibrant gold bag.
shiny brown bags contain 4 plaid lime bags, 4 dull gray bags, 1 pale tomato bag.
striped beige bags contain 1 clear yellow bag, 1 pale magenta bag, 4 dull bronze bags, 5 bright fuchsia bags.
clear brown bags contain 2 bright salmon bags, 2 vibrant turquoise bags.
muted turquoise bags contain 5 dim crimson bags, 1 drab chartreuse bag.
dark crimson bags contain 5 bright tomato bags.
clear yellow bags contain 2 dim olive bags.
bright lime bags contain 5 faded gray bags, 4 dull gold bags, 3 dark salmon bags, 4 posh lime bags.
muted coral bags contain 3 posh bronze bags, 3 striped gold bags.
dark salmon bags contain 2 vibrant indigo bags, 5 posh coral bags, 3 faded silver bags.
vibrant orange bags contain 4 dark turquoise bags, 2 vibrant lime bags.
pale violet bags contain 1 shiny brown bag, 2 dim plum bags, 3 dull crimson bags, 3 bright orange bags.
shiny purple bags contain 1 vibrant lavender bag, 1 dotted yellow bag.
drab orange bags contain 3 faded aqua bags.
posh brown bags contain 3 pale magenta bags, 4 faded orange bags, 1 drab chartreuse bag.
shiny bronze bags contain 3 light magenta bags, 3 drab indigo bags, 5 vibrant yellow bags.
muted teal bags contain 3 dim olive bags.
bright turquoise bags contain 3 bright chartreuse bags, 4 mirrored tomato bags.
muted chartreuse bags contain 4 faded gray bags, 1 dull salmon bag, 3 clear beige bags.
clear white bags contain 3 muted maroon bags.
posh violet bags contain 4 shiny white bags, 1 dull orange bag.
dotted brown bags contain 4 muted aqua bags.
mirrored plum bags contain 5 clear plum bags, 4 faded tomato bags.
drab crimson bags contain 1 pale white bag, 4 dotted maroon bags, 2 drab beige bags, 5 drab tan bags.
plaid black bags contain 1 light salmon bag, 3 mirrored orange bags, 2 dim purple bags.
dim orange bags contain 4 wavy black bags, 1 clear red bag.
faded plum bags contain 1 posh violet bag, 1 pale silver bag, 4 muted magenta bags.
vibrant salmon bags contain 2 dotted red bags, 1 dull maroon bag, 1 plaid tomato bag.
muted cyan bags contain 5 posh aqua bags, 2 faded silver bags, 2 striped red bags, 4 dim tomato bags.
muted salmon bags contain 5 muted teal bags, 3 striped cyan bags.
dim cyan bags contain 5 drab brown bags, 4 muted red bags, 1 wavy coral bag.
drab blue bags contain 4 faded aqua bags, 2 pale gray bags.
dotted lime bags contain 3 light olive bags, 2 light tomato bags, 5 dull gold bags, 2 dotted gold bags.
muted violet bags contain 4 wavy coral bags, 4 pale crimson bags, 1 dim coral bag, 2 mirrored coral bags.
vibrant maroon bags contain 5 wavy aqua bags, 4 muted orange bags, 3 dull tomato bags.
light tomato bags contain 3 dim tomato bags, 1 dim purple bag, 2 plaid gray bags, 3 striped red bags.
dotted violet bags contain 3 muted green bags, 2 faded silver bags.
mirrored coral bags contain 5 drab black bags, 2 vibrant crimson bags, 2 mirrored gold bags.
muted black bags contain 3 mirrored plum bags, 2 bright olive bags.
faded olive bags contain 1 vibrant orange bag, 3 faded gray bags, 3 shiny green bags, 2 muted lavender bags.
clear gold bags contain 4 dim purple bags.
striped lime bags contain 2 pale gray bags, 5 light brown bags, 5 vibrant violet bags, 4 bright tomato bags.
drab coral bags contain 2 pale tan bags, 5 striped teal bags, 1 drab indigo bag.
dotted purple bags contain 2 faded chartreuse bags, 3 clear beige bags, 4 striped turquoise bags.
light gold bags contain 2 dark gold bags, 5 striped salmon bags.
faded teal bags contain 5 plaid black bags, 5 dotted crimson bags, 3 mirrored magenta bags.
dull silver bags contain 5 bright yellow bags, 4 drab aqua bags, 4 shiny indigo bags.
shiny magenta bags contain 5 pale purple bags.
dull salmon bags contain 2 shiny black bags, 1 bright tomato bag.
posh fuchsia bags contain 1 pale teal bag, 1 clear orange bag.
mirrored lavender bags contain 2 posh brown bags, 3 light tomato bags, 5 plaid aqua bags, 2 vibrant olive bags.
posh tomato bags contain 2 drab blue bags.
faded maroon bags contain 2 dull beige bags, 2 dark gray bags.
dotted tomato bags contain 4 mirrored olive bags, 4 dull gold bags, 2 dotted silver bags, 4 wavy maroon bags.
muted bronze bags contain 2 dim olive bags, 2 posh lime bags, 3 drab coral bags, 5 wavy silver bags.
wavy aqua bags contain 2 striped lime bags, 4 wavy lime bags, 2 dim tan bags, 4 faded cyan bags.
dull violet bags contain 4 bright gold bags, 2 dim coral bags.
posh gray bags contain 2 dull bronze bags, 3 faded blue bags, 4 posh silver bags.
striped gold bags contain 4 wavy lavender bags, 2 muted gray bags, 3 wavy yellow bags.
vibrant black bags contain 3 shiny silver bags, 1 faded yellow bag.
dull teal bags contain 4 light blue bags, 3 posh lavender bags.
muted green bags contain 4 vibrant violet bags.
plaid green bags contain 3 dim purple bags, 4 dim teal bags, 1 muted cyan bag.
plaid blue bags contain 2 light purple bags, 4 dim gold bags, 5 pale black bags, 5 dim lavender bags.
vibrant turquoise bags contain 5 drab orange bags, 4 dark gold bags.
muted plum bags contain 3 dull aqua bags, 1 wavy lime bag, 3 dark green bags.
bright fuchsia bags contain 5 wavy gray bags, 1 dim teal bag, 5 muted cyan bags.
clear violet bags contain 1 bright salmon bag.
dotted chartreuse bags contain 4 pale plum bags, 2 bright purple bags.
vibrant gray bags contain 4 dark turquoise bags, 5 faded gold bags, 3 light olive bags.
dark tan bags contain 2 light olive bags, 1 vibrant fuchsia bag, 4 vibrant blue bags.
mirrored violet bags contain 2 muted gray bags.
mirrored maroon bags contain 5 mirrored coral bags, 2 faded lime bags, 3 dark gray bags.
dotted black bags contain 1 clear violet bag, 2 wavy chartreuse bags, 3 faded silver bags, 2 plaid gray bags.
shiny maroon bags contain 3 wavy turquoise bags, 2 dim purple bags, 1 shiny silver bag, 2 dim cyan bags.
dull cyan bags contain 3 mirrored olive bags.
drab brown bags contain 4 striped lime bags, 2 bright aqua bags.
dim crimson bags contain 2 drab black bags, 2 vibrant teal bags.
dim brown bags contain 2 mirrored beige bags.
vibrant silver bags contain 1 dark gold bag, 4 vibrant indigo bags, 5 dim red bags, 3 light blue bags.
dull olive bags contain 2 clear red bags, 1 vibrant plum bag.
faded purple bags contain 5 faded olive bags.
pale yellow bags contain 3 vibrant teal bags, 3 shiny violet bags, 2 dull yellow bags.
posh black bags contain 4 clear beige bags, 4 striped salmon bags, 4 wavy lavender bags.
dotted cyan bags contain 5 shiny crimson bags, 5 dark lavender bags, 5 faded green bags, 3 dull lime bags.
mirrored silver bags contain 4 light lime bags, 1 posh tomato bag.
pale gold bags contain 2 striped teal bags, 3 wavy chartreuse bags, 2 plaid tomato bags.
dotted white bags contain 2 muted purple bags, 2 posh white bags, 3 faded plum bags.
mirrored tan bags contain 2 clear bronze bags, 2 clear orange bags, 5 striped gray bags.
plaid beige bags contain 4 drab turquoise bags.
faded red bags contain 3 vibrant yellow bags, 3 pale brown bags, 4 dim beige bags, 5 wavy chartreuse bags.
pale coral bags contain 3 clear coral bags.
dull orange bags contain 5 wavy chartreuse bags, 5 plaid cyan bags.
dull brown bags contain 5 plaid olive bags, 3 faded chartreuse bags, 3 mirrored crimson bags.
mirrored aqua bags contain 5 faded green bags.
vibrant tan bags contain 1 dark turquoise bag, 4 plaid lime bags.
faded fuchsia bags contain 4 clear gray bags, 4 faded silver bags.
dim purple bags contain 5 dull lavender bags, 4 faded black bags, 1 muted cyan bag.
posh purple bags contain 1 wavy turquoise bag, 1 drab cyan bag, 2 dull coral bags, 4 posh yellow bags.
drab turquoise bags contain 3 dull black bags, 5 dotted bronze bags.
shiny orange bags contain 5 plaid crimson bags, 4 dotted coral bags.
plaid orange bags contain 3 wavy gray bags, 5 plaid crimson bags, 2 striped plum bags, 5 pale beige bags.
vibrant bronze bags contain 1 posh turquoise bag, 3 plaid turquoise bags, 1 dotted crimson bag.
clear tomato bags contain 5 mirrored fuchsia bags.
wavy coral bags contain 2 mirrored orange bags.
posh coral bags contain 5 dotted salmon bags.
bright tan bags contain 4 drab gray bags, 4 vibrant plum bags.
dotted gray bags contain 1 dull lime bag, 4 dotted tomato bags, 4 faded gold bags.
pale red bags contain 2 mirrored olive bags, 1 faded blue bag, 1 dark crimson bag, 3 striped teal bags.
striped aqua bags contain 2 drab black bags, 5 dull bronze bags, 3 pale purple bags, 4 faded silver bags.
plaid purple bags contain 3 bright salmon bags, 2 dim beige bags, 3 faded red bags.
drab purple bags contain 4 dotted black bags, 2 shiny black bags, 1 light plum bag, 1 dotted gold bag.
muted purple bags contain 3 pale crimson bags.
posh silver bags contain 4 bright gold bags, 1 dim coral bag, 2 drab chartreuse bags, 1 dim chartreuse bag.
dark black bags contain 1 bright green bag, 5 plaid cyan bags, 4 dotted purple bags.
striped coral bags contain 3 shiny lavender bags.
shiny yellow bags contain 4 dim tomato bags, 1 drab white bag.
bright magenta bags contain 2 muted silver bags, 3 dull bronze bags, 1 faded blue bag.
light black bags contain 4 posh silver bags.
pale purple bags contain 5 dull lavender bags, 1 mirrored orange bag.
striped salmon bags contain 3 faded chartreuse bags, 2 posh white bags, 1 striped lime bag, 3 drab cyan bags.
dull fuchsia bags contain 2 plaid tomato bags.
plaid maroon bags contain 5 dotted red bags, 2 vibrant magenta bags, 4 dotted purple bags.
posh yellow bags contain 2 wavy beige bags, 5 light yellow bags, 3 striped gray bags.
dull turquoise bags contain 1 drab lavender bag, 4 faded crimson bags, 2 drab purple bags.
wavy silver bags contain 5 dotted cyan bags, 2 faded blue bags, 2 faded aqua bags.
clear orange bags contain 5 posh silver bags, 1 vibrant teal bag, 1 pale tomato bag, 3 dull tomato bags.
drab chartreuse bags contain no other bags.
shiny black bags contain 5 dim teal bags, 1 faded silver bag, 2 posh beige bags, 1 bright olive bag.
pale teal bags contain 2 dull beige bags.
drab plum bags contain 5 pale beige bags, 2 wavy maroon bags.
vibrant lavender bags contain 4 wavy yellow bags.
dim turquoise bags contain 5 shiny crimson bags.
plaid tan bags contain 5 clear purple bags, 2 light indigo bags, 4 plaid cyan bags.
pale silver bags contain 1 pale green bag, 4 striped beige bags.
mirrored bronze bags contain 1 drab orange bag, 2 posh lavender bags, 2 muted gray bags.
plaid tomato bags contain 4 striped red bags, 3 bright olive bags.
bright indigo bags contain 4 dull tan bags.
light violet bags contain 5 faded magenta bags, 5 drab tomato bags.
clear aqua bags contain 1 plaid gray bag.
drab salmon bags contain 5 faded silver bags, 1 bright tomato bag, 1 light lime bag.
light teal bags contain 5 wavy brown bags, 2 muted indigo bags, 2 pale gold bags.
drab red bags contain 2 shiny chartreuse bags, 3 dim yellow bags, 3 vibrant teal bags, 3 mirrored silver bags.
bright white bags contain 5 dotted tan bags, 4 drab beige bags, 3 dim indigo bags, 2 dotted white bags.
dotted fuchsia bags contain 3 faded tomato bags, 1 dotted lavender bag.
dotted aqua bags contain 4 clear plum bags, 4 faded maroon bags, 1 posh bronze bag.
light purple bags contain 5 dotted cyan bags, 4 posh olive bags, 5 plaid fuchsia bags, 3 striped white bags.
shiny indigo bags contain 2 mirrored gold bags, 4 pale magenta bags, 5 shiny white bags, 4 posh tan bags.
pale turquoise bags contain 1 pale tan bag, 4 striped red bags, 1 bright olive bag.
plaid aqua bags contain 3 plaid black bags, 3 dim crimson bags.
posh cyan bags contain 3 dim tomato bags, 4 pale crimson bags, 4 shiny gold bags.
mirrored white bags contain 2 faded cyan bags.
shiny chartreuse bags contain 3 muted maroon bags, 2 dotted teal bags.
dim green bags contain 4 light salmon bags, 1 muted crimson bag, 2 striped beige bags.
striped blue bags contain 4 dark bronze bags, 5 faded plum bags, 3 bright white bags.
drab lime bags contain 4 dull tomato bags.
clear purple bags contain 2 drab chartreuse bags, 4 clear green bags.
dotted blue bags contain 5 dim purple bags, 3 dull brown bags.
vibrant cyan bags contain 2 drab indigo bags, 4 faded chartreuse bags.
light beige bags contain 3 dark orange bags, 3 vibrant cyan bags.
light lavender bags contain 1 muted cyan bag, 5 faded tan bags.
dim fuchsia bags contain 2 pale salmon bags.
mirrored purple bags contain 2 clear red bags.
faded brown bags contain 1 clear tan bag, 4 faded crimson bags.
muted magenta bags contain 5 pale tomato bags, 3 muted maroon bags.
pale beige bags contain 5 dark gold bags, 1 dull beige bag.
vibrant brown bags contain 2 striped gold bags, 1 bright gold bag.
clear coral bags contain 4 pale crimson bags, 1 dark teal bag, 4 mirrored coral bags, 4 striped gold bags.
striped tan bags contain 4 dim violet bags.
pale chartreuse bags contain 2 vibrant blue bags, 5 dark turquoise bags, 2 faded olive bags.
posh plum bags contain 1 plaid aqua bag.
striped purple bags contain 3 shiny tomato bags, 5 posh purple bags.
dark gold bags contain 5 vibrant crimson bags, 2 light tomato bags, 3 light salmon bags, 3 muted brown bags.
shiny cyan bags contain 1 vibrant crimson bag, 5 drab indigo bags.
bright yellow bags contain 3 plaid indigo bags.
bright blue bags contain 5 mirrored magenta bags.
dotted salmon bags contain 5 vibrant crimson bags, 2 posh chartreuse bags, 5 wavy gray bags, 4 pale turquoise bags.
dim olive bags contain 1 clear cyan bag.
striped turquoise bags contain 5 faded silver bags, 3 pale tan bags, 5 faded orange bags, 2 bright olive bags.
vibrant beige bags contain 3 faded yellow bags, 3 bright green bags, 3 faded bronze bags, 4 drab fuchsia bags.
clear maroon bags contain 1 vibrant indigo bag.
vibrant coral bags contain 2 mirrored tomato bags, 5 dull bronze bags, 1 vibrant teal bag, 3 pale salmon bags.
dotted orange bags contain 2 plaid green bags, 4 striped violet bags, 4 bright chartreuse bags, 4 dotted plum bags.
dull tomato bags contain 2 vibrant crimson bags.
wavy teal bags contain 1 bright orange bag.
dark teal bags contain 4 dim tan bags, 4 striped gray bags, 4 dim red bags, 4 plaid bronze bags.
vibrant indigo bags contain 3 drab coral bags, 2 plaid green bags, 4 shiny gold bags, 3 wavy coral bags.
striped red bags contain 4 faded silver bags, 4 light salmon bags, 3 drab black bags.
drab aqua bags contain 5 faded black bags.
wavy plum bags contain 4 posh blue bags, 5 striped olive bags, 3 shiny violet bags, 4 bright silver bags.
posh lavender bags contain 3 wavy silver bags, 1 drab lavender bag.
dotted red bags contain 5 drab bronze bags, 5 plaid gray bags.
dark orange bags contain 4 mirrored blue bags, 1 drab black bag.
bright lavender bags contain 4 shiny magenta bags, 2 bright tomato bags, 3 dim salmon bags, 4 dim purple bags.
mirrored chartreuse bags contain 2 wavy black bags, 4 dull cyan bags, 5 striped coral bags.
mirrored tomato bags contain 5 clear beige bags.
wavy fuchsia bags contain 2 muted silver bags, 2 shiny gold bags.
muted lime bags contain 2 striped turquoise bags, 3 dim tan bags.
shiny white bags contain 4 mirrored olive bags.
posh maroon bags contain 3 vibrant violet bags, 5 striped turquoise bags, 2 dull lavender bags, 4 faded orange bags.
faded aqua bags contain 2 faded orange bags, 2 pale magenta bags, 1 posh white bag.
mirrored blue bags contain 5 pale purple bags, 2 light red bags, 2 striped teal bags, 4 shiny crimson bags.
dotted plum bags contain 1 light chartreuse bag, 5 drab tan bags, 3 pale red bags.
muted tan bags contain 3 drab cyan bags, 2 posh olive bags, 1 dim tomato bag.
shiny tomato bags contain 3 mirrored cyan bags, 5 dim yellow bags.
pale lavender bags contain 2 dull beige bags.
pale orange bags contain 1 posh gold bag.
wavy green bags contain 4 posh bronze bags.
faded lavender bags contain 3 clear gold bags, 4 mirrored cyan bags, 4 faded silver bags, 5 posh chartreuse bags.
posh teal bags contain 1 shiny purple bag, 4 dotted violet bags, 1 dotted tomato bag, 5 dull indigo bags.
clear crimson bags contain 2 shiny lavender bags.
dim black bags contain 2 vibrant coral bags, 2 drab green bags.
dull crimson bags contain 3 vibrant orange bags, 2 drab salmon bags.
muted gold bags contain 3 posh chartreuse bags, 4 striped gold bags, 4 drab brown bags, 2 dim black bags.
dull chartreuse bags contain 3 clear fuchsia bags.
light orange bags contain 5 clear orange bags, 5 faded bronze bags, 3 clear crimson bags.
dark tomato bags contain 5 dotted chartreuse bags, 3 dull gray bags, 5 muted crimson bags.
dark brown bags contain 3 posh red bags.
faded green bags contain 1 dark white bag.
dark olive bags contain 4 vibrant teal bags, 3 pale magenta bags, 4 pale gray bags.
striped bronze bags contain 3 striped tan bags, 5 dark gray bags, 4 vibrant white bags.
striped black bags contain 1 striped turquoise bag, 1 vibrant olive bag, 1 striped salmon bag.
clear plum bags contain 4 wavy chartreuse bags, 1 pale bronze bag, 2 striped plum bags.
faded tan bags contain 2 muted cyan bags, 4 dim salmon bags, 3 vibrant crimson bags, 4 striped plum bags.
faded silver bags contain no other bags.
light silver bags contain 4 muted gray bags, 3 mirrored crimson bags, 3 dull tan bags, 2 drab indigo bags.
dim aqua bags contain 2 posh tomato bags, 2 muted coral bags, 5 wavy gray bags, 3 dull tan bags.
vibrant crimson bags contain 1 shiny lavender bag, 3 bright tomato bags.
dim maroon bags contain 4 light olive bags.
bright maroon bags contain 2 faded tan bags, 5 pale tomato bags, 5 dotted purple bags.
dim gray bags contain 1 muted gold bag, 4 shiny magenta bags, 2 wavy salmon bags, 2 posh violet bags.
dim coral bags contain 3 striped coral bags, 5 clear gold bags, 3 wavy chartreuse bags.
posh indigo bags contain 3 dull salmon bags.
striped green bags contain 3 vibrant crimson bags, 4 plaid plum bags, 4 muted brown bags.
dull purple bags contain 3 drab gold bags, 1 plaid gray bag, 4 striped silver bags.
light yellow bags contain 3 pale salmon bags, 5 dark cyan bags, 3 dull tomato bags, 3 mirrored silver bags.
shiny red bags contain 3 faded gold bags, 1 light salmon bag, 5 mirrored turquoise bags.
vibrant magenta bags contain 1 drab tomato bag, 5 plaid cyan bags.
plaid lavender bags contain 1 dull lavender bag, 5 vibrant black bags, 2 muted olive bags, 4 shiny lavender bags.
light cyan bags contain 1 bright silver bag.
dark plum bags contain 2 drab salmon bags, 3 dull violet bags, 3 posh lime bags.
dull green bags contain 4 bright gold bags, 2 posh gold bags, 2 striped plum bags.
wavy salmon bags contain 3 faded gray bags, 5 dotted cyan bags, 3 plaid maroon bags.
pale lime bags contain 1 shiny purple bag.
shiny plum bags contain 3 mirrored magenta bags, 4 clear violet bags, 5 dull tomato bags, 5 dotted violet bags.
dim red bags contain 2 posh white bags, 4 drab cyan bags, 1 dark yellow bag, 1 pale purple bag.
light red bags contain 3 dotted indigo bags, 4 bright tomato bags, 1 mirrored olive bag, 4 pale turquoise bags.
dim yellow bags contain 5 faded aqua bags, 2 shiny purple bags, 1 plaid bronze bag.
drab magenta bags contain 4 dotted coral bags, 3 plaid lime bags.
clear gray bags contain 5 plaid green bags, 3 pale purple bags.
plaid turquoise bags contain 4 mirrored crimson bags, 2 muted lavender bags, 3 light blue bags, 2 dull blue bags.
mirrored turquoise bags contain 5 muted magenta bags, 4 light red bags.
pale plum bags contain 3 clear beige bags, 5 striped plum bags, 4 striped lime bags, 2 striped teal bags.
vibrant chartreuse bags contain 2 drab chartreuse bags, 2 striped red bags, 4 dim teal bags.
striped gray bags contain 3 striped red bags, 1 drab green bag.
muted maroon bags contain 4 clear yellow bags, 1 dim tan bag, 3 vibrant cyan bags, 1 bright tomato bag.
posh aqua bags contain 3 faded silver bags, 5 pale tan bags, 2 striped red bags, 3 light salmon bags.
dotted bronze bags contain 4 striped gold bags, 5 dark lime bags, 2 pale magenta bags, 1 pale salmon bag.
dark aqua bags contain 4 dull salmon bags, 2 striped salmon bags, 5 clear turquoise bags.
plaid brown bags contain 4 posh silver bags.
bright cyan bags contain 2 posh yellow bags, 5 posh lavender bags, 4 shiny cyan bags.
dark indigo bags contain 5 pale turquoise bags, 4 light crimson bags, 2 dim orange bags.
muted yellow bags contain 3 light coral bags, 1 vibrant turquoise bag, 5 clear magenta bags, 2 pale olive bags.
clear fuchsia bags contain 2 posh silver bags, 1 striped yellow bag, 3 striped lime bags.
bright salmon bags contain 2 vibrant cyan bags.
dotted maroon bags contain 2 posh violet bags.
shiny violet bags contain 3 dim teal bags.
plaid teal bags contain 2 drab orange bags, 1 dim violet bag, 1 bright fuchsia bag.
faded salmon bags contain 5 drab orange bags, 3 clear indigo bags, 1 plaid cyan bag.
shiny beige bags contain 5 bright brown bags, 4 pale brown bags.
plaid yellow bags contain 3 vibrant crimson bags.
light indigo bags contain 4 vibrant cyan bags, 2 dotted purple bags.
dull aqua bags contain 5 pale tan bags.
posh green bags contain 2 light silver bags, 3 posh lime bags, 2 vibrant olive bags.
dark beige bags contain 3 dotted coral bags, 5 wavy chartreuse bags.
mirrored salmon bags contain 4 posh blue bags, 5 posh yellow bags, 4 posh fuchsia bags, 3 drab tomato bags.
pale crimson bags contain 3 dim tomato bags, 3 vibrant teal bags, 5 dotted silver bags.
wavy gray bags contain 1 dim olive bag, 4 plaid green bags.
bright olive bags contain 5 faded orange bags, 1 plaid black bag, 2 plaid gray bags, 3 faded silver bags.
light lime bags contain 5 dull lavender bags, 2 posh aqua bags, 4 dull aqua bags.
dim salmon bags contain 3 muted lavender bags, 1 light lime bag.
dark white bags contain 1 posh aqua bag, 3 wavy black bags.
posh magenta bags contain 5 striped silver bags, 3 wavy bronze bags, 3 faded beige bags.
mirrored cyan bags contain 5 light brown bags, 1 muted cyan bag, 4 posh silver bags.
dark magenta bags contain 2 muted indigo bags, 2 muted coral bags.
clear salmon bags contain 3 pale chartreuse bags.
dim tan bags contain 2 pale crimson bags.
bright gray bags contain 3 mirrored fuchsia bags.
bright green bags contain 5 plaid crimson bags, 3 striped turquoise bags.
faded black bags contain 1 striped red bag, 1 dim teal bag, 5 faded silver bags, 3 striped plum bags.
wavy orange bags contain 1 dark white bag.
wavy cyan bags contain 5 light olive bags.
muted blue bags contain 5 wavy maroon bags, 1 light tomato bag.
light green bags contain 1 shiny teal bag, 5 bright lime bags, 4 drab white bags, 5 posh aqua bags.
drab white bags contain 4 posh silver bags, 4 mirrored crimson bags.
bright teal bags contain 5 dotted purple bags, 1 faded yellow bag, 4 shiny coral bags.
light plum bags contain 3 pale cyan bags, 5 faded tan bags.
faded coral bags contain 4 dull gray bags.
dotted coral bags contain 2 posh bronze bags, 5 posh aqua bags, 2 mirrored violet bags.
pale cyan bags contain 2 mirrored orange bags, 2 dim tomato bags.
drab beige bags contain 4 bright aqua bags, 2 mirrored tomato bags, 2 plaid turquoise bags, 1 wavy chartreuse bag.
dark maroon bags contain 1 dull gray bag, 2 mirrored olive bags, 1 light olive bag, 1 shiny fuchsia bag.
wavy white bags contain 4 dull lavender bags.
dull gray bags contain 5 plaid black bags, 3 light lime bags, 2 wavy chartreuse bags, 5 dim tomato bags.
clear red bags contain 5 light crimson bags, 3 faded chartreuse bags, 4 clear teal bags, 4 mirrored blue bags.
bright bronze bags contain 1 clear magenta bag, 2 clear gray bags, 2 dull coral bags, 5 vibrant gray bags.|]
