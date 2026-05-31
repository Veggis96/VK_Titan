#!/usr/bin/env python3
"""
VK Titan BiS - Data Generator from BiSGearCheck
Parses BiSGearCheck Lua data files and generates clean BiSData.lua, GemData.lua, EnchantData.lua.

Usage:
    python generate_bisgearcheck.py
    (Files must be in same directory: BGC_Data.lua, BGC_GemsEnchants.lua)
"""

import re
import os
import sys

# Map BiSGearCheck spec names to our addon spec keys
SPEC_MAP = {
    "DruidBalance": "DruidBalance",
    "DruidFeralDPS": "DruidCat",
    "DruidFeralTank": "DruidBear",
    "DruidRestoration": "DruidResto",
    "HunterBM": "HunterBM",
    "HunterMM": "HunterMM",
    "HunterSV": "HunterSV",
    "MageArcane": "MageArcane",
    "MageFire": "MageFire",
    "MageFrost": "MageFrost",
    "PaladinHoly": "PaladinHoly",
    "PaladinProtection": "PaladinProt",
    "PaladinRetribution": "PaladinRet",
    "PriestHoly": "PriestHoly",
    "PriestShadow": "PriestShadow",
    "RogueAssassination": "RogueAssassination",
    "RogueCombat": "RogueCombat",
    "RogueSubtlety": "RogueSubtlety",
    "ShamanElemental": "ShamanElemental",
    "ShamanEnhancement": "ShamanEnhancement",
    "ShamanRestoration": "ShamanResto",
    "WarlockAffliction": "WarlockAffliction",
    "WarlockDemonology": "WarlockDemonology",
    "WarlockDestruction": "WarlockDestruction",
    "WarriorArms": "WarriorArms",
    "WarriorFury": "WarriorFury",
    "WarriorProtection": "WarriorProt",
}

# Map slot names from BiSGearCheck to our format
SLOT_MAP = {
    "Head": "Head",
    "Neck": "Neck",
    "Shoulders": "Shoulders",
    "Back": "Back",
    "Chest": "Chest",
    "Wrist": "Wrist",
    "Hands": "Hands",
    "Waist": "Waist",
    "Legs": "Legs",
    "Feet": "Feet",
    "Rings": "Ring1",  # BiSGearCheck uses "Rings" for both ring slots
    "Trinkets": "Trinket1",  # BiSGearCheck uses "Trinkets" for both
    "Main Hand": "MainHand",
    "Offhand": "OffHand",
    "Ranged": "Ranged",
}

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


def parse_lua_array(text):
    """Parse a Lua array like { 123, 456, 789 } into a list of ints."""
    nums = re.findall(r'\d+', text)
    return [int(n) for n in nums]


def parse_bis_data(filepath):
    """Parse BiSGearCheck Data.lua and return spec -> slot -> [itemIDs]."""
    with open(filepath, 'r') as f:
        content = f.read()

    data = {}
    # Match each spec block
    spec_pattern = re.compile(
        r'BiSGearCheckDB_WowTBCgg\["(\w+)"\]\s*=\s*\{[^}]*slots\s*=\s*\{(.*?)\}\s*\}',
        re.DOTALL
    )

    for match in spec_pattern.finditer(content):
        spec_name = match.group(1)
        slots_text = match.group(2)

        if spec_name not in SPEC_MAP:
            continue

        our_spec = SPEC_MAP[spec_name]
        data[our_spec] = {}

        # Parse each slot
        slot_pattern = re.compile(r'\["([^"]+)"\]\s*=\s*\{([^}]+)\}')
        for slot_match in slot_pattern.finditer(slots_text):
            slot_name = slot_match.group(1)
            item_ids = parse_lua_array(slot_match.group(2))

            if slot_name in SLOT_MAP:
                our_slot = SLOT_MAP[slot_name]
                data[our_spec][our_slot] = item_ids
            elif slot_name == "Rings":
                data[our_spec]["Ring1"] = item_ids
                data[our_spec]["Ring2"] = item_ids
            elif slot_name == "Trinkets":
                data[our_spec]["Trinket1"] = item_ids
                data[our_spec]["Trinket2"] = item_ids

    return data


