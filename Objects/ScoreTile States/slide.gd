extends State

	
func inPhysicsProcess(_delta):
	#friction
	actor.velocity *= 1 - GV.PLAYER_MU;

	#input
	var hdir = Input.get_axis("move_left", "move_right")
	var vdir = Input.get_axis("move_up", "move_down");
	var dir:Vector2 = Vector2(hdir, vdir);
	
	#accelerate
	if not GV.changing_level:
		actor.velocity += dir * GV.PLAYER_SLIDE_SPEED;

	#clamping
	if actor.velocity.length() < GV.PLAYER_SLIDE_SPEED_MIN:
		actor.velocity = Vector2.ZERO;
	
	actor.move_and_slide()
	for index in actor.get_slide_collision_count():
		var collision:KinematicCollision2D = actor.get_slide_collision(index);
		var collider = collision.get_collider();
		
		if collider.is_in_group("baddie"):
			actor.die();
		
		elif collider is ScoreTile:
			#find slide direction
			var slide_dir:Vector2 = collision.get_normal() * (-1);
			if abs(slide_dir.x) >= abs(slide_dir.y):
				slide_dir.y = 0;
			else:
				slide_dir.x = 0;
			slide_dir = slide_dir.normalized();
			
			#slide if slide_dir and player_dir agree
			if (slide_dir.x && slide_dir.x == dir.x) or (slide_dir.y && slide_dir.y == dir.y):
				collider.slide(slide_dir);

func changeParentState():
	if GV.player_snap:
		return states.snap;
	return null;
