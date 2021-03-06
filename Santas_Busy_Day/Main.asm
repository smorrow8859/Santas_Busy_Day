
;*******************************************************
;               Santa's Busy Day
;               Ahoy magazine 1985-12
;               =====================
;               Reverse engineered by Steve Morrow on
;               November 8, 2016
;*******************************************************

* =$340

incbin  "subchrist.raw"  


*       = $c000

        byte $01,$00,$d8,$ff,$ff,$ff,$28,$00

start
        lda     #0
        sta     841       ;841


        sta     844       ;844
        sta     251         ;251
        lda     #$0c
        sta     252         ;252
        ldy     #$0
bnc018
        lda     #32             ;*** was "32" 

;C01A
bnc01a
        sta     (251),y
        iny
        bne     bnc01a
        inc     252
        lda     252
        cmp     #165            ;159
        bne     bnc018
 
        lda     #$56
        sta     835             ;835

;C02C
        lda     #$51            ;81
        sta     251
        lda     #$28            ;40
        sta     253             
        lda     #$12            ;$fb/$fc (18) (hi/lo) > 4689
        sta     252             ;81+18*256=4689    
        sta     254             ;40+18*256=4648
        lda     #$93
        jsr     $ffd2           ;output a character
        ldx     #$00
bnc041  ldy     #$00
        lda     $0343             ;output of background screen
bnc046  sta     (253),y
        iny
        cpy     #$27            ;39
        bne     bnc046

;C04D        
        clc
        lda     253
        adc     #$28             ;40
        sta     253
        bcc     bc058            ;$c058
        inc     $fe

;C058
bc058
        inx
        cpx     #$51              ;81
        bne     bnc041            ;$c041
        ldy     #$00
        lda     #$04
        sta     (251),y
jmc063
        lda     #$ff
        sta     $d40f           ;voice 3 freq control (high)
        lda     #$80
        sta     $d412           ;voice 3 control register
        lda     $d41b           ;random number generator
        and     #$03
        sta     $ad
bnc074
        tax
        asl             
        tay
        
;C077 
;Begin drawing the map

        clc
        lda     $c000,y
        adc     $fb
        sta     170
        lda     $c001,y
        adc     $fc
        sta     171
        
        clc
        lda     $c000,y
        adc     170
        sta     253
        lda     $c001,y
        adc     171
        sta     254
        ldy     #$00
        lda     (253),y
        cmp     835
        bne     bnc0b0            ;$c0b0
        txa     
        sta     (253),y
        lda     #$20
        sta     (170),y          ;clear screen data
        lda     253
        sta     251
        lda     254
        sta     252
;C0AD
        jmp     jmc063            ;$c063

;C0B0
bnc0b0
        inx
        txa
        and     #$03
        cmp     173
        bne     bnc074            ;$c074
        lda     (251),y
        tax
        lda     #$20    
        sta     (251),y
        cpx     #$04
        beq     ldc0dd            ;c0dd      
        txa
        asl
        tay
        ldx     #$02
;C0C8
bnc0c8
        sec
        lda     251
        sbc     $c000,y         ;moving thru 49152,y
        sta     251
        lda     252
        sbc     $c001,y
        sta     252
        dex
        bne     bnc0c8          ;$c0c8          


;C0DA
        jmp     jmc063          ;$c063          

;C0DD
ldc0dd
        lda     #$f
        sta     840
        sta     $02
        lda     #$01
        sta     $d020           ;border color
        lda     #$06
        sta     $d021

        jsr     color_scrn      ;jsc0f2          
        jmp     jmc110          
;C0F2
;jsc0f2
color_scrn
        lda     #$d
        sta     $07f8           ;2040 (SPRITE SHAPE)

;Change color of maze background
        lda     $3
        ldy     #$00
;C0F6
bnc0f6
        sta     $d800,y         ;55296,y
        sta     $d900,y         ;55552,y
        sta     $da00,y         ;55808,y
        sta     $db00,y         ;56064,y
        iny
        bne     bnc0f6          ;$c0f6

        ldx     #$28
        lda     #$0d
bnc109
        sta     $dbc0,x         ;56256
        dex
        bne     bnc109          ;$c109
        rts

;C110
jmc110

