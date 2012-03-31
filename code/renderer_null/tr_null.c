#include "../qcommon/q_shared.h"
#include "../renderer/tr_types.h"
#include "../renderer/tr_public.h"

#define	REF_API_VERSION		8

static void RE_Shutdown(qboolean destroyWindow) { }
static void RE_BeginRegistration( glconfig_t *config ) { }
static qhandle_t RE_RegisterModel( const char *name ) { return 0; }
static qhandle_t RE_RegisterSkin( const char *name ) { return 0; }
static qhandle_t RE_RegisterShader( const char *name ) { return 0; }
static qhandle_t RE_RegisterShaderNoMip( const char *name ) { return 0; }
static void RE_LoadWorldMap( const char *name ) { }
static void RE_SetWorldVisData( const byte *vis ) { }
static void RE_EndRegistration( void ) { }
static void RE_ClearScene( void ) { }
static void RE_AddRefEntityToScene( const refEntity_t *re ) { }
static void RE_AddPolyToScene( qhandle_t hShader , int numVerts, const polyVert_t *verts, int num ) { }
static int R_LightForPoint( vec3_t point, vec3_t ambientLight, vec3_t directedLight, vec3_t lightDir ) { return 0; }
static void RE_AddLightToScene( const vec3_t org, float intensity, float r, float g, float b ) { }
static void RE_AddAdditiveLightToScene( const vec3_t org, float intensity, float r, float g, float b ) { }
static void RE_RenderScene( const refdef_t *fd ) { }
static void RE_SetColor( const float *rgba ) { }
static void RE_StretchPic( float x, float y, float w, float h, float s1, float t1, float s2, float t2, qhandle_t hShader ) { }
static void RE_StretchRaw(int x, int y, int w, int h, int cols, int rows, const byte *data, int client, qboolean dirty) { }
static void RE_UploadCinematic(int w, int h, int cols, int rows, const byte *data, int client, qboolean dirty) { }
static void RE_BeginFrame( stereoFrame_t stereoFrame ) { }
static void RE_EndFrame( int *frontEndMsec, int *backEndMsec ) { }
static int R_MarkFragments( int numPoints, const vec3_t *points, const vec3_t projection, int maxPoints, vec3_t pointBuffer, int maxFragments, markFragment_t *fragmentBuffer ) { return 0; }
static int R_LerpTag( orientation_t *tag,  qhandle_t model, int startFrame, int endFrame, float frac, const char *tagName ) { return 0; }
static void R_ModelBounds( qhandle_t model, vec3_t mins, vec3_t maxs ) { }
#ifdef __USEA3D
static void RE_A3D_RenderGeometry) (void *pVoidA3D, void *pVoidGeom, void *pVoidMat, void *pVoidGeomStatus) { }
#endif
static void RE_RegisterFont(const char *fontName, int pointSize, fontInfo_t *font) { }
static void R_RemapShader(const char *oldShader, const char *newShader, const char *offsetTime) { }
static qboolean R_GetEntityToken( char *buffer, int size ) { return qfalse; }
static qboolean R_inPVS( const vec3_t p1, const vec3_t p2 ) { return qfalse; }
static void RE_TakeVideoFrame( int h, int w, byte* captureBuffer, byte *encodeBuffer, qboolean motionJpeg ) { }

refimport_t ri;

#ifdef USE_RENDERER_DLOPEN
Q_EXPORT refexport_t QDECL *GetRefAPI ( int apiVersion, refimport_t *rimp ) {
#else
refexport_t *GetRefAPI ( int apiVersion, refimport_t *rimp ) {
#endif

	static refexport_t      re;

	ri = *rimp;

	Com_Memset( &re, 0, sizeof( re ) );

	if ( apiVersion != REF_API_VERSION ) {
		ri.Printf(PRINT_ALL, "Mismatched REF_API_VERSION: expected %i, got %i\n",
			  REF_API_VERSION, apiVersion );
		return NULL;
	}

	// the RE_ functions are Renderer Entry points

	re.Shutdown = RE_Shutdown;

	re.BeginRegistration = RE_BeginRegistration;
	re.RegisterModel = RE_RegisterModel;
	re.RegisterSkin = RE_RegisterSkin;
	re.RegisterShader = RE_RegisterShader;
	re.RegisterShaderNoMip = RE_RegisterShaderNoMip;
	re.LoadWorld = RE_LoadWorldMap;
	re.SetWorldVisData = RE_SetWorldVisData;
	re.EndRegistration = RE_EndRegistration;

	re.BeginFrame = RE_BeginFrame;
	re.EndFrame = RE_EndFrame;

	re.MarkFragments = R_MarkFragments;
	re.LerpTag = R_LerpTag;
	re.ModelBounds = R_ModelBounds;

	re.ClearScene = RE_ClearScene;
	re.AddRefEntityToScene = RE_AddRefEntityToScene;
	re.AddPolyToScene = RE_AddPolyToScene;
	re.LightForPoint = R_LightForPoint;
	re.AddLightToScene = RE_AddLightToScene;
	re.AddAdditiveLightToScene = RE_AddAdditiveLightToScene;
	re.RenderScene = RE_RenderScene;

	re.SetColor = RE_SetColor;
	re.DrawStretchPic = RE_StretchPic;
	re.DrawStretchRaw = RE_StretchRaw;
	re.UploadCinematic = RE_UploadCinematic;

	re.RegisterFont = RE_RegisterFont;
	re.RemapShader = R_RemapShader;
	re.GetEntityToken = R_GetEntityToken;
	re.inPVS = R_inPVS;

	re.TakeVideoFrame = RE_TakeVideoFrame;

	return &re;
}
