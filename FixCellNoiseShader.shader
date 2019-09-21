// 固定点网格噪声
Shader "Custom/FixCellNoiseShader" 
{
	Properties 
	{
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_FirstCellX("First Cell X", range(0, 1)) = 0.83
		_FirstCellY("First Cell Y", range(0, 1)) = 0.75
		_SecondCellX("Second Cell X", range(0, 1)) = 0.6
		_SecondCellY("Second Cell Y", range(0, 1)) = 0.07
		_ThirdCellX("Third Cell X", range(0, 1)) = 0.28
		_ThirdCellY("Third Cell Y", range(0, 1)) = 0.64
		_FourthCellX("Fourth Cell X", range(0, 1)) = 0.31
		_FourthCellY("Fourth Cell Y", range(0, 1)) = 0.26
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
			float4 _MainTex_ST;

			fixed _FirstCellX;
			fixed _FirstCellY;
			fixed _SecondCellX;
			fixed _SecondCellY;
			fixed _ThirdCellX;
			fixed _ThirdCellY;
			fixed _FourthCellX;
			fixed _FourthCellY;

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

			v2f vert(a2v v)
			{
				v2f i;
				i.pos = UnityObjectToClipPos(v.pos);
				i.uv = v.uv;

				return i;
			}

			fixed4 frag(v2f i) : SV_TARGET
			{
				float d = 1.414;
				d = min(d, distance(i.uv, float2(_FirstCellX, _FirstCellY)));
				d = min(d, distance(i.uv, float2(_SecondCellX, _SecondCellY)));
				d = min(d, distance(i.uv, float2(_ThirdCellX, _ThirdCellY)));
				d = min(d, distance(i.uv, float2(_FourthCellX, _FourthCellY)));

				return fixed4(d, d, d, 1.0);
			}

			ENDCG
		}	
	}
	FallBack "Diffuse"
}
