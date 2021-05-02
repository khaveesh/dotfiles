#!/usr/bin/env python3
from pathlib import Path

import yaml

ref_file = Path("references.yaml")
if ref_file.exists():
    with open(ref_file) as stream:
        refs = yaml.safe_load(stream)["references"]
        pairs = []
        for ref in refs:
            pairs.append(f"{ref['id']}: {ref['title']}")
        print("\n".join(pairs))
