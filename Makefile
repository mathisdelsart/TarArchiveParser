CC = gcc
CFLAGS = -g -Wall -Werror -Wextra

SRC_DIR = src
BIN_DIR = bin

SOURCES = $(wildcard $(SRC_DIR)/*.c)
OBJECTS = $(patsubst $(SRC_DIR)/%.c, $(BIN_DIR)/%.o, $(SOURCES))
EXECUTABLE = my_program
TAR_ARCHIVE = TAR_archive_test.tar
SUBMISSION = soumission.tar

.PHONY: all build run tar submit clean help

all: build

help:
	@echo "Available commands:"
	@echo "  make build    - Compile the project and create test archive"
	@echo "  make run      - Run the program with the test archive"
	@echo "  make all      - Compile the project (default)"
	@echo "  make tar      - Create the test TAR archive"
	@echo "  make submit   - Create submission archive"
	@echo "  make clean    - Remove generated files"
	@echo "  make help     - Show this help message"

run: build
	@echo "Running tests..."
	@./$(EXECUTABLE) $(TAR_ARCHIVE)

build: $(BIN_DIR) $(EXECUTABLE) tar

$(EXECUTABLE): $(OBJECTS)
	@echo "Linking $(EXECUTABLE)..."
	@$(CC) $(CFLAGS) $^ -o $@

$(BIN_DIR)/%.o: $(SRC_DIR)/%.c
	@echo "Compiling $<..."
	@$(CC) $(CFLAGS) -c $< -o $@

$(BIN_DIR):
	@mkdir -p $(BIN_DIR)

tar:
	@echo "Creating test archive..."
	@tar --posix --pax-option delete=".*" --pax-option delete="*time*" --no-xattrs --no-acl --no-selinux -c archive_test/folder1 archive_test/folder2 archive_test/folder3 archive_test/folder4 archive_test/symlink_multi archive_test/symlink1 > $(TAR_ARCHIVE)

clean:
	@echo "Cleaning generated files..."
	@rm -f $(EXECUTABLE) $(SUBMISSION) $(TAR_ARCHIVE)
	@rm -rf $(BIN_DIR)

submit: clean build
	@echo "Creating submission archive..."
	@tar --posix --pax-option delete=".*" --pax-option delete="*time*" --no-xattrs --no-acl --no-selinux -c src/ headers/ Makefile README.md > $(SUBMISSION)