;Scrolling
        lda     835           ;835
        sta     4687           ;4687
        sta     7887
        lda     #$20
        sta     4688
        sta     4688
        sta     7808
        sta     7846
        lda     #$00
        sta     $fb
        sta     831
        lda     #$ff
        sta     253
        lda     #$12
        sta     252
        lda     #$23
        sta     254             ;Points to 9215
        ldy     #$00

;----------------------
;MEMORY SCROLLER ------
;----------------------

;C13C
bnc13c
        ldx     #$00       
;C13E
bnc13e
        clc
        lda     $fd             ;Read screen data
        adc     #$01
        sta     $fd
        lda     $fe             ;Change to "#1" to see memory scroll
        adc     #$00
        sta     $fe
        lda     ($fb),y
        sta     ($fd),y
;C14F
        clc
        lda     $fd
        adc     #$78
        sta     $fd
        lda     $fe
        adc     #$00
        sta     $fe
        lda     ($fb),y         ;Store it in the map
        sta     ($fd),y     
;C160
        clc
        lda     $fd             ;Read screen data
        adc     #$78
        sta     $fd
        lda     $fe
        adc     #$00
        sta     $fe
        lda     ($fb),y         ;Store it in the map
        sta     ($fd),y
;C171
        sec
        lda     $fd
        sbc     #$f0            ;240
        sta     $fd
        lda     $fe
        sbc     #$00
        sta     $fe
        inx
        cpx     #$03
        bne     bnc13e
        inc     831
        lda     831
        cmp     #$28
        bne     bnc19f
;C18D
        clc
        lda     $fd
        adc     #$f0
        sta     $fd
        lda     $fe
        adc     #$00
        sta     $fe
        lda     #$00
        sta     831
;C19F        
bnc19f
        clc
        lda     $fb
        adc     #$01
        sta     $fb
        lda     $fc
        adc     #$00
        sta     $fc
        lda     $fc
        cmp     #$20
        bne     bnc13c     
;C1B2
        lda     $fb
        cmp     #$00
        bne     bnc13c


;======================================
;Draw score pellet shapes on the screen.
;======================================

;C1B8
        lda     #$a0             ;Draw score pellets, default: $a0
        sta     834
        lda     #$ff
        sta     $d40f           ;voice 3 freq control
        lda     #$80            ;reduce pellets
        sta     $d41b           ;read oscillator 3/random num gen
        
;C1C7
        ldx     #$d2
        ldy     #$00
;C1CB
bnc1cb
        lda     $d41b           ;random generator          
        cmp     #$27
        bmi     bnc1cb        
        cmp     #$90
        bpl     bnc1cb
        sta     $fc
        lda     $d41b
        sta     $fb
        lda     ($fb),y
        cmp     835
        beq     bnc1cb       
;C1E4   
        lda     834
        sta     ($fb),y
        dex
        bne     bnc1cb

;C1EC
        lda     834
        cmp     #$53
        beq     bec1fd
        lda     #$53
        sta     834
        ldx     #$02
        jmp     bnc1cb
;C1FD

;Show the score: 0000
bec1fd

;**************************************
;       Increase the score
;**************************************


;A high number in the ldx will increase the score.
;Try #$04 for a demonstration. Will increase by 1000 points.

;       04 - Tens place
;       05 - Hundredths place
;       06 - Thousandths place

        ldx     #$06
        lda     #$30
;C201

bnc201
        sta     $07c1,x         ;score panel
        dex

;****       (JSR)
        bne     bnc201
        jsr     draw_timer_panel    ;jmc20d
        jmp     jmc21d
        
;C20D

;******************* MAIN *************************

;Draw the health panel
;jmc20d
draw_timer_panel
        ldx     #$20
        lda     #$5b
bnc211
        sta     1991,x         ;health panel
        dex     
        bne     bnc211

        lda     #$01
        sta     847
        rts

;Initialize sprite data
jmc21d
        lda     #$98
        sta     836    
        lda     #$21
        sta     837
        lda     #$00
        sta     838
        lda     #$0f
        sta     $d418           ;sound volume
        lda     #$01
        sta     $d01c           ;sprite multicolor
        sta     $d015           ;sprite enabled
        lda     #$c0
        sta     $d000           ;sprite x pos
        lda     #$8c
        sta     $d001           ;sprite y pos
        ;lda     #$02

        lda     #$5
        sta     $d027           ;sprite 0 color

        lda     #$00
        sta     $d025           ;sprite multicolor reg 0
        lda     #$1
        sta     $d026           ;sprite multicolor reg 1
