from CRYSTALpytools.crystal_io import Crystal_input
import scipy.spatial.transform
import numpy as np
import os

# Run your *.cif file through this, and get an input structure file (*.gui) + header to copy/paste into your input (*.d12) file

# ==============================================================================
# MONKEY PATCH: Fixes the "buffer source array is read-only" SciPy error
# ==============================================================================
original_apply = scipy.spatial.transform.Rotation.apply


def patched_apply(self, vectors, inverse=False):
    return original_apply(self, np.array(vectors, copy=True), inverse)


scipy.spatial.transform.Rotation.apply = patched_apply
# ==============================================================================

# Define your file names
input_cif = "geo-cellopt.cif"  # Change this to your CIF file's name
output_gui = "structure.gui"  # This is essentially your fort.34 file

if os.path.exists(input_cif):
    print(f"Reading {input_cif}...")

    # --------------------------------------------------------------------------
    # OPTION 1: Generate the .gui (fort.34) file for the EXTERNAL keyword
    # --------------------------------------------------------------------------
    cry_input_ext = Crystal_input().geom_from_cif(input_cif, gui_name=output_gui, keyword='EXTERNAL')
    print(f"\n[1] Saved external geometry file to: {output_gui}")
    print("    (You can use this by putting the word EXTERNAL in your .d12 geometry block)")

    # --------------------------------------------------------------------------
    # OPTION 2: Generate the raw .d12 text block
    # --------------------------------------------------------------------------
    cry_input_d12 = Crystal_input().geom_from_cif(input_cif, keyword='CRYSTAL')

    print("\n[2] Here is your .d12 input geometry block (ready to copy/paste):\n")
    print("-" * 50)
    print(cry_input_d12.geom.data)
    print("-" * 50)

else:
    print(f"Error: Could not find '{input_cif}'. Please check the file path.")
