---
name: github-new-project-bootstrap
description: 初始化适合 1 到 3 人团队的新项目仓库，默认面向 GitHub、git、gh、AGENTS.md、DESIGN.md、OpenSpec、Superpowers、PR-Agent 和轻量 AI 协作流程。Use when Codex needs to create or standardize a new repository, scaffold collaboration docs, initialize OpenSpec, configure Superpowers or PR-Agent conventions, create a GitHub repo with gh, or prepare a simple workflow that can scale later.
---

# GitHub New Project Bootstrap

## Overview

用这套 skill 初始化一个简单、可复制、后续可迭代的新项目协作底座。

默认目标：

- 使用 `git` 和 `gh`
- 使用 GitHub 作为主协作平台
- 在仓库根目录放 `README.md`、`AGENTS.md`、`DESIGN.md`、`SUPERPOWERS.md`
- 用 `openspec/` 承载长期规格、当前上下文和需求变更
- 为 GitHub 准备最小可用的 PR 模板、PR-Agent 和基础 CI
- 保持小团队低维护成本

默认适用团队规模：

- 1 到 3 人优先
- 3 到 5 人且并行度不高时也适用

## Core Rules

- 先确认仓库是否已存在，不要覆盖用户已有结构。
- 先检查 `git`、`gh` 是否可用，再做 GitHub 操作。
- 优先初始化最小可运行结构，不要一次性塞入重型流程。
- 优先生成可编辑模板，避免把项目写死在 skill 里。
- 默认先走“无技术栈协作基线”模式，除非用户明确要求或仓库内已有清晰技术栈。
- 默认使用 `OpenSpec` 风格目录，不默认接入更重的流程平台。
- 默认把 GitHub 仓库建成私有仓库。
- 如果用户要求 SSH 推送，必须检查 `ssh -T git@github.com`，并将 `origin` 设为 SSH URL。
- 所有 GitHub 操作优先使用 `gh`，例如 `gh repo create`、`gh pr create`、`gh issue create`。
- 对已有项目执行时，只补缺失部分，不重写用户现有文档。

## Workflow

1. 检查当前目录是否已是仓库，是否已有远程。
2. 检查是否已存在 `README.md`、`AGENTS.md`、`DESIGN.md`、`SUPERPOWERS.md`、`openspec/`、`.github/workflows/`、`.pr_agent.toml`。
3. 若项目为空或缺少协作底座，则先按“无技术栈协作基线”模板补齐。
4. 若尚未初始化 git，则执行 `git init`，并将默认分支调整为 `main`。
5. 建立首个 OpenSpec bootstrap change，记录初始化结构和任务。
6. 生成 GitHub 协作基线：PR 模板、PR-Agent workflow、基础仓库校验 workflow。
7. 若用户需要创建 GitHub 仓库，先检查 `gh auth status`；若用户要求 SSH 推送，再检查 `ssh -T git@github.com`，必要时执行 `gh config set git_protocol ssh`。
8. 使用 `gh repo create <repo-name> --private --source=. --remote=origin` 创建私有仓库。
9. 无论是否已执行 `gh config set git_protocol ssh`，都必须再次检查 `git remote -v`。
10. 若远程被配置为 HTTPS 且用户要求 SSH，则将 `origin` 改为 `git@github.com:<owner>/<repo>.git`。
11. 提交首个 bootstrap commit 并推送到 `origin/main`。
12. 只有在用户明确指定技术栈，或仓库里已能推断真实语言时，再补充语言相关的 CI、测试、lint 和依赖。
13. 最后向用户说明哪些部分已初始化，哪些 GitHub secrets 或占位配置仍需后续补齐。

## Execution Checklist

执行这个 skill 时，默认按下面顺序推进，不要跳步：

