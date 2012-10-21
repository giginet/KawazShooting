import UnityEngine

class Log (MonoBehaviour): 
	public accellRate = 2.0
	private accell = Vector3.back

	def Start ():
		self.transform.eulerAngles = Vector3(90, 90, 0)
		self.accell *= accellRate
	
	def Update ():
		enemy as Enemy = self.GetComponent[of Enemy]()
		if enemy and enemy.IsInSight():
			self.rigidbody.velocity += self.accell
			self.transform.Rotate(Vector3(0, 30, 0))
