import UnityEngine

class Sensor (MonoBehaviour): 
	public reciverName as string
	public reciverObject as GameObject
	public suicide = false

	def Start ():
		pass
	
	def Update ():
		pass
		
	def OnTriggerEnter(other as Collider):
		if other.gameObject.CompareTag('Player'):
			if reciverObject:
				reciverObject.SendMessage(self.reciverName)
				if suicide:
					Destroy(gameObject)
				
	def SetReciverObject(obj as GameObject):
		reciverObject = obj
		
	def SetReciverName(method as string):
		reciverName = method
		
	def SetSuicide(b as bool):
		self.suicide = b		
