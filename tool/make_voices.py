#!/usr/bin/env python3
"""Generates the game's voice clips with Piper (https://github.com/rhasspy/piper).

    flutter test tool/voice_lines.dart          # writes build/voice_lines.json
    PIPER=/path/to/piper MODELS=/path/to/models FFMPEG=ffmpeg \\
        python3 tool/make_voices.py

Clips that already exist are skipped, so after editing dialogue only the new
lines are generated. Delete a clip (or all of assets/voice) to redo it.
"""
import json
import os
import re
import subprocess
import sys
import tempfile

# Character -> (Piper voice model, speaking length scale, pitch multiplier).
VOICES = {
    "narrator": ("en_US-ryan-high", 1.12, 0.96),
    "churlock": ("en_US-hfc_male-medium", 1.0, 1.0),
    "penny": ("en_GB-alba-medium", 1.0, 1.0),
    "graham": ("en_GB-alan-medium", 1.12, 1.0),
    "cannoli": ("en_US-norman-medium", 1.0, 0.93),
    "tira": ("en_GB-cori-high", 1.0, 1.0),
    "barry": ("en_GB-northern_english_male-medium", 1.0, 1.0),
    "sprinkles": ("en_US-joe-medium", 1.0, 1.0),
    "glaze": ("en_US-bryce-medium", 1.0, 1.05),
}

KEEP_CAPS = {"PM", "AM", "IOU"}
RATE = 22050


def speakable(text):
    """Tidies punctuation the synthesiser would stumble over."""
    text = text.replace("“", "").replace("”", "").replace("’", "'")
    text = text.replace("—", ", ").replace("–", " to ").replace("...", ". ")
    text = text.replace("É.S.", "E. S.").replace("Col.", "Colonel")
    text = text.replace("'08", "oh-eight")
    # Shouted words are read letter by letter unless lower-cased.
    return re.sub(
        r"\b[A-ZÉ]{2,}\b",
        lambda m: m.group(0) if m.group(0) in KEEP_CAPS else m.group(0).lower(),
        text,
    )


def main():
    piper = os.environ.get("PIPER", "piper")
    models = os.environ.get("MODELS", "models")
    ffmpeg = os.environ.get("FFMPEG", "ffmpeg")
    out_dir = "assets/voice"
    os.makedirs(out_dir, exist_ok=True)
    lines = json.load(open("build/voice_lines.json"))

    wanted = {l["file"] + ".mp3" for l in lines}
    for stale in sorted(set(os.listdir(out_dir)) - wanted):
        os.remove(os.path.join(out_dir, stale))
        print("removed", stale)

    for voice, (model, length, pitch) in VOICES.items():
        todo = [
            l for l in lines
            if l["voice"] == voice
            and not os.path.exists(os.path.join(out_dir, l["file"] + ".mp3"))
        ]
        if not todo:
            continue
        print(f"{voice}: {len(todo)} lines", flush=True)
        with tempfile.TemporaryDirectory() as tmp:
            requests = "".join(
                json.dumps({
                    "text": speakable(l["text"]),
                    "output_file": os.path.join(tmp, l["file"] + ".wav"),
                }) + "\n"
                for l in todo
            )
            subprocess.run(
                [piper, "--model", os.path.join(models, model + ".onnx"),
                 "--json-input", "--length_scale", str(length),
                 "--sentence_silence", "0.3"],
                input=requests.encode(), check=True,
                stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL,
            )
            for l in todo:
                filters = []
                if pitch != 1.0:
                    filters += [f"asetrate={RATE * pitch:.0f}",
                                f"aresample={RATE}", f"atempo={1 / pitch:.4f}"]
                filters.append("loudnorm=I=-17:TP=-1.5:LRA=11")
                subprocess.run(
                    [ffmpeg, "-y", "-loglevel", "error",
                     "-i", os.path.join(tmp, l["file"] + ".wav"),
                     "-af", ",".join(filters), "-ac", "1", "-ar", str(RATE),
                     "-b:a", "40k", os.path.join(out_dir, l["file"] + ".mp3")],
                    check=True,
                )
    missing = [f for f in wanted if not os.path.exists(os.path.join(out_dir, f))]
    print(f"{len(wanted) - len(missing)}/{len(wanted)} clips present")
    sys.exit(1 if missing else 0)


if __name__ == "__main__":
    main()
