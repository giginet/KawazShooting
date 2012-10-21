import UnityEngine
import Boss

class BossGugugu (Boss): 
	static guguguCount as int
	guguguLevel as int = 1
	
	virtual def Start():	
		super.Start()
		guguguCount += 1
		d = Mathf.Floor(Random.value * 2)
		if d == 0:
			self.SendMessage("SetDirection", Direction.Vertical)
		elif d == 1:
			self.SendMessage("SetDirection", Direction.Horizontal)
	
	def SetGuguguLevel(g as int):
		guguguLevel = g
		self.transform.localScale = Vector3.one * (4.0 / guguguLevel)
		if guguguLevel == 1:
			self.hp = 100
		else:
			self.hp = Mathf.Ceil(100.0 / Mathf.Pow(guguguLevel, 2))
		shooter = self.GetComponent[of Shooter]()
		shooter.repeatDuration = guguguLevel * 2
		
	virtual def Death():
		super.Death()
		if guguguLevel <= 6:
			for i in range(2):
				guguguPrefab = Resources.Load('Prefabs/BossGugugu')
				gugugu as GameObject = Instantiate(guguguPrefab, self.transform.position + i * Vector3.right * 20, Quaternion.identity)
				gugugu.name = "BossGugugu"
				gugugu.SendMessage('SetGuguguLevel', guguguLevel + 1)
				gugugu.transform.parent = self.transform.parent
		
	def OnDestroy():
		guguguCount -= 1
		if guguguCount <= 0:
			self.EndBoss()