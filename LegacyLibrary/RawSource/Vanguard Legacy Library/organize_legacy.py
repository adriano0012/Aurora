from __future__ import annotations

import json
import re
import shutil
import sys
import zipfile
from collections import defaultdict
from dataclasses import dataclass, field
from pathlib import Path


SYSTEM_KEYWORDS = {
    "AutoBuild": [r"autobuild", r"build\s*preview", r"blueprint", r"fill", r"plot\s*art"],
    "BuildPreview": [r"buildpreview", r"build\s*preview", r"preview"],
    "Blueprint": [r"blueprint", r"schematic"],
    "Fill": [r"\bfill\b", r"autofill", r"click\s*fill"],
    "PlotArt": [r"plotart", r"wire\s*art", r"pixel\s*art"],
    "AutoBuy": [r"autobuy", r"auto\s*buy", r"buy\s*item", r"wood\s*r'?us"],
    "TreeFinder": [r"tree\s*finder", r"find\s*tree", r"tree\s*search"],
    "BringTree": [r"bring\s*tree", r"bring\s*log", r"bringlogs"],
    "HardDragger": [r"hard\s*dragger", r"\bdragger\b"],
    "ModWood": [r"mod\s*wood", r"wood\s*mod", r"sawmill"],
    "Scanner": [r"scanner", r"scan\s*base", r"base\s*scan"],
    "ESP": [r"\besp\b", r"highlight", r"tracer"],
    "Vehicle": [r"vehicle", r"car\s*spawn", r"drive\s*seat"],
    "Sorter": [r"sorter", r"sorting"],
    "Slot": [r"\bslot\b", r"load\s*slot", r"save\s*slot"],
    "Dupe": [r"\bdupe\b", r"duplicate"],
    "Item": [r"\bitem\b", r"lasso", r"select\s*item"],
    "Teleports": [r"teleport", r"waypoint", r"spectate", r"follow\s*player"],
    "Player": [r"walkspeed", r"jump\s*power", r"noclip", r"flight", r"anti\s*afk", r"player"],
    "World": [r"world", r"gravity", r"lighting", r"remove\s*trees", r"remove\s*water"],
    "UI": [r"\bui\b", r"window", r"tab", r"section", r"toggle", r"dropdown"],
    "Library": [r"library", r"uilib", r"framework"],
    "Config": [r"config", r"profile", r"backup", r"settings"],
    "Loader": [r"loader", r"bootstrap", r"init"],
    "Remote": [r"remote", r"fireserver", r"invokeserver"],
    "Save": [r"save", r"load", r"writefile", r"readfile"],
    "Themes": [r"theme", r"accent", r"color3"],
    "Notifications": [r"notification", r"sendnotification", r"notify"],
    "Webhook": [r"webhook", r"discord"],
    "Statistics": [r"stats", r"statistics", r"fps", r"ping"],
}

UTILITY_KEYWORDS = {
    "Math": [r"math", r"clamp", r"lerp"],
    "String": [r"string", r"gsub", r"match"],
    "Table": [r"table\.", r"table"],
    "Signal": [r"signal", r"event", r"connect"],
    "Tween": [r"tween", r"tweenservice"],
    "Promise": [r"promise"],
    "Queue": [r"queue"],
    "Retry": [r"retry"],
    "Cache": [r"cache", r"cached"],
    "Filesystem": [r"readfile", r"writefile", r"isfile", r"makefolder"],
    "Clipboard": [r"clipboard", r"setclipboard", r"getclipboard"],
    "HTTP": [r"http", r"httprequest", r"request", r"httpget"],
    "Executor": [r"syn", r"fluxus", r"wave", r"xeno", r"executor", r"gethui"],
    "Drawing": [r"drawing", r"line.new", r"text.new"],
    "Selection": [r"selection", r"selected"],
    "Raycast": [r"raycast"],
    "CFrame": [r"cframe"],
    "Color": [r"color3", r"fromrgb"],
}

