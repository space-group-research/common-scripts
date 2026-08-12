from CRYSTALpytools.convert import cry_out2cif
import scipy.spatial.transform
import numpy as np
import os

#Run your output file from your CRYSTAL23 job (*.out) through here, and it will convert it to a *.cif file

# ==============================================================================
# MONKEY PATCH: Fixes the "buffer source array is read-only" SciPy error
# ==============================================================================
original_apply = scipy.spatial.transform.Rotation.apply


def patched_apply(self, vectors, inverse=False):
    # Intercept the read-only matrix and make a writable copy
    return original_apply(self, np.array(vectors, copy=True), inverse)


# Apply the patch
scipy.spatial.transform.Rotation.apply = patched_apply
# ==============================================================================

# Define your file names
input_file = "crystal-output-file.out"
output_cif = "final-coords.cif"

# Check if the output file actually exists before trying to convert
if os.path.exists(input_file):
    print(f"Reading {input_file}...")

    # Perform the conversion (initial=False gets the final optimized geometry)
    cry_out2cif(output=input_file, cif_file_name=output_cif, initial=False)

    print(f"Success! The optimized structure has been saved to: {output_cif}")
else:
    print(f"Error: Could not find '{input_file}'. Please check the file path.")
