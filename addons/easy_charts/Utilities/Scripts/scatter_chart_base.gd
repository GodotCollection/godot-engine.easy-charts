tool
extends Chart
class_name ScatterChartBase

# Base Class to be inherited by any chart that wants to plot points or series 
# of points in a two-variable space. It handles basic data structure and grid 
# layout and leaves to child classes the more specific behaviour.

var identifiers : Array

#Stored in the form of [[min_func1, min_func2, min_func3, ...], [max_func1, max_func2, ...]]
var x_domain := [[], []]
var y_domain := [[], []]

var x_range
var y_range

var property_list = [
	# Chart Properties
	{
		"hint": PROPERTY_HINT_NONE,
		"usage": PROPERTY_USAGE_CATEGORY,
		"name": "ScatterChartBase", #TODO Changue this in the child classes
		"type": TYPE_STRING
	},
	{
		"hint": PROPERTY_HINT_NONE,
		"usage": PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_SCRIPT_VARIABLE,
		"name": "Chart_Properties/are_values_columns",
		"type": TYPE_BOOL
	},
	{
		"hint": PROPERTY_HINT_RANGE,
		"hint_string": "-1,100,1",
		"usage": PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_SCRIPT_VARIABLE,
		"name": "Chart_Properties/labels_index",
		"type": TYPE_INT
	},
	{
		"hint": PROPERTY_HINT_NONE,
		"usage": PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_SCRIPT_VARIABLE,
		"name": "Chart_Properties/show_x_values_as_labels",
		"type": TYPE_BOOL
	},
	
	# Chart Display
	{
		"hint": PROPERTY_HINT_RANGE,
		"hint_string": "0.001, 10",
		"usage": PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_SCRIPT_VARIABLE,
		"name": "Chart_Display/x_decim",
		"type": TYPE_REAL
	},
	{
		"hint": PROPERTY_HINT_RANGE,
		"hint_string": "0.001, 10",
		"usage": PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_SCRIPT_VARIABLE,
		"name": "Chart_Display/y_decim",
		"type": TYPE_REAL
	},
	
	# Chart Style
	{ 
		"hint": 24, 
		"hint_string": ("%d/%d:%s"
		%[TYPE_INT, PROPERTY_HINT_ENUM,
		PoolStringArray(PointShapes.keys()).join(",")]),
		"name": "Chart_Style/points_shape", 
		"type": TYPE_ARRAY, 
		"usage": PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_SCRIPT_VARIABLE
	},
	{
		"hint": PROPERTY_HINT_NONE,
		"usage": PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_SCRIPT_VARIABLE,
		"name": "Chart_Style/function_colors",
		"type": TYPE_COLOR_ARRAY
	},
	{
		"hint": PROPERTY_HINT_NONE,
		"usage": PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_SCRIPT_VARIABLE,
		"name": "Chart_Style/box_color",
		"type": TYPE_COLOR
	},
	{
		"hint": PROPERTY_HINT_NONE,
		"usage": PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_SCRIPT_VARIABLE,
		"name": "Chart_Style/v_lines_color",
		"type": TYPE_COLOR
	},
	{
		"hint": PROPERTY_HINT_NONE,
		"usage": PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_SCRIPT_VARIABLE,
		"name": "Chart_Style/h_lines_color",
		"type": TYPE_COLOR
	},
	{
		"class_name": "Font",
		"hint": PROPERTY_HINT_RESOURCE_TYPE,
		"hint_string": "Font",
		"usage": PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_SCRIPT_VARIABLE,
		"name": "Chart_Style/font",
		"type": TYPE_OBJECT
	},
	{
		"class_name": "Font",
		"hint": PROPERTY_HINT_RESOURCE_TYPE,
		"hint_string": "Font",
		"usage": PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_SCRIPT_VARIABLE,
		"name": "Chart_Style/bold_font",
		"type": TYPE_OBJECT
	},
	{
		"hint": PROPERTY_HINT_NONE,
		"usage": PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_SCRIPT_VARIABLE,
		"name": "Chart_Style/font_color",
		"type": TYPE_COLOR
	},
	{
		"hint": PROPERTY_HINT_NONE,
		"usage": PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_SCRIPT_VARIABLE,
		"name": "Chart_Style/use_template",
		"type": TYPE_BOOL
	},
	{
		"hint": PROPERTY_HINT_ENUM,
		"hint_string": PoolStringArray(Utilities.templates.keys()).join(","),
		"usage": PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_SCRIPT_VARIABLE,
		"name": "Chart_Style/template",
		"type": TYPE_INT
	},
	
	# Chart Modifiers
	{
		"hint": PROPERTY_HINT_NONE,
		"usage": PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_SCRIPT_VARIABLE,
		"name": "Chart_Modifiers/treshold",
		"type": TYPE_VECTOR2
	},
	{
		"hint": PROPERTY_HINT_NONE,
		"usage": PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_SCRIPT_VARIABLE,
		"name": "Chart_Modifiers/only_disp_values",
		"type": TYPE_VECTOR2
	},
	{
		"hint": PROPERTY_HINT_NONE,
		"usage": PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_SCRIPT_VARIABLE,
		"name": "Chart_Modifiers/invert_chart",
		"type": TYPE_BOOL
	},
	]