DOCUMENT_NAMES = {
    "Roadmaps": ["roadmap"],
    "Readmes": ["readme"],
    "Notes": ["note", "notes"],
    "Changelogs": ["changelog", "changes"],
    "TODO": ["todo", "to-do"],
    "Credits": ["credit", "credits"],
    "Licenses": ["license", "licence"],
}

ASSET_EXTENSIONS = {
    "Images": {".png", ".jpg", ".jpeg", ".gif", ".bmp", ".webp"},
    "Icons": {".ico"},
    "Fonts": {".ttf", ".otf", ".woff", ".woff2"},
    "Sounds": {".mp3", ".wav", ".ogg"},
    "Animations": {".anim", ".json"},
    "Themes": {".theme"},
}

TEXT_EXTENSIONS = {".lua", ".txt", ".md", ".json", ".cfg", ".ini", ".yaml", ".yml"}


@dataclass
class ProjectRecord:
    name: str
    source_zip: str
    root: Path
    file_count: int = 0
    systems: set[str] = field(default_factory=set)
    utilities: set[str] = field(default_factory=set)
    assets: set[str] = field(default_factory=set)
    documents: set[str] = field(default_factory=set)
    unknown_files: list[str] = field(default_factory=list)
    reusable_parts: list[str] = field(default_factory=list)
    notes: list[str] = field(default_factory=list)


def sanitize_project_name(name: str) -> str:
    name = re.sub(r"\.zip$", "", name, flags=re.IGNORECASE)
    name = re.sub(r"\s*\(\d+\)$", "", name).strip()
    name = re.sub(r"[^A-Za-z0-9._ -]+", "", name).strip()
    name = re.sub(r"\s+", " ", name)
    return name or "UnknownProject"


def ensure_dirs(base: Path) -> None:
    for relative in [
        "Legacy/Scripts",
        "Legacy/Systems",
        "Legacy/Utilities",
        "Legacy/Assets",
        "Legacy/Documents",
        "Legacy/Unknown",
    ]:
        (base / relative).mkdir(parents=True, exist_ok=True)


def extract_zip(zip_path: Path, destination: Path) -> None:
    destination.mkdir(parents=True, exist_ok=True)

    def resolve_path(relative: Path, is_dir: bool) -> Path:
        current = destination
        parts = list(relative.parts)

        for index, part in enumerate(parts):
            last = index == len(parts) - 1
            candidate = current / part
            wants_dir = not last or is_dir

            if wants_dir:
                if candidate.exists() and candidate.is_file():
                    candidate = candidate.with_name(candidate.name + "__dir")
                candidate.mkdir(parents=True, exist_ok=True)
            else:
                if candidate.exists() and candidate.is_dir():
                    candidate = candidate.with_name(candidate.name + "__file")

            current = candidate

        return current

    with zipfile.ZipFile(zip_path) as archive:
        for member in archive.infolist():
            relative = Path(member.filename)
            if not relative.parts:
                continue

            if member.is_dir():
                resolve_path(relative, True)
                continue

            target = resolve_path(relative, False)
            with archive.open(member) as source, target.open("wb") as output:
                shutil.copyfileobj(source, output)


def classify_document(file_path: Path) -> str | None:
    stem = file_path.stem.lower()
    name = file_path.name.lower()
    for category, keywords in DOCUMENT_NAMES.items():
        if any(keyword in stem or keyword in name for keyword in keywords):
            return category
    if file_path.suffix.lower() == ".md":
        return "Readmes"
    return None


def classify_asset(file_path: Path) -> str | None:
    extension = file_path.suffix.lower()
    for category, extensions in ASSET_EXTENSIONS.items():
        if extension in extensions:
            return category
    return None


def keyword_hit_map(content: str, keyword_map: dict[str, list[str]]) -> set[str]:
    hits: set[str] = set()
    for category, patterns in keyword_map.items():
        if any(re.search(pattern, content, re.IGNORECASE) for pattern in patterns):
            hits.add(category)
    return hits


