/*
	Created on 2016.8.25
	Author deathponta
	3dsMax内で使用しているアニメーションレイヤ（Bipedレイヤー除く）をリストし、
	そのレイヤーに属するオブジェクトをリストする.ダブルクリックでオブジェクトを選択できる
*/
-- Field Variables
global m_layerNames = #()

-- シーン内のレイヤーネームをリスト
fn UpdateAnimLayerInScene _ddl=(
	global m_layerNames = #()
	alm = AnimLayerManager
	layerNum = alm.getlayerCount() /*シーン内のレイヤー数取得*/

	for i=1 to layerNum do(
		append m_layerNames (alm.getLayerName i)
	)

	-- ドロップダウンリストにシーン内のアニメーションレイヤー配列を代入
	_ddl.items = m_layerNames
)

fn UpdateListBox _lb _ddl=(
	alm = AnimLayerManager
	-- そのアニメーションレイヤーに属しているオブジェクトを格納する配列
	objNamesInLayer = #()

	-- シーン内の全オブジェクトをリストして、アニメーションレイヤーに属しているかをidxで確認
	for obj in objects do(
		layerIdxs = (alm.getNodesLayers obj)

		for layerIdx in layerIdxs do(
			if layerIdx == _ddl.selection do(
				append objNamesInLayer obj.name
			)
		)
	)

	_lb.items = objNamesInLayer
)

fn SelectObject _lb=(
	select (execute ("$'" + _lb.selected + "'"))
)

fn SelectAll _lb=(
	clearSelection()
	for item in _lb.items do(
		selectmore (execute ("$'" + item + "'"))
	)
)

----------------------------------------
-- UI

try(destroyDialog rol_aspectSwitch ) catch()

rollout rol_aspectSwitch "ShowAnimLayer" width:200 height:264
(
	button btn_update "更新" pos:[8,8] width:184 height:24
	button btn_selectAll "全選択" pos:[120,40] width:72 height:16
	dropdownList ddl_animLayers "アニメーションレイヤー" pos:[8,40] width:184 height:41
	listbox lb_objects "属するオブジェクト" pos:[8,88] width:184 height:11


	on btn_update pressed do(
		UpdateAnimLayerInScene ddl_animLayers
	)

	on btn_selectAll pressed do(
		SelectAll lb_objects
	)

	-- ドロップダウンが選択されている時
	on ddl_animLayers selected sel do(
		UpdateListBox lb_objects ddl_animLayers
	)

	-- リストボックスに表示されているオブエクトをダブルクリックで選択する
	on lb_objects doubleClicked sel do(
		SelectObject lb_objects
	)

)

createDialog rol_aspectSwitch /*style:#(#style_toolwindow, #style_sysmenu)*/
-- UI end
----------------------------------------
