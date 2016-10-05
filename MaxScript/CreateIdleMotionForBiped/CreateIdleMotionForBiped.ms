/*
	Created on 2016.10.3
	Author deathponta
	シーン内のBipedにポーズを付けて実行すると0-30F の待機モーションになります
	いまのところは、シーン内にBipedが1体だけ存在する場合にしか使えないです
	■ 既知のバグ
	・アニメーションレイヤーのある状態で実行するとエラー
	・オートキーをオンにしている状態でポーズを編集しなければ反映されません。
*/

global g_nowIdleType = ""
global g_idleType = #("息荒め[0-30]"/*,"落ち着き[0-60](未実装)"*/)
global g_isIK = true
global g_version = "(v.1.0.0)"

-- タイムスライダーの設定
fn SetAnimRange _s _e=(
	animationRange = interval _s _e
)

-- 作成したコレクションを後片付け(第二引数は削除したいコレクションの名前文字列)
fn ClearCollection _bip _name=(
	colNum = biped.numCopyCollections _bip
	for i=1 to colNum do(
		if (biped.getCopyCollection _bip i).name == _name do(
			biped.deleteCopyCollection _bip i
			exit
		)
	)
)

-- 現在のフレームのポーズをコピーし、第二引数で指定したフレームに貼り付ける
fn GetAndSetNowFramePose _bip _pasteF/*int*/=(
	-- 途中でフレームは動かすが、最終的に戻す
	beforeTime = currentTime as integer
	col = biped.createCopyCollection _bip "tempCol"
	
	
	poseName = biped.copyBipPose _bip col #snapNone
	
	sliderTime = _pasteF
	
	ICP_MXBipedCopy = getCopy col #pose 0
	-- 一回貼り付けただけだと、足の位置ズレが発生するので2回連続ペースト
	biped.pasteBipPose _bip ICP_MXBipedCopy false #pstdefault true true true false
	biped.pasteBipPose _bip ICP_MXBipedCopy false #pstdefault true true true false
	
	ClearCollection _bip col.name
	sliderTime = beforeTime
)

-- Bipedのすべてのキーをクリア。ただし０Fは除く
fn ClearKey _bip=(
	-- 0Fのポーズをコピー　→　全キーをクリア　→　削除
	sliderTime = 0
	-- コピーコレクションが無いとエラーを吐くので作成
	col = biped.createCopyCollection _bip "tempCol"
	poseName = biped.copyPosture _bip #pose true true true

	biped.clearAllAnimation _bip

	--biped.pastePosture bip #pose false poseName
	ICP_MXBipedCopy = getCopy col #pose 0
	--biped.pasteBipPosture $.controller ICP_MXBipedCopy true #pstdefault false false false false
	-- 最後の引数を true にすると貼り付け時に、COMのトランスフォームを維持せぬ
	biped.pasteBipPose _bip ICP_MXBipedCopy false #pstdefault true true true false

	ClearCollection _bip col.name
)

-- スライドキー（IK）の設定
fn SetIK _bip _f=(
	sliderTime = _f as integer
	footL = biped.getNode _bip #lLeg link:3
	footR = biped.getNode _bip #rLeg link:3

	biped.setSlidingKey footL
	biped.setSlidingKey footR
)

fn DoNotExistBipedError=(
	messageBox "シーン内にBipedがありません" title:"エラー" beep:true
)

