import UnityEngine

class Bacura (MonoBehaviour): 

	def Start ():
		pass
	
	def Update ():
		enemy as Enemy = self.GetComponent[of Enemy]()
		if enemy and enemy.IsInSight():
			self.transform.Rotate(-3, 0, 0)
			self.transform.position.z -= 1
