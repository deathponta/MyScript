/*
Created on 2017.9.11

■ 機能
[x]現在選択しているボーンを、最後に選択したスキンモディファイヤに追加する。
[x]選択したボーンがすでに存在する場合は追加しない。
[x]スキンモディファイヤが存在しない場合は追加する
[x]スキンに追加されているボーンを全て選択ボタン

■ このツールのメリット
Skinモディファイヤからの、ボーン追加の面倒くささを軽減します。
いちいち、ボーンを選択ウィンドウで追加するのめんどくさくないですか？
また、すでにスキンに追加されているボーンを全選択できるので、ウェイトの付け直し作業などの際に楽です。


*/

-- ボーンノードを返す
-- 2012のMaxでは、 GetBoneName でボーンの文字列しか返さないバグがあるために用意した関数
fn GetBoneFromSkin _skinMod _boneIdx=(
	local boneArray=for o in objects where (refs.dependencyLoopTest _skinMod o) collect o
	local boneName=(skinOps.GetBoneName _skinMod _boneIdx 1)
	local notFound=true
	local i=0
	while notFound and i<boneArray.count do(
		i+=1
		if boneArray[i].name==boneName then notFound=false
	)
	if notFound then undefined else boneArray[i]
)

-- 指定したスキンに追加されているボーン配列を返す
fn GetBonesFromSkin _skinMod=(
	
	skinBones = #()
	
	boneNum = skinOps.GetNumberBones _skinMod
	
	for i=1 to boneNum do(
		
		b = GetBoneFromSkin _skinMod i
		
		Append skinBones b
	)
	
	return skinBones
)

fn SelectBoneFromSkin=(
	-- 修正パネルへ切り替え
	setCommandPanelTaskMode #modify
	
	
	----------------------------------------
	-- リターン処理
	sc = selection.count
	if sc == 0 do(
		MessageBox "Skinノードを選択して下さい        " title:"選択エラ～"
		return false
	)
	
	if sc > 1 do(
		MessageBox "選択が多すぎる        " title:"選択エラ～"
		return false
	)
	
	
	
	if $.modifiers[#Skin] == undefined do(
		MessageBox "Skinモディファイヤが見つかりません。        " title:"選択エラ～"
		return false
	)
	----------------------------------------
	
	Select (GetBonesFromSkin $.modifiers[#Skin])
	
	print "スキンに追加されているボーンを全て選択しました。"
)

fn Exec=(
	skinObj = undefined
	selBones = #()
	for i=1 to selection.count do(
		
		-- 最後に選択した物をスキンモデルとして格納
		if i == selection.count do(
			skinObj = selection[i]
			exit()
		)
		
		-- 最後以外のオブジェクトは骨として格納
		Append selBones selection[i]
	)
	
	
	----------------------------------------
	-- リターン処理
	
	-- 何も選択されていない
	if selection.count < 2 do(
		MessageBox "2つ以上の選択が必要です        " title:"選択エラ～"
		return false
	)
	
	-- 最終選択ノードに「スキン」モディファイヤが存在しない場合は、追加ダイアログを表示
	if skinObj.modifiers[#Skin] == undefined do(
		msg = "最終選択にSkinモディファイヤなし。\n追加しますか？"
		if QueryBox msg title:"モディファイヤ追加" then(
			AddModifier skinObj (Skin())
		)else(
			MessageBox "処理を中断します。" title:"中断"
			return false
		)
	)
	
	----------------------------------------
	
	
	
	
	-- スキンオブジェクトのみを選択
	select skinObj
	s = skinObj.modifiers[#Skin]
	
	-- 修正パネルへ切り替え
	setCommandPanelTaskMode #modify
	
	-- スキンモディファイヤを強制アクティブ
	modPanel.setCurrentObject s
	
	
	-- すでにスキンに追加されているボーンズ
	exeistBones = GetBonesFromSkin s
	
	-- スキンにボーン追加
	for selBone in selBones do(
		
		-- 選択したボーンがすでに追加されていたら continue
		if FindItem exeistBones selBone > 0 do(
			print ( format "% はすでに存在する" selBone.name )
			continue
		)
		
		
		skinOps.Addbone s selBone 1
	)
	
	
	
)



----------------------------------------
-- GUI
try(destroyDialog rol_addBoneToSkinMod ) catch()

rollout rol_addBoneToSkinMod "AddBoneToSkinMod" width:224 height:150
(
	label lb1 "１．ボーンを選択する。\n２．最後にSkinメッシュを選択する。\n３．実行するとSkinにボーンが追加される。" pos:[8,8] width:208 height:40
	button btn1 "ボーンをスキンに追加" pos:[8,56] width:208 height:24 tooltip:"「追加」です。置き換えではありません。\n同じボーンも追加されます。"
	groupBox grp1 "その他ツール" pos:[8,88] width:208 height:48
	button btn2 "スキンﾓﾃﾞｨﾌｧｲﾔ中のボーンを全選択" pos:[16,104] width:192 height:24 tooltip:"Skinメッシュを選択して実行すると、追加されている骨を全て選択します。"
 
 
	on btn1 pressed do
		( Exec() )
	on btn2 pressed do
		( SelectBoneFromSkin() )
)

createDialog rol_addBoneToSkinMod

