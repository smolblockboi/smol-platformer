extends Node
class_name BaseAbility

signal refresh_cooldown
signal change_into_costume
signal change_out_of_costume

@export_category("Ability Properties")
enum ABILITY_TYPE {JUMP, DASH, ATTACK}
@export var type: ABILITY_TYPE
@export var level: int = 0
@export var player_texture: Texture
@export var enemy_texture: Texture

@export_category("Damage Properties")
@export var damage: float = 1.0
@export var knockback: float = 1.0
@export var stun_time: float = 1.0


func _init():
	change_into_costume.connect(on_into_costume)
	change_out_of_costume.connect(on_out_of_costume)


func _ready():
	if is_connected("change_into_costume", on_into_costume):
		print("change_into_costume connected!")
	else:
		print("change_into_costume fail!")
	if is_connected("change_out_of_costume", on_out_of_costume):
		print("change_out_of_costume connected!")
	else:
		print("change_out_of_costume fail!")


func on_into_costume():
	await get_tree().process_frame
	if owner.is_in_group("player") and player_texture:
		print("set player texture")
		if owner.get("body_sprite"):
			owner.body_sprite.texture = player_texture
	elif owner.is_in_group("enemy") and enemy_texture:
		print("set enemy texture")
		if owner.get("body_sprite"):
			owner.body_sprite.texture = enemy_texture


func on_out_of_costume():
	await get_tree().process_frame
	if owner.is_in_group("player"):
		print("revert player texture")
		if owner.get("body_sprite"):
			owner.body_sprite.texture = load("res://player/player.png")
	elif owner.is_in_group("enemy"):
		print("revert enemy texture")
		if owner.get("body_sprite"):
			owner.body_sprite.texture = load("res://enemies/baddie.png")
