FROM rocker/verse

VOLUME ["/src"]
WORKDIR /src
CMD ["./server.sh"]