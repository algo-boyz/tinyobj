package tinyobj

import rl "vendor:raylib"
import "core:fmt"
import "core:testing"

// Embedded OBJ file eg for web demos
CAPSULE_OBJ :: `v 0.82165808 -0.82165808 -1.0579772e-18\nv 0.82165808 -0.58100000 0.58100000\n\
v 0.82165808 8.7595780e-17 0.82165808\nv 0.82165808 0.58100000 0.58100000\n\
v 0.82165808 0.82165808 9.9566116e-17\nv 0.82165808 0.58100000 -0.58100000\n\
v 0.82165808 2.8884397e-16 -0.82165808\nv 0.82165808 -0.58100000 -0.58100000\n\
v -0.82165808 -0.82165808 -1.0579772e-18\nv -0.82165808 -0.58100000 0.58100000\n\
v -0.82165808 -1.3028313e-17 0.82165808\nv -0.82165808 0.58100000 0.58100000\n\
v -0.82165808 0.82165808 9.9566116e-17\nv -0.82165808 0.58100000 -0.58100000\n\
v -0.82165808 1.8821987e-16 -0.82165808\nv -0.82165808 -0.58100000 -0.58100000\n\
v 1.16200000 1.5874776e-16 -1.0579772e-18\nv -1.16200000 1.6443801e-17 -1.0579772e-18\n\
v -9.1030792e-3 -1.15822938 -1.0579772e-18\nv 9.1030792e-3 -1.15822938 -1.0579772e-18\n\
v 9.1030792e-3 -0.81899185 0.81899185\nv -9.1030792e-3 -0.81899185 0.81899185\n\
v 9.1030792e-3 1.7232088e-17 1.15822938\nv -9.1030792e-3 1.6117282e-17 1.15822938\n\
v 9.1030792e-3 0.81899185 0.81899185\nv -9.1030792e-3 0.81899185 0.81899185\n\
v 9.1030792e-3 1.15822938 1.4078421e-16\nv -9.1030792e-3 1.15822938 1.4078421e-16\n\
v 9.1030792e-3 0.81899185 -0.81899185\nv -9.1030792e-3 0.81899185 -0.81899185\n\
v 9.1030792e-3 3.0091647e-16 -1.15822938\nv -9.1030792e-3 2.9980166e-16 -1.15822938\n\
v 9.1030792e-3 -0.81899185 -0.81899185\nv -9.1030792e-3 -0.81899185 -0.81899185\n\
vn 0.71524683 -0.69887193 -2.5012597e-16\nvn 0.61185516 -0.55930013 0.55930013\n\
vn 0.71524683 0.0000000e+0 0.69887193\nvn 0.61185516 0.55930013 0.55930013\n\
vn 0.71524683 0.69887193 1.5632873e-17\nvn 0.61185516 0.55930013 -0.55930013\n\
vn 0.71524683 6.2531494e-17 -0.69887193\nvn 0.61185516 -0.55930013 -0.55930013\n\
vn -0.71524683 -0.69887193 -2.5012597e-16\nvn -0.61185516 -0.55930013 0.55930013\n\
vn -0.71524683 0.0000000e+0 0.69887193\nvn -0.61185516 0.55930013 0.55930013\n\
vn -0.71524683 0.69887193 4.6898620e-17\nvn -0.61185516 0.55930013 -0.55930013\n\
vn -0.71524683 4.6898620e-17 -0.69887193\nvn -0.61185516 -0.55930013 -0.55930013\n\
vn 1.00000000 1.5208752e-17 -2.6615316e-17\nvn -1.00000000 -1.5208752e-17 2.2813128e-17\n\
vn -0.19614758 -0.98057439 -2.2848712e-16\nvn 0.26047011 -0.96548191 -2.4273177e-16\n\
vn 0.13072302 -0.70103905 0.70103905\nvn -0.19614758 -0.69337080 0.69337080\n\
vn 0.22349711 5.9825845e-2 0.97286685\nvn -0.22349711 -5.9825845e-2 0.97286685\n\
vn 0.15641931 0.75510180 0.63667438\nvn -0.15641931 0.63667438 0.75510180\n\
vn 0.22349711 0.97286685 -5.9825845e-2\nvn -0.22349711 0.97286685 5.9825845e-2\n\
vn 0.15641931 0.63667438 -0.75510180\nvn -0.15641931 0.75510180 -0.63667438\n\
vn 0.22349711 -5.9825845e-2 -0.97286685\nvn -0.22349711 5.9825845e-2 -0.97286685\n\
vn 0.15641931 -0.75510180 -0.63667438\nvn -0.15641931 -0.63667438 -0.75510180\n\
f 1//1 17//17 2//2\nf 1//1 20//20 8//8\nf 2//2 17//17 3//3\nf 2//2 20//20 1//1\n\
f 2//2 23//23 21//21\nf 3//3 17//17 4//4\nf 3//3 23//23 2//2\nf 4//4 17//17 5//5\n\
f 4//4 23//23 3//3\nf 4//4 27//27 25//25\nf 5//5 17//17 6//6\nf 5//5 27//27 4//4\n\
f 6//6 17//17 7//7\nf 6//6 27//27 5//5\nf 6//6 31//31 29//29\nf 7//7 17//17 8//8\n\
f 7//7 31//31 6//6\nf 8//8 17//17 1//1\nf 8//8 20//20 33//33\nf 8//8 31//31 7//7\n\
f 9//9 18//18 16//16\nf 9//9 19//19 10//10\nf 10//10 18//18 9//9\nf 10//10 19//19 22//22\n\
f 10//10 24//24 11//11\nf 11//11 18//18 10//10\nf 11//11 24//24 12//12\nf 12//12 18//18 11//11\n\
f 12//12 24//24 26//26\nf 12//12 28//28 13//13\nf 13//13 18//18 12//12\nf 13//13 28//28 14//14\n\
f 14//14 18//18 13//13\nf 14//14 28//28 30//30\nf 14//14 32//32 15//15\nf 15//15 18//18 14//14\n\
f 15//15 32//32 16//16\nf 16//16 18//18 15//15\nf 16//16 19//19 9//9\nf 16//16 32//32 34//34\n\
f 19//19 33//33 20//20\nf 20//20 21//21 19//19\nf 21//21 20//20 2//2\nf 21//21 24//24 22//22\n\
f 22//22 19//19 21//21\nf 22//22 24//24 10//10\nf 23//23 26//26 24//24\nf 24//24 21//21 23//23\n\
f 25//25 23//23 4//4\nf 25//25 28//28 26//26\nf 26//26 23//23 25//25\nf 26//26 28//28 12//12\n\
f 27//27 30//30 28//28\nf 28//28 25//25 27//27\nf 29//29 27//27 6//6\nf 29//29 32//32 30//30\n\
f 30//30 27//27 29//29\nf 30//30 32//32 14//14\nf 31//31 34//34 32//32\nf 32//32 29//29 31//31\n\
f 33//33 19//19 34//34\nf 33//33 31//31 8//8\nf 34//34 19//19 16//16\nf 34//34 31//31 33//33
`

