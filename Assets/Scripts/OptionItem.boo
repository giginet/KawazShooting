import UnityEngine

class OptionItem (MonoBehaviour): 

	def Start ():
		pass
	
	def Update ():
		self.transform.Rotate(0, 1, 0)
		
	def OnTriggerEnter(other as Collider):
		if other.gameObject.CompareTag('Player'):
			clip as AudioClip = Resources.Load("Sounds/cat", AudioClip)
			a as AudioSource = GameObject.FindWithTag("GameController").GetComponent[of AudioSource]()
			a.PlayOneShot(clip)
			other.gameObject.SendMessage("AddOption")
			Destroy(gameObject)
