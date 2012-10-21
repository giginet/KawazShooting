import UnityEngine

class BossMoruboru (MonoBehaviour): 
	private shooter as Shooter
	private counter = 0

	def Start ():
		shooter = self.GetComponent[of Shooter]()
	
	def Update ():
		counter = (counter + 1) % 600
		if counter <= 200:
			shooter.type = ShootType.Curtain
			shooter.repeatDuration = 1
			shooter.bulletSpeed = 5
		elif counter <= 400:
			shooter.type = ShootType.Curl
			shooter.repeatDuration = 2
			shooter.bulletSpeed = 50
		else:			
			shooter.type = ShootType.Spiral
			shooter.repeatDuration = 5
			shooter.bulletSpeed = 20
