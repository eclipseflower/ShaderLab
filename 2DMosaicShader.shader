// 2D马赛克
Shader "Custom/2DMosaicShader"
{
    Properties
    {
        _MainTex ("MainTex", 2D) = "white" {}
        _Row("Row", Range(1, 10)) = 5
        _Col("Col", Range(1, 10)) = 5
        _SeedX("Seed X", Range(0, 100)) = 1.0
        _SeedY("Seed Y", Range(0, 100)) = 1.0
        _Amplitude("Amplitude", Range(100, 1000000)) = 1000
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
            float _MainTex_ST;
            float _Row;
            float _Col;
            float _SeedX;
            float _SeedY;
            float _Amplitude;

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

            v2f vert(a2v v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.pos);
                o.uv = v.uv;

                return o;
            }

            fixed4 frag(v2f i) : SV_TARGET
            {
                float2 uv = floor(i.uv * float2(_Row, _Col));

                float c = rand(uv);
                return fixed4(c, c, c, 1.0);
            }

            ENDCG
        }
    }
    FallBack "Diffuse"
}
