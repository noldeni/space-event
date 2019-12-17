//@author: Martin Zrcek, Michal Máša, Andrej Boleslavky: CIANT Prague
//@help: pixel based lightning with point light
//@tags: shading, blinn, fire
//@credits: vvvv group, gouraudShading

// --------------------------------------------------------------------------------------------------
// PARAMETERS:
// --------------------------------------------------------------------------------------------------

//transforms
float4x4 tW: WORLD;        //the models world matrix
float4x4 tV: VIEW;         //view matrix as set via Renderer (DX9)
float4x4 tWV: WORLDVIEW;
float4x4 tWVP: WORLDVIEWPROJECTION;
float4x4 tP: PROJECTION;   //projection matrix as set via Renderer (DX9)

//light properties
float3 lPos <string uiname="Light Position";> = {0, 5, -2};       //light position in world space
float4 ambient  : COLOR <String uiname="Ambient Color";>  = {0.15, 0.15, 0.15, 1};
float4 diffuse  : COLOR <String uiname="Diffuse Color";>  = {0.85, 0.85, 0.85, 1};
float4 specular : COLOR <String uiname="Specular Color";> = {0.35, 0.35, 0.35, 1};
float  shiness <String uiname="Shiness"; float uimin=0.0;> = 25.0;     //shininess of specular highlight
float  specularMultiple <String uiname="Effect Multiple"; float uimin=0.0;> = 5.0;     //shininess of specular highlight
float  bumpMultiple <String uiname="Bump Multiple";> = 1.0;
float2  texSize <String uiname="Bump Texture Size";> = {256.0,256.0};
float  phase <String uiname="SkyDome Phase";> = 0.0;

//texture
texture Tex <string uiname="Texture Diffuse";>;
sampler Samp = sampler_state    //sampler for doing the texture-lookup
{
    Texture   = (Tex);          //apply a texture to the sampler
    MipFilter = LINEAR;         //set the sampler states
    MinFilter = LINEAR;
    MagFilter = LINEAR;
};
//texture
texture TexBump <string uiname="Texture Bump";>;
sampler SampBump = sampler_state    //sampler for doing the texture-lookup
{
    Texture   = (TexBump);          //apply a texture to the sampler
    MipFilter = LINEAR;         	//set the sampler states
    MinFilter = LINEAR;
    MagFilter = LINEAR;
	//WrapS = clamp;
};
float4x4 tTex: TEXTUREMATRIX <string uiname="Texture Transform";>;

struct vs2ps
{
    float4 PositionClipSpace: POSITION;
    float4 TexCd : TEXCOORD0;
    //float4 Diffuse : COLOR0;
	float3 Normal	: TEXCOORD1;
	float3 LightDir	: TEXCOORD2;
	float3 EyeVec	: TEXCOORD3;
};
struct vs2psBump
{
    float4 PositionClipSpace: POSITION;
    float2 TexCd : TEXCOORD0;
	float3 LightDir	: TEXCOORD1;
	float3 EyeVec	: TEXCOORD2;
};

// --------------------------------------------------------------------------------------------------
// VERTEXSHADERS
// --------------------------------------------------------------------------------------------------

vs2ps VS(
    float4 PosO: POSITION,
    float3 NormO: NORMAL,
    float4 TexCd : TEXCOORD0)
{
    vs2ps Out = (vs2ps)0;

    float4 PosW = mul(PosO, tW);
    //inverse light direction in view space
    float3 LightDirW = normalize(lPos - PosW);
    Out.LightDir = mul(LightDirW, tV);
    
    //normal in view space
    Out.Normal = mul(NormO, tWV);
	
    //view direction = inverse vertexposition in viewspace
    float3 PosV = mul(PosW, tV);
    Out.EyeVec = normalize(-PosV);
	
    //position (projected)
    Out.PositionClipSpace  = mul(PosO, tWVP);
    Out.TexCd = mul(TexCd, tTex);

    return Out;
}

