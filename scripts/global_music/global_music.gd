extends AudioStreamPlayer

const menu_music = preload("res://assets/music/menu/A Small Adventure.wav")
const in_game_music = preload("res://assets/music/inGame/ingame.mp3")
const victory_music = preload("res://assets/music/inGame/victory.mp3")
const game_over_music = preload("res://assets/music/inGame/game_over.wav")


func play_music(music: AudioStream, volume = 0.0):
	if stream == music:
		return
		
	stream = music
	volume_db = volume
	play()
	

func play_menu_music():
	play_music(menu_music)
	
func play_in_game_music():
	play_music(in_game_music)
	
func play_victory_music():
	play_music(victory_music)
	
func play_game_over_music():
	play_music(game_over_music)
	
const press_sound = preload("res://assets/music/SFX/menu_select.mp3")
const hover_in_sound = preload("res://assets/music/SFX/hover_in.mp3")
const hover_out_sound = preload("res://assets/music/SFX/hover_out.mp3")

	
func play_FX(stream: AudioStream, name, volume=0.0):
	var fx_player = AudioStreamPlayer.new()
	fx_player.stream = stream
	fx_player.name = name
	fx_player.volume_db = volume
	fx_player.bus = "sfx"
	add_child(fx_player)
	fx_player.play()
	
	await fx_player.finished
	fx_player.queue_free()

func on_button_press():
	play_FX(press_sound, "button_press_sound")
	
func on_button_hover_in():
	play_FX(hover_in_sound, "hover_in_sound")
	
func on_button_hover_out():
	play_FX(hover_out_sound, "hover_out_sound")
