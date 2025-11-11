@tool # Needed so it runs in editor.
extends EditorScenePostImport

func _post_import(scene):
	var mesh :MeshInstance3D = scene.get_child(0)
	print(mesh.get_children())
	mesh.create_convex_collision(true,true)
	print(mesh.get_children())
	return scene
