"""Run with Blender 4.3: blender --background --factory-startup --python scripts/convert-kenney-pedestrians.py
Requires libassimp (5.x) for native Collada export. Produces only human skins, not zombies.
Original CC0 ZIP and SHA256 are retained in AssetsSource/Kenney.
"""
import bpy, ctypes, ctypes.util, tempfile, zipfile, xml.etree.ElementTree as ET, json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / 'BusinessClicker/Resources/Kenney/Pedestrians'
ARCHIVE = ROOT / 'AssetsSource/Kenney/kenney_animated-characters-retro.zip'
libpath = ctypes.util.find_library('assimp')
if not libpath: raise RuntimeError('Install libassimp before conversion.')
lib = ctypes.CDLL(libpath)
lib.aiImportFile.argtypes = [ctypes.c_char_p, ctypes.c_uint]; lib.aiImportFile.restype = ctypes.c_void_p
lib.aiExportScene.argtypes = [ctypes.c_void_p, ctypes.c_char_p, ctypes.c_char_p, ctypes.c_uint]; lib.aiExportScene.restype = ctypes.c_int
lib.aiReleaseImport.argtypes = [ctypes.c_void_p]; lib.aiGetErrorString.restype = ctypes.c_char_p
ET.register_namespace('', 'http://www.collada.org/2005/11/COLLADASchema')
reports = []
with tempfile.TemporaryDirectory(prefix='business-clicker-kenney-') as temp:
    work = Path(temp)
    with zipfile.ZipFile(ARCHIVE) as archive:
        for name in ['Model/characterMedium.fbx','Animations/run.fbx','Animations/idle.fbx']:
            path = work / name; path.parent.mkdir(parents=True, exist_ok=True); path.write_bytes(archive.read(name))
    for skin in ['male','female']:
        texture = 'humanMaleA.png' if skin == 'male' else 'humanFemaleA.png'
        for animation in ['run','idle']:
            bpy.ops.object.select_all(action='SELECT'); bpy.ops.object.delete(use_global=False)
            for a in list(bpy.data.actions): bpy.data.actions.remove(a)
            bpy.ops.import_scene.fbx(filepath=str(work / 'Model/characterMedium.fbx'))
            original = list(bpy.context.scene.objects)
            rig = next(o for o in original if o.type == 'ARMATURE')
            mesh = next(o for o in original if o.type == 'MESH')
            bpy.ops.import_scene.fbx(filepath=str(work / f'Animations/{animation}.fbx'))
            action = next(a for a in bpy.data.actions if a.name.lower().endswith('|' + animation))
            for o in list(bpy.context.scene.objects):
                if o not in original: bpy.data.objects.remove(o, do_unlink=True)
            rig.animation_data_create(); rig.animation_data.action = action
            scene = bpy.context.scene; scene.frame_start = int(action.frame_range[0]); scene.frame_end = int(action.frame_range[1]); scene.render.fps = 24
            material = bpy.data.materials.new('human_' + skin); material.use_nodes = True
            shader = material.node_tree.nodes.get('Principled BSDF'); shader.inputs['Roughness'].default_value = 0.85
            image = bpy.data.images.load(str(OUT / texture), check_existing=True)
            node = material.node_tree.nodes.new('ShaderNodeTexImage'); node.image = image; node.interpolation = 'Closest'
            material.node_tree.links.new(node.outputs['Color'], shader.inputs['Base Color'])
            mesh.data.materials.clear(); mesh.data.materials.append(material)
            for polygon in mesh.data.polygons: polygon.material_index = 0
            bpy.ops.object.select_all(action='DESELECT')
            for o in original: o.select_set(True)
            bpy.context.view_layer.objects.active = rig
            source = work / f'{skin}-{animation}.fbx'
            bpy.ops.export_scene.fbx(filepath=str(source), use_selection=True, object_types={'ARMATURE','MESH'}, add_leaf_bones=False,
                bake_anim=True, bake_anim_use_all_actions=False, bake_anim_use_nla_strips=False, bake_anim_simplify_factor=0.0,
                axis_forward='-Z', axis_up='Y', path_mode='ABSOLUTE', embed_textures=False)
            imported = lib.aiImportFile(str(source).encode(), 0)
            if not imported: raise RuntimeError(lib.aiGetErrorString().decode())
            target = OUT / f'{skin}-{animation}.dae'
            try:
                if lib.aiExportScene(imported, b'collada', str(target).encode(), 0) != 0: raise RuntimeError(lib.aiGetErrorString().decode())
            finally: lib.aiReleaseImport(imported)
            xml = ET.parse(target); ns = {'c':'http://www.collada.org/2005/11/COLLADASchema'}
            # Portable relative resource paths; never retain a conversion-machine path.
            for image_node in xml.findall('.//c:library_images/c:image/c:init_from',ns): image_node.text = texture
            duration = (scene.frame_end - scene.frame_start) / scene.render.fps
            time_sources = {node.get('source')[1:] for node in xml.findall('.//c:sampler/c:input',ns) if node.get('semantic') == 'INPUT'}
            for identifier in time_sources:
                array = xml.find('.//c:source[@id="'+identifier+'"]/c:float_array',ns)
                values = list(map(float,array.text.split())); start = min(values); span = max(values) - start
                if span > 0: array.text = ' '.join(f'{(v-start)*duration/span:.9g}' for v in values)
            xml.write(target, encoding='utf-8', xml_declaration=True)
            joints = xml.findall('.//c:node[@type="JOINT"]',ns)
            channels = xml.findall('.//c:channel',ns)
            if not joints or not channels: raise RuntimeError('Export lost skeleton or animation: ' + target.name)
            reports.append({'file':target.name,'skin':skin,'animation':animation,'joints':len(joints),'channels':len(channels),'frames':[scene.frame_start,scene.frame_end],'fps':24})
            print('EXPORTED',reports[-1])
(OUT / 'conversion.json').write_text(json.dumps({'tool':'Blender 4.3.2 + Assimp 5.4.3','license':'CC0-1.0','models':reports},indent=2)+'\n')
