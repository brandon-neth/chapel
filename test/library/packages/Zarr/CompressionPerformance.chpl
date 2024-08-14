use Zarr;
use Time;
use Random;

const D = {0..<1, 0..<100, 0..<1082, 0..<361};
const chunkSize = (1,100,136,23);

config const reps = 10;
var s: stopwatch;

writeln("Compressor,Compression,WriteTime,ReadTime");
for compressor in ["blosclz", "lz4", "lz4hc", "zlib", "zstd"] {
  for compression in 0..9 {
    var A: [D] real(32);
    fillRandom(A);
    s.restart();
    for i in 1..reps do writeZarrArrayLocal("TestLocal", A, chunkSize, compressor=compressor, bloscLevel=compression:int(32));
    var writeTime = s.elapsed();

    s.restart();
    for i in 1..reps do var B = readZarrArrayLocal("TestLocal", real(32), 4);
    var readTime = s.elapsed();

    writeln(",".join([compressor, compression:string, writeTime:string, readTime:string]));

  }
}