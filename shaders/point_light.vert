#version 450

const vec2 OFFSETS[6] = vec2[](
  vec2(-1.0, -1.0),
  vec2(-1.0, 1.0),
  vec2(1.0, -1.0),
  vec2(1.0, -1.0),
  vec2(-1.0, 1.0),
  vec2(1.0, 1.0)
);

layout(location = 0) out vec2 fragOffset;

struct PointLight
{
  vec4 position; // ignore w
  vec4 color; // w is intensity
};

layout(set = 0, binding = 0) uniform UniformBufferObject
{
  mat4 projection;
  mat4 view;
  mat4 invView;
  vec4 ambientLightColor;
  PointLight pointLights[10]; // could use specilizaation constant here
  int numLights;
} ubo;

layout(push_constant) uniform PushConstant
{
  vec4 position;
  vec4 color;
  float radius;
} push;

const float LIGHT_RADIUS = 0.05;

void main()
{
  fragOffset = OFFSETS[gl_VertexIndex];
  vec3 cameraRightWorld = {ubo.view[0][1], ubo.view[1][1], ubo.view[2][1]};
  vec3 cameraUpWorld = {ubo.view[0][2], ubo.view[1][2], ubo.view[2][2]};

  vec3 PositionWorld = push.position.xyz
    + push.radius * fragOffset.x * cameraRightWorld
    + push.radius * fragOffset.y * cameraUpWorld;

  gl_Position = ubo.projection * ubo.view * vec4(PositionWorld, 1.0);
}