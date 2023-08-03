docker run -it --rm \
  --name ghmac \
  --privileged \
   -v "$(pwd)/example:/root/example" \
  --pid=host \
  yangyw12345/cxlmemsim:v1 bash
