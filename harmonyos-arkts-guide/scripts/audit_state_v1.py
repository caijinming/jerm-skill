#!/usr/bin/env python3
"""Audit ArkUI state management V1/V2 decorators in ArkTS sources.

The script is intentionally lightweight: it reports likely migration touchpoints
without trying to rewrite source code or infer full component semantics.
"""

from __future__ import annotations

import argparse
import json
import re
from dataclasses import asdict, dataclass
from pathlib import Path
from typing import Iterable


V1_DECORATORS = {
    'Component': 'component',
    'State': 'local_state',
    'Prop': 'parent_input',
    'Link': 'two_way_state',
    'ObjectLink': 'observed_object_link',
    'Provide': 'provided_state',
    'Consume': 'consumed_state',
    'Observed': 'observed_model',
    'Watch': 'watcher',
    'StorageLink': 'storage_state',
    'StorageProp': 'storage_state',
    'LocalStorageLink': 'storage_state',
    'LocalStorageProp': 'storage_state',
    'LocalStorage': 'storage_scope',
    'AppStorage': 'storage_scope',
    'Environment': 'environment_state',
}

V2_DECORATORS = {
    'ComponentV2': 'component_v2',
    'Local': 'local_state_v2',
    'Param': 'parent_input_v2',
    'Once': 'one_time_param_v2',
    'Event': 'event_v2',
    'Provider': 'provided_state_v2',
    'Consumer': 'consumed_state_v2',
    'ObservedV2': 'observed_model_v2',
    'Trace': 'traced_field_v2',
    'Monitor': 'monitor_v2',
}

DECORATOR_RE = re.compile(r'@(\w+)\b')
SOURCE_SUFFIXES = {'.ets', '.ts'}
SKIP_DIRS = {
    '.git',
    '.hvigor',
    '.idea',
    '.preview',
    'build',
    'node_modules',
    'oh_modules',
}


@dataclass(frozen=True)
class Hit:
    path: str
    line: int
    decorator: str
    version: str
    category: str
    mixed_v2_nearby: bool
    text: str


@dataclass(frozen=True)
class FileSummary:
    path: str
    priority: str
    v1_count: int
    v2_count: int
    risks: list[str]


def iter_source_files(root: Path) -> Iterable[Path]:
    for path in root.rglob('*'):
        relative_parts = path.relative_to(root).parts
        if path.is_dir():
            continue
        if path.suffix not in SOURCE_SUFFIXES:
            continue
        if any(part in SKIP_DIRS for part in relative_parts):
            continue
        yield path


def has_nearby_v2(lines: list[str], index: int) -> bool:
    start = max(0, index - 5)
    end = min(len(lines), index + 6)
    window = '\n'.join(lines[start:end])
    return any(f'@{name}' in window for name in V2_DECORATORS)


def audit_file(root: Path, path: Path) -> list[Hit]:
    try:
        lines = path.read_text(encoding='utf-8').splitlines()
    except UnicodeDecodeError:
        lines = path.read_text(encoding='utf-8', errors='replace').splitlines()

    hits: list[Hit] = []
    for index, line in enumerate(lines):
        for match in DECORATOR_RE.finditer(line):
            name = match.group(1)
            version = 'v1'
            category = V1_DECORATORS.get(name)
            if category is None:
                category = V2_DECORATORS.get(name)
                version = 'v2'
            if category is None:
                continue
            hits.append(
                Hit(
                    path=str(path.relative_to(root)),
                    line=index + 1,
                    decorator=name,
                    version=version,
                    category=category,
                    mixed_v2_nearby=version == 'v1' and has_nearby_v2(lines, index),
                    text=line.strip(),
                )
            )
    return hits


