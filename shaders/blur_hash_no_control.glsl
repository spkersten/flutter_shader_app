#version 320 es

precision highp float;

layout(location = 0) out vec4 fragColor;

layout(location = 0) uniform float width;
layout(location = 1) uniform float height;

//layout(location = 2) in vec3 colors[12];
layout(location = 2)  uniform vec3 color0_0;
layout(location = 5)  uniform vec3 color1_0;
layout(location = 8)  uniform vec3 color2_0;
layout(location = 11) uniform  vec3 color3_0;
layout(location = 14) uniform  vec3 color0_1;
layout(location = 17) uniform  vec3 color1_1;
layout(location = 20) uniform  vec3 color2_1;
layout(location = 23) uniform  vec3 color3_1;
layout(location = 26) uniform  vec3 color0_2;
layout(location = 29) uniform  vec3 color1_2;
layout(location = 32) uniform  vec3 color2_2;
layout(location = 35) uniform  vec3 color3_2;

in vec4 gl_FragCoord;

float _linearTosRGB(in float value) {
    float v = clamp(value, 0.0, 1.0);
    const float m = 0.0031308;

//    if (v <= m) {
//        return v * 12.92 * 255.0 + 0.5;
//    } else {
//        return (1.055 * pow(v, 1.0 / 2.4) - 0.055) * 255.0 + 0.5;
//    }
    // Using sigmoid to avoid unsupported if-statement:
    float c = 1.0 / (1.0 + pow(2.0, 100000.0 * (v - m)));

    return c * (v * 12.92 * 255.0 + 0.5)
          + (1.0 - c) * ((1.055 * pow(v, 1.0 / 2.4) - 0.055) * 255.0 + 0.5);
}

void main()
{
    float x = gl_FragCoord.x / width;
    float y = gl_FragCoord.y / height;

    const int numX = 4;
    const int numY = 3;
    const float pi = 3.14159265;

    vec3 pixel = vec3(0.0, 0.0, 0.0);

//    for (float j = 0.0; j < float(numY); j++) {
//        for (float i = 0.0; i < float(numX); i++) {
//            float basis = cos((pi * x * float(i)) / width) * cos((pi * y * float(j)) / height);
//            vec3 color = colors[int(i) + int(j) * numX];
//            pixel[0] += color[0] * basis;
//            pixel[1] += color[1] * basis;
//            pixel[2] += color[2] * basis;
//        }
//    }

    // Unrolled:

    float basis0_0 = cos(pi * x * float(0)) * cos(pi * y * float(0));
    pixel[0] += color0_0[0] * basis0_0;
    pixel[1] += color0_0[1] * basis0_0;
    pixel[2] += color0_0[2] * basis0_0;

    float basis1_0 = cos(pi * x * float(1)) * cos(pi * y * float(0));
    pixel[0] += color1_0[0] * basis1_0;
    pixel[1] += color1_0[1] * basis1_0;
    pixel[2] += color1_0[2] * basis1_0;

    float basis2_0 = cos(pi * x * float(2)) * cos(pi * y * float(0));
    pixel[0] += color2_0[0] * basis2_0;
    pixel[1] += color2_0[1] * basis2_0;
    pixel[2] += color2_0[2] * basis2_0;

    float basis3_0 = cos(pi * x * float(3)) * cos(pi * y * float(0));
    pixel[0] += color3_0[0] * basis3_0;
    pixel[1] += color3_0[1] * basis3_0;
    pixel[2] += color3_0[2] * basis3_0;

    float basis0_1 = cos(pi * x * float(0)) * cos(pi * y * float(1));
    pixel[0] += color0_1[0] * basis0_1;
    pixel[1] += color0_1[1] * basis0_1;
    pixel[2] += color0_1[2] * basis0_1;

    float basis1_1 = cos(pi * x * float(1)) * cos(pi * y * float(1));
    pixel[0] += color1_1[0] * basis1_1;
    pixel[1] += color1_1[1] * basis1_1;
    pixel[2] += color1_1[2] * basis1_1;

    float basis2_1 = cos(pi * x * float(2)) * cos(pi * y * float(1));
    pixel[0] += color2_1[0] * basis2_1;
    pixel[1] += color2_1[1] * basis2_1;
    pixel[2] += color2_1[2] * basis2_1;

    float basis3_1 = cos(pi * x * float(3)) * cos(pi * y * float(1));
    pixel[0] += color3_1[0] * basis3_1;
    pixel[1] += color3_1[1] * basis3_1;
    pixel[2] += color3_1[2] * basis3_1;

    float basis0_2 = cos(pi * x * float(0)) * cos(pi * y * float(2));
    pixel[0] += color0_2[0] * basis0_2;
    pixel[1] += color0_2[1] * basis0_2;
    pixel[2] += color0_2[2] * basis0_2;

    float basis1_2 = cos(pi * x * float(1)) * cos(pi * y * float(2));
    pixel[0] += color1_2[0] * basis1_2;
    pixel[1] += color1_2[1] * basis1_2;
    pixel[2] += color1_2[2] * basis1_2;

    float basis2_2 = cos(pi * x * float(2)) * cos(pi * y * float(2));
    pixel[0] += color2_2[0] * basis2_2;
    pixel[1] += color2_2[1] * basis2_2;
    pixel[2] += color2_2[2] * basis2_2;

    float basis3_2 = cos(pi * x * float(3)) * cos(pi * y * float(2));
    pixel[0] += color3_2[0] * basis3_2;
    pixel[1] += color3_2[1] * basis3_2;
    pixel[2] += color3_2[2] * basis3_2;

    pixel[0] = _linearTosRGB(pixel[0]);
    pixel[1] = _linearTosRGB(pixel[1]);
    pixel[2] = _linearTosRGB(pixel[2]);

    fragColor = vec4(
        pixel[0] / 255.0,
        pixel[1] / 255.0,
        pixel[2] / 255.0,
        1.0
    );
}
