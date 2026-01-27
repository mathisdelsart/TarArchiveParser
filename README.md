<div align="center">

# TAR Archive Parser in C

![C](https://img.shields.io/badge/C-99-blue.svg)
![Make](https://img.shields.io/badge/Make-Build-orange.svg)
![License](https://img.shields.io/badge/License-Academic-yellow.svg)

A lightweight TAR archive parser in C featuring archive validation, file operations, and symbolic link resolution. Built from scratch with POSIX TAR format compliance for efficient archive manipulation and metadata extraction.

[About](#about) • [Features](#features) • [Usage](#usage) • [Implementation](#implementation) • [Academic Context](#academic-context)

</div>

## About

This project implements a comprehensive TAR archive utility from scratch in C, providing full support for reading, validating, and manipulating POSIX TAR archives. Built as part of the LINFO1252 course at UCLouvain, this parser demonstrates low-level file handling, binary format parsing, and efficient archive traversal algorithms.

### Core Concept

```
Archive Integrity = validate(headers) + parse(metadata) + resolve(symlinks)
```

The parser uses header-based validation with checksum verification to ensure archive integrity, supporting essential TAR operations including existence checks, type detection, directory listing, and file content extraction with symbolic link resolution.

## Features

### Archive Validation System

#### `check_archive(tar_fd)`
• Validates TAR archive integrity
• Verifies USTAR magic values and version
• Computes and validates header checksums
• Returns count of valid headers or error codes

#### `exists(tar_fd, path)`
• Checks for file/directory existence in archive
• Performs exact path matching
• Efficient linear search through headers
• Returns boolean existence status

### File Operations

#### `is_file(tar_fd, path)` / `is_dir(tar_fd, path)` / `is_symlink(tar_fd, path)`
• Type detection using TAR typeflag
• Differentiates between regular files, directories, and symbolic links
• POSIX TAR standard compliance
• Returns boolean type status

#### `list(tar_fd, path, entries, no_entries)`
• Lists directory contents non-recursively
• Supports symbolic link resolution
• Automatic subdirectory skipping
• Returns entries array and count

#### `read_file(tar_fd, path, offset, dest, len)`
• Reads file contents with offset support
• Automatic symlink resolution
• Partial read capability
• Returns remaining bytes count

### Technical Specifications

| Feature | Specification |
|---------|--------------|
| Format Support | POSIX TAR (USTAR) |
| Header Size | 512 bytes |
| Checksum Algorithm | Sum of all header bytes |
| Symlink Resolution | Automatic |
| Archive Validation | Magic + Version + Checksum |

## Usage

### Prerequisites

• GCC compiler
• Unix-like environment (Linux, macOS)
• Make utility

### Installation & Execution

```bash
# Clone the repository
git clone https://github.com/mathisdelsart/TarArchiveParser.git
cd TarArchiveParser

# Build and run
make all

# Or step by step
make build    # Compile only
make run      # Execute the program
make clean    # Remove generated files

# Create TAR archive for testing
make tar

# Create submission archive
make submit
```

### Example Output

The program runs a comprehensive test suite validating all TAR operations:

```
Test check_archive() :
        Test Passed !

Test exists_test() :
        Test Passed !
        Test Passed !

Test is_x() :
        Test Passed !

Test list() :
        Test Passed !

Test read_file() :
        Test Passed !
```

## Implementation

### Architecture

```
tar-archive-parser/
├── src/
│   ├── lib_tar.c         # Core TAR implementation
│   ├── helper.c          # Helper utilities
│   └── tests.c           # Test suite
├── headers/
│   ├── lib_tar.h         # Public API
│   ├── helper.h          # Helper functions
│   ├── var.h             # Constants and macros
│   └── tests.h           # Test definitions
├── archive_test/         # Test archive structure
├── Makefile              # Build automation
└── README.md             # This file
```

### Key Algorithms

#### Archive Validation

1. Reset file descriptor to start
2. For each header:
   - Verify USTAR magic ("ustar\0")
   - Verify version ("00")
   - Compute checksum (sum of all bytes)
   - Compare with header checksum
3. Return header count or error code (-1: magic, -2: version, -3: checksum)

#### Directory Listing

1. Locate directory entry in archive
2. Resolve symlinks recursively if needed
3. Scan subsequent entries:
   - Check if entry belongs to directory
   - Skip subdirectories automatically
   - Add entries to result array
4. Return entries count

#### File Reading with Offset

1. Search for file entry by path
2. Resolve symlinks if necessary
3. Seek to content offset
4. Read requested bytes into buffer
5. Return remaining bytes count

### TAR Header Structure

```c
typedef struct {
    char name[100];      // File name
    char mode[8];        // File mode
    char uid[8];         // User ID
    char gid[8];         // Group ID
    char size[12];       // File size (octal)
    char mtime[12];      // Modification time
    char chksum[8];      // Header checksum
    char typeflag;       // File type
    char linkname[100];  // Link target
    char magic[6];       // "ustar\0"
    char version[2];     // "00"
    // ... additional fields
} tar_header_t;
```

## Limitations

The current implementation has the following known limitations:

• The `list()` function does not support relative paths (e.g., `../`)
• TAR archive must be created with compatible options for tests to pass
• macOS BSD tar has different default options than GNU tar

Future versions may address these limitations for broader compatibility.

## Academic Context

This project was developed as part of the **LINFO1252 - Systèmes informatiques** course at UCLouvain.

**Author:**
- Mathis Delsart
- Anthony Guerrero Gurriaran

---

*A hands-on exploration of low-level file I/O and binary format parsing, demonstrating how TAR archives work under the hood. Perfect for understanding the fundamentals of archive manipulation and POSIX compliance in systems programming.*