func plot_function(x:Array, y:Array, id=""):
	pass


func update_function(x:Array, y:Array, id=""):
	pass


func delete_function(id):
	pass


func generate_identifier():
	return "f%d" % (identifiers.size() + 1)


func structure_datas(database : Array):
	# @labels_index can be either a column or a row relative to x values
	# @y_values can be either a column or a row relative to y values
	are_values_columns = invert_chart != are_values_columns
	if are_values_columns:
		for row in database.size():
			var t_vals : Array
			for column in database[row].size():
				if column == labels_index:
					var x_data = database[row][column]
					if typeof(x_data) == TYPE_INT  or typeof(x_data) == TYPE_REAL:
						x_datas.append(x_data as float)
					else:
						x_datas.append(x_data.replace(",", ".") as float)
				else:
					if row != 0:
						var y_data = database[row][column]
						if typeof(y_data) == TYPE_INT  or typeof(y_data) == TYPE_REAL:
							t_vals.append(y_data as float)
						else:
							t_vals.append(y_data.replace(",",".") as float)
					else:
						y_labels.append(str(database[row][column]))
			if not t_vals.empty():
					y_datas.append(t_vals)
		x_label = str(x_datas.pop_front())
	else:
		for row in database.size():
			if row == labels_index:
				x_datas = (database[row])
				x_label = x_datas.pop_front() as String
			else:
				var values = database[row] as Array
				y_labels.append(values.pop_front() as String)
				y_datas.append(values)
		for data in y_datas:
			for value in data.size():
				data[value] = data[value] as float


func calculate_range(id):
	# Calculate the domain of the given function in the x and y axis
	# and updates the range value
	
	var function = identifiers.find(id)
	
	y_domain[0][function] = y_datas[function].min()
	y_domain[1][function] = y_datas[function].max()
	
	x_domain[0][function] = x_datas[function].min()
	x_domain[1][function] = x_datas[function].max()
	
	# Chose the min/max from each function
	y_range = [y_domain[0].min() if not origin_at_zero else 0, y_domain[1].max()]
	x_range = [x_domain[0].min() if not origin_at_zero else 0, x_domain[1].max()]


func calculate_tics():
	y_margin_min = y_range[0]
	var y_margin_max = y_range[1]
	v_dist = y_decim * pow(10.0, str(y_margin_max).split(".")[0].length() - 1)
	var multi = 0
	var p = (v_dist * multi) + y_margin_min
	y_chors.append(p as String)
	while p < y_margin_max:
		multi += 1
		p = (v_dist * multi) + y_margin_min
		y_chors.append(p as String)
	
	x_margin_min = x_range[0]
	var x_margin_max = x_range[1]
	if not show_x_values_as_labels:
		h_dist = x_decim * pow(10.0, str(x_margin_max).split(".")[0].length() - 1)
		multi = 0
		p = (h_dist * multi) + x_margin_min
		x_labels.append(p as String)
		while p < x_margin_max:
			multi += 1
			p = (h_dist * multi) + x_margin_min
			x_labels.append(p as String)
	
	if not show_x_values_as_labels:
		x_chors = x_labels
	else:
		for function in identifiers.size():
			for value in x_datas[function]:
				if not x_chors.has(value as String): #Don't append repeated values
					x_chors.append(value as String)


