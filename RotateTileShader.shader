// 旋转花纹tile
Shader "Custom/RotateTileShader"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Row("Row", Range(1, 10)) = 4
        _Col("Column", Range(1, 10)) = 4
        _Speed("Speed", Range(0, 10)) = 1
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

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _Row;
            float _Col;
            float _Speed;

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

            float2 rotate(float angle, float2 uv)
            {
                uv = uv - 0.5;
                float cosVal = cos(angle);
                float sinVal = sin(angle);
                uv = float2(dot(uv, float2(cosVal, sinVal)), dot(uv, float2(-sinVal, cosVal)));
                uv = uv + 0.5;

                return uv;
            }

            float doubleTriangle(float2 uv)
            {
                return step(uv.x, uv.y);
            }

            float pattern(float2 uv)
            {
                float dx = step(0.5, uv.x);
                float dy = step(0.5, uv.y);
                float index = abs(3 * dy - dx);
                float2 tile = frac(uv * 2);
                tile = rotate(0.5 * index * PI, tile);
                return doubleTriangle(tile);
            }

            v2f vert(a2v v)
            {
                v2f i;
                i.pos = UnityObjectToClipPos(v.pos);
                i.uv = v.uv * float2(_Row, _Col);

                return i;
            }

            fixed4 frag(v2f i) : SV_TARGET
            {
                float2 uv = frac(i.uv);
                float t = _Time.y * _Speed;
                uv = rotate(t, uv);
                float c = pattern(uv);

                return fixed4(c, c, c, 1.0);
            }

            ENDCG
        }
    }
    FallBack "Diffuse"
}
