// 简易的卡通着色Shader

Shader "Custom/ToonShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_Diffuse ("Diffuse", Color) = (1,1,1,1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
			#include "Lighting.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
				float3 normal : NORMAL;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
				fixed3 worldNormal : TEXCOORD0;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
			fixed4 _Diffuse;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
				fixed3 worldNormal = normalize(UnityObjectToWorldNormal(v.normal));
				o.worldNormal = worldNormal;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
				fixed3 worldLightDir = normalize(WorldSpaceLightDir(i.vertex));
				fixed intensity = saturate(dot(i.worldNormal, worldLightDir));
                // sample the texture
                fixed4 col = tex2D(_MainTex, float2(intensity, 0.5));
                return col;
            }
            ENDCG
        }
    }
}
