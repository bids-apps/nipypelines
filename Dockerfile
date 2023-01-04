FROM philcryer/min-jessie

RUN apt-get update -qq \
    && apt-get install -q -y --no-install-recommends --force-yes \
            curl \
            ca-certificates  \
            apt-utils \
            bzip2 \
            libgomp1 \
            libnewmat10ldbl \
            libnifti2 \
            gcc \
            tcsh

RUN cd / && curl -L https://dl.dropbox.com/s/w2x3g9g89xqiq82/resting_progs.tgz | tar zx && \
    curl -sSLO http://repo.continuum.io/miniconda/Miniconda2-latest-Linux-x86_64.sh && \
    bash Miniconda2-latest-Linux-x86_64.sh -b && /root/miniconda2/bin/conda update -yq conda && /root/miniconda2/bin/conda install -y -c conda-forge nipype && /root/miniconda2/bin/pip install https://github.com/nipy/nipy/archive/5bc0712e2e5fe8f2069db3ed6fbbe2f2a89eb987.zip https://github.com/INCF/pybids/archive/83ddc7ed0a56adee06a8b59ae0e9cb8a22baf1ef.zip && /root/miniconda2/bin/conda clean -y --all

ENV FSLDIR /usr/share/fsl/5.0
ENV FSL_BIN /usr/share/fsl/5.0/bin
ENV PATH /opt2/freesurfer/bin:/opt2/freesurfer/fsfast/bin:/opt2/freesurfer/tktools:/usr/share/fsl/5.0/bin:/usr/lib/fsl/5.0:/opt2/freesurfer/mni/bin:/opt2/c3d-1.0.0-Linux-x86_64/bin:/opt/ants:/root/miniconda2/bin:$PATH
ENV LD_LIBRARY_PATH /usr/lib/fsl/5.0
ENV FSL_DIR /usr/share/fsl/5.0
ENV FREESURFER_HOME /opt2/freesurfer
ENV FSLOUTPUTTYPE NIFTI_GZ
ENV SUBJECTS_DIR /opt2/freesurfer/subjects
ENV FSLMULTIFILEQUIT TRUE


RUN ln -s /usr/lib/fsl/5.0 /usr/share/fsl/5.0/bin

COPY run.py /code/run.py

WORKDIR /code

RUN chmod +x run.py

ENTRYPOINT ["./run.py"]
