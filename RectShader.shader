// 画一个矩形

Shader "Custom/RectShader"
{
    Properties
    {
        _MainTex ("Canvas", 2D) = "white" {}
        _Width("Width", Range(0, 1)) = 0.8
        _Height("Height", Range(0, 1)) = 0.8
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
            float _Width;
            float _Height;

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

            v2f vert(a2v v)
            {
                v2f i;
                i.pos = UnityObjectToClipPos(v.pos);
                i.uv = v.uv - float2(0.5, 0.5);

                return i;
            }

            fixed4 frag(v2f i) : SV_TARGET
            {
                fixed c = step(abs(i.uv.x), 0.5 * _Width) * step(abs(i.uv.y), 0.5 * _Height);
                return fixed4(c, c, c, 1.0);
            }

            ENDCG
        }
    }
    FallBack "Diffuse"
}
