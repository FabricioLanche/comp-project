# Multiplicación de Matrices en MLIR con un Dialecto Propio para Strassen

Proyecto grupal del curso CS3402 Compiladores 2026-2 (UTEC), modalidad Tipo 3 de MLIR.

## Resumen

El proyecto explora el uso de MLIR como infraestructura de compilación multinivel. Sobre un caso de estudio de multiplicación de matrices, se recorre la cadena completa de bajada desde una descripción declarativa en el dialecto linalg hasta el dialecto de LLVM y su ejecución como binario nativo, pasando por affine, scf y cf. Sobre esa base se diseñó e implementó un dialecto propio llamado `sstr`, cuya única operación `sstr.matmul` delega en un pase de expansión la decisión de computar el producto con el algoritmo de Strassen o con el producto clásico, según el tamaño de corte.

El trabajo valida la corrección en tres casos de prueba, aplica optimizaciones reales de bucles (fusión y desenrollado) sobre la capa affine, y mide tiempos de compilación y de ejecución comparando el camino clásico en C++ con el camino MLIR, siempre con ambos lados al mismo nivel de optimización. El informe técnico completo vive en `docs/main.tex`.

## Estructura del proyecto

```
.
├── src/
│   ├── matmul.h              # interfaz compartida (matmul_f32 y mm_strassen)
│   ├── mm_naive.cpp          # producto de matrices clásico (camino de referencia)
│   ├── mm_strassen.cpp       # Strassen recursivo con corte (reusa matmul_f32)
│   ├── test_1/               # caso de dimensión fija (3x4x5)
│   │   ├── 01_matmul_linalg.mlir   # definición de la operación en linalg
│   │   ├── main.mlir         # punto de entrada de invocación
│   │   └── main.cpp          # camino clásico de referencia
│   ├── test_2/               # caso del dialecto propio (Strassen 64x64)
│   │   ├── 01_matmul_sstr.mlir     # definición con sstr.matmul
│   │   ├── main.mlir         # punto de entrada
│   │   ├── main.cpp
│   │   └── dialect/          # implementación del dialecto sstr
│   │       ├── build.sh      # compila sstr-opt contra libMLIR
│   │       └── src/          # SstrDialect.td, SstrOps.td, SstrStrassen.cpp
│   └── test_3/               # caso parametrizable (SIZE x SIZE x SIZE)
│       ├── 01_matmul_linalg.mlir.in  # plantilla de la definición
│       ├── main.mlir.in      # plantilla del punto de entrada
│       └── main.cpp
├── test_1.sh                 # pipeline + validación del caso fijo
├── test_2.sh                 # pipeline + validación del dialecto propio
├── test_3.sh                 # comparativa de tiempos (compilación y ejecución)
├── setup.sh                  # instalación de dependencias (apt)
├── docs/
│   ├── main.tex              # informe técnico
│   └── figs/                 # diagramas y capturas de ejecución
└── out/                      # IR generado por etapa (se regenera con los scripts)
```

## Scripts de ejecución

### Instalación de dependencias

```bash
bash setup.sh
```

Instala con `apt` el compilador, las herramientas de LLVM/MLIR 18 y las cabeceras necesarias, verifica las herramientas y compila el dialecto propio.

### Pipeline por caso de prueba

```bash
bash test_1.sh                # caso 3x4x5, cadena linalg -> affine -> scf -> cf -> llvm
bash test_2.sh                # dialecto sstr (Strassen 64x64), construcción de sstr-opt
bash test_3.sh [SIZE]         # comparativa de tiempos del caso parametrizable (def. 256)
```

Cada script genera en `out/<test>/` los archivos de IR por etapa y valida el resultado sobre un ejecutable nativo, devolviendo 0 si el matmul es correcto.

Para la comparativa se puede ajustar la cantidad de mediciones

```bash
EXEC_ITERS=5 COMPILE_ITERS=3 bash test_3.sh
```

### Detalle de la comparativa

`test_3.sh` cruza cuatro mediciones (compilación y ejecución de g++ y de MLIR) contra cuatro combinaciones (matmul normal y Strassen, con y sin optimizaciones), siempre con ambos lados al mismo nivel de optimización. En MLIR, "con optimizaciones" significa aplicar fusión y desenrollado en la capa affine antes de la bajada.

## Presentación

El enlace a la presentación del proyecto es el siguiente.

https://canva.link/zi3k7ijckpeidkl