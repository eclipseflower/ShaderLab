// 2D梯度噪声
Shader "Custom/2DGradientNoiseShader"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _SeedX1("Seed X1", Range(0, 1000)) = 1.0
        _SeedY1("Seed Y1", Range(0, 1000)) = 1.0
        _SeedX2("Seed X2", Range(0, 1000)) = 1.0
        _SeedY2("Seed Y2", Range(0, 1000)) = 1.0
        _Amplitude("Amplitude", Range(100, 1000000)) = 1000
        _Row("Row", Range(1, 10)) = 5
        _Col("Col", Range(1, 10)) = 5
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
            float _SeedX1;
            float _SeedY1;
            float _SeedX2;
            float _SeedY2;
            float _Amplitude;
            float _Row;
            float _Col;

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

            float2 rand(float2 uv)
            {
                uv = float2(dot(uv, float2(_SeedX1, _SeedY1)), dot(uv, float2(_SeedX2, _SeedY2)));
                return -1 + 2 * frac(sin(uv) * _Amplitude);
            }

            float noise(float2 uv)
            {
                float2 fpos = floor(uv);
                float2 ipos = frac(uv);

                float a = dot(rand(fpos), ipos);
                float b = dot(rand(fpos + float2(1.0, 0.0)), ipos - float2(1.0, 0.0));
                float c = dot(rand(fpos + float2(0.0, 1.0)), ipos - float2(0.0, 1.0));
                float d = dot(rand(fpos + float2(1.0, 1.0)), ipos - float2(1.0, 1.0));
                float2 p = 3 * ipos * ipos - 2 * ipos * ipos * ipos;

                return lerp(lerp(a, b, p.x), lerp(c, d, p.x), p.y);
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
                float c = noise(uv) * 0.5 + 0.5;

                return fixed4(c, c, c, 1.0);
            }

            ENDCG
        }
    }
    FallBack "Diffuse"
}
