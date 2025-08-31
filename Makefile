# Project settings
NAME        = gfx
EXPORT_PRESET = "Linux/X11"

# Try to find Godot executable
GODOT_BIN   := $(shell which godot4 || which godot || echo "")

# Paths
PROJECT_DIR = .
BUILD_DIR   = build

# Check if Godot exists
ifeq ($(strip $(GODOT_BIN)),)
$(error Could not find Godot executable in PATH. Please install or add it.)
endif

# Default rule
all: $(NAME)

# Export project for Linux
$(NAME):
	@echo "==> Exporting Godot project with preset $(EXPORT_PRESET)"
	@mkdir -p $(BUILD_DIR)
	$(GODOT_BIN) --headless --export-release $(EXPORT_PRESET) $(BUILD_DIR)/$(NAME)

# Run project
run:
	@echo "==> Running Godot project"
	$(GODOT_BIN) --path $(PROJECT_DIR)

# Clean build
clean:
	@echo "==> Cleaning build files"
	@rm -rf $(BUILD_DIR)

re: clean all

.PHONY: all clean re run
