/*

1) �I�������I�u�W�F�N�g�̃L�[���R�s�[
2) �I�������I�u�W�F�N�g�ɍŌ�ɃR�s�[�����L�[���y�[�X�g

�E�y�[�X�g���͕����I���ɑΉ�����

�� �ǉ��\��
�E�N���[���y�[�X�g�@�\
�@���@controller = controller �ł�����
�E�N���[���y�[�X�g�������̂��I���W�i���ɂ���@�\
�@���@controller = prs() �ł�����
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
		-- �I���I�u�W�F�N�g����L�[���폜
		DeleteKeys s.controller #allKeys

		s.transform.controller = m_srcTransCtrl
	)
)

--------------------------------------------------
-- UI
try(destroyDialog rol_copipeKey ) catch()

rollout rol_copipeKey "CopipeController" width:120 height:68
(

	button btn_copy "�R�s�[" pos:[8,8] width:104 height:24
	button btn_paste "�y�[�X�g�i�����j" pos:[8,36] width:104 height:24


	on btn_copy pressed do(
		CopyCtrl()
	)


	on btn_paste pressed do(
		PasteCtrl()
	)
)

createDialog rol_copipeKey
--------------------------------------------------