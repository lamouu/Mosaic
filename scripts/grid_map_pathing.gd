extends GridMap

enum Tile { WALL, START, END }

const PATH_HEIGHT: int = 0
const REGION_HEIGHT: int = 12
const REGION_WIDTH: int = 6


var astar_grid := AStarGrid2D.new()
var start_tile = remove_vert(get_used_cells_by_item(Tile.START)[0])
var end_tile = remove_vert(get_used_cells_by_item(Tile.END)[0])
var wall_tiles_3d: Array[Vector3i] = get_used_cells_by_item(Tile.WALL)
var wall_tiles_2d: Array[Vector2i]


func _ready():
	var wall_tiles = convert_tiles_to_2d(wall_tiles_3d)
	
	@warning_ignore("integer_division")
	astar_grid.region = Rect2i(- REGION_WIDTH / 2, - REGION_HEIGHT / 2, REGION_WIDTH, REGION_HEIGHT)
	astar_grid.update()
	
	add_walls(wall_tiles)
	astar_grid.update()
	
	astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_ONLY_IF_NO_OBSTACLES
	
	var path = astar_grid.get_point_path(start_tile, end_tile)
	
	if path.is_empty():
		print("No viable path")
	
	#print(
	#	'start: ', start_tile,
	#	'\nstart: ', end_tile,
	#	'\npath: ', path
	#	)
	
	
	visualise_region()
	visualise_path(path)

# lmfao
func visualise_region() -> void:
	var path_curve = Curve3D.new()
	
	@warning_ignore("integer_division")
	var region_corners = [
		Vector2i(- REGION_WIDTH / 2, - REGION_HEIGHT / 2),
		Vector2i(- REGION_WIDTH / 2, REGION_HEIGHT / 2 - 1),
		Vector2i(REGION_WIDTH / 2 - 1,  REGION_HEIGHT / 2 - 1),
		Vector2i(REGION_WIDTH / 2 - 1, - REGION_HEIGHT / 2),
		Vector2i(- REGION_WIDTH / 2, - REGION_HEIGHT / 2)
	]

	for corner in region_corners:
		var border_3d = add_vert(corner)
		var border_local = map_to_local(border_3d)
		
		path_curve.add_point(border_local)
	
	$BorderVisualisation.curve = path_curve
	$BorderVisualisation.debug_custom_color = Color(0.71, 0.0, 0.0, 1.0)


func visualise_path(path):
	var path_3d = convert_tiles_to_3d(path)
	var local_path = convert_grid_to_local(path_3d)
	
	var path_curve = Curve3D.new()
	
	for point in local_path:
		path_curve.add_point(point)
	
	$PathVisualisation.curve = path_curve
	
	return




func add_walls(wall_tiles: Array[Vector2i]) -> void:
	for wall in wall_tiles:
		astar_grid.set_point_solid(wall)


func convert_grid_to_local(tiles: Array[Vector3i]) -> Array[Vector3]:
	var local: Array[Vector3]
	
	for tile in tiles:
		var tile_local = map_to_local(tile)
		local.append(tile_local)
	
	return local


func convert_tiles_to_2d(tiles_3d: Array[Vector3i]) -> Array[Vector2i]:
	var tiles_2d: Array[Vector2i]
	
	for tile_3d in tiles_3d:
		var tile_2d = remove_vert(tile_3d)
		tiles_2d.append(tile_2d)
	
	return tiles_2d


func convert_tiles_to_3d(tiles_2d: Array[Vector2i]) -> Array[Vector3i]:
	var tiles_3d: Array[Vector3i]
	
	for tile_2d in tiles_2d:
		var tile_3d = add_vert(tile_2d)
		tiles_3d.append(tile_3d)
	
	return tiles_3d


func add_vert(v2: Vector2i) -> Vector3i:
	return Vector3i(v2.x, PATH_HEIGHT, v2.y)


func remove_vert(v3: Vector3i) -> Vector2i:
	return Vector2i(v3.x, v3.z)
