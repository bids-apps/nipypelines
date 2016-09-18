## Dataflows for the masses

### Description
This app allows preprocessing functional tasks in a BIDs dataset

Current dataflow requires freesurfer to have been run on a participant

### Documentation
Provide a link to a documention of your pipeline.

### How to report errors
Please create a new issue here: https://github.com/BIDS-Apps/nipypelines/issues/new

### Acknowledgements
Describe how would you like users to acknoledge the use of your App in their papers (citation, a paragraph that should be copy pasted etc.)

### Usage
This App has the following comman line arguments:

		usage: run.py [-h]
		              [--participant_label PARTICIPANT_LABEL [PARTICIPANT_LABEL ...]]
		              bids_dir output_dir {participant,group}

		Example BIDS App entrypoint script.

		positional arguments:
		  bids_dir              The directory with the input dataset formatted
		                        according to the BIDS standard.
		  output_dir            The directory where the output files should be stored.
		                        If you are running group level analysis this folder
		                        should be prepopulated with the results of
		                        theparticipant level analysis.
		  {participant,group}   Level of the analysis that will be performed. Multiple
		                        participant level analyses can be run independently
		                        (in parallel).

		optional arguments:
		  -h, --help            show this help message and exit
		  --participant_label PARTICIPANT_LABEL [PARTICIPANT_LABEL ...]
		                        The label(s) of the participant(s) that should be
		                        analyzed. The label corresponds to
		                        sub-<participant_label> from the BIDS spec (so it does
		                        not include "sub-"). If this parameter is not provided
		                        all subjects should be analyzed. Multiple participants
		                        can be specified with a space separated list.

To run it in participant level mode (for one participant):

    docker run -i --rm \
		-v /path/to/ds005:/bids_dataset \
		-v /path/to/outputs:/outputs \
		-v /path/to/scratch:/scratch \
		bids/example \
		/bids_dataset /outputs participant --participant_label 01


# The necessary files for running the app is generated using the following snippet of code after running `reprozip trace`.

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