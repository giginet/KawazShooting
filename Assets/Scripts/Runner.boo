import UnityEngine

enum Direction:
	Vertical
	Horizontal

class Runner (MonoBehaviour): 
	public direction as Direction = Direction.Horizontal
	public runSpeed as single = 1.0
	public range as single = 100
	private runVelocity as Vector3
	private initialPoint as Vector3

	def Start ():
		initialPoint = self.transform.position
		runVelocity = Vector3.zero
		self.gameObject.SendMessage('SetLookAt', false)
	
	def Update ():
		if self.direction == Direction.Horizontal:
			if runVelocity.Equals(Vector3.zero):
				runVelocity = Vector3.right
			elif initialPoint.x - range > self.transform.position.x:
				self.runVelocity = Vector3.right * self.runSpeed
			elif initialPoint.x + range < self.transform.position.x:
				self.runVelocity = Vector3.left * self.runSpeed
		elif self.direction == Direction.Vertical:
			if runVelocity.Equals(Vector3.zero):
				runVelocity = Vector3.forward
			elif initialPoint.z - range > self.transform.position.z:
				self.runVelocity = Vector3.forward * self.runSpeed
			elif initialPoint.z + range < self.transform.position.z:
				self.runVelocity = Vector3.back * self.runSpeed
		self.transform.position += self.runVelocity
		self.transform.LookAt(self.initialPoint + self.runVelocity * range)

	def SetDirection(d as Direction):
		self.direction = d
		
		
	def OnCollisionEnter(collision as Collision):
		if not collision.gameObject.CompareTag('Tile') and not collision.gameObject.CompareTag('Bullet') and not collision.gameObject.CompareTag('PlayerBullet'):
			self.runVelocity *= -1