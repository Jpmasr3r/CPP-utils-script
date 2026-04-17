#!/bin/bash

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
BOLD='\033[1m'
DIM='\033[2m'
NC='\033[0m'

BUILD_DIR="build"
PROJECT_NAME="main"
CORES=$(nproc)
BUILD_TYPE="Release"
USE_RUN=false
USE_FULL=false
USE_GDB=false
USE_VALGRIND=false
BUILD_SYSTEM="g++"
CPP_VERSION="17"

SCRIPT_DIR="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"

TEMPLATE_CMAKE="$SCRIPT_DIR/CMakeLists.txt"
TEMPLATE_MAIN="$SCRIPT_DIR/main.cpp"

info()    { echo -e "${CYAN}${BOLD}[INFO]${NC} ${CYAN}$1${NC}"; }
success() { echo -e "${GREEN}${BOLD}[OK]${NC} ${GREEN}$1${NC}"; }
warning() { echo -e "${YELLOW}${BOLD}[WARNING]${NC} ${YELLOW}$1${NC}"; }
error()   { echo -e "${RED}${BOLD}[ERROR]${NC} ${RED}$1${NC}"; exit 1; }

print_header() {
    echo -e "${MAGENTA}${BOLD}"
    echo "╔══════════════════════════════════════════════════════════╗"
    echo "║                  C++ Utils Script                        ║"
    echo "╚══════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

goodbye_footer() {
    echo ""
    echo ""
    echo -e "${MAGENTA}${BOLD}"
    echo "╔══════════════════════════════════════════════════════════╗"
    echo "║                   Ending Script                          ║"
    echo "║                🐱 Thanks for using 🐱                    ║"
    echo "╚══════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

show_license() {
    info "Showing GPLv2 license..."
    
    LICENSE_FILE="LICENSE"
    
    if [[ ! -f "$LICENSE_FILE" ]]; then
        info "LICENSE file not found, downloading..."
        curl -s https://www.gnu.org/licenses/old-licenses/gpl-2.0.txt -o "$LICENSE_FILE" \
        || error "Failed to download license"
        success "LICENSE created"
    fi
    
    if command -v less &> /dev/null; then
        less "$LICENSE_FILE"
    else
        cat "$LICENSE_FILE"
    fi
}

init() {
    if [[ ! -f "$TEMPLATE_CMAKE" ]]; then
        error "Template not found at $TEMPLATE_CMAKE"
    fi
    
    if [[ ! -f "$TEMPLATE_MAIN" ]]; then
        error "Template not found at $TEMPLATE_MAIN"
    fi
    
    mkdir -p ./include ./src
    cat "$TEMPLATE_CMAKE" > ./CMakeLists.txt
    cat "$TEMPLATE_MAIN" > ./src/main.cpp
    success "Project initialized"
}

detect_project() {
    if [[ -f "CMakeLists.txt" ]]; then
        BUILD_SYSTEM="cmake"
        elif ls *.cpp &> /dev/null; then
        BUILD_SYSTEM="g++"
    else
        error "No C++ project detected"
    fi
}

check_deps() {
    info "Checking dependencies..."
    
    if [[ "$BUILD_SYSTEM" = "cmake" ]]; then
        for cmd in cmake make curl; do
            command -v "$cmd" &> /dev/null || error "$cmd not found"
        done
    else
        command -v g++ &> /dev/null || error "g++ not found"
    fi
    
    success "Dependencies OK"
}

clean_build() {
    if [[ -d "$BUILD_DIR" ]]; then
        warning "Removing build..."
        rm -rf "$BUILD_DIR"
        success "Build cleaned"
    else
        info "Nothing to clean"
    fi
}

run_cmake() {
    info "Configuring CMake..."
    cmake -B "$BUILD_DIR" -DCMAKE_BUILD_TYPE=$BUILD_TYPE -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
    success "CMake ready"
}

run_make() {
    info "Compiling..."
    cmake --build "$BUILD_DIR" -j"$CORES"
    success "Build complete"
}

run_gpp() {
    info "Compiling with g++..."
    mkdir -p "$BUILD_DIR"
    
    if [[ "$BUILD_TYPE" = "Debug" ]]; then
        g++ *.cpp -o "$BUILD_DIR/$PROJECT_NAME" -g -O0 -std=c++"$CPP_VERSION" \
        || error "Compilation error"
    else
        g++ *.cpp -o "$BUILD_DIR/$PROJECT_NAME" -O2 -std=c++"$CPP_VERSION" \
        || error "Compilation error"
    fi
    
    success "Build complete"
}

run_exec() {
    info "Running..."
    echo ""
    "./$BUILD_DIR/$PROJECT_NAME"
}

run_gdb() {
    command -v gdb &> /dev/null || error "gdb not found"
    
    info "Starting GDB..."
    gdb "./$BUILD_DIR/$PROJECT_NAME"
}

run_valgrind() {
    command -v valgrind &> /dev/null || error "valgrind not found"
    
    info "Running Valgrind..."
    valgrind --leak-check=full --track-origins=yes "./$BUILD_DIR/$PROJECT_NAME"
}

show_help() {
    echo -e "${YELLOW}${BOLD}USAGE:${NC}"
    echo -e "  ${CYAN}cpp${NC} [options]"
    echo -e "  ${CYAN}./cpp_utils${NC} [options]"
    echo ""
    
    echo -e "${YELLOW}${BOLD}OPTIONS:${NC}"
    
    echo -e "  ${GREEN}-r, --run${NC}           ${DIM}Run after build${NC}"
    echo -e "  ${GREEN}-f, --full${NC}          ${DIM}Clean and rebuild${NC}"
    echo -e "  ${GREEN}-v, --version${NC}       ${DIM}Set C++ version${NC}"
    echo -e "      ${DIM}example:${NC} ${CYAN}--version 17${NC}"
    
    echo -e "  ${GREEN}-c, --clean${NC}         ${DIM}Remove build and binaries${NC}"
    echo -e "  ${GREEN}-d, --debug${NC}         ${DIM}Debug build${NC}"
    echo -e "  ${GREEN}-R, --release${NC}       ${DIM}Release build${NC}"
    
    echo -e "  ${GREEN}-b, --build-dir${NC}     ${DIM}Set build directory${NC}"
    echo -e "      ${DIM}example:${NC} ${CYAN}--build-dir build${NC}"
    
    echo -e "  ${GREEN}-n, --name${NC}          ${DIM}Set binary name${NC}"
    echo -e "      ${DIM}example:${NC} ${CYAN}--name main${NC}"
    
    echo -e "  ${GREEN}-i, --init${NC}          ${DIM}Initialize project${NC}"
    echo -e "  ${GREEN}-l, --license${NC}       ${DIM}Show GPLv2 license${NC}"
    
    echo -e "  ${GREEN}--gdb${NC}               ${DIM}Run with GDB (debug mode)${NC}"
    echo -e "  ${GREEN}--valgrind${NC}         ${DIM}Memory analysis with Valgrind${NC}"
    
    echo -e "  ${GREEN}-h, --help${NC}          ${DIM}Show help${NC}"
}

print_header

while [[ $# -gt 0 ]]
do
    case "$1" in
        -r|--run) USE_RUN=true; shift ;;
        -f|--full) USE_FULL=true; shift ;;
        -v|--version) CPP_VERSION=$2; shift 2 ;;
        -c|--clean) clean_build; exit 0 ;;
        -d|--debug) USE_FULL=true; BUILD_TYPE="Debug"; shift ;;
        -R|--release) BUILD_TYPE="Release"; shift ;;
        --gdb) USE_FULL=true; USE_GDB=true; BUILD_TYPE="Debug"; shift ;;
        --valgrind) USE_FULL=true; USE_VALGRIND=true; BUILD_TYPE="Debug"; shift ;;
        -b|--build-dir) BUILD_DIR="$2"; shift 2 ;;
        -n|--name) PROJECT_NAME="$2"; shift 2 ;;
        -i|--init) init; exit 0 ;;
        -l|--license) show_license; exit 0 ;;
        -h|--help) show_help; exit 0 ;;
        *) error "Invalid option: $1" ;;
    esac
done

detect_project
check_deps

if $USE_FULL; then
    clean_build
fi

if [[ "$BUILD_SYSTEM" = "cmake" ]]; then
    [[ ! -d "$BUILD_DIR" ]] && run_cmake
    run_make
else
    run_gpp
fi

echo ""
success "Ready!"
echo -e "${DIM}Binary:${NC} ${CYAN}./$BUILD_DIR/$PROJECT_NAME${NC}"

if $USE_GDB; then
    run_gdb
    elif $USE_VALGRIND; then
    run_valgrind
    elif $USE_RUN; then
    run_exec
fi

goodbye_footer