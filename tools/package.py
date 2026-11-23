#!/usr/bin/env python3
import os,shutil,subprocess,sys,tempfile
from pathlib import Path
root=Path(__file__).resolve().parents[1]
stage=root/'layout'
out=root/'packages'; out.mkdir(exist_ok=True)
for p in root.rglob('EditMenuRadiusTweak.dylib'):
    dst=stage/'Library/MobileSubstrate/DynamicLibraries/EditMenuRadius.dylib'; dst.parent.mkdir(parents=True,exist_ok=True); shutil.copy2(p,dst)
for p in root.rglob('EditMenuRadiusPrefs.bundle'):
    dst=stage/'Library/PreferenceBundles/EditMenuRadiusPrefs.bundle'
    if p.resolve()!=dst.resolve(): shutil.copytree(p,dst,dirs_exist_ok=True)
control=stage/'DEBIAN/control'
subprocess.run(['ldid','-S',str(stage/'Library/MobileSubstrate/DynamicLibraries/EditMenuRadius.dylib')],check=True)
subprocess.run(['ldid','-S',str(stage/'Library/PreferenceBundles/EditMenuRadiusPrefs.bundle/EditMenuRadiusPrefs')],check=False)
subprocess.run(['dpkg-deb','-b',str(stage),str(out/'com.ning.editmenuradius_0.1.0_iphoneos-arm64e.deb')],check=True)