;C257
jmc257
        lda     $dc00           ;joystick setup
        and     #$0f
        sta     832             ;save joystick data
        dec     838
        lda     838             ;838
        cmp     #$00            ;joystick is idle
        bne     readjoystick      ;bnc27b
;C269
        lda     #$00
        sta     $d404           ;voice 1 control register
        lda     840             ;840
        sta     $02
        jsr     color_scrn      ;jsc0f2
        lda     #$06
        sta     $d020           ;change border color
;C27B
;bnc27b
readjoystick

;Joystick up
        ;jsr     resetmapdata

        sec
        lda     #$0f
        sbc     832
        sta     832
        cmp     #$0             
        beq     bec28b          ;joystick is idle
        sta     845

        lda     #$d
        sta     $07f8           ;2040 (SPRITE SHAPE)

;C28B
bec28b
        lda     828
        cmp     #$01
        bne     bnc298
        lda     832
        sta     845             ;store joystick data

;C298
bnc298
        lda     845   
        cmp     #$01            ;01 = up
        bne     bnc2a2
        jmp     joystickup      ;jmc2ba - moving up
;C2A2
bnc2a2
        cmp     #$02            ;02 = down
        bne     bnc2a9
        jmp     joystickdown    ;jmc2e1 - moving down
;C2A9
bnc2a9
        cmp     #$04            ;04 = left
        bne     bnc2b0
        jmp     joystickleft    ;jmc308          
;C2B0
bnc2b0   
        cmp     #$08            ;08 = right
        beq     bec2b7          ;moving  right
        jmp     jmc353
;C2B7
bec2b7
        jmp     joystickright   ;jmc32f


;C2BA
;jmc2ba
joystickup        
        lda     $05cc
        sta     833
        cmp     835
        bne     bnc2cd
        lda     #$02
        sta     845
        jmp     jmc353
;C2CD
bnc2cd
        sec
        lda     836
        sbc     #$78
        sta     836
        lda     837
        sbc     #$00
        sta     837
        jmp     $c353

;jmc2e1
joystickdown
        lda     $061c           ;1564
        sta     833
        cmp     835
        bne     bnc2f4
;C2EC 
        lda     #$01
        sta     845
        jmp     jmc353
;C2F4
bnc2f4
        clc
        lda     836
        adc     #$78
        sta     836
        lda     $0345
        adc     #$00
        sta     837
        jmp     jmc353

;Joystick left
       
;C308
;jmc308
joystickleft
        lda     $05f3           ;1523
        sta     833
        cmp     $0343
        bne     bnc31b
        lda     #$08
        sta     835           ;845
        jmp     jmc353
;C31B
bnc31b
        sec
        lda     836
        sbc     #$01
        sta     836
        lda     837
        sbc     #$00
        sta     837
        jmp     jmc353


;Joystick right

;C32F
;jmc32f
joystickright
        lda     $05f5
        sta     833
        cmp     835
        bne     bnc342
        lda     #$04
        sta     845
        jmp     jmc353        
;C342
bnc342
        clc
        lda     836
        adc     #$01
        sta     836
        lda     837
        adc     #$00
        sta     837

;*********** Main loop **********

;C353
jmc353
        lda     #$00
        sta     $fd
        lda     #$04
        sta     $fe
        lda     #$00            ;init screen 0+4*256=1024      
;C35D
bnc35d
        sta     846
        sta     839
        lda     836
        sta     $fb
        lda     837
        sta     $fc
;C36D
        ldy     #$00
bnc36f
        lda     ($fb),y
        sta     ($fd),y
        clc
        lda     $fb
        adc     #$01
        sta     $fb
        lda     $fc
        adc     #$00
        sta     $fc
        clc
;C381
        lda     $fd
        adc     #$01
        sta     $fd
        lda     $fe
        adc     #$00
        sta     $fe
        inc     839
        lda     839
        cmp     #$28            ;40
        bne     bnc3a9
