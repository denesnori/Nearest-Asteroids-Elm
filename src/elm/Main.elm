module Main exposing (..)

import Update exposing (..)
import Model exposing (..)
import View exposing (..)
import Html exposing (..)


-- main: @TODO. Replace getAsteroids with getDate Cmd


main : Program Never Model Msg
main =
    program
        { update = update
        , init = ( initialModel, now )
        , view = view
        , subscriptions = always Sub.none
        }
