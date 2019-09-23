// 平铺网格噪声
Shader "Custom/TileCellNoiseShader"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Row("Row", Range(1, 5)) = 3
        _Col("Col", Range(1, 5)) = 3
        _Center("Center", Range(0, 1)) = 0.02
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
            float _Row;
            float _Col;
            fixed _Center;

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

            float2 random2(float2 uv)
            {
                return frac(sin(float2(dot(uv, float2(127.1,311.7)), dot(uv, float2(269.5,183.3)))) * 43758.5453);
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
                float2 ipos = floor(uv);
                float2 fpos = frac(uv);
                float2 pt = random2(ipos);
                fixed c = distance(pt, fpos);


                c += step(c, _Center);
                c.r += step(0.98, fpos.x);
                c.r += step(0.98, fpos.y);

                return fixed4(c, c, c, 1.0);
            }

            ENDCG
        }
    }
    FallBack "Diffuse"
}
