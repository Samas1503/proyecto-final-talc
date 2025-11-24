# ===============================
#   Makefile para Analizador IPv4
# ===============================

SRC := src
DIST := dist
EXEC := main

BISON_SRC := $(SRC)/sintacticoBison.y
FLEX_SRC := $(SRC)/analex.l

BISON_C := $(DIST)/sintacticoBison.tab.c
BISON_H := $(DIST)/sintacticoBison.tab.h
FLEX_C  := $(DIST)/lex.yy.c

CC := gcc
CFLAGS := -Wall -Wextra -O2
LIBS := -lfl

# Regla por defecto
all: $(EXEC)

# Crear dist si no existe
$(DIST):
	mkdir -p $(DIST)

# Ejecutar Bison
$(BISON_C) $(BISON_H): $(BISON_SRC) | $(DIST)
	bison -d $(BISON_SRC) -o $(BISON_C)

# Ejecutar Flex
$(FLEX_C): $(FLEX_SRC) | $(DIST)
	flex -o $(FLEX_C) $(FLEX_SRC)

# Compilar ejecutable
$(EXEC): $(BISON_C) $(FLEX_C)
	$(CC) $(BISON_C) $(FLEX_C) -o $(EXEC) $(LIBS)

# Limpiar archivos generados
clean:
	rm -f $(DIST)/*.c
	rm -f $(DIST)/*.h
	rm -f $(EXEC)

# Limpiar completamente la carpeta dist
distclean: clean
	rm -rf $(DIST)

# Atajos para probar desde test/
run: $(EXEC)
	./$(EXEC) < test/input.txt

.PHONY: all clean distclean run
