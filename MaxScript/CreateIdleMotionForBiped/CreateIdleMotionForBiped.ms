/*
	Created on 2016.10.3
	Author deathponta
	�V�[������Biped�Ƀ|�[�Y��t���Ď��s�����0-30F �̑ҋ@���[�V�����ɂȂ�܂�
	���܂̂Ƃ���́A�V�[������Biped��1�̂������݂���ꍇ�ɂ����g���Ȃ��ł�
	�� ���m�̃o�O
	�E�A�j���[�V�������C���[�̂����ԂŎ��s����ƃG���[
	�E�I�[�g�L�[���I���ɂ��Ă����ԂŃ|�[�Y��ҏW���Ȃ���Δ��f����܂���B
*/

global g_nowIdleType = ""
global g_idleType = #("���r��[0-30]"/*,"��������[0-60](������)"*/)
global g_isIK = true
global g_version = "(v.1.0.0)"

-- �^�C���X���C�_�[�̐ݒ�
fn SetAnimRange _s _e=(
	animationRange = interval _s _e
)

-- �쐬�����R���N�V��������Еt��(�������͍폜�������R���N�V�����̖��O������)
fn ClearCollection _bip _name=(
	colNum = biped.numCopyCollections _bip
	for i=1 to colNum do(
		if (biped.getCopyCollection _bip i).name == _name do(
			biped.deleteCopyCollection _bip i
			exit
		)
	)
)

-- ���݂̃t���[���̃|�[�Y���R�s�[���A�������Ŏw�肵���t���[���ɓ\��t����
fn GetAndSetNowFramePose _bip _pasteF/*int*/=(
	-- �r���Ńt���[���͓��������A�ŏI�I�ɖ߂�
	beforeTime = currentTime as integer
	col = biped.createCopyCollection _bip "tempCol"
	
	
	poseName = biped.copyBipPose _bip col #snapNone
	
	sliderTime = _pasteF
	
	ICP_MXBipedCopy = getCopy col #pose 0
	-- ���\��t�����������ƁA���̈ʒu�Y������������̂�2��A���y�[�X�g
	biped.pasteBipPose _bip ICP_MXBipedCopy false #pstdefault true true true false
	biped.pasteBipPose _bip ICP_MXBipedCopy false #pstdefault true true true false
	
	ClearCollection _bip col.name
	sliderTime = beforeTime
)

-- Biped�̂��ׂẴL�[���N���A�B�������OF�͏���
fn ClearKey _bip=(
	-- 0F�̃|�[�Y���R�s�[�@���@�S�L�[���N���A�@���@�폜
	sliderTime = 0
	-- �R�s�[�R���N�V�����������ƃG���[��f���̂ō쐬
	col = biped.createCopyCollection _bip "tempCol"
	poseName = biped.copyPosture _bip #pose true true true

	biped.clearAllAnimation _bip

	--biped.pastePosture bip #pose false poseName
	ICP_MXBipedCopy = getCopy col #pose 0
	--biped.pasteBipPosture $.controller ICP_MXBipedCopy true #pstdefault false false false false
	-- �Ō�̈����� true �ɂ���Ɠ\��t�����ɁACOM�̃g�����X�t�H�[�����ێ�����
	biped.pasteBipPose _bip ICP_MXBipedCopy false #pstdefault true true true false

	ClearCollection _bip col.name
)

-- �X���C�h�L�[�iIK�j�̐ݒ�
fn SetIK _bip _f=(
	sliderTime = _f as integer
	footL = biped.getNode _bip #lLeg link:3
	footR = biped.getNode _bip #rLeg link:3

	biped.setSlidingKey footL
	biped.setSlidingKey footR
)

fn DoNotExistBipedError=(
	messageBox "�V�[������Biped������܂���" title:"�G���[" beep:true
)

fn Main=(
	----------------------------------------
	-- �m�[�h���擾�@Biped�����������珈�����Ȃ�
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
	-- COM �͎擾������Ȃ̂ł����ł͎擾���Ȃ�
	----------------------------------------
	
	----------------------------------------
	-- ���݂̃t���[���̃|�[�Y���R�s�[���A0�t���[���ڂɓ\��t����
	GetAndSetNowFramePose bip 0
	----------------------------------------

	----------------------------------------
	-- 0F�ȊO�̃L�[���N���A����B�����I�ɂ̓R���N�V�����ɃL�[���ꎞ�I�ɓ�����
	ClearKey bip
	----------------------------------------


	----------------------------------------
	-- �A�j���[�g
	if animButtonState == false do animButtonState = true

	-- �L�[�Z�b�g�t���[���z��
	F = #(0,7,15,23,30)
	
	-- �^�C���X���C�_�[�ݒ�
	SetAnimRange F[1] F[5]
	
	-- �x�N�g��
	dx = [1,0,0]
	dy = [0,1,0]
	dz = [0,0,1]

	-- 0�t���[���ɃL�[
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
	-- ��
	sliderTime = F[3]
	rotate head (angleaxis 5 dx)
	sliderTime = F[5]
	rotate head (angleaxis -5 dx)
	----------
	
	----------
	-- ��
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
	-- ��

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
	
	-- ����F�R�s�[(�������Ă���ԂɎ����ۊǂ���Ēl���ς�邽��)
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
	-- �� ���[�v�����炩�ɂ���
	-- ���[�v�̐^�񒆂̃|�[�Y���A���[�v�O�O��ɃR�s�[����
	overStartF = (F[5]/-2) as integer
	overEndF = F[5]+((F[5]/2) as integer)
	SetAnimRange overStartF overEndF
	sliderTime = F[3]
	GetAndSetNowFramePose bip overStartF
	GetAndSetNowFramePose bip overEndF
	----------
	
	-- IK ���Z�b�g���邩
	if g_isIK do( 
		SetIK bip F[1]
		SetIK bip F[5]
	)
	
	-- �^�C���X���C�_�[�ݒ��߂�
	SetAnimRange F[1] F[5]
	----------
	
	----------------------------------------
)

----------
-- UI
try( DestroyDialog rol_breathBiped )catch()
rollout rol_breathBiped ("Biped���ċz������̂ł�"+ g_version) width:220 height:88(
	button btn_exec "���s" pos:[8,56] width:202 height:24
	dropdownList ddl_idleType "�ڑI��" items:g_idleType pos:[8,8] width:202 height:41
	checkbox chk_isIK "�ݒu�L�[" pos:[150,8] width:80 height:16 checked:true
	
	on btn_exec pressed do( Main() )
	
	on chk_isIK changed state do( g_isIK = state )
)
CreateDialog rol_breathBiped
----------