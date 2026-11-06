# skills

A personal library of Claude Code **skills, agents and slash commands**, vendored from
[affaan-m/ECC](https://github.com/affaan-m/ECC) v2.2.3 (commit `b38be6a`, MIT — see `LICENSE-ECC`).

| What | Count | Where | Installed to |
|---|---|---|---|
| Skills (auto-loaded know-how) | 314 | `skills/<name>/SKILL.md` | `~/.claude/skills/` |
| Agents (subagents Claude delegates to) | 71 | `agents/*.md` | `~/.claude/agents/` |
| Slash commands | 98 | `commands/*.md` | `~/.claude/commands/` |
| Coding rules per language | 22 sets | `rules/<lang>/` | `~/.claude/rules/` (opt-in) |

**Full list with one-line descriptions: [CATALOG.md](CATALOG.md).**

## Use them in every project

Anything in `~/.claude/` is available to Claude Code in all projects. Clone this repo once and run:

```bash
git clone https://github.com/tsy0311/skills ~/skills && cd ~/skills
./install.sh                         # everything, as symlinks (git pull = update)
./install.sh tdd-workflow seo        # or only the skills you pick
./install.sh --rules python          # also add common + Python coding rules
./install.sh --copy                  # copy instead of symlink
./install.sh --uninstall             # remove only what install.sh added
```

Existing files in `~/.claude` that the script did not create are left alone. Restart Claude Code afterwards.

> **Tip:** every installed skill's description is loaded into Claude's context so it knows when to use it.
> 314 skills is a lot; installing only the stacks you use (e.g. `python-patterns python-testing tdd-workflow security-review`)
> keeps sessions leaner. For a single project, you can instead copy skills into that project's `.claude/skills/`.

Prefer the upstream, auto-updating plugin with hooks? Use ECC's own installer instead of this repo:
`npx ecc-universal@2.2.3 setup` (or in Claude Code: `/plugin marketplace add affaan-m/ECC`, then `/plugin install ecc@ecc`).

## What you can do with them

Skills trigger automatically when the task matches their description; you can also just ask
("use the tdd-workflow skill"). Commands are typed as `/name`.

**Everyday coding loop**
- `/plan` → requirements, risks and a step plan; waits for your OK before touching code
- `tdd-workflow` skill → failing test first, then implement, then refactor
- `/build-fix` → fix build and type errors incrementally
- `/code-review` (local diff or a PR number), `code-reviewer` agent
- `/test-coverage`, `/refactor-clean`, `/update-docs`, `verification-loop`
- `/save-session` and `/resume-session` to carry context across sessions

**Language & framework know-how** (72 skills) — Python, TypeScript, React/Next.js/Vue/Nuxt/Angular,
Go, Rust, Java/Spring Boot/Quarkus, Kotlin/Ktor, Django, Laravel, Rails, .NET, C++, Swift/SwiftUI,
Flutter, plus Postgres/MySQL/Redis/ClickHouse/Prisma and migrations.

**Security** — `security-review`, `security-scan`, OWASP-style framework guides (Django, Spring, Laravel,
Quarkus, Perl), HIPAA/PHI, smart-contract and LLM-agent hardening, `/security-scan` (AgentShield).

**DevOps** — Docker, Kubernetes, deployment patterns, canary watching, GitHub ops, homelab networking.

**Building with AI** — agent harness design, autonomous loops, evals, prompt caching, cost tracking,
MCP server patterns, multi-agent orchestration (`/orch-add-feature`, `/orch-fix-defect`, `/orch-build-mvp`, `team-builder`, `dmux-workflows`),
`/santa-loop` dual-reviewer gate.

**Research & writing** — `deep-research`, `market-research`, `article-writing`, `brand-voice`, `seo`,
`investor-materials`, `crosspost`/`social-publisher`.

**Media** — `frontend-slides`, `manim-video`, `remotion-video-creation`, `video-editing`, motion design.

**Domain packs** — healthcare (EMR/CDSS), supply chain and logistics, finance/billing ops, prediction markets.

**Grow your own library** — `/learn` turns a session into a candidate skill, `/skill-create` mines your
git history for patterns, `skill-stocktake` audits what you have.

Some skills call external services (Exa, fal.ai, X API, Jira, Google Workspace, etc.) and need their own
API keys or MCP servers; the `SKILL.md` says so at the top.

## Updating from upstream

```bash
git clone --depth 1 https://github.com/affaan-m/ECC /tmp/ecc
rsync -a --delete /tmp/ecc/{skills,agents,commands,rules} ./
```
