Shader "Unlit/See-Through Shader"
{
	Properties
	{
		_Color("Color", Color) = (1.0, 1.0, 1.0, 0.5)
	}
		SubShader
	{
		Tags{ "RenderType" = "Transparent" "Queue" = "AlphaTest" }
		LOD 100

		Pass
	{
		Cull Off
		ZWrite Off
		ZTest Always
		Blend SrcAlpha OneMinusSrcAlpha

		CGPROGRAM
#pragma vertex vert
#pragma fragment frag
		// make fog work
#pragma multi_compile_fog

#include "UnityCG.cginc"

		struct appdata
	{
		float4 vertex : POSITION;
	};

	struct v2f
	{
		UNITY_FOG_COORDS(1)
			float4 vertex : SV_POSITION;
	};

	float4 _Color;

	v2f vert(appdata v)
	{
		v2f o;
		o.vertex = UnityObjectToClipPos(v.vertex);
		UNITY_TRANSFER_FOG(o,o.vertex);
		return o;
	}

	fixed4 frag(v2f i) : SV_Target
	{
		fixed4 col = _Color;
	//float x = smoothstep(0, 15, i.vertex.x % 25) * smoothstep(25, 10, i.vertex.x % 25);
	//float y = smoothstep(0, 15, i.vertex.y % 25) * smoothstep(25, 10, i.vertex.y % 25);
	//col.a = x * y;
	// apply fog
	UNITY_APPLY_FOG(i.fogCoord, col);
	return col;
	}
		ENDCG
	}
	}
}