fn Main=(
	----------------------------------------
	-- ノードを取得　Bipedが無かったら処理しない
	bips = $Bip*
	if bips.count == 0 do(
		DoNotExistBipedError()
		return false
	)
	
	bip = $Bip*[1].controller.rootnode.controller
	
	head = biped.getNode bip #head link:1

	spine = biped.getNode bip #spine link:1
	spine1 = biped.getNode bip #spine link:2
	spine2 = biped.getNode bip #spine link:3
	spine3 = biped.getNode bip #spine link:4
	spine4 = biped.getNode bip #spine link:5

	clavicleL = biped.getNode bip #rArm link:1
	clavicleR = biped.getNode bip #lArm link:1
	-- COM は取得が特殊なのでここでは取得しない
	----------------------------------------
	
	----------------------------------------
	-- 現在のフレームのポーズをコピーし、0フレーム目に貼り付ける
	GetAndSetNowFramePose bip 0
	----------------------------------------

	----------------------------------------
	-- 0F以外のキーをクリアする。内部的にはコレクションにキーを一時的に逃がす
	ClearKey bip
	----------------------------------------


	----------------------------------------
	-- アニメート
	if animButtonState == false do animButtonState = true

	-- キーセットフレーム配列
	F = #(0,7,15,23,30)
	
	-- タイムスライダー設定
	SetAnimRange F[1] F[5]
	
	-- ベクトル
	dx = [1,0,0]
	dy = [0,1,0]
	dz = [0,0,1]

	-- 0フレームにキー
	sliderTime = F[1]
	biped.addNewKey head.controller F[1]
	biped.addNewKey spine.controller F[1]
	biped.addNewKey spine1.controller F[1]
	if spine2 != undefined do biped.addNewKey spine2.controller F[1]
	if spine3 != undefined do biped.addNewKey spine3.controller F[1]
	if spine4 != undefined do biped.addNewKey spine4.controller F[1]
	biped.addNewKey clavicleL.controller F[1]
	biped.addNewKey clavicleR.controller F[1]
	biped.setkey bip.rootNode true true true
	----------
	
	----------
	-- 頭
	sliderTime = F[3]
	rotate head (angleaxis 5 dx)
	sliderTime = F[5]
	rotate head (angleaxis -5 dx)
	----------
	
	----------
	-- 胴
	sliderTime = F[5]
	rotate spine (angleaxis 0 dx)
	rotate spine1 (angleaxis 0 dx)
	sliderTime = F[2]
	rotate spine (angleaxis 4 dx)
	rotate spine1 (angleaxis -4 dx)
	sliderTime = F[4]
	rotate spine (angleaxis -2 dx)
	rotate spine1 (angleaxis -4 dx)
	----------
	
	----------
	-- 肩

	sliderTime = F[3]
	rotate clavicleL (angleaxis 8 dy)
	rotate clavicleR (angleaxis -8 dy)

	sliderTime = F[5]
	rotate clavicleL (angleaxis -8 dy)
	rotate clavicleR (angleaxis 8 dy)
	----------
	
	----------
	-- COM
	sliderTime = F[1]
	bipO = bip.rootNode
	
	-- 初期Fコピー(動かしている間に自動保管されて値が変わるため)
	zeroKey = biped.getTransform bipO #pos
	-- biped.setKey <biped_node> copyHor:<bool_setHoriz> copyVer:<bool> copyTrn:<bool> 
	
	sliderTime = F[2]
	move bipO [-0.5,-0.5,1.5]
	biped.setkey bipO true true false
	
	sliderTime = F[3]
	move bipO [0.5,0.5,1.5]
	biped.setkey bipO true true false
	
	sliderTime = F[4]
	move bipO [0.5,0.5,-1.5]
	biped.setkey bipO true true false
	
	sliderTime = F[5]
	biped.setTransform bipO #pos zeroKey true
	----------
	
	----------
	-- ■ ループを滑らかにする
	-- ループの真ん中のポーズを、ループ外前後にコピーする
	overStartF = (F[5]/-2) as integer
	overEndF = F[5]+((F[5]/2) as integer)
	SetAnimRange overStartF overEndF
	sliderTime = F[3]
	GetAndSetNowFramePose bip overStartF
	GetAndSetNowFramePose bip overEndF
	----------
	
	-- IK をセットするか
	if g_isIK do( 
		SetIK bip F[1]
		SetIK bip F[5]
	)
	
	-- タイムスライダー設定を戻す
	SetAnimRange F[1] F[5]
	----------
	
	----------------------------------------
)

----------
-- UI
try( DestroyDialog rol_breathBiped )catch()
rollout rol_breathBiped ("Bipedを呼吸させるのです"+ g_version) width:220 height:88(
	button btn_exec "実行" pos:[8,56] width:202 height:24
	dropdownList ddl_idleType "尺選択" items:g_idleType pos:[8,8] width:202 height:41
	checkbox chk_isIK "設置キー" pos:[150,8] width:80 height:16 checked:true
	
	on btn_exec pressed do( Main() )
	
	on chk_isIK changed state do( g_isIK = state )
)
CreateDialog rol_breathBiped
----------