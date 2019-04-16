// 画一个圆角矩形
Shader "Custom/RingShader" {
	Properties {
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_PlotX("Plot X", Range(0, 0.5)) = 0.1
		_PlotY("Plot Y", Range(0, 0.5)) = 0.1
		_Radius("Radius", Range(0, 0.5)) = 0.1
		_Thickness("Thickness", Range(0, 1.0)) = 0.2
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		Pass
		{
			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float _PlotX;
			float _PlotY;
			float _Radius;
			float _Thickness;

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
				float2 vec = max(abs(i.tex) - float2(_PlotX, _PlotY), 0);
				float d = length(vec);
				fixed c = smoothstep((1.0 - _Thickness) * _Radius, _Radius, d) * smoothstep(1.1 * _Radius, _Radius, d);
				return fixed4(c, c, c, 1.0);
			}

			ENDCG
		}
	}
	FallBack "Diffuse"
}
