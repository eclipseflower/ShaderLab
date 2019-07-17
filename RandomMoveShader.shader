// 按行随机移动
Shader "Custom/RandomMoveShader"
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
                return frac(sin(dot(uv, float2(_SeedX, _SeedY))) * _Amplitude);
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

                float vec = max(_Row, _Col) * _Time.y * rand(float2(max(_Row, _Col), ipos.y));
                uv.x = floor(0.1 * (uv.x + vec));

                float c = 1 - step(0.5, rand(float2(uv.x, ipos.y))) * step(0.2, fpos.y);

                return fixed4(c, c, c, 1.0);
            }

            ENDCG
        }
    }
    FallBack "Diffuse"
}