;C397
        lda     #$00
        sta     839
        clc
        lda     $fb
        adc     #$50
        sta     $fb
        lda     $fc
        adc     #$00
        sta     $fc
;C3A9
bnc3a9
        inx
        bne     bnc36f
        inc     846
        lda     846
        cmp     #$04
        bne     bnc3b9
        jmp     jmc3c2
;C3B9
bnc3b9
        cmp     #$03
        bne     bnc36f
        
;C3BD
        ldx     #$68
        jmp     bnc36f






;******************************************************
;************ Every below is understood ***************
;******************************************************

;!!!!!!!!!!!!!!!!  OUCH! !!!!!!!!!!!!!!!!!!!!!
;Bumped into a wall

;C3C2
jmc3c2
        lda     833
        cmp     835
        bne     bnc3f0
        lda     #$08
        sta     $02              ;Change to $02 to bounce player
        lda     #$d              ;Change border to green
        sta     $d020

;//////// Sound when picking up gifts  ///////
        jsr     color_scrn      ;jsc0f2            
;C3D4
        lda     #$08
        sta     $d405           ;voice 1 attack/decay register
        lda     #$81
        sta     $d404           ;voice 1 control register
        lda     #$19
        sta     $d401           ;voice 1 freq control (high byte)
        lda     #$0a
        sta     841
        lda     #$02
        sta     838
        inc     847             ;controls game timer
;C3F0
bnc3f0
        lda     833             ;Commenting out these
        cmp     #$a0            ;lines kept the score
        bne     bnc415          ;increasing
;C3F7
        lda     #$07
        sta     $02             ;Change color of border
        sta     $d020           ;when hitting a wall

        jsr     color_scrn      ;jsc0f2
        lda     #$01
        sta     843
        lda     #$0f
        sta     $d405           ;voice 1 attack/decay register
        lda     #$11
        sta     $d404           ;voice 1 control register
        lda     #$05
        sta     838
;C415
bnc415
        lda     833
        cmp     #$53
        bne     bnc442
        lda     #$00
        sta     $02
        jsr     color_scrn      ;jsc0f2
        lda     #$0f
        sta     $d405           ;voice 1 attack/decay register
        lda     #$21
        sta     $d404           ;voice 1 control register               
        lda     #$04
        sta     838
        ldx     #$80
        ldy     #$00

;**************************
;       FLASH SCREEN
;**************************

;C436
bnc436
        inc     $d021           ;Increase 53281 (Screen color)
        iny
        bne     bnc436
        inx
        bne     bnc436
        

;  ----  (JSR) ------

;C43F
        jsr     draw_timer_panel        ; jmc20d
;C442
bnc442
        lda     841
        cmp     #$00
        beq     bec460

;C449
;Spells "OUCH"
        lda     #$0
        sta     $052c           ;1324
        lda     #$15
        sta     $0554           ;1364
        lda     #$03
        sta     $057c           ;1404
        lda     #$08
        sta     $05a4           ;1444
        dec     841
        
;C460
bec460
        clc
        lda     836
        adc     #$b4            ;change to $28 to stop from
        sta     $fb             ;erasing the gifts
        lda     837
        adc     #$05
        sta     $fc
        lda     #$20
        sta     ($fb),y
        sta     833
        lda     843
        cmp     #$01
        bne     bnc4c6        
;C47D
        lda     #$00
        sta     843
        lda     #$0
        sta     842
        clc
        lda     1988
        adc     #$01            ;57 = 9
        cmp     #$3a            ;1st digit > 9 $3a = 58
        beq     updatescore     ;bec497
;Update score (starting at leftmost digit - 1988)

;C491
        sta     1988           ;digit 1
        jmp     jmc4a1
;C497
;bec497
updatescore
        lda     #$30            ;"0"
        sta     1988           ;digit 2
        lda     #$01
        sta     842
;C4A1
jmc4a1
        ldx     #$02        
;C4A3
bnc4a3
        clc
        lda     $07c1,x
        adc     842
        cmp     #$3a
        beq     bec4b9
        sta     $07c1,x         ;1985,x
        lda     #$00
        sta     $034a
        jmp     jmc4c3
;C4B9

;Score  :0000
bec4b9
        lda     #$30
        sta     $07c1,x         ;1985,x
        lda     #$01
        sta     $034a
