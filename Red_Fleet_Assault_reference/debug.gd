extends Node

var debug_enabled = false
var frame_times = []
var max_frame_history = 60
var performance_data = {}
var function_timers = {}

func _ready():
	# Enable debug overlay
	if debug_enabled:
		create_debug_overlay()

func _process(delta):
	if not debug_enabled:
		return
	
	# Track frame times
	frame_times.append(delta)
	if frame_times.size() > max_frame_history:
		frame_times.pop_front()
	
	# Update performance metrics
	update_performance_metrics()
	
	# Check for frame drops
	if delta > 0.033:  # More than 30 FPS
		print("Frame drop detected: ", delta, "s (", 1.0/delta, " FPS)")

# Time a specific function or code block
func start_timer(timer_name: String):
	function_timers[timer_name] = Time.get_ticks_msec()

func end_timer(timer_name: String):
	if timer_name in function_timers:
		var elapsed = Time.get_ticks_msec() - function_timers[timer_name]
		print("Timer [", timer_name, "]: ", elapsed, "ms")
		function_timers.erase(timer_name)
		return elapsed
	else:
		print("Timer not found: ", timer_name)
		return 0

# Profile a callable function
func profile_function(func_name: String, callable: Callable, args = []):
	var start_time = Time.get_ticks_msec()
	var result = callable.callv(args)
	var elapsed = Time.get_ticks_msec() - start_time
	print("Function [", func_name, "] took: ", elapsed, "ms")
	return result

# Get current performance stats
func get_performance_stats():
	var stats = {}
	
	# Frame rate stats
	if frame_times.size() > 0:
		var avg_frame_time = 0.0
		var min_frame_time = frame_times[0]
		var max_frame_time = frame_times[0]
		
		for time in frame_times:
			avg_frame_time += time
			min_frame_time = min(min_frame_time, time)
			max_frame_time = max(max_frame_time, time)
		
		avg_frame_time /= frame_times.size()
		
		stats["avg_fps"] = 1.0 / avg_frame_time
		stats["min_fps"] = 1.0 / max_frame_time
		stats["max_fps"] = 1.0 / min_frame_time
		stats["avg_frame_time"] = avg_frame_time * 1000  # Convert to ms
	
	# Memory usage
	stats["memory_peak"] = OS.get_static_memory_peak_usage()
	
	# Engine stats - Using Performance class for Godot 4.3
	stats["render_info"] = {
		"visible_objects": Performance.get_monitor(Performance.RENDER_TOTAL_OBJECTS_IN_FRAME),
		"draw_calls": Performance.get_monitor(Performance.RENDER_TOTAL_DRAW_CALLS_IN_FRAME),
		"vertices": Performance.get_monitor(Performance.RENDER_TOTAL_PRIMITIVES_IN_FRAME),
	}
	
	return stats

# Update performance metrics
func update_performance_metrics():
	performance_data = get_performance_stats()

# Print detailed performance report
func print_performance_report():
	print("=== PERFORMANCE REPORT ===")
	var stats = get_performance_stats()
	
	print("FPS - Avg: ", "%.1f" % stats.get("avg_fps", 0))
	print("FPS - Min: ", "%.1f" % stats.get("min_fps", 0))
	print("FPS - Max: ", "%.1f" % stats.get("max_fps", 0))
	print("Frame Time - Avg: ", "%.2f" % stats.get("avg_frame_time", 0), "ms")
	
	var memory_mb = stats.get("memory_peak", 0) / 1024.0 / 1024.0
	print("Memory - Peak: ", "%.2f" % memory_mb, "MB")
	
	var render_info = stats.get("render_info", {})
	print("Visible Objects: ", render_info.get("visible_objects", 0))
	print("Draw Calls: ", render_info.get("draw_calls", 0))
	print("Vertices: ", render_info.get("vertices", 0))
	
	print("========================")

# Monitor node tree for performance issues
func analyze_node_tree(node: Node = null):
	if node == null:
		node = get_tree().root
	
	print("=== NODE TREE ANALYSIS ===")
	_analyze_node_recursive(node, 0)
	print("========================")