def read_text(file_path: Path) -> str:
    try:
        return file_path.read_text(encoding="utf-8", errors="ignore")
    except Exception:
        return ""


def analyze_project(project_root: Path, source_zip: Path) -> ProjectRecord:
    record = ProjectRecord(
        name=project_root.name,
        source_zip=source_zip.name,
        root=project_root,
    )

    for file_path in project_root.rglob("*"):
        if not file_path.is_file():
            continue

        record.file_count += 1

        document_category = classify_document(file_path)
        if document_category:
            record.documents.add(document_category)

        asset_category = classify_asset(file_path)
        if asset_category:
            record.assets.add(asset_category)

        searchable = " ".join(part.lower() for part in file_path.parts[-4:])
        if file_path.suffix.lower() in TEXT_EXTENSIONS:
            content = read_text(file_path)
            searchable = f"{searchable}\n{content[:20000]}"

        systems = keyword_hit_map(searchable, SYSTEM_KEYWORDS)
        utilities = keyword_hit_map(searchable, UTILITY_KEYWORDS)

        record.systems.update(systems)
        record.utilities.update(utilities)

        if not document_category and not asset_category and not systems and not utilities:
            record.unknown_files.append(str(file_path.relative_to(project_root)).replace("\\", "/"))

    if record.systems:
        record.reusable_parts.append("Sistemas candidatos para reescrita: " + ", ".join(sorted(record.systems)))
    if record.utilities:
        record.reusable_parts.append("Utilitários candidatos para reescrita: " + ", ".join(sorted(record.utilities)))

    if any("loader" in system.lower() for system in record.systems):
        record.notes.append("Possui fluxo de inicialização próprio; usar apenas como referência arquitetural.")
    if record.unknown_files:
        record.notes.append(f"{len(record.unknown_files)} arquivo(s) ficaram sem categoria clara.")
    if not record.systems and not record.utilities:
        record.notes.append("Projeto precisa de análise manual mais profunda.")

    return record


def write_project_info(record: ProjectRecord) -> None:
    reusable = "\n".join(f"- {item}" for item in record.reusable_parts) or "- Nenhuma parte evidente detectada automaticamente."
    notes = "\n".join(f"- {item}" for item in record.notes) or "- Sem observações adicionais."
    categories = ", ".join(sorted(record.documents | record.assets | record.systems | record.utilities)) or "Nenhuma"
    systems = ", ".join(sorted(record.systems)) or "Nenhum"
    utilities = ", ".join(sorted(record.utilities)) or "Nenhum"
    assets = ", ".join(sorted(record.assets)) or "Nenhum"
    unknown = "\n".join(f"- {item}" for item in record.unknown_files[:50]) or "- Nenhum"

    text = f"""# ProjectInfo

Nome: {record.name}
Origem: {record.source_zip}
Quantidade de arquivos: {record.file_count}
Categorias encontradas: {categories}
Sistemas encontrados: {systems}
Utilitários encontrados: {utilities}
Assets encontrados: {assets}
Possíveis partes reutilizáveis:
{reusable}
Necessita reescrita: Sim
Observações:
{notes}

## Unknown Files
{unknown}
"""
    (record.root / "ProjectInfo.md").write_text(text, encoding="utf-8")


