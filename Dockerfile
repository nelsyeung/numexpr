FROM fedora:27 AS build
RUN dnf install --assumeyes gcc-c++ && \
    curl https://mise.run | sh && \
    ~/.local/bin/mise exec python@3.13 -- \
        python -m pip install cibuildwheel==3.4.0 numpy==2.2.6 \
            setuptools==82.0.1 wheel==0.46.3
WORKDIR /workdir
COPY ./ ./
RUN ~/.local/bin/mise mise exec python@3.13 -- python setup.py bdist_wheel

FROM scratch AS artifact
COPY --from=build /workdir/dist/*.whl /

FROM build