func _analyze_node_recursive(node: Node, depth: int):
	var indent = "  ".repeat(depth)
	var child_count = node.get_child_count()
	var process_mode = node.process_mode
	
	print(indent, node.name, " (", node.get_class(), ")")
	print(indent, "  Children: ", child_count)
	print(indent, "  Process Mode: ", process_mode)
	
	# Check for potential performance issues
	if child_count > 100:
		print(indent, "  ⚠️  HIGH CHILD COUNT - Consider pooling or culling")
	
	if node.has_method("_process") and process_mode == Node.PROCESS_MODE_INHERIT:
		print(indent, "  ⚠️  HAS _process() - Monitor for expensive operations")
	
	if node.has_method("_physics_process"):
		print(indent, "  ⚠️  HAS _physics_process() - Monitor for expensive operations")
	
	# Recursively analyze children
	for child in node.get_children():
		_analyze_node_recursive(child, depth + 1)

# Create debug overlay
func create_debug_overlay():
	var overlay = Control.new()
	overlay.name = "PerformanceOverlay"
	overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	var label = Label.new()
	label.name = "PerformanceLabel"
	label.position = Vector2(10, 10)
	label.add_theme_color_override("font_color", Color.YELLOW)
	label.add_theme_color_override("font_shadow_color", Color.BLACK)
	label.add_theme_constant_override("shadow_offset_x", 1)
	label.add_theme_constant_override("shadow_offset_y", 1)
	
	overlay.add_child(label)
	get_tree().root.add_child(overlay)
	
	# Update overlay every frame
	var timer = Timer.new()
	timer.wait_time = 0.1  # Update 10 times per second
	timer.timeout.connect(_update_overlay)
	timer.autostart = true
	add_child(timer)

func _update_overlay():
	var overlay = get_tree().root.get_node_or_null("PerformanceOverlay")
	if overlay:
		var label = overlay.get_node("PerformanceLabel")
		var stats = get_performance_stats()
		
		label.text = "FPS: %.1f\nFrame Time: %.2f ms\nMemory: %.1f MB" % [
			stats.get("avg_fps", 0),
			stats.get("avg_frame_time", 0),
			stats.get("memory_peak", 0) / 1024.0 / 1024.0
		]

# Utility functions for common debugging scenarios

# Check if a specific node is causing issues
func monitor_node_performance(node: Node, duration: float = 5.0):
	print("Monitoring node: ", node.name, " for ", duration, " seconds")
	
	var start_time = Time.get_ticks_msec()
	var initial_stats = get_performance_stats()
	
	await get_tree().create_timer(duration).timeout
	
	var end_stats = get_performance_stats()
	var elapsed = Time.get_ticks_msec() - start_time
	
	print("Node monitoring complete:")
	print("  Initial FPS: ", "%.1f" % initial_stats.get("avg_fps", 0))
	print("  Final FPS: ", "%.1f" % end_stats.get("avg_fps", 0))
	print("  FPS Change: ", "%.1f" % (end_stats.get("avg_fps", 0) - initial_stats.get("avg_fps", 0)))

# Quick performance snapshot
func snapshot():
	print("=== PERFORMANCE SNAPSHOT ===")
	var stats = get_performance_stats()
	print("Time: ", Time.get_datetime_string_from_system())
	print("FPS: ", "%.1f" % stats.get("avg_fps", 0))
	print("Frame Time: ", "%.2f ms" % stats.get("avg_frame_time", 0))
	print("Memory: ", "%.1f MB" % (stats.get("memory_peak", 0) / 1024.0 / 1024.0))
	print("===========================")

# Usage examples:
# PerformanceDebugger.start_timer("my_function")
# # Your code here
# PerformanceDebugger.end_timer("my_function")
#
# PerformanceDebugger.snapshot()
# PerformanceDebugger.print_performance_report()
# PerformanceDebugger.analyze_node_tree()
# PerformanceDebugger.monitor_node_performance($SomeNode, 10.0)
