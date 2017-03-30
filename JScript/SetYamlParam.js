/*
パラメータ一括変更シート

使用例 こんな感じで書き換えます
  m_hp: 25
  ↓
  m_hp: 1000
*/

// 下の値を書き換えます
var SERCH_WORD = "m_hp";
var SET_WORD = "100";


var args = WScript.Arguments;

//-----------------------------------------------------
//  オープンモード
var FORREADING      = 1;    // 読み取り専用
var FORWRITING      = 2;    // 書き込み専用
var FORAPPENDING    = 8;    // 追加書き込み

//  開くファイルの形式
var TRISTATE_TRUE       = -1;   // Unicode
var TRISTATE_FALSE      =  0;   // ASCII
var TRISTATE_USEDEFAULT = -2;   // システムデフォルト
//-----------------------------------------------------


function ReplaceParam( _idx ){

	//  ファイル関連の操作を提供するオブジェクトを取得
	var fs = new ActiveXObject( "Scripting.FileSystemObject" );

	//  ファイルを読み取り専用で開き中の文字列のみを取得
	var readFile = fs.OpenTextFile( args(_idx), FORREADING, true , TRISTATE_USEDEFAULT );
	var baseStr = readFile.ReadAll();


	// 今度は書き込み専用で開きいじくる
	var writeFile = fs.OpenTextFile( args(_idx), FORWRITING, true , TRISTATE_USEDEFAULT );


	// 文字列操作
	// 一行ずつ処理したいときは、ReadAllで最初に全部読み込んでから、改行文字でsplitして配列にして、それを処理する
	var lines = baseStr.split(/\r\n/);
	
	for( var i = 0; i < lines.length; i++ ){
		var line = lines[i]; // 一度代入しないと戻す際に改行が増える

		// 検索文字列が見つかった場合に処理
	    if( line.indexOf( SERCH_WORD ) > 0 ){
	    	// 正規表現で置き換え. スペースの間に整数が1桁以上ありかつ末尾のものを置き換え対処
	    	lines[i] = line.replace( /\s\d{1,}$/, " " + SET_WORD );
	    	
	    	//WScript.Echo(lines[i]);
	    }
	}

	// 書き込み(1行ずつちゃんと書き込む \n でやると改行がおかしくなる)
	for( var j=0; j<lines.length;j++ ){
		writeFile.WriteLine( lines[j] );
	}

	//  ファイルを閉じる
	writeFile.Close();

	//  オブジェクトを解放
	fs = null;
}



//------------------------------------------------------------
// メイン処理

// D&Dしたファイル数分処理
for( var i=0; i<args.length; i++ ){
	ReplaceParam(i);
}

