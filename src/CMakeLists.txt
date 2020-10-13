include(GNUInstallDirs)

set(SMFC_SOURCES
  codegen.cc
  cpp_generator.cc
  go_generator.cc
  python_generator.cc
  main.cc)

set(SMFC_LIBS
  Flatbuffers::flatbuffers
  Boost::system
  Boost::filesystem
  gflags
  glog::glog
  ${CMAKE_THREAD_LIBS_INIT})

add_executable(smfc ${SMFC_SOURCES})
target_link_libraries(smfc PRIVATE ${SMFC_LIBS})
target_include_directories(smfc PRIVATE src)
install(TARGETS smfc
  EXPORT smf-export
  DESTINATION ${CMAKE_INSTALL_BINDIR})

smfc_gen(
  CPP
  TARGET_NAME raw_rpc_gen
  OUTPUT_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/include/smf
  SOURCES ${CMAKE_CURRENT_SOURCE_DIR}/rpc.fbs)
install(
  FILES ${CMAKE_CURRENT_BINARY_DIR}/include/smf/rpc_generated.h
  DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/smf)

if(CMAKE_BUILD_TYPE MATCHES Debug)
  target_compile_options(smf PRIVATE
    -fdiagnostics-color=auto
    -Wall
    -Werror
    -Wextra
    -Wformat
    -Wmissing-braces
    -Wparentheses
    -Wpointer-arith
    -Wformat-security
    -Wunused
    -Wno-unused-parameter
    -Wcast-align
    -Wno-missing-field-initializers
    -Wdelete-non-virtual-dtor
    -Wno-ignored-qualifiers)
endif()
