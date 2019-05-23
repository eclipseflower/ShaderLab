// 两种tile平铺
Shader "Custom/TileShader"
{
    Properties
    {
        _BkColor ("Back Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _MainColor("Main Color", Color) = (1,1,1,1)
        _Row("Row", Range(1, 10)) = 4
        _Col("Column", Range(1, 10)) = 4
        _Gap("Gap", Range(0, 1)) = 0.1
        _Diamond("Diamond", Range(0, 1)) = 0.4
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        Pass
        {
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            static float PI = 3.1415926535897932384626433832795;
            fixed4 _BkColor;
            sampler2D _MainTex;
            float4 _MainTex_ST;
            fixed4 _MainColor;
            float _Row;
            float _Col;
            float _Gap;
            float _Diamond;

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
                i.uv.x = v.uv.x * _Row;
                i.uv.y = v.uv.y * _Col;

                return i;
            }

            float2 swap(float2 uv)
            {
                return uv + 0.5 * (2.0 * step(uv, 0.5) - 1);
            }

            float2 rotate(float theta, float2 uv)
            {
                uv = uv - 0.5;
                float cosVal = cos(theta);
                float sinVal = sin(theta);
                uv = float2(dot(uv, float2(cosVal, -sinVal)), dot(uv, float2(sinVal, cosVal)));
                uv = uv + 0.5;
                return uv;
            }

            float rect(float2 size, float2 uv)
            {
                size = float2(0.5, 0.5) - 0.5 * size;
                float2 res = smoothstep(size, 1.001 * size, uv) * smoothstep(size, 1.001 * size, 1.0 - uv);
                return res.x * res.y;
            }

            fixed4 frag(v2f i) : SV_TARGET
            {
                float2 uv = frac(i.uv);
                float2 guv = swap(uv);
                float c1 = rect(float2(1.0 - _Gap, 1.0 - _Gap), guv);
                float2 duv = rotate(PI * 0.25, uv);
                float c2 = rect(float2(_Diamond, _Diamond), duv);
                float c3 = rect(float2(_Diamond * 0.9, _Diamond * 0.9), duv);
                float c = c1 - c2 + 2 * c3;
                return c1 * _BkColor - c2 * _BkColor + step(c1 - c2, -1) * c3 * _BkColor + c3 * _MainColor;
            }

            ENDCG
        }
    }
    FallBack "Diffuse"
}
