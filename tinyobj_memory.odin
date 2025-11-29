package tinyobj

import rl "vendor:raylib"
import "core:c/libc"
import "core:mem"

load_obj_from_memory :: proc(file_text: string, load_to_gpu := true) -> (model: rl.Model) {
	model.transform = rl.Matrix(1)

	if len(file_text) == 0 {
		return model
	}
	o := parse_obj(file_text, "", FLAG_TRIANGULATE)
	if !o.success {
		return model
	}
	defer destroy(&o)

	if len(o.attrib.faces) == 0 {
		return model
	}
	model.meshCount = 1
	model.materialCount = 1
	
	// Alloc
	model.meshes = cast([^]rl.Mesh)libc.malloc(uint(size_of(rl.Mesh) * int(model.meshCount)))
	mem.set(model.meshes, 0, size_of(rl.Mesh) * int(model.meshCount))

	model.materials = cast([^]rl.Material)libc.malloc(uint(size_of(rl.Material) * int(model.materialCount)))
	model.meshMaterial = cast([^]i32)libc.malloc(uint(size_of(i32) * int(model.meshCount)))

	model.materials[0] = rl.LoadMaterialDefault()
	model.meshMaterial[0] = 0

	vertex_count := len(o.attrib.faces)
	triangle_count := vertex_count / 3

	mesh := &model.meshes[0]
	mesh.vertexCount = i32(vertex_count)
	mesh.triangleCount = i32(triangle_count)

	mesh.vertices  = cast([^]f32)libc.malloc(uint(int(mesh.vertexCount) * 3 * size_of(f32)))
	mesh.texcoords = cast([^]f32)libc.malloc(uint(int(mesh.vertexCount) * 2 * size_of(f32)))
	mesh.normals   = cast([^]f32)libc.malloc(uint(int(mesh.vertexCount) * 3 * size_of(f32)))

	vertices_slice  := ([^]f32)(mesh.vertices)[:mesh.vertexCount*3]
	texcoords_slice := ([^]f32)(mesh.texcoords)[:mesh.vertexCount*2]
	normals_slice   := ([^]f32)(mesh.normals)[:mesh.vertexCount*3]

	// Cache lengths to avoid repeated lookups
	n_verts := len(o.attrib.vertices)
	n_uvs   := len(o.attrib.texcoords)
	n_norms := len(o.attrib.normals)

	for i := 0; i < vertex_count; i += 1 {
		idx := o.attrib.faces[i]

		// Vertices bounds checking
		v_base := idx.v_idx * 3
		// Check against n_verts (length of the float array)
		if idx.v_idx >= 0 && (v_base + 2) < n_verts {
			vertices_slice[i*3 + 0] = o.attrib.vertices[v_base + 0]
			vertices_slice[i*3 + 1] = o.attrib.vertices[v_base + 1]
			vertices_slice[i*3 + 2] = o.attrib.vertices[v_base + 2]
		} else {
			// Fallback: Collapse invalid vertices to origin to prevent crash
			vertices_slice[i*3 + 0] = 0
			vertices_slice[i*3 + 1] = 0
			vertices_slice[i*3 + 2] = 0
		}
		// TexCoords
		if n_uvs > 0 {
			vt_base := idx.vt_idx * 2
			if idx.vt_idx >= 0 && (vt_base + 1) < n_uvs {
				texcoords_slice[i*2 + 0] = o.attrib.texcoords[vt_base + 0]
				texcoords_slice[i*2 + 1] = 1.0 - o.attrib.texcoords[vt_base + 1]
			} else {
				texcoords_slice[i*2 + 0] = 0
				texcoords_slice[i*2 + 1] = 0
			}
		}
		// Normals
		if n_norms > 0 {
			vn_base := idx.vn_idx * 3
			if idx.vn_idx >= 0 && (vn_base + 2) < n_norms {
				normals_slice[i*3 + 0] = o.attrib.normals[vn_base + 0]
				normals_slice[i*3 + 1] = o.attrib.normals[vn_base + 1]
				normals_slice[i*3 + 2] = o.attrib.normals[vn_base + 2]
			} else {
				normals_slice[i*3 + 0] = 0
				normals_slice[i*3 + 1] = 1
				normals_slice[i*3 + 2] = 0
			}
		}
	}
	if load_to_gpu {
		rl.UploadMesh(mesh, false)
	}
	return model
}