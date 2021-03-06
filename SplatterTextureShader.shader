﻿// 噪声泼溅
Shader "Custom/SplatterTextureShader"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _VSeedX("Value Seed X", Range(0, 100)) = 1.0
        _VSeedY("Value Seed Y", Range(0, 100)) = 1.0
        _VAmplitude("Amplitude", Range(100, 1000000)) = 1000
        _GSeedX1("Gradient Seed X1", Range(0, 1000)) = 1.0
        _GSeedY1("Gradient Seed Y1", Range(0, 1000)) = 1.0
        _GSeedX2("Gradient Seed X2", Range(0, 1000)) = 1.0
        _GSeedY2("Gradient Seed Y2", Range(0, 1000)) = 1.0
        _GAmplitude("Gradient Amplitude", Range(100, 1000000)) = 1000
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
            float _VSeedX;
            float _VSeedY;
            float _VAmplitude;
            float _GSeedX1;
            float _GSeedY1;
            float _GSeedX2;
            float _GSeedY2;
            float _GAmplitude;

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

            float vrand(float2 uv)
            {
                return frac(sin(dot(uv, float2(_VSeedX, _VSeedY))) * _VAmplitude);
            }

            float vnoise(float2 uv)
            {
                float2 fpos = floor(uv);
                float2 ipos = frac(uv);

                float a = vrand(fpos);
                float b = vrand(fpos + float2(1.0, 0.0));
                float c = vrand(fpos + float2(0.0, 1.0));
                float d = vrand(fpos + float2(1.0, 1.0));
                float2 p = 3 * ipos * ipos - 2 * ipos * ipos * ipos;

                return lerp(lerp(a, b, p.x), lerp(c, d, p.x), p.y);
            }

            float2 grand(float2 uv)
            {
                uv = float2(dot(uv, float2(_GSeedX1, _GSeedY1)), dot(uv, float2(_GSeedX2, _GSeedY2)));
                return -1 + 2 * frac(sin(uv) * _GAmplitude);
            }

            float gnoise(float2 uv)
            {
                float2 fpos = floor(uv);
                float2 ipos = frac(uv);

                float a = dot(grand(fpos), ipos);
                float b = dot(grand(fpos + float2(1.0, 0.0)), ipos - float2(1.0, 0.0));
                float c = dot(grand(fpos + float2(0.0, 1.0)), ipos - float2(0.0, 1.0));
                float d = dot(grand(fpos + float2(1.0, 1.0)), ipos - float2(1.0, 1.0));
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
                float2 uv = i.uv + gnoise(i.uv) * _Time.w;
                float c = smoothstep(0.18, 0.2, gnoise(uv));
                c += smoothstep(0.15, 0.2, gnoise(uv * 10));
                c -= smoothstep(0.35, 0.4, gnoise(uv * 10));

                return fixed4(1 - c, 1 - c, 1 - c, 1.0);
            }

            ENDCG
        }
    }
    FallBack "Diffuse"
}
