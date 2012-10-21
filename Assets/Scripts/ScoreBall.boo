import UnityEngine
import HSVColor

class ScoreBall (MonoBehaviour): 
	private velocity as Vector3
	private homing as bool

	def Start ():
		self.transform.Rotate(90, 0, 0)
		hue = Random.value * 360
		cylinder = transform.Find('Cylinder')
		c as Color = HSVColor.GetColorFromHSV(hue, 1.0, 1.0)
		cylinder.renderer.material.color = c
		homing = false
	
	def Update ():
		player as GameObject = GameObject.FindWithTag('Player')
		if player:
			playerComponent = player.GetComponent[of Player]()
			if not playerComponent.isShooting:
				homing = true
		if not homing:
			self.transform.position += velocity
		else:
			if player:
				self.transform.position = Vector3.Lerp(transform.position, player.transform.position + Vector3.up * 5, Time.deltaTime * 5)
		self.transform.Rotate(0, 0, 30)
		width = Screen.width
		height = Screen.height
		screen as Vector3 = Camera.main.WorldToScreenPoint(transform.position)
		if screen.x < -100 or width + 100 < screen.x or screen.y < -100 or height + 100 < screen.y:
			Destroy(gameObject)	
		
	def OnTriggerEnter(other as Collider):
		if other.gameObject.CompareTag('Player'):
			if not audio.isPlaying:
				clip as AudioClip = Resources.Load("Sounds/item", AudioClip)
				audio.volume = 0.2
				a as AudioSource = GameObject.FindWithTag("GameController").GetComponent[of AudioSource]()
				a.PlayOneShot(clip)
			GameObject.FindWithTag('GameController').SendMessage("AddScore", 100)
			Destroy(gameObject)
			
	def SetVelocity(v as Vector3):
		self.velocity = v
		
	static def Create(position as Vector3):
		ballPrefab as GameObject = Resources.Load("Prefabs/BallPrefab")
		ball as GameObject = Instantiate(ballPrefab, position, Quaternion.identity)
		v = Random.onUnitSphere 
		v.y = 0
		v = Vector3.Normalize(v)
		ball.SendMessage('SetVelocity', v)
		return ball