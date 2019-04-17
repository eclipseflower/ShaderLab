// 画一个雪花
Shader "Custom/SnowFlakesShader"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _PlotX("Plot X", Range(0, 0.5)) = 0.1
		_PlotY("Plot Y", Range(0, 0.5)) = 0.1
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
            float _PlotX;
			float _PlotY;

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
                float dy = i.tex.y - _PlotY;
                float dx = i.tex.x - _PlotX;
                float theta = atan2(dy, dx);
                float f = 0.4 * abs(cos(12.0 * theta) * sin(3.0 * theta)) + 0.1;
                float r = sqrt(dy * dy + dx * dx);
                fixed c = smoothstep(r, 1.02 * r, f);

                return fixed4(c, c, c, 1.0);
            }

            ENDCG
        }
    }
    FallBack "Diffuse"
}
