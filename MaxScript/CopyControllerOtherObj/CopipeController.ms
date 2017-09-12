/*

1) 選択したオブジェクトのキーをコピー
2) 選択したオブジェクトに最後にコピーしたキーをペースト

・ペースト時は複数選択に対応する

▼ 追加予定
・クローンペースト機能
　→　controller = controller でいける
・クローンペーストしたものをオリジナルにする機能
　→　controller = prs() でいける
*/

global m_srcTransCtrl = undefined

fn CopyCtrl=(
	global m_srcTransCtrl

	s = selection[1]

	m_srcTransCtrl = copy s.transform.controller
)

fn PasteCtrl=(
	global m_srcTransCtrl

	for s in selection do(
		-- 選択オブジェクトからキーを削除
		DeleteKeys s.controller #allKeys

		s.transform.controller = m_srcTransCtrl
	)
)

--------------------------------------------------
-- UI
try(destroyDialog rol_copipeKey ) catch()

rollout rol_copipeKey "CopipeController" width:120 height:68
(

	button btn_copy "コピー" pos:[8,8] width:104 height:24
	button btn_paste "ペースト（複数可）" pos:[8,36] width:104 height:24


	on btn_copy pressed do(
		CopyCtrl()
	)


	on btn_paste pressed do(
		PasteCtrl()
	)
)

createDialog rol_copipeKey
--------------------------------------------------
