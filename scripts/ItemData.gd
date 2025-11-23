extends Resource
class_name ItemData

@export var id: String = ""
@export var display_name: String = ""
@export var description: String = ""
@export var icon: Texture2D          # 인벤토리 리스트용 작은 아이콘

@export var detail_image: Texture2D  # 클릭했을 때 크게 보일 이미지 (없으면 icon 재사용)
