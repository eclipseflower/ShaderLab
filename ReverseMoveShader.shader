// 按行随机移动
Shader "Custom/ReverseMoveShader"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Col("Column", Range(2, 10)) = 2
        _SeedX("Seed X", Range(0, 100)) = 1.0
        _SeedY("Seed Y", Range(0, 100)) = 1.0
        _Amplitude("Amplitude", Range(100, 1000000)) = 1000
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

            fixed4 _Color;
            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _Col;
            float _SeedX;
            float _SeedY;
            float _Amplitude;

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

            float rand(float2 uv)
            {
                return frac(sin(dot(uv, float2(_SeedX, _SeedY)) * _Amplitude));
            }

            v2f vert(a2v v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.pos);
                o.uv = v.uv;

                return o;
            }

            fixed4 frag(v2f i) : SV_TARGET
            {
                float2 uv = i.uv * float2(1, _Col);
                float dir = 2 * step(1, fmod(uv.y, 2.0)) - 1;
                float y = floor(uv.y);
                uv = frac(uv);
                uv.x = floor(100 * uv.x) + dir * floor(_Time.y);
                float c = 1 - step(0.8, rand(float2(uv.x, y)));

                return fixed4(c, c, c, 1);
            }

            ENDCG
        }
    }
    FallBack "Diffuse"
}
