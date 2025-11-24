# 📘 Analizador IPv4 utilizando **Flex + Bison**

Este proyecto implementa un **analizador de direcciones IPv4**, utilizando las herramientas **Flex** (para análisis léxico) y **Bison** (para análisis sintáctico). El objetivo es enseñar y demostrar cómo ambos componentes trabajan juntos para procesar texto estructurado y detectar errores.

Está documentado en español y con un enfoque pedagógico, como si fuera una guía para estudiantes de compiladores.

---

# 📑 Contenido

* [📘 Introducción](#-introducción)
* [🧩 1. ¿Qué es Flex?](#-1-qué-es-flex)
* [🧩 2. ¿Qué es Bison?](#-2-qué-es-bison)
* [🧠 Comunicación Flex → Bison](#-comunicación-flex--bison)
* [📄 Estructura de archivos del proyecto](#-estructura-de-archivos-del-proyecto)
* [⚙️ Compilación del proyecto](#️-compilación-del-proyecto)
* [▶️ Ejecución](#️-ejecución)
* [🧩 3. Estructura de un archivo Flex](#-3-estructura-de-un-archivo-flex)
* [🧩 4. Estructura de un archivo Bison](#-4-estructura-de-un-archivo-bison)
* [🧩 5. Manejo de errores](#-5-manejo-de-errores)
* [🧪 Ejemplos de entradas y salidas](#-ejemplos-de-entradas-y-salidas)
* [📚 Conclusión](#-conclusión)

---

# 📘 Introducción

Flex y Bison son herramientas clásicas para construir analizadores léxicos y sintácticos. Se usan ampliamente en el desarrollo de compiladores, intérpretes y sistemas que necesitan interpretar contenido estructurado.

En este proyecto aprenderás:

✔ Cómo definir tokens con expresiones regulares usando **Flex**.
✔ Cómo definir gramáticas y acciones semánticas usando **Bison**.
✔ Cómo pasar información usando `yylval` y `%union`.
✔ Cómo manejar errores léxicos y sintácticos correctamente.
✔ Cómo construir un analizador de **direcciones IPv4 válidas**.

---

# 🧩 1. ¿Qué es Flex?

**Flex (Fast Lexical Analyzer)** genera un analizador léxico en lenguaje C a partir de expresiones regulares.

### Flex produce:

* Un archivo `lex.yy.c` con la función fundamental:

  ```c
  int yylex();
  ```
* Esta función devuelve tokens a Bison.

### ¿Qué hace Flex?

Convierte texto → tokens.
Ejemplo:

```
192.168.0.10
```

Se convierte en:

* ENTERO
* PUNTO
* ENTERO
* PUNTO
* ENTERO
* PUNTO
* ENTERO

---

# 🧩 2. ¿Qué es Bison?

**Bison** es un generador de analizadores sintácticos. A partir de una gramática, produce un parser basado en reglas formales.

### Bison produce:

* `sintacticoBison.tab.c` → contiene la función `yyparse()`
* `sintacticoBison.tab.h` → contiene las definiciones de tokens

### ¿Qué hace Bison?

Convierte tokens → estructura válida o error.

---

# 🧠 Comunicación Flex → Bison

Flex y Bison se comunican mediante:

### 1. **Tokens**

Flex retorna valores que Bison reconoce:

```c
return ENTERO;
return PUNTO;
```

### 2. **Valores semánticos (`yylval`)**

Bison define:

```yacc
%union {
    int num;
    char dir[32];
}
```

Flex asigna:

```c
yylval.num = atoi(yytext);
return ENTERO;
```

---

# 📄 Estructura de archivos del proyecto

```
.
├── dist/                 # Archivos generados automáticamente
├── src/                  # Código fuente de Flex y Bison
│   ├── analex.l
│   └── sintacticoBison.y
├── scripts/              # Scripts de compilación/ejecución
├── test/                 # Archivos de prueba
│   └── input.txt
└── README.md
```

---

# ⚙️ Compilación del proyecto

Con el Makefile incluido, solo necesitas ejecutar:

```
make
```

Esto genera:

* `dist/sintacticoBison.tab.c`
* `dist/lex.yy.c`
* `analizador` (en la raíz)

---

# ▶️ Ejecución

Para analizar un archivo:

```
./analizador < test/input.txt
```

---

# 🧩 3. Estructura de un archivo Flex

Un archivo `.l` tiene esta forma:

```flex
%{
    Código C
%}

Declaraciones y ER

%%

Reglas léxicas → acciones

%%
Código extra
```

### Ejemplo de tokenización de IPv4

```flex
numero  [0-9]+
punto   \.

%%
{numero} { yylval.num = atoi(yytext); return ENTERO; }
{punto}  { return PUNTO; }
\n       { return SALTO; }
.        { return OTRO; }
%%
```

---

# 🧩 4. Estructura de un archivo Bison

```yacc
%{
    Código C
%}

%union {...}
%token ENTERO PUNTO

%%

Reglas gramaticales

%%
Funciones C
```

### Ejemplo básico

```yacc
expr:
      ENTERO PUNTO ENTERO
      { printf("Formato válido"); }
;
```

---

# 🧩 5. Manejo de errores

### Error léxico (Flex)

```c
. { printf("Error léxico: %s\n", yytext); }
```

### Error sintáctico (Bison)

```c
int yyerror(char *s) {
    printf("Error sintáctico: %s\n", s);
}
```

### Manejo robusto de direcciones incorrectas

El parser descarta todos los tokens hasta el final de línea para evitar errores en cascada.

---

# 🧪 Ejemplos de entradas y salidas

Entrada:

```
192.168.0.10
1..3.4
300.10.20.30
```

Salida:

```
192.168.0.10 → Clase C (Privada)
Error: formato inválido (1..3.4)
Error: octeto fuera de rango (300)
```

---

# 📚 Conclusión

Este proyecto demuestra cómo Flex y Bison trabajan juntos para analizar un mini-lenguaje real: direcciones IPv4.

Conceptos clave aprendidos:

* Uso de expresiones regulares para tokenizar entradas.
* Uso de gramáticas para validar estructuras.
* Manejo de valores con `%union` y `yylval`.
* Control de errores adecuado y no intrusivo.

Este repositorio puede servir como:

* base para construir analizadores más complejos,
* ejemplo didáctico para cursos universitarios,
* plantilla para futuros proyectos con Flex + Bison.

---

Si querés extender esta guía con diagramas, flujo de tokens, ejemplos visuales o una versión PDF, ¡solo pedímelo!
