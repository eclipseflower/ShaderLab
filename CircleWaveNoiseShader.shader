// 波纹噪声
Shader "Custom/CircleWaveNoiseShader"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Radius("Radius", Range(0, 1)) = 0.8
        _Border("Border", Range(0, 1)) = 0.1
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
            float _Radius;
            float _Border;
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

            float shape(float2 uv, float r)
            {
                uv = uv - 0.5;
                float len = length(uv) * 2;
                float angle = atan2(uv.y, uv.x);
                len += sin(angle * 50) * gnoise(uv + _Time.w * 0.2) * 0.1;
                return smoothstep(len, len + 0.007, r);
            }

            float shapeBorder(float2 uv)
            {
                return shape(uv, _Radius) - shape(uv, _Radius - _Border);
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
                float c = shapeBorder(i.uv);
                return fixed4(1 - c, 1 - c, 1 - c, 1.0);
            }

            ENDCG
        }
    }
    FallBack "Diffuse"
}
