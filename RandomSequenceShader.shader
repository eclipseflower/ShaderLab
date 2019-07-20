// 格子随机移动序列
Shader "Custom/RandomSequenceShader"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Row("Row", Range(10, 100)) = 50
        _Col("Column", Range(10, 100)) = 100
        _SeedX("Seed X", Range(0, 100)) = 1.0
        _SeedY("Seed Y", Range(0, 100)) = 1.0
        _Amplitude("Amplitude", Range(100, 1000000)) = 1000
        _Speed("Speed", Range(1, 100)) = 10
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
            float _Row;
            float _Col;
            float _SeedX;
            float _SeedY;
            float _Amplitude;
            float _Speed;

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
                float2 uv = i.uv * float2(_Row, _Col);
                float2 ipos = floor(uv);
                float2 fpos = frac(uv);

                float dir = 2 * step(1, fmod(uv.y, 2.0)) - 1;
                float vec = fmod(_Speed * _Time.y, _Row * _Col);
                float vec2 = rand(float2(1, ipos.y)) * _Speed * _Time.y;

                // 分隔线跟着格子移动
                float margin = step(0.1, frac(uv.x + dir * vec2)) * step(0.1, fpos.y);
                float time = step(ipos.y + 1, floor(vec / _Row)) + step(ipos.y, floor(vec / _Row)) * step(ipos.x, fmod(vec, _Row));
                time = clamp(time, 0, 1);
                float pattern = step(0.5, rand(float2(floor(uv.x + dir * vec2), ipos.y)));
                float c =  1 - margin * time * pattern;

                return fixed4(c, c, c, 1.0);
            }

            ENDCG
        }
    }
    FallBack "Diffuse"
}
