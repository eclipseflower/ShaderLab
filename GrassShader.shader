// 公告板矩阵+顶点振幅+线性雾
Shader "Custom/GrassShader"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Tex", 2D) = "white" {}
        _Amplitude("Amplitude", Range(0, 1)) = 0.1
        _FogStart("FogStart", Range(0, 1)) = 1
        _FogRange("FogRange", Range(1, 50)) = 30
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200
        Cull Off

        Pass
        {
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            fixed4 _Color;
            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _Amplitude;
            float _FogStart;
            float _FogRange;

            struct a2v
            {
                float4 pos : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
                float fogParam : TEXCOORD1;
            };

            v2f vert(a2v v)
            {
                float3 center = 0;
                float3 view = mul(unity_WorldToObject, float4(_WorldSpaceCameraPos, 1.0)).xyz;
                float3 look = normalize(view - center);
                float3 up = float3(0, 1, 0);
                float3 right = normalize(cross(up, look));
                up = normalize(cross(look, right));

                v.pos.xyz = v.pos.x * right + v.pos.y * up + v.pos.z * look + _Amplitude * _SinTime.w;

                float dis = distance(v.pos, view);
                float fogParam = saturate((dis - _FogStart) / _FogRange);

                v2f i;
                i.pos = UnityObjectToClipPos(v.pos);
                i.uv = v.uv;
                i.fogParam = fogParam;

                return i;
            }

            fixed4 frag(v2f i) : SV_TARGET
            {
                fixed4 texCol = tex2D(_MainTex, i.uv);
                fixed4 fogCol = fixed4(0.5, 0.5, 0.5, 1);
                return lerp(texCol, fogCol, i.fogParam);
            }

            ENDCG
        }
    }
    FallBack "Diffuse"
}