1. 读取 skill 自身和模板目录。
2. 运行 `git status --short --branch`，判断是否已是仓库。
3. 运行 `git remote -v`，判断是否已有远程。
4. 列出当前目录文件，判断是否为空仓库或半初始化仓库。
5. 如果仓库为空或缺基线文件：
   - 创建 `.github/workflows/`
   - 创建 `openspec/specs/`
   - 创建 `openspec/changes/`
   - 创建 bootstrap change 目录
6. 复制或生成最小基线文件，不覆盖用户已有非空文件，除非用户明确要求重写。
7. 如果当前不是 git 仓库：
   - 执行 `git init`
   - 将默认分支设为 `main`
8. 如果用户要求创建 GitHub 仓库：
   - 先跑 `gh auth status`
   - 如果用户要求 SSH，再跑 `ssh -T git@github.com`
   - 需要时执行 `gh config set git_protocol ssh`
   - 先检查仓库是否已存在，再执行 `gh repo create`
9. 如果用户要求 SSH：
   - 无论前面是否设置过 `gh config set git_protocol ssh`，都再次检查 `git remote -v`
   - 若 `origin` 不是 SSH URL，执行 `git remote set-url origin git@github.com:<owner>/<repo>.git`
10. 在提交前，至少验证：
   - 必需文件存在
   - `openspec/project.md` 和 `openspec/CURRENT.md` 存在
   - `.github/workflows/pr-agent.yml` 和 `.pr_agent.toml` 成对存在
11. 生成首个提交：
   - `git add .`
   - `git commit -m "chore: bootstrap repository foundation"`
12. 如果远程存在，推送：
   - `git push -u origin main`
13. 在最终回复中明确：
   - 是否创建了私有 GitHub 仓库
   - `origin` 是否为 SSH
   - 首个 commit hash
   - 还需要用户补哪些 secrets 或后续技术栈配置

## Default Bootstrap Change

如果仓库从 0 到 1 初始化，默认创建一个类似下面命名的 change：

- `bootstrap-repository-foundation`

该 change 至少应包含：

- `proposal.md`
- `tasks.md`
- `design.md`

并覆盖这些任务：

- 本地 git 初始化
- 协作文档创建
- OpenSpec 基线创建
- PR-Agent 与 GitHub workflow 创建
- `gh auth status` 检查
- `ssh -T git@github.com` 检查（若用户要求 SSH）
- 私有仓库创建
- SSH remote 配置
- 首个 commit 与 push

## Minimum Deliverables

初始化时至少应生成或确认存在：

- `README.md`
- `AGENTS.md`
- `DESIGN.md`
- `SUPERPOWERS.md`
- `.gitignore`
- `.editorconfig`
- `.gitattributes`
- `openspec/project.md`
- `openspec/CURRENT.md`
- `openspec/specs/`
- `openspec/changes/`
- `.github/pull_request_template.md`
- `.github/workflows/ci.yml`
- `.github/workflows/pr-agent.yml`
- `.pr_agent.toml`

## Stack Detection Rule

- 如果仓库是空的，或没有可靠证据表明技术栈，禁止擅自把项目初始化成 Python、Node.js、Go、Rust 等任意语言项目。
- 此时只建立与技术栈无关的仓库治理层。
- 只有当仓库已存在明确技术栈文件，或用户明确指定时，才补语言相关命令和依赖。

## Command Preference

- 先用 `git status`、`git remote -v`、`gh auth status` 探测环境。
- 用户要求 SSH GitHub 操作时，再补 `ssh -T git@github.com`。
- 创建仓库优先用：
  `gh repo create <repo-name> --private --source=. --remote=origin`
- 如果需要 SSH：
  `gh config set git_protocol ssh`
- 如果远程不是 SSH：
  `git remote set-url origin git@github.com:<owner>/<repo>.git`
- 首次推送优先用：
  `git push -u origin main`
- 如果仓库已存在，只补文档和目录，不重复建 repo。
- 创建功能分支优先用：
  `git checkout -b feature/<name>`

## Template Map

