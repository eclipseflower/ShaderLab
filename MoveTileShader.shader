// Tile横竖移动
Shader "Custom/MoveTileShader"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Row("Row", Range(1, 10)) = 4
        _Col("Column", Range(1, 10)) = 4
        _Speed("Speed", Range(0, 10)) = 0.5
        _Radius("Radius", Range(0, 0.5)) = 0.2
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
            float _Radius;

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

            float circle(float radius, float2 uv)
            {
                return smoothstep(radius * 0.9, radius, length(uv - 0.5));
            }

            v2f vert(a2v v)
            {
                v2f i;
                i.pos = UnityObjectToClipPos(v.pos);
                i.uv.x = v.uv.x * _Row;
                i.uv.y = v.uv.y * _Col;

                return i;
            }

            fixed4 frag(v2f i) : SV_TARGET
            {
                float t = _Time.y * _Speed;

                float2 hori = step(1, fmod(t, 2.0));
                float2 dir = 2 * step(1.0, fmod(i.uv, 2.0)) - 1;

                i.uv.x = i.uv.x + hori * dir.y * t;
                i.uv.y = i.uv.y + (1 - hori) * dir.x * t;

                float2 uv = frac(i.uv);
                float c = circle(_Radius, uv);
                return fixed4(c, c, c, 1.0);
            }

            ENDCG
        }
    }
    FallBack "Diffuse"
}
