cmake_minimum_required(VERSION 3.24)

#set(CMAKE_VERBOSE_MAKEFILE ON)

include(pico_sdk_import.cmake)

# Initialize the SDK
pico_sdk_init()

execute_process (COMMAND date +%Y%m%d OUTPUT_VARIABLE CMAKE_BUILDDATE OUTPUT_STRIP_TRAILING_WHITESPACE)
execute_process (COMMAND git rev-parse --short HEAD OUTPUT_VARIABLE CMAKE_REVISION OUTPUT_STRIP_TRAILING_WHITESPACE)
execute_process (COMMAND git describe --tags --abbrev=0 OUTPUT_VARIABLE CMAKE_VERSION_NUMBER OUTPUT_STRIP_TRAILING_WHITESPACE)

project("PicoRuby-RP2040-Peripheral-Demo")

set(MRUBY_CONFIG_NAME "rp2040-peripheral-demo")

add_compile_options(-Wall
  # int != int32_t as far as the compiler is concerned because gcc has int32_t as long int
  -Wno-format
  -Wno-unused-function
  -Wno-maybe-uninitialized
)

add_definitions(
  -DNDEBUG
  -DMRBC_REQUIRE_32BIT_ALIGNMENT=1
  -DMRBC_CONVERT_CRLF=1
  -DMRBC_USE_MATH=1
  -DMRBC_TICK_UNIT=1
  -DMRBC_TIMESLICE_TICK_COUNT=10
)

file(GLOB SRCS src/*.c)
add_executable(${PROJECT_NAME}
  ${SRCS}
  ${CMAKE_SOURCE_DIR}/lib/picoruby/mrbgems/picoruby-gpio/ports/rp2040/gpio.c
  ${CMAKE_SOURCE_DIR}/lib/picoruby/mrbgems/picoruby-i2c/ports/rp2040/i2c.c
  ${CMAKE_SOURCE_DIR}/lib/picoruby/mrbgems/picoruby-adc/ports/rp2040/adc.c
  ${CMAKE_SOURCE_DIR}/lib/picoruby/mrbgems/picoruby-spi/ports/rp2040/spi.c
  ${CMAKE_SOURCE_DIR}/lib/picoruby/mrbgems/picoruby-uart/ports/rp2040/uart.c
)

set(PICORBC ${CMAKE_SOURCE_DIR}/lib/picoruby/bin/picorbc)

add_custom_target(mrbdir ALL
  COMMAND ${CMAKE_COMMAND} -E make_directory ${CMAKE_SOURCE_DIR}/build/mrb
)

set(RUBY_FILES app)

add_dependencies(${PROJECT_NAME}
  mrbdir
  ${RUBY_FILES}
)

foreach(rb ${RUBY_FILES})
add_custom_target(${rb}
  COMMAND ${PICORBC} -B${rb} -o${CMAKE_SOURCE_DIR}/build/mrb/${rb}.c ${CMAKE_SOURCE_DIR}/mrblib/${rb}.rb
)
endforeach(rb)

target_include_directories(${PROJECT_NAME} PRIVATE
  ${CMAKE_CURRENT_LIST_DIR}/include
)

target_link_directories(${PROJECT_NAME} PRIVATE
  ${CMAKE_SOURCE_DIR}/lib/picoruby/build/${MRUBY_CONFIG_NAME}/lib
)

target_link_libraries(${PROJECT_NAME} PRIVATE
  pico_stdlib
  pico_bootsel_via_double_reset
  hardware_flash
  hardware_i2c
  hardware_adc
  hardware_spi
  hardware_uart
  mruby
)

target_include_directories(${PROJECT_NAME} PRIVATE
  ${CMAKE_CURRENT_LIST_DIR}
  ${PICO_SDK_PATH}/src/rp2_common/pico_stdio_usb/include
  ${CMAKE_SOURCE_DIR}/lib/picoruby/mrbgems/picoruby-mrubyc/repos/mrubyc/src
  ${CMAKE_SOURCE_DIR}/lib/picoruby/build/${MRUBY_CONFIG_NAME}/mrbgems
  ${CMAKE_SOURCE_DIR}/lib/picoruby/build/repos/${MRUBY_CONFIG_NAME}/mruby-pico-compiler/include
  ${CMAKE_SOURCE_DIR}/lib/picoruby/mrbgems/picoruby-mrubyc/repos/mrubyc/src/hal_rp2040
)

pico_add_extra_outputs(${PROJECT_NAME})

add_custom_command(
  TARGET ${PROJECT_NAME}
  POST_BUILD
  COMMAND gzip -kf ${PROJECT_NAME}.uf2
  COMMAND zip -r ${PROJECT_NAME}.uf2.zip ${PROJECT_NAME}.uf2
)
