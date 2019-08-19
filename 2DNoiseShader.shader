// 2D插值噪声
Shader "Custom/2DNoiseShader"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _SeedX("Seed X", Range(0, 100)) = 1.0
        _SeedY("Seed Y", Range(0, 100)) = 1.0
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
            float _SeedX;
            float _SeedY;
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

            float rand(float2 uv)
            {
                return frac(sin(dot(uv, float2(_SeedX, _SeedY))) * _Amplitude);
            }

            float noise(float2 uv)
            {
                float2 fpos = floor(uv);
                float2 ipos = frac(uv);

                float a = rand(fpos);
                float b = rand(fpos + float2(1.0, 0.0));
                float c = rand(fpos + float2(0.0, 1.0));
                float d = rand(fpos + float2(1.0, 1.0));
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
                float c = noise(uv);
                return fixed4(c, c, c, 1.0);
            }

            ENDCG
        }
    }
    FallBack "Diffuse"
}
