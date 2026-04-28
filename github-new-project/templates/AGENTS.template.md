# AGENTS.md

## Project Summary

- 项目名称：`<PROJECT_NAME>`
- 项目阶段：`仓库基线初始化完成，业务代码尚未开始`
- 当前目标：`先建立 AI 与人协作底座，再按需求迭代具体技术栈`

## Required Reading

开始任何实质修改前，先看这些文件：

1. `README.md`
2. `AGENTS.md`
3. `openspec/CURRENT.md`
4. 与当前任务直接相关的 `openspec/specs/*` 或 `openspec/changes/*`

## Working Agreement

- 先理解现状，再改动文件。
- 优先做最小必要修改，不扩散到无关区域。
- 未明确前，不擅自引入技术栈、构建系统或第三方服务。
- 重要流程和结构变化必须先进入 OpenSpec。
- 如果需要创建 GitHub PR，优先通过 `gh` 完成。

## Repository Structure

- `.github/`：GitHub 工作流、PR 模板、自动化配置
- `openspec/specs/`：长期有效的能力规格
- `openspec/changes/`：尚在推进中的变更
- `openspec/CURRENT.md`：当前工作恢复入口

## OpenSpec Rules

- 新功能、流程调整、重要结构变化，先写 `proposal.md`
- 任务拆分写到 `tasks.md`
- 涉及设计取舍时补 `design.md`
- 变更完成后，把长期有效内容合并进 `openspec/specs/`
- 已完成的一次性变更可以归档到 `openspec/changes/archive/`

## Superpowers Rules

- 如果任务是“从需求到实现”的完整链路，优先采用 Superpowers 的工作方式。
- 先澄清需求，再形成设计，再拆解计划，再执行。
- 不要跳过验证直接声称完成。
- 不要在缺乏上下文时直接大改仓库结构。

## Validation

- 在没有语言栈之前，至少保证仓库级协作校验可以通过。
- 如果后续引入技术栈，再把 lint、test、typecheck 命令补到这里。

## Git Workflow

- 从 `main` 拉出功能分支：`feature/<name>`
- 使用 Conventional Commits
- 合并通过 GitHub Pull Request 完成
- 不直接推送到 `main`

## GitHub Workflow

- 使用 `gh` 管理仓库、issue、PR
- 提交 PR 前通过必要校验
- PR 描述至少包含：背景、改动点、验证方式、风险

## Do Not

- 不要删除用户已有文档来“重建”结构
- 不要把一次性讨论直接写进长期 spec
- 不要在未确认前引入语言相关依赖
