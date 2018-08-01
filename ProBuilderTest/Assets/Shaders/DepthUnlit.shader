Shader "Unlit/DepthUnlit"
{
	Properties
	{
		_Color("Color", Color) = (1,1,1,1)
		_FarColor("Far Color", Color) = (1,1,1,1)
		_NearColor("Near Color", Color) = (1,1,1,1)
		_LerpScale("Lerp scale", Range(1,10)) = 1
		_MainTex ("Texture", 2D) = "white" {}
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" "Queue" = "Transparent" }
		LOD 100

		ZWrite Off
		ZTest Always

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			#pragma multi_compile_fog
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
				float3 local_Pos : TEXCOORD1;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			fixed4 _Color;
			fixed4 _FarColor;
			fixed4 _NearColor;
			float _LerpScale;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				o.local_Pos = v.vertex;
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				//fixed4 col = tex2D(_MainTex, i.uv);
				// apply fog
				//UNITY_APPLY_FOG(i.fogCoord, col);
				return lerp(_FarColor, _NearColor, (i.local_Pos.z+1)/ _LerpScale);
			}
			ENDCG
		}
	}
}
