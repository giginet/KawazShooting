import UnityEngine

class PlayerShooter (MonoBehaviour): 
	public bulletSpeed as single = 100
	public BulletPrefab as GameObject = null
	public repeatDuration as int = 3
	private repeatCount = 0
	
	def Start ():
		pass
	
	def Update ():
		player = GameObject.FindWithTag('Player')
		if Input.GetKey(KeyCode.Space) and player:
			if repeatCount == 0:
				bullet as GameObject = Instantiate(BulletPrefab, transform.position + Vector3.up * 10, Quaternion.identity) 
				bullet.SendMessage('SetVelocity', transform.forward * self.bulletSpeed)
				b = bullet.GetComponent[of Bullet]()
				b.owner = self.gameObject
				b.tag = "PlayerBullet"
			repeatCount = (repeatCount + 1) % repeatDuration
		else:
			repeatCount = 0