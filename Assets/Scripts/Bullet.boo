import UnityEngine
import ScoreBall

enum BulletType:
	Normal
	Direction
	Sin
	Accell
	Homing

class Bullet (MonoBehaviour):
	public attack as int = 1
	public delay as int = 0
	public owner as GameObject = null
	public type as BulletType = BulletType.Normal
	private delayTimer = 0
	private prePosition as Vector3

	def Start ():
		self.delayTimer = 0
		prePosition = self.transform.position
	
	def Update ():
		rigidbody.velocity.y = 0
		if self.transform.position.y < 5:
			self.transform.position.y = 5
		if delayTimer < delay:
			delayTimer += 1
			transform.position = prePosition
		elif delayTimer == delay:
			if type == BulletType.Direction:
				player as GameObject = GameObject.FindWithTag('Player')
				if player:
					speed = Vector3.Distance(self.rigidbody.velocity, Vector3.zero)
					self.rigidbody.velocity = Vector3.Normalize(player.transform.position - self.transform.position) * speed
					delayTimer += 1
			
		width = Screen.width
		height = Screen.height
		screen as Vector3 = Camera.main.WorldToScreenPoint(transform.position)
		if screen.x < -100 or width + 100 < screen.x or screen.y < -100 or height + 100 < screen.y:
			Destroy(gameObject)
		prePosition = transform.position
		if not owner:
			ScoreBall.Create(self.transform.position)
			Destroy(gameObject)

	def OnTriggerEnter(other as Collider):
		if not other.gameObject.Equals(self.owner):
			if other.gameObject.CompareTag("Wall"):
				Destroy(gameObject)
			elif other.gameObject.CompareTag("Enemy") and self.gameObject.CompareTag("Bullet"):
				Destroy(gameObject)
			elif other.gameObject.CompareTag("Enemy") and self.gameObject.CompareTag("PlayerBullet"):
				other.gameObject.SendMessage("Damage", attack)
				Destroy(gameObject)
			elif other.gameObject.CompareTag("Player") and self.gameObject.CompareTag("Bullet"):
				other.gameObject.SendMessage("Damage", attack)
				Destroy(gameObject)
				
	def SetDelay(d as int):
		self.delay = d
		
	def SetBulletType(t as BulletType):
		type = t
		
	def SetVelocity(v as Vector3):	
		self.rigidbody.velocity = v