#include "FBX.hlsli"

struct SkinOutput
{
float4 pos;
float3 normal;
};

SkinOutput ComputeSkin(VSInput input)
{

	SkinOutput output = (SkinOutput)0;

	uint iBone;
	float weight;
	matrix m;

	//ボーン0
	iBone = input.boneIndices.x;
	weight = input.boneWeights.x;
	m= matSkinning[iBone];
	output.pos += weight * mul(m,input.pos);
	output.normal +=weight * mul((float3x3)m,input.normal);

	//ボーン1
	iBone = input.boneIndices.y;
	weight = input.boneWeights.y;
	m= matSkinning[iBone];
	output.pos += weight * mul(m,input.pos);
	output.normal +=weight * mul((float3x3)m,input.normal);

	//ボーン2
	iBone = input.boneIndices.x;
	weight = input.boneWeights.x;
	m= matSkinning[iBone];
	output.pos += weight * mul(m,input.pos);
	output.normal +=weight * mul((float3x3)m,input.normal);

	//ボーン3
	iBone = input.boneIndices.y;
	weight = input.boneWeights.y;
	m= matSkinning[iBone];
	output.pos += weight * mul(m,input.pos);
	output.normal +=weight * mul((float3x3)m,input.normal);



	return output;
}

VSOutput main(VSInput input)
{
	SkinOutput skinned = ComputeSkin(input);

	// 法線にワールド行列によるスケーリング・回転を適用
	float4 wnormal = normalize(mul(world, float4(skinned.normal, 0)));
	// ピクセルシェーダーに渡す値
	VSOutput output;
	// 行列による座標変換
	output.svpos = mul(mul(viewproj, world), skinned.pos);
	// ワールド法線を次のステージに渡す
	output.normal = wnormal.xyz;
	// 入力値をそのまま次のステージに渡す
	output.uv = input.uv;

	return output;
}