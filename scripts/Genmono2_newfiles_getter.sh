## #!/system/bin/sh

# -- パス
SRC="/data/data/jp.lifemaker.Genmono2"
FILE="/storage/emulated/0/AppData/jp.lifemaker.Genmono2/files"
DST="/storage/emulated/0/AppData/jp.lifemaker.Genmono2/_append_data"
LIST="/storage/emulated/0/AppData/jp.lifemaker.Genmono2/_list"
TMP="/storage/emulated/0/AppData/jp.lifemaker.Genmono2/_tmp"

# --  デバッグ用パス
#SRC="./Genmono2"
#DST="./dst"
#FILE="./files"
#LIST="./list"
#TMP="./tmp"

# --  権限付与
chmod 777 -R $SRC

# --  最新データのファイル名を取得
ls "$SRC/files/it1" | awk '{print}' > "$TMP/it1.log"
ls "$SRC/files/it2" | awk '{print}' > "$TMP/it2.log"
ls "$SRC/files/it3" | awk '{print}' > "$TMP/it3.log"
ls "$SRC/files/it4" | awk '{print}' > "$TMP/it4.log"
ls "$SRC/files/mob" | awk '{print}' > "$TMP/mob.log"

# --  前回取得データとの比較
diff "$LIST/it1.log" "$TMP/it1.log" | awk '/^\+/' | sed '/^\+\+\+/d' | sed 's/^\+//' > "$TMP/_it1.log"
diff "$LIST/it2.log" "$TMP/it2.log" | awk '/^\+/' | sed '/^\+\+\+/d' | sed 's/^\+//' > "$TMP/_it2.log"
diff "$LIST/it3.log" "$TMP/it3.log" | awk '/^\+/' | sed '/^\+\+\+/d' | sed 's/^\+//' > "$TMP/_it3.log"
diff "$LIST/it4.log" "$TMP/it4.log" | awk '/^\+/' | sed '/^\+\+\+/d' | sed 's/^\+//' > "$TMP/_it4.log"
diff "$LIST/mob.log" "$TMP/mob.log" | awk '/^\+/' | sed '/^\+\+\+/d' | sed 's/^\+//' > "$TMP/_mob.log"

echo "[*] DIFF DATA"

# --  DSTディレクトリを再作成
rm -rf $DST
mkdir -p $DST

# --  DSTに差分ファイルをコピー
i=0
FILES_ARRAY=("it1" "it2" "it3" "it4" "mob")
APPEND_DATA_FILE=("_it1.log" "_it2.log" "_it3.log" "_it4.log" "_mob.log")
while [ $i -lt 5 ]
do
    while read filename
    do
        cp -r "$SRC/files/${FILES_ARRAY[$i]}/$filename" $DST
    done < "$TMP/${APPEND_DATA_FILE[$i]}"
    i=`expr $i + 1`
done 

# --  DSTにコピーした差分ファイルにpng拡張子を追加
ls $DST | awk '{print}' > "$DST/_tmp.log"
while read filename
do
    mv "$DST/$filename" "$DST/$filename.png"
done < "$DST/_tmp.log"
rm -f "$DST/_tmp.log"
rm -rf "$DST/_tmp.log.png"

echo "[*] COPIED"

# --  ファイルリストの更新
cp -r $TMP/*.* $LIST

# --  FILEディレクトリにバックアップファイルをコピー
cp -r $SRC/files/* $FILE

echo "[*] FINISH!!"