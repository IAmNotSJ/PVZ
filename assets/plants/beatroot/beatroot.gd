class_name Beatroot
extends Plant

@export_category("Parameters")
@export var sight:Area2D

@export_category("Stats")
@export var attacking_interval:float = 0.05
@export var attack:float = 0.1

var attacking_timer:float = 0


enum States {
	WATCHING,
	ATTACKING
}
var cur_state:States = States.WATCHING

func activate():
	super()
# Need to check every frame for zombie rather than on enter because there can be multiple? I think? 
func _process(delta):
	if activated:
		match cur_state:
			States.WATCHING:
				if sight.has_overlapping_areas():
					cur_state = States.ATTACKING
					animationPlayer.play('attack')
			States.ATTACKING:
				if attacking_timer <= 0:
					attacking_timer = attacking_interval
					for area in sight.get_overlapping_areas():
						var zombie = area.owner
						zombie.take_damage(attack, Enums.DAMAGE_PHYSICAL)
				else:
					attacking_timer -= delta
				if !sight.has_overlapping_areas():
					cur_state = States.WATCHING
					animationPlayer.play('dance')