- 复制 [templates/README.template.md](templates/README.template.md) 作为 `README.md`
- 复制 [templates/AGENTS.template.md](templates/AGENTS.template.md) 作为 `AGENTS.md`
- 复制 [templates/DESIGN.template.md](templates/DESIGN.template.md) 作为 `DESIGN.md`
- 复制 [templates/SUPERPOWERS.template.md](templates/SUPERPOWERS.template.md) 作为 `SUPERPOWERS.md`
- 复制 [templates/gitignore.template](templates/gitignore.template) 作为 `.gitignore`
- 复制 [templates/editorconfig.template](templates/editorconfig.template) 作为 `.editorconfig`
- 复制 [templates/gitattributes.template](templates/gitattributes.template) 作为 `.gitattributes`
- 复制 [templates/openspec-project.template.md](templates/openspec-project.template.md) 作为 `openspec/project.md`
- 复制 [templates/openspec-current.template.md](templates/openspec-current.template.md) 作为 `openspec/CURRENT.md`
- 复制 [templates/openspec-spec-change-management.template.md](templates/openspec-spec-change-management.template.md) 作为 `openspec/specs/change-management/spec.md`
- 复制 [templates/openspec-spec-repository-bootstrap.template.md](templates/openspec-spec-repository-bootstrap.template.md) 作为 `openspec/specs/repository-bootstrap/spec.md`
- 复制 [templates/github-pr-template.md](templates/github-pr-template.md) 作为 `.github/pull_request_template.md`
- 复制 [templates/github-ci.template.yml](templates/github-ci.template.yml) 作为 `.github/workflows/ci.yml`
- 复制 [templates/github-pr-agent-workflow.template.yml](templates/github-pr-agent-workflow.template.yml) 作为 `.github/workflows/pr-agent.yml`
- 复制 [templates/pr-agent.template.toml](templates/pr-agent.template.toml) 作为 `.pr_agent.toml`
- 复制 [templates/openspec-change/proposal.template.md](templates/openspec-change/proposal.template.md) 作为 `proposal.md`
- 初始化仓库 bootstrap change 时，优先复制 [templates/openspec-change/bootstrap-tasks.template.md](templates/openspec-change/bootstrap-tasks.template.md) 作为 `tasks.md`
- 复制 [templates/openspec-change/tasks.template.md](templates/openspec-change/tasks.template.md) 作为 `tasks.md`
- 需要复杂功能时，再复制 [templates/openspec-change/design.template.md](templates/openspec-change/design.template.md)

## Iteration Path

第一阶段只做这些：

- 文档底座
- OpenSpec 基线
- Superpowers 使用说明
- PR-Agent 基线
- GitHub 私有仓库初始化
- SSH 远程配置
- 最小仓库级 CI

第二阶段再逐步加入：

- 语言和框架相关工程配置
- 更严格的 PR 模板
- 更细的 PR review 自动化
- 子代理角色定义
- 更复杂的 spec 或任务编排系统

## Review Defaults

- 优先检查模板是否与项目实际语言、框架、命令一致。
- 优先检查在“无技术栈模式”下，模板是否避免了假的依赖或假的运行命令。
- 优先检查 `AGENTS.md` 是否没有误导性的目录或命令。
- 优先检查 `DESIGN.md` 是否足够克制，不把 UI 风格写死。
- 优先检查 `openspec/project.md`、`openspec/CURRENT.md` 和 bootstrap change 是否完整。
- 优先检查 `.github/workflows/pr-agent.yml` 与 `.pr_agent.toml` 是否成对出现。
- 优先检查最终 `origin` 是否真的是 SSH URL（如果用户要求 SSH）。
- 优先检查是否错误地引入了某个语言栈依赖。

## Maintain This Skill

- 保持 `SKILL.md` 只描述流程和判断标准。
- 将可复用内容放到 `templates/` 下维护。
- 当团队规模和流程复杂度上升时，在模板里新增可选段落，而不是把主流程改重。
