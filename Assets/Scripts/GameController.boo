import UnityEngine

enum GameState:
	Main
	Boss
	GameOver
	Clear

class GameController (MonoBehaviour): 
	public player as GameObject
	public state as GameState
	public initialStage as int = 1
	public maxStage = 3
	private stage as int = 1
	private boss as GameObject = null
	private maxBossHP as single = 0
	private currentMaxBossHP as single = 0
	private restorePoint as Vector3 = Vector3.zero
	private score as int = 0
	
	def Start ():
		self.restorePoint = Vector3.zero
		self.stage = self.initialStage
		self.score = 0
		self.SetUp()
		
	def SetUp():
		System.GC.Collect()
		Resources.UnloadUnusedAssets()
		self.CreateStage(self.stage)
		self.state = GameState.Main
		self.player = GameObject.FindWithTag('Player')
		if not Vector3.Distance(Vector3.zero, self.restorePoint) == 0:
			self.player.transform.position = self.restorePoint
		self.currentMaxBossHP = 0
		audio.clip = Resources.Load("Musics/trance", AudioClip)
		audio.loop = true
		audio.Play()
	
	def Update ():
		if self.state == GameState.GameOver:
			if Input.GetKeyDown(KeyCode.Space):
				self.Replay()
		elif self.state == GameState.Clear:
			if self.stage < self.maxStage and Input.GetKeyDown(KeyCode.Space):
				self.NextStage()
		if self.state == GameState.Boss:
			if self.currentMaxBossHP <= self.maxBossHP:
				self.currentMaxBossHP += 0.5
				audioPlayer as GameObject = GameObject.Find('AudioPlayer')
				if not audioPlayer.audio.isPlaying:
					audioPlayer.audio.volume = 0.5
					clip as AudioClip = Resources.Load("Sounds/gauge", AudioClip)
					audioPlayer.audio.PlayOneShot(clip)

	def GameOver():
		if state != GameState.GameOver:
			audio.Stop()
			clip as AudioClip = Resources.Load("Sounds/gameover", AudioClip)
			audio.PlayOneShot(clip)
			state = GameState.GameOver	
			score = score / 2 + 1
		
	def OnGUI():
		style as GUIStyle = GUIStyle()
		style.fontSize = 24
		style.normal.textColor = Color.white
		style.alignment = TextAnchor.MiddleRight
		shadowStyle as GUIStyle = GUIStyle()
		shadowStyle.fontSize = 24
		shadowStyle.normal.textColor = Color.gray
		shadowStyle.alignment = TextAnchor.MiddleRight
		GUI.Label(Rect(32, 32, 80, 50), "Stage: ", shadowStyle)
		GUI.Label(Rect(30, 30, 80, 50), "Stage: ", style)
		GUI.Label(Rect(332, 32, 80, 50), "Score: ", shadowStyle)
		GUI.Label(Rect(330, 30, 80, 50), "Score: ", style)
		shadowStyle.alignment = TextAnchor.MiddleLeft
		style.alignment = TextAnchor.MiddleLeft
		GUI.Label(Rect(112, 32, 50, 50), self.stage.ToString(), shadowStyle)
		GUI.Label(Rect(110, 30, 50, 50), self.stage.ToString(), style)
		GUI.Label(Rect(412, 32, 100, 50), self.score.ToString(), shadowStyle)
		GUI.Label(Rect(410, 30, 100, 50), self.score.ToString(), style)
		texture as Texture2D = Texture2D(1, 1, TextureFormat.ARGB32, false)
		texture.SetPixel(0, 0, Color.black)
		texture.Apply()
		GUI.DrawTextureWithTexCoords(Rect(540, 30, 400, 40), texture, Rect(0, 0, 1, 1))
		hpRate = 0.0
		if player:
			component = player.GetComponent[of Player]()
			if component:
				hpRate = component.GetHPRate()	
		texture1 as Texture2D = self.GetHPBarTexture(hpRate)
		GUI.DrawTextureWithTexCoords(Rect(540, 30, 400 * hpRate, 40), texture1, Rect(0, 0, 1, 1))
		labelStyle = GUIStyle()
		labelStyle.fontSize = 64 
		labelStyle.alignment = TextAnchor.MiddleCenter
		labelStyle.normal.textColor = Color.white
		shadowLabelStyle = GUIStyle()
		shadowLabelStyle.fontSize = 64 
		shadowLabelStyle.alignment = TextAnchor.MiddleCenter
		shadowLabelStyle.normal.textColor = Color.gray
		width = Screen.width
		height = Screen.height
		if self.state == GameState.GameOver:	
			GUI.Label(Rect(width / 2 - 300 + 3, height / 2 - 200 + 3, 600, 400), "Game Over", shadowLabelStyle)	
			GUI.Label(Rect(width / 2 - 300, height / 2 - 200, 600, 400), "Game Over", labelStyle)	
			if GUI.Button( Rect(width / 2 - 210, height / 2 + 100, 200, 60), "Replay(Space)"):
				self.Replay()
			elif GUI.Button( Rect(width / 2 + 10, height / 2 + 100, 200, 60), "Exit"):
				Application.Quit()
		elif self.state == GameState.Boss:
			bgTexture as Texture2D = Texture2D(1, 1, TextureFormat.ARGB32, false)
			bgTexture.SetPixel(0, 0, Color.black)
			bgTexture.Apply()
			GUI.DrawTextureWithTexCoords(Rect(230, Screen.height - 60, 200, 40), bgTexture, Rect(0, 0, 1, 1))
			if self.boss:
				bossComponent = boss.GetComponent[of Boss]()
				bossHP as single = bossComponent.hp
				bossHPRate as single = Mathf.Min(bossHP / self.maxBossHP, self.currentMaxBossHP / self.maxBossHP)
				bossTexture as Texture2D = self.GetHPBarTexture(bossHPRate)
				GUI.DrawTextureWithTexCoords(Rect(230, Screen.height - 60, 200 * bossHPRate, 40), bossTexture, Rect(0, 0, 1, 1))
				shadowStyle.alignment = TextAnchor.MiddleRight
				style.alignment = TextAnchor.MiddleRight
				GUI.Label(Rect(22, Screen.height - 64 + 2, 200, 50), bossComponent.bossName, shadowStyle)
				GUI.Label(Rect(20, Screen.height - 62, 200, 50), bossComponent.bossName, style)
		elif self.state == GameState.Clear:
			text as string
			if self.stage == 3:
				text = "Conguraturations!"
				if GUI.Button( Rect(width / 2 - 100, height / 2 + 100, 200, 60), "Exit"):
					Application.Quit()
			else:
				if GUI.Button( Rect(width / 2 - 100, height / 2 + 100, 200, 60), "Next Level(Space)"):
					self.NextStage()
				text = "Clear!"
			GUI.Label(Rect(width / 2 - 300 + 3, height / 2 - 200 + 3, 600, 400), text, shadowLabelStyle)	
			GUI.Label(Rect(width / 2 - 300, height / 2 - 200, 600, 400), text, labelStyle)		
			
	def GetHPBarTexture(hpRate as single) as Texture2D:
		texture as Texture2D = Texture2D(1, 1, TextureFormat.ARGB32, false)
		if hpRate >= 0:
			if hpRate >= 0.6:
				texture.SetPixel(0, 0, Color.green)
			elif hpRate >= 0.2:
				texture.SetPixel(0, 0, Color.yellow)
			else:
				texture.SetPixel(0, 0, Color.red)
			texture.Apply()
		return texture
			
				
	def DefeatBoss():
		audio.Stop()
		
	def Clear():
		self.state = GameState.Clear
		clip as AudioClip = Resources.Load("Sounds/clear", AudioClip)
		audio.PlayOneShot(clip)
		
	def Replay():
		self.SetUp()
		
	def NextStage():
		self.stage += 1
		self.restorePoint = Vector3.zero
		self.SetUp()

	def CreateStage(s as int):
		loader = GameObject.Find('StageLoader')
		loader.SendMessage("CreateStage", s)
		
	def ChangeBossState():
		if self.state == GameState.Main:
			self.state = GameState.Boss
			self.player.SendMessage("SetLockCamera", true)
			audio.Stop()
			audio.clip = Resources.Load("Musics/boss", AudioClip)
			audio.Play()
			component = boss.GetComponent[of Boss]()
			self.maxBossHP = component.hp
			
	def SetBoss(b as GameObject):
		self.boss = b
		
	def SetRestorePoint():
		self.restorePoint = self.player.transform.position
		
	def AddScore(s as int):
		self.score += s