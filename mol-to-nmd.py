# -*- coding: utf-8 -*-
"""
Created on Tue Jan 16 20:00:24 2024

@author: Angela Shipman and Adam Hogan
"""
#USER INPUT====================================================================

count=input("How many vibrational modes are in your file? Type an integer. (Sorry, I'm bad at coding and can't get python to read the bloody last vibration at the moment.)\n")
print("There are "+count+" modes in this calculation.\n")
count=int(count)

molfile=input('Please type the file name of the *.mol file you would like to convert to NMD. Please include the *.mol file extension at the end.\n')
print("MOL file has been set to " + molfile)

nmdfilename=input('Name your *.nmd file. Please include the *.nmd file extension at the end.\n')
print("Got it.\n")

title=input('Name the molecule as it will appear in VMD.\n')
print("Title set to " + title + ".")

#GET INFO FROM FILES===========================================================
mol = open(molfile, "r")

names=[]
coordinates=[]
freqs=[]

modes=[]
mode=[]

read_atoms = False
read_freqs = False
read_vibration = False

#Build list of lists
modes = [[] for _ in range(count)]

#SORT MOL FILE    
for idx, line in enumerate(mol.readlines()):
    split_line = line.split()

    if "[Atoms]" in line:
        read_atoms = True
        continue
   
    if read_atoms:
        if "[FREQ]" in line:
            read_atoms = False
            read_freqs = True
            continue
        names.append(split_line[0])
        coordinates.append(split_line[3])
        coordinates.append(split_line[4])
        coordinates.append(split_line[5])
        
    if read_freqs:
        if "[FR-COORD]" in line:
            read_freqs = False
            continue
        freqs.append(float(split_line[0]))
    if "vibration" in line: #if new vibration starting
        read_vibration = True
        mode_num = int(split_line[1])
        modes[mode_num-1].append(split_line[1])
        continue
    if read_vibration: #if not new vibration starting
        modes[mode_num-1].append(split_line[0])
        modes[mode_num-1].append(split_line[1])
        modes[mode_num-1].append(split_line[2])
        
final_modes=[]
for mode, freq in zip(modes,freqs):
    mode.insert(0,"mode")
    mode.insert(2,str(freq))
    final_modes.append(mode)

#MAKE NMD FILE ==============================================================

nmdfile=[]

#Convert lists to strings in NMD format    
nmdfile.append("nmwiz_load "+ nmdfilename)
nmdfile.append("title " + title)
nmdfile.append("names " + ' '.join(names))
#resids="resids " + resids     these are wrong lol
nmdfile.append("coordinates " + ' '.join(coordinates))
for mode in final_modes:
    nmdfile.append(' '.join(mode))
    
file = open(nmdfilename,'w')
for line in nmdfile:
    file.write(line+"\n")
file.close()
print(molfile + " has been converted to an NMD file, " + nmdfilename + ". You may now load it in VMD > Extensions > Analysis > Normal Mode Wizard.")
