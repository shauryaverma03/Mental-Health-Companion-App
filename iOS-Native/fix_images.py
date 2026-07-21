import os
import json
import glob

assets_dir = '/Users/shauryaverma/Desktop/Mental-Health-Companion-App/MentalHealthCompanion-iOS/MentalHealthCompanion/Assets.xcassets'

for imageset in glob.glob(os.path.join(assets_dir, '*.imageset')):
    contents_path = os.path.join(imageset, 'Contents.json')
    if not os.path.exists(contents_path):
        continue
        
    with open(contents_path, 'r') as f:
        data = json.load(f)
        
    changed = False
    
    for image in data.get('images', []):
        filename = image.get('filename')
        if filename and not filename.endswith('.png'):
            # Old path
            old_file = os.path.join(imageset, filename)
            new_filename = f"{filename}.png"
            new_file = os.path.join(imageset, new_filename)
            
            if os.path.exists(old_file):
                os.rename(old_file, new_file)
                image['filename'] = new_filename
                changed = True
                print(f"Renamed {filename} to {new_filename}")
                
    if changed:
        with open(contents_path, 'w') as f:
            json.dump(data, f, indent=2)
            print(f"Updated {contents_path}")
