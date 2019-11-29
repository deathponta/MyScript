# -*- coding: utf-8 -*-
import maya.cmds as mc
import os

"""
スキニングされたメッシュを分離するスクリプト

■　処理の流れ
１．スキンドメッシュAを複製

２．選択フェース（頂点）をバインドしているジョイントを取得

３．２のジョイントと１で複製したメッシュを選択してスキニング。スキンドメッシュBと呼びます。

．スキンドメッシュA　と　スキンドメッシュB　を選択して、
スキン＞スキンウェイトのコピー　オプションを開き下記の設定をしてウェイトをコピーします


"""

def get_skinkCluster( _transform ):
	shape = mc.listRelatives( _transform , s=True )
	skinC = mc.listConnections( shape , type='skinCluster' )
	return skinC

def get_bind_joints( _transform ):
	jnts = mc.listConnections( get_skinkCluster( _transform ) , type='joint' )
	return jnts,


# フェースのオブジェクト名取得（複数オブジェクトは不可）
def get_obj_from_face( _faces ):
	objName = _faces[0].split('.')[0]
	return objName


def cleanup_mesh( _transform ):
	mc.makeIdentity( _transform , apply=True, t=1, r=1, s=1, n=2 )

# 選択したフェースを渡すとそのフェース単体のオブジェクトを作成（複製）する
def duplicate_face( _faces ):
	# meshを複製
	objName = get_obj_from_face(_faces)
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

	# トランスフォームのフリーズ
	cleanup_mesh( newObj )

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
	# バインドに使うジョイントを保持
	baseObj = get_obj_from_face(selFaces)
	bindJoints = get_bind_joints( baseObj )


	#---------------------------------
	# 新しいメッシュにスキニング～
	mc.select( cl=True )
	for j in bindJoints:
		mc.select( j , add=True )
	mc.select( newObj , add=True )
	mc.skinCluster( dr=4.5) # ここの設定箇所ちゃんとしてないかも！ 191129

	#---------------------------------
	# ウェイトをコピ～（スキンクラスター同士を選択して実行）
	baseSkinC = get_skinkCluster(baseObj)[0].encode()
	tgtSkinC = get_skinkCluster(newObj)[0].encode()
	print tgtSkinC,
	mc.copySkinWeights( ss=baseSkinC , ds=tgtSkinC , noMirror=True , surfaceAssociation='closestPoint' , influenceAssociation='oneToOne' , normalize=True )






main()