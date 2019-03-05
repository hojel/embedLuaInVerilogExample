Modified from http://github.com/oddball/embedPythonInVerilogExample.git


Wanted to show how easy it is to use Lua together with Verilog or VHDL. With just a few lines the Python interpreter can be embedded and call tasks or functions in SystemVerilog. I am using the proprietary simulator Questasim in this example.

The SystemVerilog code looks like this

```v
`timescale 1 ns/1 ns
module top;
      import "DPI-C" context task startLua();
      export "DPI-C" task sv_write;
 
   // Exported SV task.  Can be called by C,SV or Lua using c_write
   task sv_write(input int data,address);
      begin
     $display("sv_write(data = %d, address = %d)",data,address);
      end
   endtask
 
   initial
     begin
    startLua();
    $display("DONE!!");
     end
 
endmodule
```


The C code looks like this

```c
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
```

Easiest way to try it out:

```bash
git clone http://github.com/hojel/embedLuaInVerilogExample.git
cd embedLuaInVerilogExample
make
```
