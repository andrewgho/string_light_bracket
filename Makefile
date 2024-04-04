# Makefile - create STL files from OpenSCAD source
# Andrew Ho (andrew@zeuscat.com)

ifeq ($(shell uname), Darwin)
  OPENSCAD = /Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD
else
  OPENSCAD = openscad
endif

TARGETS = bracket.stl

all: $(TARGETS)

bracket.stl: bracket.scad
	$(OPENSCAD) -o bracket.stl bracket.scad

clean:
	@rm -f $(TARGETS)
