/** 
 * @file normaldebugG.glsl
 *
 * $LicenseInfo:firstyear=2023&license=viewerlgpl$
 * Second Life Viewer Source Code
 * Copyright (C) 2023, Linden Research, Inc.
 * 
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation;
 * version 2.1 of the License only.
 * 
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
 * 
 * Linden Research, Inc., 945 Battery Street, San Francisco, CA  94111  USA
 * $/LicenseInfo$
 */

out vec4 vertex_color;

in vec4 normal_g[];
#if HAS_ATTRIBUTE_TANGENT == 1
in vec4 tangent_g[];
#endif

layout(TRIANGLES) in;
#if HAS_ATTRIBUTE_TANGENT == 1
layout(LINE_STRIP, max_vertices = 12) out;
#else
layout(LINE_STRIP, max_vertices = 6) out;
#endif

void triangle_normal_debug(int i)
{
    // Normal
    vec4 normal_color = vec4(1.0, 1.0, 0.0, 1.0);
    gl_Position = gl_in[i].gl_Position;
    vertex_color = normal_color;
    EmitVertex();
    gl_Position = normal_g[i];
    vertex_color = normal_color;
    EmitVertex();
    EndPrimitive();

#if HAS_ATTRIBUTE_TANGENT == 1
    // Tangent
    vec4 tangent_color = vec4(0.0, 1.0, 1.0, 1.0);
    gl_Position = gl_in[i].gl_Position;
    vertex_color = tangent_color;
    EmitVertex();
    gl_Position = tangent_g[i];
    vertex_color = tangent_color;
    EmitVertex();
    EndPrimitive();
#endif
}

void main()
{
    triangle_normal_debug(0);
    triangle_normal_debug(1);
    triangle_normal_debug(2);
}
