/*
	Created on 2016.8.25
	Author deathponta
	3dsMax���Ŏg�p���Ă���A�j���[�V�������C���iBiped���C���[�����j�����X�g���A
	���̃��C���[�ɑ�����I�u�W�F�N�g�����X�g����.�_�u���N���b�N�ŃI�u�W�F�N�g��I���ł���
*/
-- Field Variables
global m_layerNames = #()

-- �V�[�����̃��C���[�l�[�������X�g
fn UpdateAnimLayerInScene _ddl=(
	global m_layerNames = #()
	alm = AnimLayerManager
	layerNum = alm.getlayerCount() /*�V�[�����̃��C���[���擾*/

	for i=1 to layerNum do(
		append m_layerNames (alm.getLayerName i)
	)

	-- �h���b�v�_�E�����X�g�ɃV�[�����̃A�j���[�V�������C���[�z�����
	_ddl.items = m_layerNames
)

fn UpdateListBox _lb _ddl=(
	alm = AnimLayerManager
	-- ���̃A�j���[�V�������C���[�ɑ����Ă���I�u�W�F�N�g���i�[����z��
	objNamesInLayer = #()

	-- �V�[�����̑S�I�u�W�F�N�g�����X�g���āA�A�j���[�V�������C���[�ɑ����Ă��邩��idx�Ŋm�F
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
	button btn_update "�X�V" pos:[8,8] width:184 height:24
	button btn_selectAll "�S�I��" pos:[120,40] width:72 height:16
	dropdownList ddl_animLayers "�A�j���[�V�������C���[" pos:[8,40] width:184 height:41
	listbox lb_objects "������I�u�W�F�N�g" pos:[8,88] width:184 height:11


	on btn_update pressed do(
		UpdateAnimLayerInScene ddl_animLayers
	)

	on btn_selectAll pressed do(
		SelectAll lb_objects
	)

	-- �h���b�v�_�E�����I������Ă��鎞
	on ddl_animLayers selected sel do(
		UpdateListBox lb_objects ddl_animLayers
	)

	-- ���X�g�{�b�N�X�ɕ\������Ă���I�u�G�N�g���_�u���N���b�N�őI������
	on lb_objects doubleClicked sel do(
		SelectObject lb_objects
	)

)

createDialog rol_aspectSwitch /*style:#(#style_toolwindow, #style_sysmenu)*/
-- UI end
----------------------------------------
