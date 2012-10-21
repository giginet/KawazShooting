import UnityEngine

enum ShootType:
	Normal
	Circle
	Sine
	Spiral
	Curl
	Curtain
	Fan

class Shooter (MonoBehaviour): 
	public bulletSpeed as single = 100
	public type as ShootType = ShootType.Normal
	public BulletPrefab as GameObject = null
	public repeatDuration as int = 3
	public circleRange = 30
	private repeatCount = 0
	private spiralAngle = 0
	
	def Start ():
		self.spiralAngle = 0
		
	def Update() :
		pass
	
	def Shoot ():
		q as Quaternion
		if repeatCount == 0:	
			if self.type == ShootType.Normal:
				self.CreateBullet(transform.position + Vector3.up * 15)
			elif self.type == ShootType.Circle:
				for deg in range(360.0 / circleRange):
					q = Quaternion.AngleAxis(deg * circleRange, Vector3.up)
					v = Vector3.forward
					b = self.CreateBullet(transform.position + (q * v))
					b.SendMessage('SetVelocity', q * Vector3.forward * self.bulletSpeed)
			elif self.type == ShootType.Spiral:
				q = Quaternion.AngleAxis(spiralAngle, Vector3.up)
				v = Vector3.forward
				b = self.CreateBullet(transform.position + (q * v))
				r = b.GetComponent[of Rigidbody]()
				r.velocity = q * Vector3.forward * self.bulletSpeed
				spiralAngle = (spiralAngle + circleRange) % 360
			elif self.type == ShootType.Curl:
				for i in range(2):
					q = Quaternion.AngleAxis(spiralAngle + 180 * i, Vector3.up)
					v = Vector3.forward * 30
					b = self.CreateBullet(transform.position + (q * v))
					b.SendMessage('SetVelocity', q * Vector3.forward * self.bulletSpeed)
					b.SendMessage("SetDelay", 100)
					b.SendMessage("SetBulletType", BulletType.Direction)
				spiralAngle = (spiralAngle + circleRange) % 360
			elif self.type == ShootType.Curtain:
				b = self.CreateBullet(transform.position + (q * v))
				b.SendMessage('SetVelocity', Random.onUnitSphere * self.bulletSpeed)
			elif self.type == ShootType.Fan:
				for i in range(5):
					b = self.CreateBullet(transform.position + (q * v))
					q = Quaternion.AngleAxis((i - 2) * self.repeatDuration, Vector3.up)
					b.SendMessage('SetVelocity', q * transform.forward * self.bulletSpeed)
				
		repeatCount = (repeatCount + 1) % repeatDuration
		
	def CreateBullet(position as Vector3):
		bullet as GameObject = Instantiate(BulletPrefab, position, Quaternion.identity)
		bullet.SendMessage('SetVelocity', transform.forward * self.bulletSpeed)
		b = bullet.GetComponent[of Bullet]()
		b.owner = self.gameObject
		return bullet
		
	def SetShootType(t as ShootType):
		type = t