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
	clj -Spath

compile:
	@echo "Current directory: $$(pwd)"
	@echo "Compiling Java files..."
	mkdir -p $(BUILD_DIR)
	javac --release $(JAVA_VERSION) -cp $(CLASSPATH) -d $(BUILD_DIR) $(SRC_DIR)/*.java
	@echo "Copying resources..."
	mkdir -p $(BUILD_DIR)
	cp -R $(RES_DIR)/* $(BUILD_DIR)
	@echo "Contents of build directory:"
	@find $(BUILD_DIR) -type f

run:
	java -cp $(BUILD_DIR):$(CLASSPATH) $(APP_NAME)

uber:
	mkdir -p $(BUILD_DIR) $(DIST_DIR)
	javac --release $(JAVA_VERSION) -cp $(CLASSPATH) -d $(BUILD_DIR) $(SRC_DIR)/*.java
	cp -R $(RES_DIR)/* $(BUILD_DIR)
	jar cvfe $(DIST_DIR)/$(APP_NAME).jar $(APP_NAME) -C $(BUILD_DIR) .
	# Add dependencies to the uber jar
	for file in $(LIB_DIR)/*.jar; do \
		jar xf $$file -C $(BUILD_DIR) .; \
	done
	jar uvfe $(DIST_DIR)/$(APP_NAME).jar $(APP_NAME) -C $(BUILD_DIR) .

clean:
	rm -rf $(BUILD_DIR) $(DIST_DIR)
