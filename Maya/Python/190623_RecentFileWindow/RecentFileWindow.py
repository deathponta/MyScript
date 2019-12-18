# -*- coding: utf-8 -*-
"""
・最近使ったファイルをウィンドウ内にボタンとして表示します。

[x]フォルダボタンを押下するとエクスプローラーでファイルの格納フォルダが開く
[x]ファイルを開く際に確認ダイアログを表示する


"""
from functools import partial
import maya.cmds as cmds
import datetime
import os
import subprocess
import maya.mel as mel

class RecentFileWindow(object):
    w = None
    scroll = None
    cl = None
    intRFN = None
    title = 'RecentFileWindow' # dock title

    def __init__(self):
        self.createWindow()

    def createWindow(self):
        if(cmds.window('crfWindow', ex=True)):
            cmds.deleteUI('crfWindow')

        if(cmds.dockControl( self.title , ex=True)):
            cmds.deleteUI( self.title )

        self.w = cmds.window('crfWindow', tlb=True)

        self.scroll = cmds.scrollLayout(vst=16 , p=self.w , cr=True )

        self.gui()

        cmds.scriptJob(e=('SceneOpened', 'RecentFileWindow.gui()'), p=self.w)
        cmds.dockControl( self.title , a='left', con=self.w, aa=['all'])

    def gui(self):
        if(not self.cl is None):
            if(cmds.columnLayout(self.cl, ex=True)):
                cmds.deleteUI(self.cl)
        self.cl = cmds.columnLayout('crfLayout', adj=True, p=self.scroll)
        list = cmds.optionVar(q='RecentFilesList')
        
        # mayaの新規起動の場合はlistがint0になる
        if list==0 :
            print u'最近開いたファイルが存在しません',
            return
        
        list.reverse()
        for f in list:
			dirname = os.path.dirname(f)
			filename = os.path.basename(f)

			cmds.rowLayout( nc=2 , adj=1 )

			cmds.button(l=filename,c=partial(self.customOpenFile, f) , ann=dirname )
			cmds.button( l=u'ﾌｫﾙﾀﾞ', c=partial(self.openExplorer , f) , ann=u'親フォルダをエクスプローラーで開く' , bgc=[0.9,0.9,0])

			cmds.setParent( '..' )


    def customOpenFile(self, path, v):
		# ダイアログ：No なら処理しない
		result = cmds.confirmDialog( t=u'確認', m=u'開きますか？', button=[u'Yes',u'No'], defaultButton=u'Yes', cancelButton=u'No', dismissString=u'No' )
		if not result == 'Yes':
			return

		cmds.file(path ,f=True, iv=True,o=True)
		
		# プロジェクト設定
		parent_dir = os.path.basename(os.path.dirname(path))
		if parent_dir == "scenes":
			project_dir = os.path.dirname(os.path.dirname(path))
			mel.eval('setProject "' + project_dir + '";')
			print u'プロジェクトをセットしました！ --> %s\n'%project_dir,
			msg = u'プロジェクトをセットしました！\n%s\n'%project_dir
			cmds.inViewMessage( amg=msg, pos='botCenter', fade=True , fst=5000 )
		else:
			cmds.inViewMessage( amg=u'プロジェクトフォルダが親フォルダに見つかりません！', pos='botCenter', fade=True , fst=5000 )



    # ファイルのディレクトリを開く
    def openExplorer(self,filePath,v):
        # \ -> \\ に変換(エスケープシーケンスとして反応しないように)
        newPath = '\\'.join(filePath.split('/'))
        # ファイルのあるフォルダを開いて、ファイルを選択状態にする
        subprocess.Popen( 'explorer /select , "%s"'%( newPath ) )


# 開発中用　インポートして使用した場合は下記は実行されない
if __name__ == '__main__' :
    RecentFileWindow = RecentFileWindow()