def build_indexes(base: Path, records: list[ProjectRecord]) -> None:
    legacy = base / "Legacy"
    system_index: dict[str, list[tuple[str, str]]] = defaultdict(list)
    utility_index: dict[str, list[tuple[str, str]]] = defaultdict(list)
    asset_index: dict[str, list[tuple[str, str]]] = defaultdict(list)
    document_index: dict[str, list[tuple[str, str]]] = defaultdict(list)

    for record in records:
        for category in sorted(record.systems):
            system_index[category].append((record.name, record.source_zip))
        for category in sorted(record.utilities):
            utility_index[category].append((record.name, record.source_zip))
        for category in sorted(record.assets):
            asset_index[category].append((record.name, record.source_zip))
        for category in sorted(record.documents):
            document_index[category].append((record.name, record.source_zip))

    for folder, index_map in [
        ("Systems", system_index),
        ("Utilities", utility_index),
        ("Assets", asset_index),
        ("Documents", document_index),
    ]:
        root = legacy / folder
        for category, entries in index_map.items():
            category_dir = root / category
            category_dir.mkdir(parents=True, exist_ok=True)
            lines = [f"# {category}", ""]
            for project_name, source_zip in sorted(entries):
                lines.append(f"- {project_name} ({source_zip})")
            (category_dir / "Index.md").write_text("\n".join(lines) + "\n", encoding="utf-8")

    project_lines = ["# Legacy Index", ""]
    for record in sorted(records, key=lambda item: item.name.lower()):
        project_lines.append(record.name)
        for system in sorted(record.systems):
            project_lines.append(f"- {system}")
        project_lines.append("")
    (legacy / "Index.md").write_text("\n".join(project_lines).strip() + "\n", encoding="utf-8")


def write_readme(base: Path) -> None:
    readme = """# Legacy

Esta pasta e uma biblioteca de pesquisa permanente para projetos antigos.

Regras:
- Os projetos aqui nao fazem parte do Vanguard.
- Nenhum codigo deve ser copiado diretamente para o Vanguard.
- Toda reutilizacao deve ser reescrita seguindo a arquitetura atual.
- Os ZIPs sao extraidos e catalogados automaticamente.
- A pesquisa deve ser feita pelos indices gerados em `Index.md`, `Systems/`, `Utilities/`, `Assets/` e `Documents/`.
"""
    (base / "Legacy" / "README.md").write_text(readme, encoding="utf-8")


def organize(source_dir: Path, base_dir: Path) -> dict[str, object]:
    ensure_dirs(base_dir)
    write_readme(base_dir)
    legacy_scripts = base_dir / "Legacy" / "Scripts"

    zip_files = sorted(source_dir.glob("*.zip"))
    records: list[ProjectRecord] = []

    for zip_path in zip_files:
        project_name = sanitize_project_name(zip_path.stem)
        project_dir = legacy_scripts / project_name
        extract_dir = project_dir / "Source"

        if project_dir.exists():
            shutil.rmtree(project_dir)
        project_dir.mkdir(parents=True, exist_ok=True)

        extract_zip(zip_path, extract_dir)
        record = analyze_project(project_dir, zip_path)
        write_project_info(record)
        records.append(record)

    stray_files = [file for file in source_dir.iterdir() if file.is_file() and file.suffix.lower() != ".zip"]
    if stray_files:
        unknown_dir = base_dir / "Legacy" / "Unknown"
        unknown_dir.mkdir(parents=True, exist_ok=True)
        for file in stray_files:
            shutil.copy2(file, unknown_dir / file.name)

    build_indexes(base_dir, records)

    summary = {
        "projects": len(records),
        "zip_files": len(zip_files),
        "systems": sorted({item for record in records for item in record.systems}),
        "utilities": sorted({item for record in records for item in record.utilities}),
        "assets": sorted({item for record in records for item in record.assets}),
        "documents": sorted({item for record in records for item in record.documents}),
    }
    (base_dir / "Legacy" / "summary.json").write_text(json.dumps(summary, indent=2), encoding="utf-8")
    return summary


def main() -> int:
    if len(sys.argv) != 3:
        print("usage: organize_legacy.py <source_dir> <base_dir>")
        return 1

    source_dir = Path(sys.argv[1]).resolve()
    base_dir = Path(sys.argv[2]).resolve()

    if not source_dir.exists():
        print(f"source dir not found: {source_dir}")
        return 1

    summary = organize(source_dir, base_dir)
    print(json.dumps(summary, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
