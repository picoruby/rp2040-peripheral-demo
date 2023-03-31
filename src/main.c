/* Raspi SDK */
#include <pico/stdlib.h>
#include <pico/bootrom.h>
#include <bsp/board.h>
#include <hardware/clocks.h>

/* PicoRuby */
#include <picorbc.h>
#include <picogem_init.c>

#ifndef HEAP_SIZE
#define HEAP_SIZE (1024 * 220 - 1)
#endif

int loglevel = LOGLEVEL_ERROR;
static uint8_t heap_pool[HEAP_SIZE];

int
main(void)
{
  stdio_init_all();
  board_init();

  mrbc_init(heap_pool, HEAP_SIZE);
  picoruby_init_require();
  mrbc_create_task(main, 0);
  mrbc_run();
  return 0;
}

