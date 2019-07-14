// 2D 随机迷宫
Shader "Custom/2DMazeShader"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("MainTex", 2D) = "white" {}
        _Row("Row", Range(1, 10)) = 5
        _Col("Col", Range(1, 10)) = 5
        _SeedX("Seed X", Range(0, 100)) = 1.0
        _SeedY("Seed Y", Range(0, 100)) = 1.0
        _Amplitude("Amplitude", Range(100, 1000000)) = 1000
        _Thickness("Thickness", Range(0, 0.2)) = 0.03
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
            float _Thickness;

            static float PI = 3.1415926535897932384626433832795;

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

            float2 rotate(float angle, float2 uv)
            {
                uv = uv - 0.5;
                float cosVal = cos(angle);
                float sinVal = sin(angle);
                uv = float2(dot(uv, float2(cosVal, -sinVal)), dot(uv, float2(sinVal, cosVal)));
                uv = uv + 0.5;

                return uv;
            }

            float pattern(float2 uv)
            {
                return smoothstep(uv.y - _Thickness, uv.y, uv.x) * smoothstep(uv.y + _Thickness, uv.y, uv.x);
            }

            float truchetPattern(float2 fpos, float2 ipos)
            {
                float index = rand(fpos);
                index = floor(index * 4);
                ipos = rotate(index * PI * 0.5, ipos);
                return pattern(ipos);
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
                uv = (uv - 0.5 * float2(_Row, _Col)) * abs(_SinTime.w) * 5;
                uv.x = uv.x + _Time.y * 5;
                float2 fpos = floor(uv);
                float2 ipos = frac(uv);

                float c = truchetPattern(fpos, ipos);

                return fixed4(c, c, c, 1.0);
            }

            ENDCG
        }
    }
    FallBack "Diffuse"
}
