#ifdef GL_ES
precision lowp float;
#endif
varying vec4 v_fragmentColor;
varying vec2 v_texCoord;
uniform sampler2D CC_Texture0;

//time/10 time time*2 time*4
//uniform vec4 CC_Time;



//uniform float CC_Time;
//uniform float CC_SinTime;
//uniform float CC_CosTime;

void main() {
    vec2 uv = vec2(v_texCoord);
    /*
    if(uv.y <= 0.35f) {
        uv.x = uv.x+0.07*min((0.35f-uv.y), 0.1)*sin(10*(CC_Time+uv.y+sin(uv.x)));
    }
    */
    float nx = uv.x-0.5;
    float ny = uv.y-0.5;
    float len = sqrt(nx*nx+ny*ny);
    //0.5 * 1s * k = 2pi
    float theta = atan(ny, nx);

    float w = (0.708-len)*4.0*3.14*CC_Time.y + theta;
    float nnx = len*cos(w);
    float nny = len*sin(w);

    vec2 txy = vec2(nnx+0.5, nny+0.5);


	gl_FragColor =  v_fragmentColor*texture2D(CC_Texture0, txy);
    
    //gl_FragColor = vec4(1, 0, 0, 1);
    //* u_color;
}