func build_chart():
	SIZE = get_size() - Vector2(OFFSET.x, 0)
	origin = Vector2(OFFSET.x, SIZE.y - OFFSET.y)
	
	OFFSET.x = str(y_range[1]).length() * font_size
	OFFSET.y = font_size * 2


func calculate_pass():
	# Calculate distance in pixel between 2 consecutive values/datas
	x_pass = (SIZE.x - OFFSET.x) / (x_chors.size() - 1 if x_chors.size() > 1 else x_chors.size())
	y_pass = (origin.y - ChartName.get_rect().size.y * 2) / (y_chors.size() - 1)


func calculate_coordinates():
	point_values.clear()
	point_positions.clear()
	point_values.resize(identifiers.size())
	point_positions.resize(identifiers.size())
	
	for function in identifiers.size():
		for val in function.size():
			var value_x = (x_datas[function][val] - x_margin_min) * x_pass / h_dist
			var value_y = (y_datas[function][val] - y_margin_min) * y_pass / v_dist
	
			point_values[function].append([x_datas[function][val], y_datas[function][val]])
			point_positions[function].append(Vector2(value_x + origin.x, origin.y - value_y))


func draw_grid():
	# ascisse
	for p in x_chors.size():
		var point : Vector2 = origin + Vector2(p * x_pass, 0)
		# v grid
		draw_line(point, -Vector2(0, SIZE.y - OFFSET.y), v_lines_color, 0.2, true)
		# ascisse
		draw_line(point - Vector2(0, 5), point, v_lines_color, 1, true)
		draw_string(font, point + Vector2(-const_width/2 * x_chors[p].length(), 
				font_size + const_height), x_chors[p], font_color)
	
	# ordinate
	for p in y_chors.size():
		var point : Vector2 = origin - Vector2(0, p * y_pass)
		# h grid
		draw_line(point, point + Vector2(SIZE.x - OFFSET.x, 0), h_lines_color, 0.2, true)
		# ordinate
		draw_line(point, point + Vector2(5, 0), h_lines_color, 1, true)
		draw_string(font, point - Vector2(y_chors[p].length() * const_width +
				font_size, -const_height), y_chors[p], font_color)


func draw_chart_outlines():
	draw_line(origin, SIZE-Vector2(0, OFFSET.y), box_color, 1, true)
	draw_line(origin, Vector2(OFFSET.x, 0), box_color, 1, true)
	draw_line(Vector2(OFFSET.x, 0), Vector2(SIZE.x, 0), box_color, 1, true)
	draw_line(Vector2(SIZE.x, 0), SIZE - Vector2(0, OFFSET.y), box_color, 1, true)


func draw_points():
	var defined_colors : bool = false
	if function_colors.size():
		defined_colors = true
	
	for function in point_values.size():
		var PointContainer : Control = Control.new()
		Points.add_child(PointContainer)
		
		for function_point in point_values[function].size():
			var point : Point = point_node.instance()
			point.connect("_point_pressed",self,"point_pressed")
			point.connect("_mouse_entered",self,"show_data")
			point.connect("_mouse_exited",self,"hide_data")
			
			point.create_point(points_shape[function], function_colors[function], 
			Color.white, point_positions[function][function_point], 
			point.format_value(point_values[function][function_point], false, false), 
			y_labels[function] as String)
			
			PointContainer.add_child(point)


func draw_treshold():
	if v_dist != 0:
		treshold_draw = Vector2((treshold.x * x_pass) + origin.x ,origin.y - ((treshold.y * y_pass)/v_dist))
		if treshold.y != 0:
			draw_line(Vector2(origin.x, treshold_draw.y), Vector2(SIZE.x, treshold_draw.y), Color.red, 0.4, true)
		if treshold.x != 0:
			draw_line(Vector2(treshold_draw.x, 0), Vector2(treshold_draw.x, SIZE.y - OFFSET.y), Color.red, 0.4, true)