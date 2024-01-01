; sesame-os
[bits   16]
[org    0x7c00]
CYLS    EQU             10

jmp         entry

; FAT32フォーマット

bootsectorsName         DB      "OPENSESAME"        ;ブートセクタの名前
bitesPerSector          DW      512                 ;1セクタの大きさ、大体512（FAT32フォーマット）
sectorsPerCluster       DB      8                   ;アロケーションユニット(クラスタ)当たりのセクタ数
reservedSectors         DW      32                  ;FATがどこから始まるか（FAT32では代表的に32らしい）
FATsNum                 DB      2                   ;FATの数。このフィールドの値は常に2に設定すべきである
directoryEntryNum       DW      0                   ;ルートディレクトリに含まれるディレクトリエントリの数（FAT32ではこのフィールドは使われず、常に0でないといけない）
sectorsNum              DW      0                   ;総セクタ数（FAT32では無効値(0)にしないといけない）
mediaType               DB      0xf8                ;メディアのタイプ（区画分けされてない0xf0）
sectorsPerFAT           DW      0                   ;FAT領域の長さ（FAT32では無効値(0)にしなければならない）
sectorsPerTrack         DW      63                  ;1トラックにいくつのセクタがあるか（IBM PCのディスクBIOSで使用される）
sectorsPerHead          DW      2                   ;ヘッドの数（IBM PCのディスクBIOSで使用される）
pertation               DD      0                   ;パーテションを使ってないのでここは必ず0
totalSectorsNum         DD      0x00FE3B1F          ;ユーザ領域(ボリューム)の総セクタ数(違う値でもいける)
FATsSector              DD      0x00000778          ;1つのFATに占有されるセクタ数(わからず、違う値でもいける？)
flagsNum                DW      0x0000              ;
versionNum              DW      0x0000              ;version0.0
directoryStart          DD      2                   ;基本2
infoSector              DW      1                   ;基本1
buckupBootSector        DW      6                   ;基本6

    TIMES   12  DB  0

driveNum                DB      0                   ;IBM PCのディスクBIOSで使われるドライブ番号
reservedByte            DB      0                   ;予約（WindowsNTで使用）
bootSignature           DB      0x29                ;拡張ブートシグネチャ
volumeSerialNum         DD      0xffffffff          ;ボリュームシリアル番号（てきとーでもいける）
discName                DB      "SESAME-OS  "       ;ディスクの名前（11バイト）
formatName              DB      "FAT32   "          ;フォーマットの名前（8バイト）

;
;   プログラム本体
;

;エントリー動作
entry:
    mov     ax, 0               ;レジスタ初期化
    mov     ss, ax
    mov     sp, 0x7c00
    mov     ds, ax

    mov     ax, 0x0820          ;一回これで
    mov     es, ax
;ディスクを読む
readloop:
    mov     si, 0               ;失敗回数を数えるレジスタ
ReadSector:
    mov     ah, 0x02            ;BIOSのリード・セクタ
    mov     al, 0x01            ;一セクタ
    mov     bx, 0x00
    mov     ch, 0x00            ;トラック
    mov     cl, 0x00            ;セクタ
    mov     dh, 0x00            ;ヘッド
    mov     dl, 0x00            ;ドライブ
    int     0x13                ;BIOSのドライブ読み込み機能呼び出し
    JNC     next
    add     si, 1
    cmp     si, 5
    JAE     error
    mov     ah, 0x00
    mov     dl, 0x00
    int     0x13
    jmp     ReadSector
next:
    mov     ax, es
    add     ax, 0x0020
    mov     es, ax
    add     cl, 1
    cmp     cl, BYTE[sectorsPerTrack]
    JBE     readloop
    mov     cl, 1
    add     dh, 1
    cmp     dh, BYTE[sectorsPerHead]
    JB      readloop
    mov     dh, 0
    add     ch, 1
    cmp     ch, CYLS
    JB      readloop

;system実行
    jmp     0xc200

error:
    mov     si, msg
DisplayLoop:
    mov     al, [si]
    add     si, 1
    cmp     al, 0
    je      fin
    mov     ah, 0x0e
    mov     bx, 15
    int     0x10
    jmp     DisplayLoop
fin:
    hlt
    jmp     fin
msg:
    DB      0x0a, 0x0a
    DB      "load error"
    DB      0x0a
    DB      0

	RESB	0x7dfe-($-$$)	; 0x7dfeまでを0x00で埋める命令

	DB		0x55, 0xaa
