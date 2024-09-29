APP_NAME = UsrjJava
SRC_DIR = src
RES_DIR = resources
BUILD_DIR = build
DIST_DIR = dist
LIB_DIR = lib
JAVA_VERSION = 11

# Find all JAR files in the lib directory
CLASSPATH = $(shell find $(LIB_DIR) -name '*.jar' | tr '\n' ':')

.PHONY: all clean uber deps

all: deps compile run

deps:
	@mkdir -p $(LIB_DIR)
	@clj -Spath

compile:
	@echo "Compiling Java files..."
	@mkdir -p $(BUILD_DIR)
	@javac --release $(JAVA_VERSION) -cp $(CLASSPATH) -d $(BUILD_DIR) $(shell find $(SRC_DIR) -name "*.java")
	@echo "Copying resources..."
	@cp -R $(RES_DIR)/* $(BUILD_DIR)

run:
	@java -cp $(BUILD_DIR):$(CLASSPATH) $(APP_NAME)

uber: compile
	@echo "Creating fat jar..."
	@mkdir -p $(DIST_DIR) temp_build
	@cp -R $(BUILD_DIR)/* temp_build/
	@echo "Manifest-Version: 1.0\nMain-Class: $(APP_NAME)" > temp_build/MANIFEST.MF
	@cd temp_build && \
	find ../$(LIB_DIR) -name '*.jar' | grep -v "lib/org/clojure" | \
	xargs -I {} jar xf {}
	@jar cvfm $(DIST_DIR)/$(APP_NAME).jar temp_build/MANIFEST.MF -C temp_build .
	@rm -rf temp_build
	@echo "Fat jar created: $(DIST_DIR)/$(APP_NAME).jar"

clean:
	rm -rf $(BUILD_DIR) $(DIST_DIR)
