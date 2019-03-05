#include <lua.h>
#include <lualib.h>
#include <lauxlib.h>
#include "vpi_user.h"

extern int sv_write();

static int c_write(lua_State *L) {
  int address = luaL_checknumber(L, 1);
  int data    = luaL_checknumber(L, 2);
  (void)sv_write(address,data);
  return 0;
}

int startLua() {
    lua_State *L;
    L = luaL_newstate();
    luaL_openlibs(L);

    lua_pushcfunction(L, c_write);
    lua_setglobal(L, "c_write");

    (void)luaL_dostring(L, "c_write(0,1)");
    lua_close(L);
    return 0;
}
