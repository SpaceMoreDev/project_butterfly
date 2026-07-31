extends Collectable
class_name Page

@export var page_texture : Texture2D
var active: bool = true

func Interact():
	if active:
		if page_texture:
			super()
			var book : Book = Global.Player_book
			book.all_pages.append(page_texture)
			active = false
			visible = false
			$CollisionShape3D.disabled = true
