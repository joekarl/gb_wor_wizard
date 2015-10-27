
__CURRENT_DIR=$(shell pwd)

OBJ_DIR:=$(__CURRENT_DIR)/obj
SDCC:=sdcc
SDCC_INCLUDE:=/usr/local/share/sdcc/include
GBDK_INCLUDE:=$(__CURRENT_DIR)/gbdk/include
GBDK_LIB:=$(__CURRENT_DIR)/gbdk/lib

SRC:=$(wildcard *.c)
HEADERS:=$(wildcard *.h)
RELS:=$(addprefix $(OBJ_DIR)/, $(patsubst %.c, %.rel, $(SRC)))

build_binary: clean mk_obj_dir link
	makebin -Z $(OBJ_DIR)/wor_bundle.ihx wor.gb

link: compile
	$(SDCC) -mgbz80 --no-std-crt0 --data-loc 0xc0a0 -I $(SDCC_INCLUDE) -I $(SDCC_INCLUDE)/asm -L $(GBDK_LIB) $(GBDK_LIB)/crt0.rel -l gb.lib -o $(OBJ_DIR)/a.ihx $(RELS) -o $(OBJ_DIR)/wor_bundle.ihx

mk_obj_dir:
	mkdir -p $(OBJ_DIR)

compile: $(RELS)

$(OBJ_DIR)/%.rel: %.c
	$(SDCC) -mgbz80 --no-std-crt0 -I$(GBDK_INCLUDE) -I$(GBDK_INCLUDE)/asm -I$(SDCC_INCLUDE) -c $< -o $@

clean:
	rm -rf $(OBJ_DIR)
	rm -f wor.gb