def summarize_files(hits: list[Hit]) -> list[FileSummary]:
    by_file: dict[str, list[Hit]] = {}
    for hit in hits:
        by_file.setdefault(hit.path, []).append(hit)

    summaries: list[FileSummary] = []
    for path, file_hits in by_file.items():
        v1_hits = [hit for hit in file_hits if hit.version == 'v1']
        v2_hits = [hit for hit in file_hits if hit.version == 'v2']
        categories = {hit.category for hit in file_hits}
        risks: list[str] = []

        if v1_hits and v2_hits:
            risks.append('mixed-file')
        if any(hit.mixed_v2_nearby for hit in file_hits):
            risks.append('mixed-v2-nearby')
        if 'two_way_state' in categories or 'observed_object_link' in categories:
            risks.append('two-way-state')
        if 'observed_model' in categories or 'observed_model_v2' in categories or 'traced_field_v2' in categories:
            risks.append('observed-model')
        if 'storage_state' in categories or 'storage_scope' in categories or 'environment_state' in categories:
            risks.append('storage-state')
        if 'provided_state' in categories or 'consumed_state' in categories or 'provided_state_v2' in categories or 'consumed_state_v2' in categories:
            risks.append('dependency-injection')
        if 'watcher' in categories or 'monitor_v2' in categories:
            risks.append('watch-or-monitor')

        if 'mixed-file' in risks or 'two-way-state' in risks or 'observed-model' in risks or 'storage-state' in risks:
            priority = 'high'
        elif 'dependency-injection' in risks or 'watch-or-monitor' in risks:
            priority = 'medium'
        elif v1_hits:
            priority = 'low'
        else:
            priority = 'v2-only'

        summaries.append(
            FileSummary(
                path=path,
                priority=priority,
                v1_count=len(v1_hits),
                v2_count=len(v2_hits),
                risks=risks,
            )
        )

    return sorted(summaries, key=lambda item: (priority_rank(item.priority), item.path))


def priority_rank(priority: str) -> int:
    ranks = {
        'high': 0,
        'medium': 1,
        'low': 2,
        'v2-only': 3,
    }
    return ranks.get(priority, 9)


def print_text(hits: list[Hit], summaries: list[FileSummary]) -> None:
    if not hits:
        print('No ArkUI state management V1/V2 decorators found.')
        return

    by_category: dict[str, list[Hit]] = {}
    for hit in hits:
        by_category.setdefault(f'{hit.version}:{hit.category}', []).append(hit)

    v1_count = len([hit for hit in hits if hit.version == 'v1'])
    v2_count = len([hit for hit in hits if hit.version == 'v2'])
    print(f'Found {v1_count} V1 and {v2_count} V2 decorator touchpoints across {len({hit.path for hit in hits})} files.')

    print('\n[file priorities]')
    for summary in summaries:
        risk_text = ', '.join(summary.risks) if summary.risks else 'none'
        print(f'{summary.priority:7} {summary.path}  v1={summary.v1_count} v2={summary.v2_count} risks={risk_text}')

    print('\n[decorators]')
    for category in sorted(by_category):
        category_hits = by_category[category]
        print(f'\n[{category}] {len(category_hits)}')
        for hit in category_hits:
            mixed = ' mixed-v2-nearby' if hit.mixed_v2_nearby else ''
            print(f'{hit.path}:{hit.line} @{hit.decorator}{mixed}  {hit.text}')


def main() -> int:
    parser = argparse.ArgumentParser(description='Audit ArkUI state management V1/V2 decorators and mixed migration risk.')
    parser.add_argument('root', nargs='?', default='.', help='Project root to scan.')
    parser.add_argument('--json', action='store_true', help='Print machine-readable JSON.')
    args = parser.parse_args()

    root = Path(args.root).resolve()
    hits: list[Hit] = []
    for source_file in iter_source_files(root):
        hits.extend(audit_file(root, source_file))

    hits.sort(key=lambda hit: (hit.path, hit.line, hit.decorator))
    summaries = summarize_files(hits)

    if args.json:
        payload = {
            'summary': [asdict(summary) for summary in summaries],
            'hits': [asdict(hit) for hit in hits],
        }
        print(json.dumps(payload, ensure_ascii=False, indent=2))
    else:
        print_text(hits, summaries)
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
