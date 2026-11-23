#!/usr/bin/env python3
import shutil, subprocess
from pathlib import Path
root = Path(__file__).resolve().parents[1]
stage = root / 'layout'
out = root / 'packages'
out.mkdir(exist_ok=True)
dylib = next(root.rglob('EditMenuRadiusTweak.dylib'))
dst = stage / 'Library/MobileSubstrate/DynamicLibraries/EditMenuRadius.dylib'
dst.parent.mkdir(parents=True, exist_ok=True)
shutil.copy2(dylib, dst)
bundle = next(root.rglob('EditMenuRadiusPrefs.bundle'))
bdst = stage / 'Library/PreferenceBundles/EditMenuRadiusPrefs.bundle'
if bundle.resolve() != bdst.resolve():
    shutil.rmtree(bdst, ignore_errors=True)
    shutil.copytree(bundle, bdst)
# Sign only Mach-O files; never pass a .bundle directory to ldid.
subprocess.run(['ldid', '-S', str(dst)], check=True)
prefs_bin = bdst / 'EditMenuRadiusPrefs'
if prefs_bin.exists():
    subprocess.run(['ldid', '-S', str(prefs_bin)], check=True)
# Remove debug symbols and other non-runtime build products.
for p in list(bdst.rglob('*.dSYM')):
    if p.is_dir(): shutil.rmtree(p)
package = out / 'com.ning.editmenuradius_0.1.0_iphoneos-arm64e.deb'
subprocess.run(['dpkg-deb', '-b', str(stage), str(package)], check=True)
print(package)
