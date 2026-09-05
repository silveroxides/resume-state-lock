import pathlib
import json
import os
import shutil
import subprocess
import tempfile
import unittest


ROOT = pathlib.Path(__file__).resolve().parents[1]
HOOKS = (
    ROOT / "hooks" / "resume-state-lock.ps1",
    ROOT / "hooks" / "resume-state-lock.sh",
)


class LockContractTests(unittest.TestCase):
    def test_hooks_define_direct_filesystem_skill_loading(self):
        required = (
            "reading the exact SKILL.md locator",
            "do not search for a callable tool",
            "ALL_TOOLS",
            "query MCP capabilities",
            "Load only skills named or required",
        )
        for hook in HOOKS:
            text = hook.read_text(encoding="utf-8")
            for phrase in required:
                with self.subTest(hook=hook.name, phrase=phrase):
                    self.assertIn(phrase, text)

    def test_platform_hooks_emit_same_contract(self):
        powershell = HOOKS[0].read_text(encoding="utf-8")
        powershell = powershell[powershell.index("MANDATORY POST-COMPACTION LOCK:"):].removesuffix("'\n")
        shell = HOOKS[1].read_text(encoding="utf-8")
        shell = shell[shell.index("MANDATORY POST-COMPACTION LOCK:") : shell.rindex("\nMESSAGE")].strip()
        self.assertEqual(powershell, shell)

    def test_hook_load_commands_preserve_special_character_paths(self):
        for executable, hook, marker in (
            (shutil.which("powershell.exe"), HOOKS[0], "PowerShell load command: "),
            (shutil.which("sh"), HOOKS[1], "POSIX load command: "),
        ):
            if not executable:
                continue
            with self.subTest(hook=hook.name), tempfile.TemporaryDirectory() as temporary:
                plugin = pathlib.Path(temporary) / "space+[brackets]'$`&" / "resume-state-lock" / "resume-state-lock" / "0.1.2+test"
                hooks = plugin / "hooks"
                hooks.mkdir(parents=True)
                installed = hooks / hook.name
                shutil.copyfile(hook, installed)
                skill = plugin / "skills" / "resume-state-lock" / "SKILL.md"
                skill.parent.mkdir(parents=True)
                skill.write_text("# Locator fixture\n", encoding="utf-8")
                is_powershell = hook.suffix == ".ps1"
                # Pass POSIX paths via environment and shell code via stdin:
                # MSYS's native Windows argv parsing otherwise consumes apostrophes.
                command = ([executable, "-NoProfile", "-NonInteractive", "-ExecutionPolicy", "Bypass", "-File", str(installed)]
                           if is_powershell else [executable])
                kwargs = {} if is_powershell else {
                    "input": 'exec sh "$LOCK_TEST_SCRIPT"\n',
                    "env": dict(os.environ, LOCK_TEST_SCRIPT=installed.as_posix()),
                }
                output = subprocess.check_output(command, text=True, timeout=15, **kwargs)
                self.assertIn("MANDATORY POST-COMPACTION LOCK:", output)
                line = next(line for line in output.splitlines() if line.startswith(marker))
                load_command = line.removeprefix(marker)
                loaded = subprocess.check_output(
                    [executable, "-NoProfile", "-NonInteractive", "-Command", load_command]
                    if is_powershell else [executable], text=True, timeout=15,
                    **({} if is_powershell else {"input": load_command + "\n"}))
                self.assertIn("# Locator fixture", loaded)
                skill.unlink()
                missing = subprocess.check_output(command, text=True, timeout=15, **kwargs)
                self.assertFalse(json.loads(missing)["continue"])

    def test_skill_repeats_invocation_semantics(self):
        text = (ROOT / "skills" / "resume-state-lock" / "SKILL.md").read_text(encoding="utf-8")
        self.assertIn("invocation means reading the exact `SKILL.md` locator", text)
        self.assertIn("Never search for a callable skill tool", text)
        self.assertIn("inspect or filter `ALL_TOOLS`", text)


if __name__ == "__main__":
    unittest.main()
