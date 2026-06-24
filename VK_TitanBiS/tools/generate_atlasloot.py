#!/usr/bin/env python3
"""
VK Titan BiS - AtlasLoot data importer

Reads AtlasLootClassic TBC Anniversary BiS phase files and regenerates
Data/BiSData.lua with the same item IDs and ordering AtlasLoot shows.
"""

import os
import re
import sys


ATLAS_ADDONS = r"C:\Program Files (x86)\World of Warcraft\_anniversary_\Interface\AddOns"
PHASE_FILES = {
    0: os.path.join(ATLAS_ADDONS, "AtlasLootClassic_TBC_Phase_0_PreBis", "prebisDB.lua"),
    1: os.path.join(ATLAS_ADDONS, "AtlasLootClassic_TBC_Phase_1_Karazhan", "phaseoneDB.lua"),
}

SPEC_MAP = {
    "DruidBalance": "DruidBalance",
    "DruidBalance_P1": "DruidBalance",
    "DruidBear": "DruidBear",
    "DruidBear_P1": "DruidBear",
    "DruidCat": "DruidCat",
    "DruidCat_P1": "DruidCat",
    "DruidResto": "DruidResto",
    "DruidRestoration_P1": "DruidResto",
    "HunterBM": "HunterBM",
    "HunterBM_P1": "HunterBM",
    "HunterMM": "HunterMM",
    "HunterMM_P1": "HunterMM",
    "HunterSV": "HunterSV",
    "HunterSurv_P1": "HunterSV",
    "MageArc": "MageArcane",
    "MageArcane_P1": "MageArcane",
    "Mage Fire": "MageFire",
    "MageFire_P1": "MageFire",
    "MageFrost": "MageFrost",
    "MageFrost_P1": "MageFrost",
    "PalHoly": "PaladinHoly",
    "PaladinHoly_P1": "PaladinHoly",
    "PalProt": "PaladinProt",
    "PaladinProtection_P1": "PaladinProt",
    "PalRet": "PaladinRet",
    "PaladinRetribution": "PaladinRet",
    "Rogue": "RogueCombat",
    "PriestHoly": "PriestHoly",
    "PriestShadow": "PriestShadow",
    "ShamanEle": "ShamanElemental",
    "ShamanElemental": "ShamanElemental",
    "ShamanEnh": "ShamanEnhancement",
    "ShamanEnhancement": "ShamanEnhancement",
    "ShamanResto": "ShamanResto",
    "ShamanRestoration": "ShamanResto",
    "WarlockAff": "WarlockAffliction",
    "WarlockAffliction": "WarlockAffliction",
    "WarlockDemonology": "WarlockDemonology",
    "WarlockDestruction": "WarlockDestruction",
    "WarriorArms": "WarriorArms",
    "WarriorFury": "WarriorFury",
    "WarriorProt": "WarriorProt",
    "WarriorProtection": "WarriorProt",
}

FALLBACK_SPECS = {
    "PriestDisc": "PriestHoly",
    "RogueAssassination": "RogueCombat",
    "RogueSubtlety": "RogueCombat",
    "WarlockDemonology": "WarlockAffliction",
}

SLOT_MAP = {
    "Head": "Head",
    "Shoulders": "Shoulders",
    "Back": "Back",
    "Chest": "Chest",
    "Wrist": "Wrist",
    "Hands": "Hands",
    "Waist": "Waist",
    "Legs": "Legs",
    "Feet": "Feet",
    "Neck": "Neck",
    "Rings": "Ring1",
    "Trinkets": "Trinket1",
    "Main Hand": "MainHand",
    "Onehand": "MainHand",
    "Off Hand": "OffHand",
    "Offhand": "OffHand",
    "Twohand": "TwoHand",
    "Ranged": "Ranged",
}

SLOT_ORDER = [
    "Head", "Shoulders", "Back", "Chest", "Wrist", "Hands",
    "Waist", "Legs", "Feet", "Neck", "Ring1", "Trinket1",
    "MainHand", "OffHand", "TwoHand", "Ranged",
]

