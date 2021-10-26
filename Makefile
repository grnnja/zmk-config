ZMK_DIR = $(shell readlink -f ./zmk/)
CONFIG_DIR = $(shell readlink -f ./config/)
BOARD = nrfmicro_11
SHIELD = prem_dactyl_manuform
KEYMAP = default
SIDE = 

BUILD_SCRIPT = source $(ZMK_DIR)/zephyr/zephyr-env.sh; west build -p -s $(ZMK_DIR)/app -b $(BOARD) -d build/shield$${SIDE} -- -DSHIELD=$(SHIELD)$${SIDE} -DKEYMAP=$(KEYMAP) -DZMK_CONFIG=$(CONFIG_DIR)

left:
	SIDE=_left; $(BUILD_SCRIPT)

right:
	SIDE=_right; $(BUILD_SCRIPT)
