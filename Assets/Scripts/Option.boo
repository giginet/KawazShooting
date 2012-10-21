import UnityEngine

class Option (MonoBehaviour):
	public target as GameObject = null
	public orbitalRadius = 50
	public positions as List
	public delay as int = 30
	public minDistance as single = 20
	private sub as Vector3
	private lockAngle as Vector3 

	def Start ():
		positions = []
	
	def Update ():
		if not target: return
		if Input.GetKeyDown(KeyCode.Z):
			sub = self.transform.position - target.transform.position
			lockAngle = target.transform.eulerAngles
		if not Input.GetKey(KeyCode.Z):
			v0 = self.transform.position
			v1 = self.target.transform.position
			if Vector3.Distance(v0, v1) >= minDistance:
				positions.Add(self.target.transform.position)
			if len(positions) >= delay:
				p as Vector3 = positions.Pop()
				self.transform.position = Vector3.Lerp(transform.position, p, Time.deltaTime * 1)
			self.transform.eulerAngles = self.target.transform.eulerAngles
		else:
			self.transform.position = self.target.transform.position + sub
			self.transform.eulerAngles = lockAngle