extends CharacterBody2D

@export var speed: float = 200.0
@onready var sprite: Sprite2D = $Sprite2D

# 각 방향별 3프레임
@export var sprite_up_frames: Array[Texture] = []
@export var sprite_down_frames: Array[Texture] = []
@export var sprite_left_frames: Array[Texture] = []
@export var sprite_right_frames: Array[Texture] = []
@export var sprite_up_left_frames: Array[Texture] = []
@export var sprite_up_right_frames: Array[Texture] = []
@export var sprite_down_left_frames: Array[Texture] = []
@export var sprite_down_right_frames: Array[Texture] = []

@export var frame_time: float = 0.5
var _frame_timer: float = 0.0
var _frame_index: int = 1
var _current_frames: Array[Texture] = []
var _last_direction: Vector2 = Vector2.DOWN


func _ready():
	add_to_group("Player")


func _physics_process(delta):

	# ----------------------------------------------------
	# ⛔ 대화 중이면 이동 금지 + space로 대사 넘기기
	# ----------------------------------------------------
	if DialogueManager.talking:
		# space 입력 감지 → 대사 넘기기
		if Input.is_action_just_pressed("ui_accept"):
			DialogueManager.next()

		# 플레이어 이동 막기
		velocity = Vector2.ZERO
		move_and_slide()
		return
	# ----------------------------------------------------


	var direction := Vector2.ZERO

	# 방향키 입력
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_down"):
		direction.y += 1
	if Input.is_action_pressed("ui_up"):
		direction.y -= 1

	if direction != Vector2.ZERO:
		direction = direction.normalized()
		_last_direction = direction
		_current_frames = _get_frames_for_direction(direction)

		if _current_frames.size() >= 3:
			_frame_timer += delta
			if _frame_timer >= frame_time:
				_frame_timer = 0.0
				_frame_index = 2 if _frame_index == 1 else 1
			sprite.texture = _current_frames[_frame_index]
		else:
			if _current_frames.size() > 0:
				sprite.texture = _current_frames[0]
	else:
		var frames = _get_frames_for_direction(_last_direction)
		if frames.size() > 0:
			sprite.texture = frames[0]
		_frame_index = 1
		_frame_timer = 0.0

	velocity = direction * speed
	move_and_slide()


# === 방향별 프레임 배열 선택 ===
func _get_frames_for_direction(direction: Vector2) -> Array[Texture]:
	if direction.x > 0.5 and direction.y < -0.5:
		return sprite_up_right_frames
	elif direction.x < -0.5 and direction.y < -0.5:
		return sprite_up_left_frames
	elif direction.x > 0.5 and direction.y > 0.5:
		return sprite_down_right_frames
	elif direction.x < -0.5 and direction.y > 0.5:
		return sprite_down_left_frames
	elif direction.y < -0.5:
		return sprite_up_frames
	elif direction.y > 0.5:
		return sprite_down_frames
	elif direction.x < -0.5:
		return sprite_left_frames
	elif direction.x > 0.5:
		return sprite_right_frames
	return []