CLASSES = [
    {"key": "DRUID", "name": "Druid", "specs": ["Balance", "Cat", "Bear", "Resto"]},
    {"key": "HUNTER", "name": "Hunter", "specs": ["BM", "MM", "SV"]},
    {"key": "MAGE", "name": "Mage", "specs": ["Arcane", "Fire", "Frost"]},
    {"key": "PALADIN", "name": "Paladin", "specs": ["Holy", "Prot", "Ret"]},
    {"key": "PRIEST", "name": "Priest", "specs": ["Holy", "Disc", "Shadow"]},
    {"key": "ROGUE", "name": "Rogue", "specs": ["Assassination", "Combat", "Subtlety"]},
    {"key": "SHAMAN", "name": "Shaman", "specs": ["Elemental", "Enhancement", "Resto"]},
    {"key": "WARLOCK", "name": "Warlock", "specs": ["Affliction", "Demonology", "Destruction"]},
    {"key": "WARRIOR", "name": "Warrior", "specs": ["Arms", "Fury", "Prot"]},
]


def extract_data_blocks(content):
    matches = list(re.finditer(r'data\["([^"]+)"\]\s*=\s*\{', content))
    for index, match in enumerate(matches):
        start = match.start()
        end = matches[index + 1].start() if index + 1 < len(matches) else len(content)
        yield match.group(1), content[start:end]


def parse_block(block):
    items = []
    slot_pattern = re.compile(
        r'name\s*=\s*format\(AL\["([^"]+)"\][^\)]*\).*?\[NORMAL_DIFF\]\s*=\s*\{(.*?)\}\s*,\s*\},',
        re.DOTALL,
    )
    item_pattern = re.compile(r'\{\s*(\d+)\s*,\s*(\d+)\s*(?:,|\})')

    for slot_name, slot_body in slot_pattern.findall(block):
        slot = SLOT_MAP.get(slot_name)
        if not slot:
            continue
        for rank_text, item_id_text in item_pattern.findall(slot_body):
            items.append({
                "slot": slot,
                "itemID": int(item_id_text),
                "rank": int(rank_text),
            })
    return items


def parse_phase_file(path):
    with open(path, "r", encoding="utf-8") as handle:
        content = handle.read()

    parsed = {}
    for atlas_key, block in extract_data_blocks(content):
        spec_key = SPEC_MAP.get(atlas_key)
        if not spec_key:
            continue
        items = parse_block(block)
        if items:
            parsed[spec_key] = items
    return parsed


def build_data():
    data = {}
    for phase, path in PHASE_FILES.items():
        if not os.path.exists(path):
            raise FileNotFoundError(path)
        phase_data = parse_phase_file(path)
        for spec_key, items in phase_data.items():
            data.setdefault(spec_key, {})[phase] = items

    for missing_spec, fallback_spec in FALLBACK_SPECS.items():
        if missing_spec not in data and fallback_spec in data:
            data[missing_spec] = data[fallback_spec]
        elif missing_spec in data and fallback_spec in data:
            for phase, items in data[fallback_spec].items():
                data[missing_spec].setdefault(phase, items)

    return data


def generate_lua(data):
    lines = [
        "-- VK Titan BiS - Item Rankings",
        "-- AUTO-GENERATED from AtlasLootClassic TBC BiS data",
        "-- Do not edit manually! Run tools/generate_atlasloot.py instead.",
        "",
        "local ADDON_NAME, ns = ...",
        "",
        "ns.ClassSpecs = {",
    ]

    for cls in CLASSES:
        specs = ", ".join(f'"{spec}"' for spec in cls["specs"])
        lines.append(f'    {{ key = "{cls["key"]}", name = "{cls["name"]}", specs = {{ {specs} }} }},')

    lines.extend([
        "}",
        "",
        "ns.BiSData = {}",
        "",
    ])

    for spec_key in sorted(data):
        lines.append(f'ns.BiSData["{spec_key}"] = {{')
        for phase in sorted(data[spec_key]):
            items = sorted(data[spec_key][phase], key=lambda item: (SLOT_ORDER.index(item["slot"]), item["rank"]))
            lines.append(f"    [{phase}] = {{")
            for item in items:
                lines.append(f'        {{ slot = "{item["slot"]}", itemID = {item["itemID"]}, rank = {item["rank"]} }},')
            lines.append("    },")
        lines.append("}")
        lines.append("")

    return "\n".join(lines).rstrip() + "\n"


def main():
    data = build_data()
    output_path = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "Data", "BiSData.lua"))
    with open(output_path, "w", encoding="utf-8", newline="\n") as handle:
        handle.write(generate_lua(data))

    print(f"Generated {output_path}")
    for spec_key in sorted(data):
        phases = ", ".join(str(phase) for phase in sorted(data[spec_key]))
        count = sum(len(items) for items in data[spec_key].values())
        print(f"  {spec_key}: phases {phases}, {count} items")


if __name__ == "__main__":
    try:
        main()
    except Exception as exc:
        print(f"Error: {exc}", file=sys.stderr)
        sys.exit(1)
