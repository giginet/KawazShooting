import UnityEngine

class Enemy (MonoBehaviour): 
	public hp as int = 1
	public bodyName as string = "body"
	public explosionPrefab as GameObject
	public invinsibleDuration = 10 
	public lookAt = true
	public collisionDamage = true
	public sight = 100
	public ballCount = 12
	public collisionThreshold = 3.0
	private currentInvinsibleDuration = 0
	private isInvinsible = false
	private shooter as Shooter

	virtual def Start ():
		shooter = self.GetComponent[of Shooter]()
	
	virtual def Update ():	
		if isInvinsible:
			currentInvinsibleDuration += 1
			transform.Find(bodyName).renderer.enabled = currentInvinsibleDuration % 2 == 0
			if currentInvinsibleDuration >= invinsibleDuration:
				isInvinsible = false
				currentInvinsibleDuration = 0
		else:
			transform.Find(bodyName).renderer.enabled = true
			player as GameObject = GameObject.FindWithTag('Player')
			if player:
				if self.IsInSight():
					if self.lookAt: self.transform.LookAt(player.transform)
					if shooter:
						shooter.Shoot()
				if Vector3.Distance(player.transform.position, self.collider.ClosestPointOnBounds(player.transform.position)) < self.collisionThreshold:
					if collisionDamage: player.SendMessage('Damage', 10)
		if self.transform.position.y < -100:
			self.Death()
	
	def IsInSight():
		player as GameObject = GameObject.FindWithTag('Player')
		if player:
			dis as single = Vector3.Distance(player.transform.position, self.transform.position)
			return dis < sight
		return false
		
		
	virtual def Damage(attack as int):
		if not isInvinsible:
			clip as AudioClip = Resources.Load("Sounds/damage", AudioClip)
			audio.PlayOneShot(clip)
			hp -= attack
			isInvinsible = true
			currentInvinsibleDuration = 0
			if hp <= 0:
				self.Death()
				
	virtual def Death():
		scoreBallPrefab = Resources.Load("Prefabs/BallPrefab")
		Instantiate(explosionPrefab, transform.position, Quaternion.identity)
		velocity = Random.onUnitSphere 
		velocity.y = 0
		velocity = Vector3.Normalize(velocity)
		for deg in range(self.ballCount):
			q = Quaternion.AngleAxis(deg * 360 / self.ballCount, Vector3.up)
			ball as GameObject = Instantiate(scoreBallPrefab, self.transform.position + q * Vector3.forward * 20, Quaternion.identity)
			ball.SendMessage("SetVelocity", velocity)
		Destroy(gameObject)
		
	def SetLookAt(l as bool):
		lookAt = l
