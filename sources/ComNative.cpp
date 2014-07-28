//
//  ComNative.cpp
//  demo
//
//  Created by lodogame on 14-7-18.
//
//

#include "ComNative.h"

void setGLProgram(CCSprite *sp) {
    CCShaderCache *sc = CCShaderCache::sharedShaderCache();
    CCGLProgram *prog = (CCGLProgram*)sc->programForKey("waveGrass");
    if(prog == NULL) {
        GLchar *fragSource = (GLchar*)CCString::createWithContentsOfFile(CCFileUtils::sharedFileUtils()->fullPathForFilename("Frag.h").c_str())->getCString();
        GLchar *vertSource = (GLchar*)CCString::createWithContentsOfFile(CCFileUtils::sharedFileUtils()->fullPathForFilename("Vert.h").c_str())->getCString();
        CCLog("Frag File");
        //CCLog("%s", fragSource);
        CCLog("Vert File");
        //CCLog("%s", vertSource);
        
        prog = new CCGLProgram();
        prog->initWithVertexShaderByteArray(vertSource, fragSource);
        sp->setShaderProgram(prog);
        prog->release();
        
        CHECK_GL_ERROR_DEBUG();
        prog->addAttribute(kCCAttributeNamePosition, kCCVertexAttrib_Position);
        prog->addAttribute(kCCAttributeNameColor, kCCVertexAttrib_Color);
        prog->addAttribute(kCCAttributeNameTexCoord, kCCVertexAttrib_TexCoords);
        CHECK_GL_ERROR_DEBUG();
        
        prog->link();
        CHECK_GL_ERROR_DEBUG();
        prog->updateUniforms();
        CHECK_GL_ERROR_DEBUG();
        sc->addProgram(prog, "waveGrass");
    } else {
        sp->setShaderProgram(prog);
    }
    //return (int)glGetUniformLocation(prog->getProgram(), "offset");
    //return 0;
}