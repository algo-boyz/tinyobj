# Odin's tiny_obj

A tiny but powerful [Wavefront .obj](http://www.fileformat.info/format/material/) loader written in **Odin**.

This is a port of the [tinyobjloader\_c](https://www.google.com/search?q=https://github.com/syoyo/tinyobjloader_c) library (which is itself a C port of the C++ [tinyobjloader](https://github.com/syoyo/tinyobjloader)).

### Current Status

**Functional.** Geometry (vertices, normals, texcoords) and Material parsing are implemented. It includes a specialized helper for loading models directly into **Raylib**.

### Features

  * **Native Odin & Dependency-Free:** Only depends on Odin std lib
  * **Raylib Integration:** Includes `load_obj_from_memory` to create `rl.Model` directly from embedded string data.
  * **Safe:** Includes bounds checking for vertex indices to prevent crashes on malformed files.
  * **Triangulation:** Built-in support for triangulating faces (`FLAG_TRIANGULATE`).

### Usage

#### Parsing of Raw Data

If you need raw vertex/face data for your own engine or processing:

```odin
import "core:fmt"
import "tinyobj"

main :: proc() {
    obj_data := `... string content of obj ...`

    // Parse the data
    // Flags: tinyobj.FLAG_TRIANGULATE | tinyobj.FLAG_None
    result := tinyobj.parse_obj(obj_data, "", tinyobj.FLAG_TRIANGULATE)
    
    if !result.success {
        fmt.println("Failed to parse OBJ")
        return
    }
    // Clean up dynamic arrays when done
    defer tinyobj.destroy_result(&result)

    fmt.printf("Vertices: %d\n", len(result.attrib.vertices) / 3)
    fmt.printf("Faces: %d\n", len(result.attrib.faces))

    for shape in result.shapes {
        fmt.printf("Shape: %s\n", shape.name)
    }
}
```

#### Raylib Integration

This package includes a helper to load an OBJ string directly into a `rl.Model`.

**Note:** This helper uses `libc.malloc` for mesh data allocation, ensuring compatibility with Raylib's `UnloadModel` (which uses C `free`).

```odin
import rl "vendor:raylib"
import "tinyobj"

main :: proc() {
    rl.InitWindow(800, 600, "TinyObj Odin")
    defer rl.CloseWindow()

    obj_string := `...` // Load your file to string

    // load_to_gpu = true (default) uploads data immediately.
    // Set to false for headless testing.
    model := tinyobj.load_obj_from_memory(obj_string, true)
    defer rl.UnloadModel(model) // Safe to call Raylib unload

    for !rl.WindowShouldClose() {
        rl.BeginDrawing()
        rl.ClearBackground(rl.RAYWHITE)
        rl.DrawModel(model, {0, 0, 0}, 1.0, rl.WHITE)
        rl.EndDrawing()
    }
}
```

### Tests

The project includes unit tests covering parsing logic and the Raylib memory loader.

To run the tests:

```bash
odin test .
```

#### **MIT License**