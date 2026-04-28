# <PROJECT_NAME>

这是一个尚未选定技术栈的新仓库基线。

当前阶段的目标不是实现业务代码，而是先把后续协作和迭代需要的底座搭好：

- `AGENTS.md`
- `DESIGN.md`
- `SUPERPOWERS.md`
- `openspec/`
- `.github/`

## Repository Layout

- `.github/`：GitHub 协作与自动化配置
- `openspec/`：需求、设计、任务拆分和状态管理
- `AGENTS.md`：仓库协作约定
- `DESIGN.md`：设计规范起点
- `SUPERPOWERS.md`：面向代理工作流的方法说明

## Workflow

1. 新需求先写到 `openspec/changes/<change-name>/proposal.md`
2. 明确范围后补 `tasks.md`
3. 涉及重要结构取舍时补 `design.md`
4. 实现完成并稳定后，把长期真相沉淀到 `openspec/specs/`
