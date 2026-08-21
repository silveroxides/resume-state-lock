import pathlib
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
        powershell = HOOKS[0].read_text(encoding="utf-8").removeprefix("Write-Output '").removesuffix("'\n")
        shell = HOOKS[1].read_text(encoding="utf-8")
        shell = shell[shell.index("MANDATORY POST-COMPACTION LOCK:") : shell.rindex("\nMESSAGE")].strip()
        self.assertEqual(powershell, shell)

    def test_skill_repeats_invocation_semantics(self):
        text = (ROOT / "skills" / "resume-state-lock" / "SKILL.md").read_text(encoding="utf-8")
        self.assertIn("invocation means reading the exact `SKILL.md` locator", text)
        self.assertIn("Never search for a callable skill tool", text)
        self.assertIn("inspect or filter `ALL_TOOLS`", text)


if __name__ == "__main__":
    unittest.main()