@(test)
test_load_obj_from_memory :: proc(t: ^testing.T) {
    // Pass false to skip GPU upload (prevents Segfault in test)
    model := load_obj_from_memory(CAPSULE_OBJ, false)
    defer rl.UnloadModel(model)
    
    // Verify model was loaded
    testing.expect(t, model.meshCount == 1, "Model should have 1 mesh")
    
    mesh := model.meshes[0]
    testing.expect(t, mesh.vertexCount > 0, "Mesh should have vertices")
    testing.expect(t, mesh.triangleCount > 0, "Mesh should have triangles")
    
    expected_faces := 160 // Counting 'f' lines in the OBJ
    testing.expect(t, mesh.triangleCount == i32(expected_faces), 
        fmt.tprintf("Expected %d triangles, got %d", expected_faces, mesh.triangleCount))
    testing.expect(t, mesh.vertexCount == i32(expected_faces * 3),
        fmt.tprintf("Expected %d vertices, got %d", expected_faces * 3, mesh.vertexCount))
    
    // Verify that vertex data was allocated
    testing.expect(t, mesh.vertices != nil, "Vertices should be allocated")
    testing.expect(t, mesh.normals != nil, "Normals should be allocated")
    testing.expect(t, mesh.texcoords != nil, "Texcoords should be allocated")
    
    fmt.println("✓ Capsule OBJ loaded successfully")
    fmt.printf("  - Vertices: %d\n", mesh.vertexCount)
    fmt.printf("  - Triangles: %d\n", mesh.triangleCount)
}

@(test)
test_load_obj_minimal :: proc(t: ^testing.T) {
    minimal_obj := `v 0.0 0.0 0.0
v 1.0 0.0 0.0
v 0.5 1.0 0.0
vn 0.0 0.0 1.0
vn 0.0 0.0 1.0
vn 0.0 0.0 1.0
f 1//1 2//2 3//3
`
    // Pass false to skip GPU upload (prevents Segfault in test)
    model := load_obj_from_memory(minimal_obj, false) 
    defer rl.UnloadModel(model)
    
    testing.expect(t, model.meshCount == 1, "Should have 1 mesh")
    
    mesh := model.meshes[0]
    testing.expect(t, mesh.triangleCount == 1, "Should have 1 triangle")
    testing.expect(t, mesh.vertexCount == 3, "Should have 3 vertices")
    
    v0_x := mesh.vertices[0]
    v0_y := mesh.vertices[1]
    v0_z := mesh.vertices[2]
    testing.expect(t, v0_x == 0.0 && v0_y == 0.0 && v0_z == 0.0, 
        "First vertex should be at origin")
}

@(test)
test_load_obj_empty_string :: proc(t: ^testing.T) {
    model := load_obj_from_memory("")
    defer rl.UnloadModel(model)
    
    testing.expect(t, model.meshCount == 0, "Empty string should produce empty model")
    fmt.println("✓ Empty string handled correctly")
}