vs2psBump VSBumpMapping(
    float4 PosO: POSITION,
    float3 NormO: NORMAL,
    float3 TangO: TANGENT,
    //float3 BinoO: BINORMAL,
    float4 TexCd : TEXCOORD0)
{
    vs2psBump Out = (vs2psBump)0;
    Out.PositionClipSpace  = mul(PosO, tWVP);
	float3 BinoO;
	float3x3 TBN;
	//TangO = normalize(TangO);
	//NormO = normalize(NormO);
	BinoO = cross(TangO,NormO);
	//TangO = cross(NormO,BinoO);
	TBN[0] = mul(TangO, tW);
	TBN[1] = mul(BinoO, tW);
	TBN[2] = mul(NormO, tW);
	
	TBN = transpose(TBN);	// this means multiplying from right

	
    	// vert2light direction in tangent space
    float4 PosW = mul(PosO, tW);
    float3 LightDirW = (lPos - PosW);	// light pos - vertex pos in world space
    Out.LightDir = mul(LightDirW,TBN);

    	// vert2camera direction = inverse vertexposition in screen, to tangent space
    float3 PosV = mul(PosW, tV);
    Out.EyeVec = mul(float3(-PosV), TBN);
	
    //position (projected)
    Out.TexCd = mul(TexCd, tTex);

    return Out;	
}
vs2ps VSSkyDome(
    float4 PosO: POSITION,
    float3 NormO: NORMAL,
    float4 TexCd : TEXCOORD0)
{
    vs2ps Out = (vs2ps)0;
    //Out.LightDir = float3(0,0,0);
    //Out.EyeVec = float3(0,0,0);
	
    //inverted normal in view space
    Out.Normal = mul(NormO, tWV);
    Out.PositionClipSpace  = mul(PosO, tWVP);
    Out.TexCd = mul(TexCd, tTex);

    return Out;
}

// --------------------------------------------------------------------------------------------------
// PIXELSHADERS:
// --------------------------------------------------------------------------------------------------

float4 PS(vs2ps In): COLOR
{
	// Classical school example of Phong shading, available to find on the internet
    float4 textureDiff = tex2D(Samp, In.TexCd);
		//	ambient
	float4 final_color = ambient*textureDiff;	// can be multiplied by texture
	
		//	diffuse
	float3 N = normalize(In.Normal);
	float3 L = normalize(In.LightDir);
	float lambertTerm = max(dot(N,L), 0.0);
	//final_color.a *= textureDiff.a;
	final_color.rgb += textureDiff.rgb*diffuse.rgb*lambertTerm;	// can be multiplied by texture
	
		//	specular
	float3 E = normalize(In.EyeVec);
	float3 R = reflect(-L, N);
	float specularFloat = specularMultiple*pow( max(dot(R,E), 0.0), shiness );
	final_color.rgb += specular.rgb * specularFloat;

    return final_color;
}

float4 PSBumpMapping(vs2psBump In): COLOR
{
	// fragment normals are counted from a height map
    float4 textureDiff = tex2D(Samp, In.TexCd);
    float4 textureBumpUp = tex2D(SampBump, float2(In.TexCd.x,In.TexCd.y-1.0/texSize.y));
    float4 textureBumpDo = tex2D(SampBump, float2(In.TexCd.x,In.TexCd.y+1.0/texSize.y));
    float4 textureBumpLe = tex2D(SampBump, float2(In.TexCd.x-1.0/texSize.x,In.TexCd.y));
    float4 textureBumpRi = tex2D(SampBump, float2(In.TexCd.x+1.0/texSize.x,In.TexCd.y));
	// only red color makes the grey
	float3 tangentT = float3( 0, 1, bumpMultiple*(textureBumpUp.r-textureBumpDo.r));
	float3 tangentS = float3( 1, 0, bumpMultiple*(textureBumpRi.r-textureBumpLe.r));
	float3 bumpNormal = normalize(cross(tangentS,tangentT));
	
	//float3 bumpNormal = (2.0 * (tex2D(BumpMapSampler,input.TexCoord))) - 1.0;
	
		//	ambient
	float4 final_color = 0;
	final_color += ambient*textureDiff;	// can be multiplied by texture
	
		//	diffuse
	float3 N = bumpNormal;
	//N = float3(0,0,1);
	float3 L = normalize(In.LightDir);
	float lambertTerm = max(dot(N,L), 0.0);
	final_color.rgb += textureDiff.rgb*diffuse.rgb*lambertTerm;
	
		//	specular
	float3 E = normalize(In.EyeVec);
	float3 R = reflect(-L, N);
	float specularFloat = specularMultiple*pow( max(dot(R,E), 0.0), shiness );
	final_color.rgb += specular.rgb * specularFloat;

    return final_color;
}

float4 PSFire(vs2ps In): COLOR
{
	// This shader is a realy crazy one :)
	// see the sin function in specular...
	// But it generally is ambient + diffuse contour - specular wave
	// I don't solve the alpha channel. You can make out something yourself.
	
	float3 N = normalize(In.Normal);	// normal
	float3 L = normalize(In.LightDir);	// vertex to light
	float3 E = normalize(In.EyeVec);	// vertex to camera (eye)
	float3 R = reflect(-L, N);			// reflected light

		//	ambient
	float4 final_color = ambient;	// set alpha from ambient
	
		//	diffuse
    //float4 col = tex2D(Samp, In.TexCd);
	float diffAngle = 1-abs(dot(N,E));
	diffAngle=pow(diffAngle,shiness/5.0);
	float lambertTerm = max(dot(N,L), 0.0);
	final_color.rgb += lambertTerm*diffuse.rgb;
	final_color.rgb += specularMultiple*diffAngle*diffuse.rgb;
	
		//	specular
	final_color.rgb -= (1.0-lambertTerm)*specular.rgb;
	float specAngle = min(sin(specularMultiple*dot(R,E)),0.1);
	specAngle=pow(specAngle,shiness/5.0);
	final_color.rgb += diffuse.rgb * specAngle;

    return final_color;
}

