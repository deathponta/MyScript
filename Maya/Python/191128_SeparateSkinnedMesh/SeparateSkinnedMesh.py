# -*- coding: utf-8 -*-
import maya.cmds as mc
import os

"""
スキニングされたメッシュを分離するスクリプト

■　処理の流れ
１．スキンドメッシュAを複製

２．ジョイントと１で複製したメッシュを選択してスキニング。
スキンドメッシュBと呼びます。

３．スキンドメッシュA　と　スキンドメッシュB　を選択して、
スキン＞スキンウェイトのコピー　オプションを開き下記の設定をしてウェイトをコピーします


"""

# 選択したフェースを渡すとそのフェース単体のオブジェクトを作成（複製）する
def duplicate_face( _faces ):
	# meshを複製
	objName = _faces[0].split('.')[0] # フェースのオブジェクト名取得
	newObjName = mc.duplicate( objName )[0]
	
	
	# 選択メッシュ以外を削除
	selFaces2 = []
	for sf in _faces:
		temp = sf.replace( objName, newObjName)
		selFaces2.append( temp )

	
	mc.select(cl=True)
	mc.select ( selFaces2 )
	mc.InvertSelection()
	mc.delete()

	# ロック解除
	mc.setAttr( '%s.tx'%newObjName , lock=False )
	mc.setAttr( '%s.ty'%newObjName , lock=False )
	mc.setAttr( '%s.tz'%newObjName , lock=False )
	mc.setAttr( '%s.rx'%newObjName , lock=False )
	mc.setAttr( '%s.ry'%newObjName , lock=False )
	mc.setAttr( '%s.rz'%newObjName , lock=False )
	mc.setAttr( '%s.sx'%newObjName , lock=False )
	mc.setAttr( '%s.sy'%newObjName , lock=False )
	mc.setAttr( '%s.sz'%newObjName , lock=False )

	return newObjName


def main():
	#---------------------------------
	# フェース以外だったらリターン
	selFaces = mc.ls(sl=True)
	if not selFaces:
		print( u'フェースを選択してください！'),
		return

	for selFace in selFaces:
		if mc.nodeType( selFace ) != 'mesh':
			print( u'フェースを選択してください！'),
			return
	

	#---------------------------------
	# 選択したフェースの複製
	newObj = duplicate_face( selFaces )


	#---------------------------------
	# 選択したフェースの複製


	
	







main()