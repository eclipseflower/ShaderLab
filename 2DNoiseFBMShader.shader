// 2D FBM
Shader "Custom/2DNoiseFBMShader"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _SeedX("Seed X", Range(0, 100)) = 1.0
        _SeedY("Seed Y", Range(0, 100)) = 1.0
        _Amplitude("Amplitude", Range(100, 1000000)) = 1000
        _FBMAmplitude("FBM Amplitude", Range(0, 1)) = 0.5
        _FBMFreq("FBM Frequency", Range(1, 10)) = 2
        _Octaves("Octaves", Range(1, 10)) = 5
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
            fixed _FBMAmplitude;
            float _FBMFreq;
            float _Octaves;

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
                float2 ipos = floor(uv);
                float2 fpos = frac(uv);

                float a = rand(ipos);
                float b = rand(ipos + float2(1.0, 0.0));
                float c = rand(ipos + float2(0.0, 1.0));
                float d = rand(ipos + float2(1.0, 1.0));
                float2 p = 3 * fpos * fpos - 2 * fpos * fpos * fpos;

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
                float2 uv = 3 * i.uv;
                float amp = 0.5;
                float c = 0;
                for(int i = 1; i <= _Octaves; i++)
                {
                    c += amp * noise(uv);
                    amp *= _FBMAmplitude;
                    uv *= _FBMFreq;
                }

                return fixed4(c, c, c, 1.0);
            }

            ENDCG
        }
    }
    FallBack "Diffuse"
}
