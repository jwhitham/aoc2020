
$ROWS_LOG_2 = 7
$COLS_LOG_2 = 3
$ROWS = 1 -shl $ROWS_LOG_2
$COLS = 1 -shl $COLS_LOG_2
$ROW_FIELD_ENDS = $ROWS_LOG_2 - 1
$COL_FIELD_ENDS = $ROWS_LOG_2 + $COLS_LOG_2 - 1

function getSeatNumber($passNumber) {
    $row = 0
    $j = $ROWS
    foreach ($i in 0 .. $ROW_FIELD_ENDS) {
        $j = $j -shr 1
        if ($passNumber.Substring($i, 1) -eq "B") {
            $row = $row -bor $j
        }
    }
    $col = 0
    $j = $COLS
    foreach ($i in ($ROW_FIELD_ENDS + 1) .. $COL_FIELD_ENDS) {
        $j = $j -shr 1
        if ($passNumber.Substring($i, 1) -eq "R") {
            $col = $col -bor $j
        }
    }
    $seatNumber = ($row -shl $COLS_LOG_2) + $col
    return $seatNUmber
}

function getPassNumber($seatNumber) {
    $row = $seatNumber -shr $COLS_LOG_2
    $col = $seatNumber % $COLS
    $passNumber = ""
    $j = $ROWS
    foreach ($i in 0 .. $ROW_FIELD_ENDS) {
        $j = $j -shr 1
        if ($row -band $j) {
            $passNumber = $passNumber + "B"
        } else {
            $passNumber = $passNumber + "F"
        }
    }
    $j = $COLS
    foreach ($i in ($ROW_FIELD_ENDS + 1) .. $COL_FIELD_ENDS) {
        $j = $j -shr 1
        if ($col -band $j) {
            $passNumber = $passNumber + "R"
        } else {
            $passNumber = $passNumber + "L"
        }
    }
    return $passNumber
}

function test($passNumber, $seatNumber) {

    $s = getSeatNumber $passNumber
    $p = getPassNumber $s
    if ($p -ne $passNumber) {
        [System.Console]::WriteLine("ERROR (passNumber): $p != $passNumber")
        exit 1
    }
    if ($s -ne $seatNumber) {
        [System.Console]::WriteLine("ERROR (seatNumber) $s != $seatNumber")
        exit 1
    }
}


test "BFFFBBFRRR" 567
test "FFFBBBFRRR" 119
test "BBFFBBFRLL" 820
exit 0

