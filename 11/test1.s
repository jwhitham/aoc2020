               JOB  TEST0.S 12/11/20 12:36:38                              -0198
     *
               CTL       6611  *6=16,000C;6=16,000T;1=OBJDECK;,1=MODADD
     *   1         2         3         4         5         6         7         8
     *78901234567890123456789012345678901234567890123456789012345678901234567890
     * label   | op | OPERATION                                         |xxxxxxx

               ORG  87
     X1        DSA  0                  index register 1
               ORG  92
     X2        DSA  0                  index register 2
               ORG  97
     X3        DSA  0                  index register 3
               ORG  100     * START ABOVE INDEX "REGISTERS" 
     INIT      B    START
               ORG  200
     PRINTS    DCW  @ @
               ORG  220
     PRINTM    DC   @ @
               ORG  332
     PRINTE    DC   @ @
               DC   @CONSTANTS:@

     WIDTH     DCW  012
     HEIGHT    DCW  012
     SIZE      DCW  144
     SIZE1     DCW  132
     ZERO      DCW  000
     ONE       DCW  001
     FIELD     DCW  @............@
               DCW  @.#.##.##.##.@
               DCW  @.#######.##.@
               DCW  @.#.#.#..#...@
               DCW  @.####.##.##.@
               DCW  @.#.##.##.##.@
               DCW  @.#.#####.##.@
               DCW  @...#.#......@
               DCW  @.##########.@
               DCW  @.#.######.#.@
               DCW  @.#.#####.##.@
               DCW  @............@     
               DC   @  VARIABLES:@
     CUR       DCW  @X@
     CUR2      DCW  @X@
     NBR       DCW  @A@
               DCW  @B@
               DCW  @C@
               DCW  @D@
               DCW  @E@
               DCW  @F@
               DCW  @G@
               DCW  @H@
     LAST      DCW  @X@
     SCNT      DCW  0
               DC   @  CODE:@     
     
     START     CS   PRINTE
               CS
               SW   PRINTS

     * Print out the current state of the field
               MCW  ZERO,X1
     OUTLP     SBR  X2,FIELD&X1
               MCW  0&X2,PRINTM              
               W
               A    WIDTH,X1
               C    SIZE,X1
               BU   OUTLP
     * Print a blank line
               CS   PRINTM
               W
     
     * Go to the next state
               MCW  ZERO,X1
     ITER      SBR  X2,FIELD&X1
     * Current cell is at X2 - does it represent floor space?
               MN   0&X2,CUR
               MZ   0&X2,CUR
               C    CUR,@.@
               BE   NSEAT
     
     * It represents a seat - so we need to decide what happens next
     * Collect occupied seats into a linear array
               MCW  X2,X3
     * Go west
               S    @1@,X3
               MN   0&X3,NBR&1
               MZ   0&X3,NBR&1
     * Go east
               MN   2&X3,NBR&2
               MZ   2&X3,NBR&2
     * northwest
               S    WIDTH,X3
               MN   0&X3,NBR&3
               MZ   0&X3,NBR&3
     * north
               MN   1&X3,NBR&4
               MZ   1&X3,NBR&4
     * northeast
               MN   2&X3,NBR&5
               MZ   2&X3,NBR&5
     * southwest
               A    WIDTH,X3
               A    WIDTH,X3
               MN   0&X3,NBR&6
               MZ   0&X3,NBR&6
     * south
               MN   0&X3,NBR&7
               MZ   0&X3,NBR&7
     * southeast
               MN   0&X3,NBR&0
               MZ   0&X3,NBR&0

     * Count the number of occupied seats
               MCW  ZERO,X3
               SBR  X3,NBR&X3
               MCW  @0@,SCNT
     * F - occupied before, unoccupied now
     * # - occupied before and now
     * X - end of NBR array
     CSEATS    MN   0&X3,CUR2
               MZ   0&X3,CUR2
               BCE  OCC,CUR2,F
               BCE  OCC,CUR2,#
               BCE  CSEATD,CUR2,X
               A    ONE,X3
               B    CSEATS
     OCC       A    @1@,SCNT
               B    CSEATS
     
     * Done counting seats
     CSEATD    C    @3@,SCNT
               BH   MANY
     * 0..3 adjacent seats are occupied
               C    @0@,SCNT
               BE   NONE
     * 1..3 adjacent seats are occupied: no state change
               B    NSEAT 
     
     * 0 adjacent seats are occupied
     * Rules:
     *  #    -> # (still occupied)
     *  else -> O (became occupied)
     NONE      C    @#@,CUR
               BE   NSEAT
               MN   @O@,0&X2
               MZ   @O@,0&X2
               B    NSEAT
     
     * 4..8 adjacent seats are occupied
     * Rules:
     *  #    -> F (became vacant)
     *  else -> L (still vacant)
     MANY      C    @#@,CUR
               BE   VAC
               B    NSEAT
     VAC       MN   @L@,0&X2
               MZ   @L@,0&X2

     * Go to the next seat (or space on the floor)                             
     NSEAT     A    ONE,X1
               C    SIZE1,X1
               BU   ITER   
     
               H    START
               B    START
               END  START
