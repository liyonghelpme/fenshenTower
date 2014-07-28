//
//  MyCocosExt.cpp
//  demo
//
//  Created by lodogame on 14-7-18.
//
//

#include "MyCocosExt.h"
#include "tolua_fix.h"

#include "cocos2d.h"
#include "CCLuaEngine.h"
#include "ComNative.h"

using namespace cocos2d;

#ifndef TOLUA_DISABLE_tolua_Cocos2d_setGLProgram00
static int tolua_Cocos2d_setGLProgram00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
	tolua_Error tolua_err;
	if (
		!tolua_isusertype(tolua_S,1, "CCSprite",0,&tolua_err) ||
		!tolua_isnoobj(tolua_S,2,&tolua_err)
        )
        goto tolua_lerror;
	else
#endif
	{
        CCSprite *sp = (CCSprite*)tolua_tousertype(tolua_S, 1, 0);
        setGLProgram(sp);
		//tolua_pushnumber(tolua_S, (lua_Number)res);
	}
	return 0;
#ifndef TOLUA_RELEASE
tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'setGLProgram'", &tolua_err);
    return 0;
#endif
}
#endif


TOLUA_API int tolua_ext_reg_types(lua_State* tolua_S)
{
    return 1;
}
TOLUA_API int tolua_ext_reg_modules(lua_State* tolua_S)
{
    tolua_function(tolua_S,"setGLProgram", tolua_Cocos2d_setGLProgram00);
    return 1;
}
int tolua_MyExt_open(lua_State *tolua_S) {
    tolua_open(tolua_S);
    tolua_ext_reg_types(tolua_S);
    tolua_module(tolua_S, NULL, 0);
    tolua_beginmodule(tolua_S, NULL);
    tolua_ext_reg_modules(tolua_S);
    tolua_endmodule(tolua_S);
	return 1;
}
