// 十字平移旋转缩放
Shader "Custom/CrossTRSShader"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _CrossRadiusX("Cross Radius X", Range(0, 1)) = 0.5
        _CrossRadiusY("Cross Radius Y", Range(0, 1)) = 0.5
        _CrossWidth("Cross Width", Range(0, 1)) = 0.2
        _CrossHeight("Cross Height", Range(0, 1)) = 0.2
        _TranslateRadius("Translate Radius", Range(0, 0.5)) = 0.2
        _AnchorX("Anchor X", Range(0, 1)) = 0.3
        _AnchorY("Anchor Y", Range(0, 1)) = 0.4
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        Pass
        {
            CGPROGRAM

            #include "UnityCG.cginc"
            #pragma vertex vert
            #pragma fragment frag

            fixed4 _Color;
            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _CrossRadiusX;
            float _CrossRadiusY;
            float _CrossWidth;
            float _CrossHeight;
            float _TranslateRadius;
            float _AnchorX;
            float _AnchorY;

            struct a2v
            {
                float4 pos : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            v2f vert(a2v v)
            {
                v2f i;
                i.pos = UnityObjectToClipPos(v.pos);
                i.uv = v.uv;

                return i;
            }

            fixed box(float2 start, float2 uv)
            {
                float2 c = smoothstep(start, start + 0.001, uv) * smoothstep(start, start + 0.001, 1.0 - uv);
                return c.x * c.y;
            }

            fixed cross(float2 uv)
            {
                float2 borderH = float2(0.5 - 0.5 * _CrossRadiusX, 0.5 - 0.5 * _CrossHeight);
                float2 borderV = float2(0.5 - 0.5 * _CrossWidth, 0.5 - 0.5 * _CrossRadiusY);
                return box(borderH, uv) + box(borderV, uv);
            }

            float2 translate(float2 uv)
            {
                return uv + float2(_CosTime.w, _SinTime.w) * _TranslateRadius;
            }

            float2 rotate(float2 uv)
            {
                float cosT = _CosTime.w;
                float sinT = _SinTime.w;
                uv = uv - float2(_AnchorX, _AnchorY);
                uv = float2(dot(uv, float2(cosT, sinT)), dot(uv, float2(-sinT, cosT)));
                uv = uv + 0.5;
                return uv;
            }

            float2 scale(float2 uv)
            {
                uv = uv - 0.5;
                float s = _SinTime.w;
                uv = s * uv;
                uv = uv + 0.5;
                return uv;
            }

            fixed4 frag(v2f i) : SV_TARGET
            {
                //i.uv = translate(i.uv);
                i.uv = rotate(i.uv);
                //i.uv = scale(i.uv);
                fixed c = cross(i.uv);
                return fixed4(c, c, c, 1.0);
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}
