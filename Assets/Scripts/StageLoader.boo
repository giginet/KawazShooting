import UnityEngine
import Runner

class StageLoader (MonoBehaviour): 
	public tilePrefab as GameObject
	public playerPrefab as GameObject
	public wallPrefab as GameObject
	public guguguPrefab as GameObject
	public bossCatPrefab as GameObject
	public bossGuguguPrefab as GameObject
	public bossMoruboruPrefab as GameObject
	public moruboruPrefab as GameObject
	public optionPrefab as GameObject
	public sensorPrefab as GameObject
	public columnPrefab as GameObject
	private playerPlaced as bool = false
	
	def Start ():
		pass
		
	def Update ():
		pass
		
	def CreateStage (stageNo as int):
		self.playerPlaced = false
		stageData as TextAsset = Instantiate(Resources.Load("Stages/stage" + stageNo,  TextAsset))
		width as single = tilePrefab.transform.localScale.x
		height as single = tilePrefab.transform.localScale.z
		lines = stageData.text.Split("\n"[0])
		self.DestroyStage()
		stage as GameObject = GameObject.CreatePrimitive(PrimitiveType.Cube)
		stage.tag = "Stage"
		stage.renderer.enabled = false
		stage.name = "Stage" + stageNo
		controller as GameObject = GameObject.FindWithTag('GameController')
		player as GameObject = Instantiate(playerPrefab, Vector3.zero, Quaternion.identity)
		for y as int, line as string in enumerate(lines):
			for x as int in range(line.Length):
				position = Vector3(x * width, 0, -y * height)
				c = line[x]
				if not c == " "[0] and not c == "#"[0]:
					tile as GameObject = Instantiate(tilePrefab, position, Quaternion.identity)
					tile.transform.parent = stage.transform
				if c == "#"[0]:
					wall as GameObject = Instantiate(wallPrefab, position + (Vector3.up * height / 2), Quaternion.identity)
					wall.transform.parent = stage.transform
				elif c == "G"[0] or c == "V"[0] or c == "C"[0] or c == "H"[0]:
					gugugu as GameObject = Instantiate(guguguPrefab, position, Quaternion.identity)
					if c == "C"[0]:
						gugugu.SendMessage("SetShootType", ShootType.Circle)
					elif c == "V"[0]:
						gugugu.AddComponent(Runner)
						gugugu.SendMessage('SetDirection', Direction.Vertical)
					elif c == "H"[0]:
						gugugu.AddComponent(Runner)
						gugugu.SendMessage('SetDirection', Direction.Horizontal)
						
					gugugu.transform.parent = stage.transform
				elif c == "M"[0]:
					moruboru as GameObject = Instantiate(moruboruPrefab, position, Quaternion.identity)
					moruboru.transform.parent = stage.transform
				elif c == "S"[0] and not self.playerPlaced:
					player.transform.position = position + Vector3.up * 5
					self.playerPlaced = true
					player.transform.parent = stage.transform
				elif c == "w"[0] or c == "r"[0] or c == "l"[0] or c == "u"[0]:
					sensor as GameObject = Instantiate(sensorPrefab, position, Quaternion.identity)
					sensor.transform.parent = stage.transform
					if c == "r"[0]:
						sensor.SendMessage("SetReciverObject", controller)
						sensor.SendMessage("SetReciverName", "SetRestorePoint")
					elif c == "w"[0]:
						sensor.SendMessage("SetReciverName", "ChangeBossState")
						sensor.SendMessage("SetReciverObject", controller)
					elif c == "l"[0]:
						sensor.SendMessage("SetReciverName", "LockCamera")
						sensor.SendMessage("SetReciverObject", player)
						sensor.SendMessage("SetSuicide", true)
					elif c == "u"[0]:						
						sensor.SendMessage("SetReciverName", "UnlockCamera")
						sensor.SendMessage("SetReciverObject", player)
						sensor.SendMessage("SetSuicide", true)
				elif c == "O"[0]:
					option as GameObject = Instantiate(optionPrefab, position + Vector3.up * 5, Quaternion.identity)
					option.transform.parent = stage.transform
				elif c == "W"[0]:
					for i in range(3):
						column as GameObject = Instantiate(columnPrefab, position + Vector3.up * 5, Quaternion.identity)
						column.transform.position.y += 3 * i * 10
						column.transform.parent = stage.transform
				elif c == "B"[0]:
					bossPrefab as GameObject
					if stageNo <= 1:
						bossPrefab = bossCatPrefab
					elif stageNo == 2:
						bossPrefab = bossGuguguPrefab
					elif stageNo == 3:
						bossPrefab = bossMoruboruPrefab
					boss as GameObject = Instantiate(bossPrefab, position + Vector3.up * 5, Quaternion.identity)
					controller.SendMessage('SetBoss', boss)
					boss.transform.parent = stage.transform
				elif c == "b"[0]:
					bacuraPrefab = Resources.Load("Prefabs/Bacura")
					bacura as GameObject = Instantiate(bacuraPrefab, position + Vector3.up * 20, Quaternion.identity)
					bacura.transform.parent = stage.transform
				elif c == "L"[0]:
					logPrefab = Resources.Load("Prefabs/Log")
					log as GameObject = Instantiate(logPrefab, position + Vector3.up * 5, Quaternion.identity)
					log.transform.parent = stage.transform
	
	def DestroyStage():
		stage as GameObject = GameObject.FindWithTag("Stage")
		if stage:
			Destroy(stage)
					
	