float4 PSSimpleFire(vs2ps In): COLOR
{
	// This shader picks an angle between normal and eye of viewer
	// and turns it into a shining contour
	
	float3 N = normalize(In.Normal);
	float3 E = normalize(In.EyeVec);
	float angle = 1-abs(dot(N,E));
	angle=pow(angle,shiness/5.0);
	float4 final_color = ambient-specular+specularMultiple*angle*diffuse;
    //float4 col = tex2D(Samp, In.TexCd);	// no texture enabled
	final_color.a = ambient.a;

    return final_color;

}

float4 PSCull(vs2ps In): COLOR
{
	// Important shader, to hide particles behind geometry (blend it in a group)
    float4 col = 0.0;
	col.a=1.0;
    return col;
}
float4 PSSkyDome(vs2ps In): COLOR
{
	// Classical school example of Phong shading, available to find on the internet
    float4 textureDiff = tex2D(Samp, 4*In.TexCd + phase);
    float4 textureDiff2 = tex2D(Samp, 3*In.TexCd + 2*phase);
		//	ambient
	float4 final_color = ambient;
	final_color.rgb *= (1.0-textureDiff);	// what's behind

		//	diffuse
	final_color += 0.66*diffuse*textureDiff;
	final_color += diffuse*textureDiff2;
	
		// specular
	final_color += specular*pow( (textureDiff+textureDiff2)/2.0 , shiness/5.0 );
	//final_color /= .3*length(final_color);
	
    return final_color;
}


// --------------------------------------------------------------------------------------------------
// TECHNIQUES:
// --------------------------------------------------------------------------------------------------

technique TPhongPoint
{
    pass P0
    {
        //Wrap0 = U;  // useful when mesh is round like a sphere
        VertexShader = compile vs_3_0 VS();
        PixelShader = compile ps_3_0 PS();
    }
}
technique TPhongPointBump
{
	// this technique needs a Mesh with normals and tangents, bump texture and texture dimensions
    pass P0
    {
        //Wrap0 = U;  // useful when mesh is round like a sphere
        VertexShader = compile vs_3_0 VSBumpMapping();
        PixelShader = compile ps_3_0 PSBumpMapping();
    }
}
technique TFire
{
    pass P0
    {
        //Wrap0 = U;  // useful when mesh is round like a sphere
        VertexShader = compile vs_3_0 VS();
        PixelShader = compile ps_3_0 PSFire();
    }
}
technique TSimpleFire
{
    pass P0
    {
        //Wrap0 = U;  // useful when mesh is round like a sphere
        VertexShader = compile vs_3_0 VS();
        PixelShader = compile ps_3_0 PSSimpleFire();
    }
}
technique TCull
{
    pass P0
    {
        //Wrap0 = U;  // useful when mesh is round like a sphere
        VertexShader = compile vs_3_0 VS();
        PixelShader = compile ps_3_0 PSCull();
    }
}
technique TSkyDome
{
    pass P0
    {
    	ZEnable = false;
        Wrap0 = U;  // useful when mesh is round like a sphere
    	VertexShader = compile vs_3_0 VSSkyDome();
        PixelShader = compile ps_3_0 PSSkyDome();
    }
}

technique TGouraudPointFF
{
    pass P0
    {
        //transformations
        NormalizeNormals = true;
        WorldTransform[0]   = (tW);
        ViewTransform       = (tV);
        ProjectionTransform = (tP);

        //material
        MaterialAmbient  = {1, 1, 1, 1};
        MaterialDiffuse  = {1, 1, 1, 1};
        MaterialSpecular = {1, 1, 1, 1};
        MaterialPower    = (shiness);

        //texturing
        Sampler[0] = (Samp);
        TextureTransform[0] = (tTex);
        TexCoordIndex[0] = 0;
        TextureTransformFlags[0] = COUNT2;
        //Wrap0 = U;  // useful when mesh is round like a sphere

        //lighting
        LightEnable[0] = TRUE;
        Lighting       = TRUE;
        SpecularEnable = TRUE;
        
        LightType[0]     = POINT;
        /*LightAmbient[0]  = (ambient);
        LightDiffuse[0]  = (diffuse);
        LightSpecular[0] = (specular);
        LightPosition[0] = (lPos);*/

        //shading
        ShadeMode = GOURAUD;
        VertexShader = NULL;
        PixelShader  = NULL;
    }
}
