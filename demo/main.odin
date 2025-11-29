package main

import "core:fmt"
import "core:os"
import "../"

main :: proc() {
	// Read .obj file into string
	data, ok := os.read_entire_file("../../assets/capsule.obj")
	if !ok {
		fmt.println("Failed to read file")
		return
	}
	defer delete(data)

	// Parse
	content := string(data)
	// We pass "" as base_dir, implies current directory for .mtl search
	result := tinyobj.parse_obj(content, "", tinyobj.FLAG_TRIANGULATE)
	
	if !result.success {
		fmt.println("Failed to parse OBJ")
		return
	}
	defer tinyobj.destroy(&result)

	fmt.printf("# of vertices  = %d\n", len(result.attrib.vertices) / 3)
	fmt.printf("# of normals   = %d\n", len(result.attrib.normals) / 3)
	fmt.printf("# of texcoords = %d\n", len(result.attrib.texcoords) / 2)
	fmt.printf("# of shapes    = %d\n", len(result.shapes))
	fmt.printf("# of materials = %d\n", len(result.materials))

	// Iterate over shapes
	for shape in result.shapes {
		fmt.printf("Shape: %s\n", shape.name)
		
		// Iterate over faces in this shape
		index_offset := 0
		for f := 0; f < shape.length; f += 1 {
			current_face_idx := shape.face_offset + f
			num_verts := result.attrib.face_num_verts[current_face_idx]
			mat_id := result.attrib.material_ids[current_face_idx]

			fmt.printf("  Face %d (Material ID: %d): ", f, mat_id)
			
			// Print vertex indices for this face
			for v := 0; v < num_verts; v += 1 {
				idx := result.attrib.faces[index_offset + v]
				fmt.printf("%d/%d/%d ", idx.v_idx, idx.vt_idx, idx.vn_idx)
			}
			fmt.println("")
			
			index_offset += num_verts
		}
	}
}