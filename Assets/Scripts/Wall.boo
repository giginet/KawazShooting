import UnityEngine

class Wall (MonoBehaviour): 

	def Start ():
		pass
	
	def Update ():
		pass
	
	def OnCollisionEnter(other as Collision):
		if other.gameObject.CompareTag('Bullet') or other.gameObject.CompareTag('PlayerBullet'):
			Destroy(other.gameObject)