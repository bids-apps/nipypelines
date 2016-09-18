FROM philcryer/min-jessie

RUN apt-get update \
    && apt-get install -y curl bzip2 libgomp1 libnewmat10ldbl libnifti2 gcc tcsh

# RUN wget -O /etc/apt/sources.list.d/neurodebian.sources.list http://neuro.debian.net/lists/xenial.us-ca.full
# RUN apt-key adv --recv-keys --keyserver hkp://pgp.mit.edu:80 0xA5D32F012649A5A9

RUN cd / && curl -L https://dl.dropbox.com/s/w2x3g9g89xqiq82/resting_progs.tgz | tar zx
RUN curl -O http://repo.continuum.io/miniconda/Miniconda2-latest-Linux-x86_64.sh && bash Miniconda2-latest-Linux-x86_64.sh -b && /root/miniconda2/bin/conda update -yq conda && /root/miniconda2/bin/conda install -y -c conda-forge nipype && /root/miniconda2/bin/pip install https://github.com/nipy/nipy/archive/5bc0712e2e5fe8f2069db3ed6fbbe2f2a89eb987.zip https://github.com/INCF/pybids/archive/83ddc7ed0a56adee06a8b59ae0e9cb8a22baf1ef.zip && /root/miniconda2/bin/conda clean -y --all

ENV FSLDIR /usr/share/fsl/5.0
# ENV POSSUMDIR /usr/share/fsl/5.0
# ENV FSLREMOTECALL
ENV FSL_BIN /usr/share/fsl/5.0/bin
ENV PATH /opt2/freesurfer/bin:/opt2/freesurfer/fsfast/bin:/opt2/freesurfer/tktools:/usr/share/fsl/5.0/bin:/usr/lib/fsl/5.0:/opt2/freesurfer/mni/bin:/opt2/c3d-1.0.0-Linux-x86_64/bin:/opt/ants:/root/miniconda2/bin:$PATH
ENV LD_LIBRARY_PATH /usr/lib/fsl/5.0
# ENV FSLLOCKDIR
# ENV FMRI_ANALYSIS_DIR /opt2/freesurfer/fsfast
ENV FSL_DIR /usr/share/fsl/5.0
ENV FREESURFER_HOME /opt2/freesurfer
# ENV MNI_PERL5LIB /opt2/freesurfer/mni/lib/perl5/5.8.5
# ENV FSLWISH /usr/bin/wish
# ENV MINC_BIN_DIR /opt2/freesurfer/mni/bin
ENV FSLOUTPUTTYPE NIFTI_GZ
ENV SUBJECTS_DIR /opt2/freesurfer/subjects
# ENV MINC_LIB_DIR /opt2/freesurfer/mni/lib
# ENV PERL5LIB /opt2/freesurfer/mni/lib/perl5/5.8.5
# ENV FSLMACHINELIST 
ENV FSLMULTIFILEQUIT TRUE
# ENV FSLTCLSH /usr/bin/tclsh
# ENV MNI_DATAPATH /opt2/freesurfer/mni/data
# ENV MNI_DIR /opt2/freesurfer/mni
# ENV LOCAL_DIR /opt2/freesurfer/local
# ENV FUNCTIONALS_DIR /opt2/freesurfer/sessions

RUN ln -s /usr/lib/fsl/5.0 /usr/share/fsl/5.0/bin

COPY run.py /code/run.py

WORKDIR /code

RUN chmod +x run.py

ENTRYPOINT ["./run.py"]

