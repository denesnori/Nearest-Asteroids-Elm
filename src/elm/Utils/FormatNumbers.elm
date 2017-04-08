module Utils.FormatNumbers exposing (..)

import Regex exposing (..)
import Types exposing (..)


-- formatFloat: 13424123.453453 -> 13,424,123.45


formatFloat : Unit -> String
formatFloat =
    let
        decReg =
            "(\\d+\\.\\d{2})(\\d+)"

        tripReg =
            "(?=(?:\\d{3})+(?:\\.|$))"

        snip =
            replace All
                (regex decReg)
                (\{ submatches } ->
                    Maybe.withDefault "" <| Maybe.withDefault (Just "String") <| List.head submatches
                )

        format =
            split All (regex tripReg) >> String.join ","
    in
        toString >> snip >> format



-- kmString: 13424123.453453 -> 13,424,123.45km


kmString : Unit -> String
kmString =
    formatFloat >> flip (++) "km"



-- kmsString: 13424123.453453 -> 13,424,123.45km/s


kmsString : Unit -> String
kmsString =
    kmString >> flip (++) "/s"
