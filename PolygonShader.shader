// 画正多边形
Shader "Custom/PolygonShader" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Side("Side", float) = 3
	}
	SubShader {
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
			float _Side;
			static float PI = 3.1415926;

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
				float theta = atan2(i.tex.y, i.tex.x);
				float k = 2.0 * PI / _Side;
				float f = cos(floor(0.5 + theta / k) * k - theta) * length(i.tex);
				fixed c = smoothstep(0.2, 0.21, f);
				
				return fixed4(c, c, c, 1.0);
			}

			ENDCG
		}
	}
	FallBack "Diffuse"
}
