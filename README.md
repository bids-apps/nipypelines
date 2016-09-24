## Dataflows for the masses

### Description
This app allows preprocessing functional tasks in a BIDs dataset.

A preprocessing workflow for functional timeseries data.

This workflow makes use of ANTS, FreeSurfer, FSL, NiPy, and CompCor.

This workflow includes 2mm subcortical atlas and templates that are available from:

http://mindboggle.info/data.html

specifically the 2mm versions of:

- `Joint Fusion Atlas <http://mindboggle.info/data/atlases/jointfusion/OASIS-TRT-20_jointfusion_DKT31_CMA_labels_in_MNI152_2mm_v2.nii.gz>`_
- `MNI template <http://mindboggle.info/data/templates/ants/OASIS-30_Atropos_template_in_MNI152_2mm.nii.gz>`_

Requirements:
Current dataflow requires freesurfer to have been run on a participant and stored in /bids_dataset/derivatives/freesurfer.
The docker container allows you to mount your own freesurfer directory and provide the path to it using the `--subjects_dir` 
flag.

### How to report errors
Please create a new issue here: https://github.com/BIDS-Apps/nipypelines/issues/new

### Acknowledgements
Please use the following zenodo citation when using this App.

### Usage
This App has the following command line arguments:

usage: run.py [-h]
              [--participant_label PARTICIPANT_LABEL [PARTICIPANT_LABEL ...]]
              [-t TARGET_FILE] [--subjects_dir FSDIR]
              [--target_surfaces TARGET_SURFS [TARGET_SURFS ...]]
              [--vol_fwhm VOL_FWHM] [--surf_fwhm SURF_FWHM] [-l LOWPASS_FREQ]
              [-u HIGHPASS_FREQ] [-w WORK_DIR] [-p PLUGIN]
              [--plugin_args PLUGIN_ARGS]
              bids_dir output_dir {participant}

positional arguments:
  bids_dir              The directory with the input dataset formatted according to the BIDS standard.
  output_dir            The directory where the output files should be stored. If you are running group level analysis this folder should be prepopulated with the results of theparticipant level analysis.
  {participant}         Level of the analysis that will be performed. Multiple participant level analyses can be run independently (in parallel) using the same output_dir.

optional arguments:
  -h, --help            show this help message and exit
  --participant_label PARTICIPANT_LABEL [PARTICIPANT_LABEL ...]
                        The label(s) of the participant(s) that should be analyzed. The label corresponds to sub-<participant_label> from the BIDS spec (so it does not include "sub-"). If this parameter is not provided all subjects should be analyzed. Multiple participants can be specified with a space separated list.
  -t TARGET_FILE, --target TARGET_FILE
                        Target in MNI space. Best to use the MindBoggle template - OASIS-30_Atropos_template_in_MNI152_2mm.nii.gz
  --subjects_dir FSDIR  FreeSurfer subject directory
  --target_surfaces TARGET_SURFS [TARGET_SURFS ...]
                        FreeSurfer target surfaces (default ['fsaverage5'])
  --vol_fwhm VOL_FWHM   Spatial FWHM (default 6.0)
  --surf_fwhm SURF_FWHM
                        Spatial FWHM (default 15.0)
  -l LOWPASS_FREQ, --lowpass_freq LOWPASS_FREQ
                        Cutoff frequency for low pass filter (Hz) (default 0.1)
  -u HIGHPASS_FREQ, --highpass_freq HIGHPASS_FREQ
                        Cutoff frequency for high pass filter (Hz) (default 0.01)
  -w WORK_DIR, --work_dir WORK_DIR
                        Work directory
  -p PLUGIN, --plugin PLUGIN
                        Plugin to use
  --plugin_args PLUGIN_ARGS
                        Plugin arguments

To run it in participant level mode (for one participant):

    docker run -i --rm \
		-v /path/to/ds005:/bids_dataset \
		-v /path/to/outputs:/outputs \
		bids/nipypelines \
		/bids_dataset /outputs participant --participant_label 01

### Commercial use

The following **non-free** Debian packages are part of this BIDS App:

    non-free/science        fsl-5.0-core
    non-free/science        fsl-atlases

If you are considering commercial use of this App please consult the relevant licenses.

### Using reprozip to minimize container size

This app compresses the FreeSurfer and FSL routines used in the Dockerfile to minimize size. This was carried 
out using (reprozip)[https://vida-nyu.github.io/reprozip/] inside a docker container. 

`reprozip trace --dir /outputs/trace python run.py /bids_dataset /outputs participant --participant_label 01`

This generates a `config.yml` containing all the necessary files used in running the software. The necessary 
files for running the app is generated using the following snippet of code after running `reprozip trace`.

```
from yaml import read
import yaml as yl
import os
import json

with open('config.yml', 'rt') as fp:
    data = yl.load(fp)

paths1 = [val['path'] for val in data['inputs_outputs'] if all([key not in val['path'] for key in ('bids_dataset', 'scratch', 'outputs', '/run')])]
paths2 = [val for val in data['other_files'] if ('fsl' in val or 'opt' in val ) and ('miniconda' not in val and 'bids_dataset' not in val)]

paths = [val for val in paths1 if val not in paths2] + paths2
files = [val for val in paths if not os.path.isdir(val)]

os.system('tar zcf files.tgz %s' % ' '.join(files))

rel_env = dict([(k, v) for k, v in data['runs'][0]['environ'].items() if any([key in k.lower() or key in v.lower() for key in ('fsl', 'freesurfer')])])
info = dict(files=files, environ=rel_env)

with open('appinfo.json', 'wt') as fp:
    json.dump(info, fp, indent=2)
```

### TODO

  - [ ] Add revised version with Topup processing
  - [ ] Add CIFTI2 output using nibabel
  - [ ] Allow custom ROIs to be processed
  - [ ] Generate default seed-based connectomes 
  - [ ] Generate embedded maps
