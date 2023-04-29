#!/usr/bin/python3

# import whisper
import ffmpeg
import sys

from logging import error
from chord_extractor.extractors import Chordino

c = Chordino(roll_on=1)
# m = whisper.load_model("base")

file = sys.argv[1]

tmp_name = "/tmp/_a2c.srt"
srt_file = open(tmp_name, "w")
if srt_file == None:
    error("cannot open {}".format(tmp_name))
    exit(1)

chords = c.extract(file)

for i in range(len(chords) - 1):
    prev_crd = "" if i == 0 else chords[i-1].chord

    cur = chords[i]
    nxt = chords[i + 1]
    t   = cur.timestamp

    h    = int(t / 3600)
    t   -= h * 3600
    m    = int(t / 60)
    t   -= m * 60
    s    = int(t)
    n    = int((t - s) * 100)

    t    = nxt.timestamp
    n_h  = int(t / 3600)
    t   -= n_h * 3600
    n_m  = int(t / 60)
    t   -= n_m * 60
    n_s  = int(t)
    n_n  = int((t - n_s) * 100)


    ts = "{:02d}:{:02d}:{:02d},{:03d} --> {:02d}:{:02d}:{:02d},{:03d}" \
        .format(h, m, s, n, n_h, n_m, n_s, n_n)

    print(
        "{}\n{}\n{}".format(
            i + 1,
            ts,
            "{} <b><i>{}</b></i> {}".format(prev_crd, cur.chord, nxt.chord)
        ),
        end="\n\n",
        file=srt_file
    )

srt_file.close()
print("created {}".format(tmp_name))

print("running ffmpeg (this may take a while)")

ffmpeg \
    .input(file) \
    .output("out.mp4", vf="subtitles={}".format(tmp_name)) \
    .run(quiet=True, overwrite_output=True)

print("created {}".format("out.mp4"))
