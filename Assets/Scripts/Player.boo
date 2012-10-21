import UnityEngine

class Player (MonoBehaviour):
	public maxHP as single = 100
	public isShooting = false
	public explosionPrefab as GameObject
	public optionPrefab as GameObject = null
	private options as List = []
	private hp as single = 100
	private prePosition as Vector3
	private isInvinsible = false
	private invinsibleTimer = 0
	public invinsibleDuration = 20
	
	def Start():
		self.hp = self.maxHP
		prePosition = transform.position
		
	def Update():
		if isInvinsible:
			for renderer in self.GetComponentsInChildren[of Renderer]():
				renderer.enabled = invinsibleTimer % 2 == 0
			invinsibleTimer += 1			
		if invinsibleTimer > invinsibleDuration:
			isInvinsible = false
			invinsibleTimer = 0
		isShooting = Input.GetKey(KeyCode.Space)
		screen as Vector3 = Camera.main.WorldToScreenPoint(transform.position) 
		if screen.y < 0 or screen.x < 0:
			self.transform.position = prePosition
		self.prePosition = self.transform.position
		if self.transform.position.y < -20:
			self.Damage(99999)
		
	def Damage(d as int):
		if not isInvinsible:
			self.isInvinsible = true
			hp -= d
			clip as AudioClip = Resources.Load("Sounds/player_damage", AudioClip)
			audio.PlayOneShot(clip)
			if hp <= 0:
				controller = GameObject.FindWithTag('GameController')
				controller.SendMessage("GameOver")
				Instantiate(explosionPrefab, transform.position, Quaternion.identity)
				Destroy(self.gameObject)	
			
	def AddOption():
		optionObject as GameObject = Instantiate(optionPrefab, transform.position + Vector3.up * 100, Quaternion.identity)
		stage = GameObject.FindWithTag('Stage')
		optionObject.transform.parent = stage.transform
		option = optionObject.GetComponent[of Option]()
		if len(options) == 0:
			option.target = self.gameObject
		else:
			option.target = self.options[-1]
		options.Add(optionObject)
		
	def GetHPRate():
		return hp / maxHP