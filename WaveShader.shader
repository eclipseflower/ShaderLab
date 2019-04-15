Shader "Custom/WaveShader" {
	Properties {
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Sparse("Sparse", Range(1, 100)) = 1.0
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
			float _Sparse;

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
				fixed c = frac(length(i.tex) * _Sparse);
				return fixed4(c, c, c, 1.0);
			}

			ENDCG
		}
	}
	FallBack "Diffuse"
}
