extends Character

var animTree: AnimationTree

func _ready() -> void:
	super()
	animTree = self.get_node("SubViewportContainer").get_node("SubViewport").get_node("ModelRoot").get_node("BuggyBoi2").get_node("AnimationTree")

func attackAnim() -> void:
	super()
	animTree.set("parameters/BlendTree/Attack/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)

func _physics_process(delta: float) -> void:
	super(delta)
	
	animTree.set("parameters/BlendTree/MeleeWindup/blend_amount", meleeWindup)
	
	var walkBlendAmount = self.velocity.length() / maxSpeed
	animTree.set("parameters/BlendTree/IdleToWalk/blend_amount", walkBlendAmount)
	