;C4C3
jmc4c3
        dex
        bne     bnc4a3
;C4C6
bnc4c6
        inc     844
        lda     844
        cmp     #$00
        bne     bec4d3
;C4D0
        inc     847           ;847 - timer
;C4D3
bec4d3
        lda     847
        tax


;Point score: default "10"

;Draw the energy bar

;C4D7
bnc4d7
        lda     #$a0
        sta     $07c7,x         ;score update
        lda     #$7
        sta     $dbc7,x
        dex
        bne     bnc4d7          ;Change 1988 to end game at
        lda     1986            ; "2000" points
        cmp     #50            ;Check score 200,000         
        bne     bnc4e9
        jmp     gameover       ;jmc4f3 - jump end of game
;C4E9
bnc4e9
        lda     847
        cmp     #$20
        bne     brc538
        jmp     gameover       ;jmc4f3

brc538
        jmp     bnc538


;C4F3
;jmc4f3
gameover
;Game over

;Print "OVER"
        lda     #$00
        sta     $d404           ;voice 1 control register
        sta     $d015           ;turn off sprite

game_msg_display   
        lda     #$c9            ;position message 
        sta     $fb             ;"HACKED BY" starting
        lda     #$5             ;at memory location        
        sta     $fc             ;7c6 (1990)
        ldx     #$0
        lda     gamemsgdisplaylo,x
        sta     253     
        lda     gamemsgdisplayhi,x
        sta     254
        ldx     #1
rdmsghi   
        ldy     #0   
rdmsglow  
        lda     ($fd),y        ;gmap4
        sta     ($fb),y        ;1024,x
        iny
        cpy     #$9
        bne     rdmsglow 

        lda     #$29
        sta     $05f3           ;1523   (energy pellet)
        lda     #$14
        sta     $05f4
        lda     #$05
        sta     $05f5
        lda     #$16
        sta     $05f6
        lda     #$05
        sta     $05f7
        lda     #$02
        sta     $02
        lda     #$00
        sta     $d021           ;53281, 0
        jsr     color_scrn      ;jsc0f2

;C51B
        lda     #$d
        sta     $d9f3           ;55795
        sta     $d9f4           ;55796
        sta     $d9f5
        sta     $d9f6
        sta     $d9f7


        lda     #$32
        sta     $61c
        lda     #$30
        sta     $61d
        lda     #$31
        sta     $61e
        lda     #$36
        sta     $61f


;color in "HACKED BY"
        lda     #$d
        sta     $d9c9
        sta     $d9ca
        sta     $d9cb
        sta     $d9cc
        sta     $d9cd
        sta     $d9ce
        sta     $d9cf
        sta     $d9d0
        sta     $d9d1

;"2016"
        lda     #1
        sta     $da1c
        sta     $da1d
        sta     $da1e
        sta     $da1f


;C529
bnc529
        lda     $c5
        cmp     #$40
        bne     bnc529

;C52F

;Wait for a key to be pressed. 
;Then restart the game.
bec52f
        inc     $d020
        nop     
        nop     
        nop
        nop
        nop
        nop
        nop
        nop
        lsr
        lda     $c5
        cmp     #$40
        beq     bec52f
        jmp     start           ;jmc008
;C538
bnc538
        jmp     jmc257
   


;Test code

loop
        ;sta     $d020
        lda     #1
        sta     1024
        asl
        sta     1025
        lda     #$ff
        sta     $7f8
        ;sta     $d000
        ;lsr     
        ;sta     $d001

        lda     #7
        sta     $d021


        jmp     loop

resetmapdata
          ldx            #2                  
          lda            gscreenmaplo,x 
          sta            251
          lda            gscreenmaphi,x 
          sta            252       
          rts 


hackedby_msg
        text   'hacked by'

gamemsgdisplaylo    byte    <hackedby_msg, hackedby_msg
gamemsgdisplayhi    byte    >hackedby_msg, hackedby_msg

gscreenmaplo    byte    <gmap4, <gmap4, <gmap4, <gmap4
gscreenmaphi    byte    >gmap4, >gmap4, >gmap4, >gmap4


gmap4
* = $8000

incbin  "subchrist.raw" 