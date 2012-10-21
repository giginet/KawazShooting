import UnityEngine
import Enemy

class Boss (Enemy):
	public bossName as string
	public gatePrefab as GameObject
	public lastBoss as bool = true

	def Start ():
		super.Start()
	
	def Update ():
		super.Update()
		
	virtual def Death():
		if gatePrefab and lastBoss:
			self.EndBoss()	
		super.Death()
		
	virtual def EndBoss():
		stage as GameObject = GameObject.FindWithTag('Stage')
		if stage:
			gate as GameObject = Instantiate(gatePrefab, transform.position, Quaternion.identity)
			controller as GameObject = GameObject.FindWithTag('GameController')
			controller.SendMessage("DefeatBoss")
			gate.transform.parent = stage.transform
		
