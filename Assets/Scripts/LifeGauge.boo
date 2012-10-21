import UnityEngine

class LifeGauge (MonoBehaviour): 

	def Start ():
		pass
	
	def Update ():
		screenSpace = Camera.main.ScreenToWorldPoint(Vector3(100, 100, 20))
		self.transform.position = screenSpace