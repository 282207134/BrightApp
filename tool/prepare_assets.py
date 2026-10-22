"""Trim transparent Pixso padding and encode local assets as WebP."""
from pathlib import Path
from PIL import Image

for path in Path('assets/images').glob('*.png'):
    image = Image.open(path).convert('RGBA')
    if path.stem not in {'onboarding', 'profile_cover', 'mamba_banner'}:
        bounds = image.getchannel('A').getbbox()
        if bounds:
            image = image.crop(bounds)
    image.thumbnail((1100, 1600))
    image.save(path.with_suffix('.webp'), quality=88, method=6)
    path.unlink()
