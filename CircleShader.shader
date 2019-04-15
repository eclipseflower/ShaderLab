//画一个圆
Shader "Custom/CircleShader"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Radius("Radius", Range(0, 0.5)) = 0.4
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
            float _Radius;

            struct a2v
            {
                float4 pos : POSITION;
                float2 tex : TEXCOORD0;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 tex : TEXCOORD0;
            };

            v2f vert(a2v v)
            {
                v2f i;
                i.pos = UnityObjectToClipPos(v.pos);
                i.tex = v.tex - float2(0.5, 0.5);

                return i;
            }

            fixed4 frag(v2f i) : SV_TARGET
            {
                float r = sqrt(i.tex.x * i.tex.x + i.tex.y * i.tex.y);
                fixed c = step(r, _Radius);
                return fixed4(c, c, c, 1.0);
            }

            ENDCG
        }
    }
    FallBack "Diffuse"
}