def parse_gem_data(filepath):
    """Parse BiSGearCheck Data_GemsEnchants.lua for gem recommendations."""
    with open(filepath, 'r') as f:
        content = f.read()

    gems = {}
    # Match gem blocks
    gem_pattern = re.compile(
        r'BiSGearCheckGemsDB\["(\w+)"\]\s*=\s*\{(.*?)\n\}',
        re.DOTALL
    )

    for match in gem_pattern.finditer(content):
        spec_name = match.group(1)
        block = match.group(2)

        if spec_name not in SPEC_MAP:
            continue

        our_spec = SPEC_MAP[spec_name]
        gems[our_spec] = {}

        # Parse meta
        meta_match = re.search(r'meta\s*=\s*\{\s*(\d+)\s*,\s*"([^"]+)"', block)
        if meta_match:
            gems[our_spec]["meta"] = {
                "id": int(meta_match.group(1)),
                "name": meta_match.group(2),
            }

        # Parse gem colors
        for color in ["red", "yellow", "blue"]:
            color_match = re.search(
                rf'{color}\s*=\s*\{{\s*\{{\s*(\d+)\s*,\s*"([^"]+)"\s*\}}',
                block
            )
            if color_match:
                gems[our_spec][color] = {
                    "id": int(color_match.group(1)),
                    "name": color_match.group(2),
                }

    return gems


def parse_enchant_data(filepath):
    """Parse BiSGearCheck Data_GemsEnchants.lua for enchant recommendations."""
    with open(filepath, 'r') as f:
        content = f.read()

    enchants = {}
    # Match enchant blocks
    enchant_pattern = re.compile(
        r'BiSGearCheckEnchantsDB\["(\w+)"\]\s*=\s*\{(.*?)\n\}',
        re.DOTALL
    )

    for match in enchant_pattern.finditer(content):
        spec_name = match.group(1)
        block = match.group(2)

        if spec_name not in SPEC_MAP:
            continue

        our_spec = SPEC_MAP[spec_name]
        enchants[our_spec] = {}

        # Parse each slot's enchant
        slot_pattern = re.compile(
            r'(\w+)\s*=\s*\{\s*\{\s*(\d+)\s*,\s*"([^"]+)"',
        )
        for slot_match in slot_pattern.finditer(block):
            slot_name = slot_match.group(1)
            enchant_id = int(slot_match.group(2))
            enchant_name = slot_match.group(3)

            # Map slot names
            slot_map = {
                "Head": "Head", "Shoulder": "Shoulders", "Back": "Back",
                "Chest": "Chest", "Wrist": "Wrist", "Hands": "Hands",
                "Legs": "Legs", "Feet": "Feet", "Weapon": "MainHand",
                "Shield": "OffHand", "Ranged": "Ranged",
            }
            if slot_name in slot_map:
                enchants[our_spec][slot_map[slot_name]] = {
                    "id": enchant_id,
                    "name": enchant_name,
                }

    return enchants


def generate_bisdata_lua(bis_data):
    """Generate BiSData.lua content."""
    lines = [
        "-- VK Titan BiS - Item Rankings",
        "-- AUTO-GENERATED from BiSGearCheck (WowTBC.gg data)",
        "-- Do not edit manually!",
        "",
        'local ADDON_NAME, ns = ...',
        "",
        "ns.ClassSpecs = {",
    ]

    for cls in CLASSES:
        specs_str = ", ".join(f'"{s}"' for s in cls["specs"])
        lines.append(f'    {{ key = "{cls["key"]}", name = "{cls["name"]}", specs = {{ {specs_str} }} }},')

    lines.append("}")
    lines.append("")
    lines.append("ns.BiSData = {}")
    lines.append("")

    for spec_key in sorted(bis_data.keys()):
        lines.append(f'ns.BiSData["{spec_key}"] = {{')
        # Phase 1 data (BiSGearCheck Data.lua is Phase 1)
        lines.append("    [1] = {")
        for slot in ["Head", "Neck", "Shoulders", "Back", "Chest", "Wrist",
                      "Hands", "Waist", "Legs", "Feet", "Ring1", "Ring2",
                      "Trinket1", "Trinket2", "MainHand", "OffHand", "Ranged"]:
            if slot in bis_data[spec_key]:
                for rank, item_id in enumerate(bis_data[spec_key][slot][:5], 1):
                    lines.append(f'        {{ slot = "{slot}", itemID = {item_id}, rank = {rank} }},')
        lines.append("    },")
        lines.append("}")
        lines.append("")

    return "\n".join(lines)


