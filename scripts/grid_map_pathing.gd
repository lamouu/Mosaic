extends GridMap

enum Tile { WALL, START, END }

const PATH_HEIGHT: int = 0

var astar_grid := AStarGrid2D.new()
var start_tile = remove_vert(get_used_cells_by_item(Tile.START)[0])
var end_tile = remove_vert(get_used_cells_by_item(Tile.END)[0])
var wall_tiles_3d: Array[Vector3i] = get_used_cells_by_item(Tile.WALL)
var wall_tiles_2d: Array[Vector2i]


func _ready():
	var wall_tiles = convert_tiles_to_2d(wall_tiles_3d)
	astar_grid.region = find_region(wall_tiles)
	astar_grid.update()
	
	add_walls(wall_tiles)
	astar_grid.update()
	
	var path = astar_grid.get_point_path(start_tile, end_tile)
	
	#print(
	#	'start: ', start_tile,
	#	'\nstart: ', end_tile,
	#	'\npath: ', path
	#	)
	
	visualise_path(path)

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


func find_region(tiles: Array) -> Rect2i:
	var x_max := 0
	var x_min := 0
	var y_max := 0
	var y_min := 0
	
	for vec in tiles:
		var vec_x: int = vec.x
		var vec_y: int = vec.y
		
		if vec_x < x_min:
			x_min = vec_x
		elif vec_x > x_max:
			x_max = vec_x
		
		if vec_y < y_min:
			y_min = vec_y
		elif vec_y > y_max:
			y_max = vec_y
	
	return region_from_bounds(x_max, x_min, y_max, y_min)


# absoluetly fucked, using hard coded numbers atm
func region_from_bounds(x_max, x_min, y_max, y_min) -> Rect2i:
	var x = (x_max + x_min) / 2
	var y = (y_max + y_min) / 2
	var width = abs(x_max) + abs(x_min)
	var height = abs(y_max) + abs(y_min)
	
	#print(
	#	'x: ', x,
	#	'\ny: ', y,
	#	'\nwidth: ', width,
	#	'\nheight: ', height,
	#	'\nRect2i: ', Rect2i(x, y, width, height)
	#)
	
	return Rect2i(-6, -6, 12, 12)
