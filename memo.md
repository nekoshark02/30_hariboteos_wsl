# nasm
* DB(data byte)：ファイルの内容を1バイトだけ直接書く
* RESB(reserve byte)：指定バイト開ける（0x00で埋める）
* DW(data word)：DBの2byte版
* DD(data dowble-word)：DBの4byte版
* ORG(origin)： 実行時にPCのメモリのどこに読み込まれるか教える
* CMP(compere)-JE(jump if equal)：比較、JEは条件ジャンプ命令
* INT(interrupt)：ソフトウェア割り込み命令
* JC(jump if carry)
# レジスタ
### 16bit resister
* AX：アキュムレータ
* CX：カウンタ
* DX：データ
* BX：ベース
* SP：スタックポインタ
* BP：ベースポインタ
* SI：ソースインデックス
* DI：ディスティネーションインデックス

### 8bit resister
* AL：アキュムレータロウ
* CL：カウンタロウ
* DL：データロウ
* BL：ベースロウ
* AH：アキュムレータハイ
* CH：カウンタハイ
* DH：データハイ
* BH：ベースハイ

##### 参考資料
http://elm-chan.org/docs/fat.html

https://qiita.com/Wanwannodao/items/19830459606eedc46812

http://oswiki.osask.jp/?(AT)BIOS