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
	@find $(SRC_DIR) -name "*.java" > sources.txt
	@javac --release $(JAVA_VERSION) -cp $(CLASSPATH) -d $(BUILD_DIR) @sources.txt
	@rm sources.txt
	@echo "Copying resources..."
	@cp -R $(RES_DIR)/* $(BUILD_DIR)

run:
	@java -cp $(BUILD_DIR):$(CLASSPATH) $(APP_NAME)

uber: compile
	@echo "Creating fat jar..."
	@mkdir -p $(DIST_DIR)
	@echo "Manifest-Version: 1.0" > $(BUILD_DIR)/MANIFEST.MF
	@echo "Main-Class: $(APP_NAME)" >> $(BUILD_DIR)/MANIFEST.MF
	@jar cvfm $(DIST_DIR)/$(APP_NAME).jar $(BUILD_DIR)/MANIFEST.MF -C $(BUILD_DIR) .
	@for jar in $$(find $(LIB_DIR) -name '*.jar'); do \
		echo "Adding $$jar to fat jar..."; \
		jar xf $$jar; \
		jar uf $(DIST_DIR)/$(APP_NAME).jar $$(find . -type f -not -path '*/META-INF/*'); \
		rm -rf META-INF; \
	done

	@echo "Fat jar created: $(DIST_DIR)/$(APP_NAME).jar"

clean:
	rm -rf $(BUILD_DIR) $(DIST_DIR)
