APP_NAME = UsrjJava
SRC_DIR = src
RES_DIR = resources
BUILD_DIR = build
DIST_DIR = dist
JAVA_VERSION = 11

.PHONY: all clean uber

all: compile run

compile:
	@echo "Current directory: $$(pwd)"
	@echo "Compiling Java files..."
	mkdir -p $(BUILD_DIR)
	javac --release $(JAVA_VERSION) -d $(BUILD_DIR) $(SRC_DIR)/*.java
	@echo "Copying resources..."
	mkdir -p $(BUILD_DIR)
	cp -R $(RES_DIR)/* $(BUILD_DIR)
	@echo "Contents of build directory:"
	@find $(BUILD_DIR) -type f

run:
	java -cp $(BUILD_DIR) $(APP_NAME)

uber:
	mkdir -p $(BUILD_DIR) $(DIST_DIR)
	javac --release $(JAVA_VERSION) -d $(BUILD_DIR) $(SRC_DIR)/*.java
	cp -R $(RES_DIR)/* $(BUILD_DIR)
	jar cvfe $(DIST_DIR)/$(APP_NAME).jar $(APP_NAME) -C $(BUILD_DIR) .

clean:
	rm -rf $(BUILD_DIR) $(DIST_DIR)
