/*
D&Dしたファイル内の特定の文字列を、指定した文字列に置き換える
*/
var args = WScript.Arguments;

var SERCH_WORD = "m_hp";
var SET_WORD = "1000";

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

// ファイル数分処理
for( var i=0; i<args.length; i++ ){
	

	//  ファイル関連の操作を提供するオブジェクトを取得
	var fs = new ActiveXObject( "Scripting.FileSystemObject" );

	//  ファイルを読み取り専用で開き中の文字列のみを取得
	var readFile = fs.OpenTextFile( args(i), FORREADING, true , TRISTATE_USEDEFAULT );
	var baseStr = readFile.ReadAll();


	// 今度は書き込み専用で開きいじくる
	var writeFile = fs.OpenTextFile( args(i), FORWRITING, true , TRISTATE_USEDEFAULT );


	// 文字列操作
	// 一行ずつ処理したいときは、ReadAllで最初に全部読み込んでから、改行文字でsplitして配列にして、それを処理する
	var lines = baseStr.split(/\r\n/);
	
	for( var i = 0; i < lines.length; i++ ){
		var line = lines[i]; // 一度代入しないと戻す際に改行が増える

		// 検索文字列が見つかった場合に処理
	    if( line.indexOf( SERCH_WORD ) > 0 ){
	    	/*
	    	// けつから半角スペースがある箇所まで
	    	start = line.lastIndexOf( /\s/ );
	    	end = line.length;
	    	WScript.Echo( "HP : " + lines[i].substr( start , end ) );
	    	*/
	    	
	    	// 正規表現で置き換え
	    	lines[i] = line.replace( /\s*$/, SET_WORD );
	    	
	    	WScript.Echo(lines[i]);
	    }
	}

	baseStr = lines.join('\n');

	writeFile.WriteLine( baseStr );

	//  ファイルを閉じる
	writeFile.Close();

	//  オブジェクトを解放
	fs = null;
}

