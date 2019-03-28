// 基础光照

Shader "Custom/BaseLightShader"
{
    Properties
    {
        _Diffuse ("Diffuse", Color) = (1,1,1,1)
        _Spec("Spec", Color) = (1,1,1,1)
        _Power("Power", Range(1, 256)) = 5
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        Pass
        {
            CGPROGRAM

            #include "Lighting.cginc"
            #pragma vertex vert
            #pragma fragment frag

            fixed4 _Diffuse;
            fixed4 _Spec;
            float _Power;

            struct a2v
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                fixed4 color : COLOR;
            };

            v2f vert(a2v v)
            {
                v2f i;
                i.vertex = UnityObjectToClipPos(v.vertex);
                fixed4 ambient = UNITY_LIGHTMODEL_AMBIENT;
                fixed3 worldNormal = normalize(mul(v.normal, (float3x3)unity_WorldToObject));
                fixed3 worldLight = normalize(_WorldSpaceLightPos0.xyz);
                fixed4 diffuse = fixed4(saturate(dot(worldNormal, worldLight)) * _LightColor0.rgb * _Diffuse.rgb, _Diffuse.a);
                float4 worldPos = mul(unity_ObjectToWorld, v.vertex);
                fixed3 view = normalize(_WorldSpaceCameraPos - worldPos.xyz);
                fixed3 vec = normalize(reflect(-worldLight, worldNormal));
                fixed4 spec = fixed4(pow(saturate(dot(view, vec)), _Power) * _LightColor0.rgb * _Spec.rgb, _Spec.a);

                i.color = ambient + diffuse + spec;
                return i;
            }

            fixed4 frag(v2f i) : SV_TARGET
            {
                return i.color;
            }

            ENDCG
        }
    }
    FallBack "Diffuse"
}
