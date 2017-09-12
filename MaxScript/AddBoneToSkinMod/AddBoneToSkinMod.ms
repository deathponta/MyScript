/*
Created on 2017.9.11

�� �@�\
[x]���ݑI�����Ă���{�[�����A�Ō�ɑI�������X�L�����f�B�t�@�C���ɒǉ�����B
[x]�I�������{�[�������łɑ��݂���ꍇ�͒ǉ����Ȃ��B
[x]�X�L�����f�B�t�@�C�������݂��Ȃ��ꍇ�͒ǉ�����
[x]�X�L���ɒǉ�����Ă���{�[����S�đI���{�^��

�� ���̃c�[���̃����b�g
Skin���f�B�t�@�C������́A�{�[���ǉ��̖ʓ|���������y�����܂��B
���������A�{�[����I���E�B���h�E�Œǉ�����̂߂�ǂ������Ȃ��ł����H
�܂��A���łɃX�L���ɒǉ�����Ă���{�[����S�I���ł���̂ŁA�E�F�C�g�̕t��������ƂȂǂ̍ۂɊy�ł��B


*/

-- �{�[���m�[�h��Ԃ�
-- 2012��Max�ł́A GetBoneName �Ń{�[���̕����񂵂��Ԃ��Ȃ��o�O�����邽�߂ɗp�ӂ����֐�
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

-- �w�肵���X�L���ɒǉ�����Ă���{�[���z���Ԃ�
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
	-- �C���p�l���֐؂�ւ�
	setCommandPanelTaskMode #modify
	
	
	----------------------------------------
	-- ���^�[������
	sc = selection.count
	if sc == 0 do(
		MessageBox "Skin�m�[�h��I�����ĉ�����        " title:"�I���G���`"
		return false
	)
	
	if sc > 1 do(
		MessageBox "�I������������        " title:"�I���G���`"
		return false
	)
	
	
	
	if $.modifiers[#Skin] == undefined do(
		MessageBox "Skin���f�B�t�@�C����������܂���B        " title:"�I���G���`"
		return false
	)
	----------------------------------------
	
	Select (GetBonesFromSkin $.modifiers[#Skin])
	
	print "�X�L���ɒǉ�����Ă���{�[����S�đI�����܂����B"
)

fn Exec=(
	skinObj = undefined
	selBones = #()
	for i=1 to selection.count do(
		
		-- �Ō�ɑI�����������X�L�����f���Ƃ��Ċi�[
		if i == selection.count do(
			skinObj = selection[i]
			exit()
		)
		
		-- �Ō�ȊO�̃I�u�W�F�N�g�͍��Ƃ��Ċi�[
		Append selBones selection[i]
	)
	
	
	----------------------------------------
	-- ���^�[������
	
	-- �����I������Ă��Ȃ�
	if selection.count < 2 do(
		MessageBox "2�ȏ�̑I�����K�v�ł�        " title:"�I���G���`"
		return false
	)
	
	-- �ŏI�I���m�[�h�Ɂu�X�L���v���f�B�t�@�C�������݂��Ȃ��ꍇ�́A�ǉ��_�C�A���O��\��
	if skinObj.modifiers[#Skin] == undefined do(
		msg = "�ŏI�I����Skin���f�B�t�@�C���Ȃ��B\n�ǉ����܂����H"
		if QueryBox msg title:"���f�B�t�@�C���ǉ�" then(
			AddModifier skinObj (Skin())
		)else(
			MessageBox "�����𒆒f���܂��B" title:"���f"
			return false
		)
	)
	
	----------------------------------------
	
	
	
	
	-- �X�L���I�u�W�F�N�g�݂̂�I��
	select skinObj
	s = skinObj.modifiers[#Skin]
	
	-- �C���p�l���֐؂�ւ�
	setCommandPanelTaskMode #modify
	
	-- �X�L�����f�B�t�@�C���������A�N�e�B�u
	modPanel.setCurrentObject s
	
	
	-- ���łɃX�L���ɒǉ�����Ă���{�[���Y
	exeistBones = GetBonesFromSkin s
	
	-- �X�L���Ƀ{�[���ǉ�
	for selBone in selBones do(
		
		-- �I�������{�[�������łɒǉ�����Ă����� continue
		if FindItem exeistBones selBone > 0 do(
			print ( format "% �͂��łɑ��݂���" selBone.name )
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
	label lb1 "�P�D�{�[����I������B\n�Q�D�Ō��Skin���b�V����I������B\n�R�D���s�����Skin�Ƀ{�[�����ǉ������B" pos:[8,8] width:208 height:40
	button btn1 "�{�[�����X�L���ɒǉ�" pos:[8,56] width:208 height:24 tooltip:"�u�ǉ��v�ł��B�u�������ł͂���܂���B\n�����{�[�����ǉ�����܂��B"
	groupBox grp1 "���̑��c�[��" pos:[8,88] width:208 height:48
	button btn2 "�X�L����ި̧�Ԓ��̃{�[����S�I��" pos:[16,104] width:192 height:24 tooltip:"Skin���b�V����I�����Ď��s����ƁA�ǉ�����Ă��鍜��S�đI�����܂��B"
 
 
	on btn1 pressed do
		( Exec() )
	on btn2 pressed do
		( SelectBoneFromSkin() )
)

createDialog rol_addBoneToSkinMod
