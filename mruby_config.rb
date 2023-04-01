MRuby::CrossBuild.new("rp2040-peripheral-demo") do |conf|

  ###############################################################
  # You need following tools:
  #   arm-none-eabi       | to make libmruby.a
  ###############################################################

  conf.toolchain

  conf.cc.command = "arm-none-eabi-gcc"
  conf.linker.command = "arm-none-eabi-ld"
  conf.linker.flags << "-static"
  conf.archiver.command = "arm-none-eabi-ar"

  conf.cc.host_command = "gcc"

  conf.cc.flags.flatten!
  conf.cc.flags.delete "-O3"
  conf.cc.flags << "-Og"
  conf.cc.flags << "-mcpu=cortex-m0plus"
  conf.cc.flags << "-mthumb"
  conf.cc.flags << "-Wall"
  conf.cc.flags << "-Wno-format"
  conf.cc.flags << "-Wno-unused-function"
  conf.cc.flags << "-Wno-maybe-uninitialized"
  conf.cc.flags << "-ffunction-sections"
  conf.cc.flags << "-fdata-sections"

  # These defines should not contradict platform's configuration
  conf.cc.defines << "NDEBUG"
  conf.cc.defines << "MRBC_REQUIRE_32BIT_ALIGNMENT=1"
  conf.cc.defines << "MRBC_CONVERT_CRLF=1"
  conf.cc.defines << "MRBC_USE_MATH=1"
  conf.cc.defines << "MRBC_TICK_UNIT=1"
  conf.cc.defines << "MRBC_TIMESLICE_TICK_COUNT=10"
  conf.cc.defines << "LEMON_PICORBC=1"

  conf.mrubyc_hal_arm
  conf.picoruby

  conf.gembox "peripherals"
  conf.gem core: 'picoruby-adafruit_pcf8523'
end