def generate_gemdata_lua(gem_data, enchant_data):
    """Generate GemData.lua content."""
    lines = [
        "-- VK Titan BiS - Gem & Enchant Recommendations",
        "-- AUTO-GENERATED from BiSGearCheck",
        "-- Do not edit manually!",
        "",
        'local ADDON_NAME, ns = ...',
        "",
        "ns.GemData = {}",
        "",
    ]

    for spec_key in sorted(gem_data.keys()):
        gd = gem_data[spec_key]
        lines.append(f'ns.GemData["{spec_key}"] = {{')

        if "meta" in gd:
            lines.append(f'    meta = {{ id = {gd["meta"]["id"]}, name = "{gd["meta"]["name"]}" }},')
        else:
            lines.append('    meta = nil,')

        lines.append('    gems = {')
        for color in ["red", "yellow", "blue"]:
            if color in gd:
                g = gd[color]
                lines.append(f'        {color.title()} = {{ id = {g["id"]}, name = "{g["name"]}" }},')
        lines.append('    },')

        # Add enchants inline
        if spec_key in enchant_data:
            ed = enchant_data[spec_key]
            lines.append('    enchants = {')
            for slot in ["Head", "Shoulders", "Back", "Chest", "Wrist", "Hands", "Legs", "Feet", "MainHand", "OffHand", "Ranged"]:
                if slot in ed:
                    e = ed[slot]
                    lines.append(f'        {slot} = {{ id = {e["id"]}, name = "{e["name"]}" }},')
            lines.append('    },')

        lines.append("}")
        lines.append("")

    return "\n".join(lines)


def main():
    tools_dir = os.path.dirname(os.path.abspath(__file__))
    data_file = os.path.join(tools_dir, "BGC_Data.lua")
    gems_file = os.path.join(tools_dir, "BGC_GemsEnchants.lua")

    if not os.path.exists(data_file):
        print(f"Error: {data_file} not found")
        sys.exit(1)
    if not os.path.exists(gems_file):
        print(f"Error: {gems_file} not found")
        sys.exit(1)

    print("Parsing BiSGearCheck BiS data...")
    bis_data = parse_bis_data(data_file)
    print(f"  Found {len(bis_data)} specs")
    for spec in sorted(bis_data.keys()):
        slots = len(bis_data[spec])
        items = sum(len(v) for v in bis_data[spec].values())
        print(f"    {spec}: {slots} slots, {items} items")

    print("\nParsing gem data...")
    gem_data = parse_gem_data(gems_file)
    print(f"  Found {len(gem_data)} specs")

    print("\nParsing enchant data...")
    enchant_data = parse_enchant_data(gems_file)
    print(f"  Found {len(enchant_data)} specs")

    # Generate BiSData.lua
    print("\nGenerating BiSData.lua...")
    bis_lua = generate_bisdata_lua(bis_data)
    bis_path = os.path.join(tools_dir, "..", "Data", "BiSData.lua")
    with open(bis_path, 'w') as f:
        f.write(bis_lua)
    print(f"  Written to {bis_path}")

    # Generate GemData.lua (combined gems + enchants)
    print("\nGenerating GemData.lua (gems + enchants)...")
    gem_lua = generate_gemdata_lua(gem_data, enchant_data)
    gem_path = os.path.join(tools_dir, "..", "Data", "GemData.lua")
    with open(gem_path, 'w') as f:
        f.write(gem_lua)
    print(f"  Written to {gem_path}")

    print("\nDone! Copy Data/ files to addon folder and reload WoW.")


if __name__ == "__main__":
    main()
