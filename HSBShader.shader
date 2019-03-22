// HSB转RGB
Shader "Custom/HSBShader"
{
    Properties
    {
        _HSB ("HSB", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
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

            fixed4 _HSB;
            sampler2D _MainTex;
            float4 _MainTex_ST;
            static float TWO_PI = 6.283185307179586476925286766559;

            struct a2v
            {
                float4 position : POSITION;
                float2 texcoord : TEXCOORD0;
            };

            struct v2f
            {
                float4 position : SV_POSITION;
                float2 texcoord : TEXCOORD0; 
            };

            fixed3 hsb2rgb(fixed3 c)
            {
                fixed3 rgb = clamp(abs(fmod(c.x * 6.0 + float3(0.0, 4.0, 2.0), 6.0) - 3.0) - 1.0, 0.0, 1.0);
                rgb = rgb * rgb * (3.0 - 2.0 * rgb);
                return c.z * lerp(fixed3(1.0, 1.0, 1.0), rgb, c.y);
            }

            v2f vert(a2v v)
            {
                v2f i;
                i.position = UnityObjectToClipPos(v.position);
                i.texcoord = v.texcoord - float2(0.5, 0.5);

                return i;
            }

            fixed4 frag(v2f i) : SV_TARGET
            {
                float angle = atan2(i.texcoord.y, i.texcoord.x) / TWO_PI + 0.5;
                float radius = length(i.texcoord) * 2.0;
                return fixed4(hsb2rgb(fixed3(angle, radius, 1.0)), 1.0);
            }

			ENDCG
		}
    }
    FallBack "Diffuse"
}
