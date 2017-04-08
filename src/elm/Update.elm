module Update exposing (..)

import Types exposing (..)
import Data exposing (neoKeys, buildNasaUrl)
import Utils.FormatDate exposing (formatDate)
import Utils.ChangeSettings exposing (nextSetting, previousSetting)
import Utils.NasaDecoder exposing (nasaDecoder)
import Http exposing (..)
import Date exposing (Date)
import Task
import Window exposing (..)


type Msg
    = AsteroidRequest (Result Http.Error AsteroidList)
    | SetDate (Maybe Date)
    | NextSetting
    | PreviousSetting
    | Resize Int


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetDate Nothing ->
            ( model, getAsteroids model.date )

        SetDate (Just date) ->
            let
                newDate =
                    formatDate date
            in
                ( { model | date = newDate }, getAsteroids newDate )

        AsteroidRequest (Ok res) ->
            ( { model | asteroids = res, loading = False }, getWidth )

        AsteroidRequest (Err _) ->
            ( { model | asteroidsErr = Error <| resultErrMessage model.date, loading = False }, getWidth )

        NextSetting ->
            { model | setting = (nextSetting model.setting) } ! []

        PreviousSetting ->
            { model | setting = (nextSetting model.setting) } ! []

        Resize w ->
            setOrientation w model ! []


getWidth : Cmd Msg
getWidth =
    Task.perform Resize width


setOrientation : Int -> Model -> Model
setOrientation w model =
    if w < 500 then
        { model | orientation = Portrait }
    else
        { model | orientation = Landscape }


now : Cmd Msg
now =
    Task.attempt processDateResult Date.now


processDateResult : Result String Date -> Msg
processDateResult result =
    case result of
        Ok date ->
            SetDate (Just date)

        Err _ ->
            SetDate Nothing


resultErrMessage : String -> String
resultErrMessage currentDate =
    "Unable to generate results for " ++ currentDate ++ ", displaying example data"


getAsteroids : String -> Cmd Msg
getAsteroids date =
    Http.get (buildNasaUrl date) nasaDecoder
        |> Http.send AsteroidRequest


subscriptions : Model -> Sub Msg
subscriptions model =
    Window.resizes (\{ height, width } -> Resize width)
