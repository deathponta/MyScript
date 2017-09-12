/*
    Created on 2017.4.5
    現在のアクティブレイヤーの下のレイヤーをオン・オフ
    不透明度は50%にする
    ■ 用途
    アニメーション作業をする時に、下のレイヤーをオン・オフしながらやることが多いので
*/
l = activeDocument.layers;
al = activeDocument.activeLayer;

for( i=0;i<l.length;i++ ){
    
    // 最終レイヤーでアレば処理しない
    if( (l[i] == al) && (i != l.length-1) ){
        ul = l[i+1]; // under layer 下のレイヤー
        
        // 見えている時は不透明度50..visibleの順番が大事です。
        if( ul.visible ){
            ul.opacity = 100;
            ul.visible = false;
        }else{
            ul.visible = true;
            ul.opacity = 50;
        }

    }// end if
    
}// end for