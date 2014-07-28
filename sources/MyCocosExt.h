//
//  MyCocosExt.h
//  demo
//
//  Created by lodogame on 14-7-18.
//
//

#ifndef demo_MyCocosExt_h
#define demo_MyCocosExt_h
#if !defined(COCOS2D_DEBUG) || COCOS2D_DEBUG == 0
#define TOLUA_RELEASE
#endif

#include "tolua++.h"


TOLUA_API int tolua_MyExt_open(lua_State *tolua_S);
#endif
