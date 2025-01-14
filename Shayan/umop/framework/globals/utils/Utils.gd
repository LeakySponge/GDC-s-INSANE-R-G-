extends Node

enum Type{TOP, BOTTOM, LEFT, RIGHT}



func random_box_position(rect: Rect2, border = false) -> Vector2:
	var position: = rect.position

	if border:
		var type: = randi() % 4
		match type:
			Type.TOP:
				position += Vector2(randf_range(0, rect.size.x), 0)
			Type.BOTTOM:
				position += Vector2(randf_range(0, rect.size.x), rect.size.y)
			Type.LEFT:
				position += Vector2(0, randf_range(0, rect.size.y))
			Type.RIGHT:
				position += Vector2(rect.size.x, randf_range(0, rect.size.y))
	else:
		position += Vector2(randf_range(0, rect.size.x), randf_range(0, rect.size.y))

	return position


func clamp_vector_to_rect(vector: Vector2, rect: Rect2) -> Vector2:
	return Vector2(clamp(vector.x, rect.position.x, rect.position.x + rect.size.x), clamp(vector.y, rect.position.y, rect.position.y + rect.size.y))
