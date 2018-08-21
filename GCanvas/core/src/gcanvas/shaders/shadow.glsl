#define SHADOW_SHADER "SHADOW"



#define SHADOW_SHADER_VS                                "\
precision mediump float;                                \n\
uniform mat4 u_shadowMvpMatrix;                         \n\
attribute vec4 a_position;                              \n\
attribute vec2 a_texCoord;                              \n\
varying vec2 v_texCoord;                                \n\
void main()                                             \n\
{                                                       \n\
	gl_Position = u_shadowMvpMatrix * a_position;       \n\
	v_texCoord = a_texCoord;                            \n\
}"


#define SHADOW_SHADER_PS                                "\
precision mediump float;                                \n\
varying vec2 v_texCoord;                                \n\
uniform vec2 u_blurStep;                                \n\
uniform int u_blurRadius;                               \n\
uniform vec4 u_shadowColor;                             \n\
uniform bool u_useShadowTexture;                        \n\
uniform sampler2D diffuseTexture;                       \n\
                                                        \n\
uniform float u_gaussianKernel[121];                    \n\
                                                        \n\
void main()                                             \n\
{                                                       \n\
    if(u_useShadowTexture){                             \n\
         float xStep = u_blurStep.x;                    \n\
         float yStep = u_blurStep.y;                    \n\
         int blurSize = u_blurRadius > 10 ? 10: u_blurRadius; \n\
         vec4 resultColor = vec4(0.0);                      \n\
         float gamma = 0.0;                                 \n\
         float yOffset = 0.0;                               \n\
         for(int rowIndex = 0; rowIndex <= blurSize;rowIndex++){                                                \n\
             float xOffset = 0.0;                                                                               \n\
             for(int columnIndex = 0; columnIndex <= blurSize;columnIndex++){                                   \n\
                float weight = u_gaussianKernel[rowIndex * blurSize + columnIndex];                             \n\
                vec4 targetColor;                                                                               \n\
                if(rowIndex == 0){                                                                                  \n\
                    if(columnIndex == 0){                                                                           \n\
                        targetColor = texture2D( diffuseTexture, vec2(v_texCoord.x, v_texCoord.y));                 \n\
                        resultColor += (vec4(targetColor.rgb * targetColor.a, targetColor.a) * weight);            \n\
                    } else {                                                                                        \n\
                        targetColor = texture2D( diffuseTexture, vec2(v_texCoord.x + xOffset, v_texCoord.y));       \n\
                        resultColor += (vec4(targetColor.rgb * targetColor.a, targetColor.a) * weight);            \n\
                        targetColor = texture2D( diffuseTexture, vec2(v_texCoord.x - xOffset, v_texCoord.y));       \n\
                        resultColor += (vec4(targetColor.rgb * targetColor.a, targetColor.a) * weight);            \n\
                    }                                                                                               \n\
                } else {                                                                                            \n\
                    if(columnIndex == 0){                                                                           \n\
                        targetColor = texture2D( diffuseTexture, vec2(v_texCoord.x, v_texCoord.y + yOffset));       \n\
                        resultColor += (vec4(targetColor.rgb * targetColor.a, targetColor.a) * weight);            \n\
                        targetColor = texture2D( diffuseTexture, vec2(v_texCoord.x, v_texCoord.y - yOffset));       \n\
                        resultColor += (vec4(targetColor.rgb * targetColor.a, targetColor.a) * weight);            \n\
                    } else {                                                                                        \n\
                        targetColor = texture2D( diffuseTexture, vec2(v_texCoord.x + xOffset, v_texCoord.y + yOffset));       \n\
                        resultColor += (vec4(targetColor.rgb * targetColor.a, targetColor.a) * weight);            \n\
                        targetColor = texture2D( diffuseTexture, vec2(v_texCoord.x + xOffset, v_texCoord.y - yOffset));       \n\
                        resultColor += (vec4(targetColor.rgb * targetColor.a, targetColor.a) * weight);            \n\
                        targetColor = texture2D( diffuseTexture, vec2(v_texCoord.x - xOffset, v_texCoord.y + yOffset));       \n\
                        resultColor += (vec4(targetColor.rgb * targetColor.a, targetColor.a) * weight);            \n\
                        targetColor = texture2D( diffuseTexture, vec2(v_texCoord.x - xOffset, v_texCoord.y - yOffset));       \n\
                        resultColor += (vec4(targetColor.rgb * targetColor.a, targetColor.a) * weight);            \n\
                    }                                                                                             \n\
                }                                                                                               \n\
                xOffset += xStep;                                                                               \n\
             }                                                                                                  \n\
             yOffset += yStep;                                                                                  \n\
         }                                                                                                  \n\
         if(resultColor.a == 0.0){                                                                          \n\
            gl_FragColor = vec4(0.0);                                                                       \n\
         } else {                                                                                           \n\
            gl_FragColor = vec4(resultColor.rgb / resultColor.a, resultColor.a);                            \n\
         }                                                                                                  \n\                                                                                                            \n\
    } else {                                        \n\
        gl_FragColor = u_shadowColor;               \n\
    }                                               \n\
}"







