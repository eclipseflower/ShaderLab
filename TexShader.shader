// 测试unity texture的scale和offset

Shader "Custom/TexShader"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
	}
		SubShader
	{
		Tags { "RenderType" = "Opaque" }
		LOD 200

		Pass
		{
			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag

			sampler2D _MainTex;
			float4 _MainTex_ST;

			struct appdata 
			{
				float4 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
			};

			struct v2f 
			{
				float4 vertex : SV_POSITION;
				float2 texcoord : TEXCOORD0;
			};

			v2f vert(appdata v) 
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.texcoord = v.texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
				return o;
			}

			fixed4 frag(v2f i) : SV_TARGET
			{
				return fixed4(tex2D(_MainTex, i.texcoord).rgb, 1.0);
			}

			ENDCG
		}

    }
    FallBack "Diffuse"
}
