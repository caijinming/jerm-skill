# Capability: change-management

## Goal

用 OpenSpec 跟踪仓库的重要结构、流程和决策演进，而不是把长期真相散落在聊天记录中。

## Requirements

### Requirement: Bootstrap Baseline

仓库必须通过一个 bootstrap change 记录初始协作结构。

#### Scenario: repository initialization

- When the repository is initialized
- Then a change under `openspec/changes/` records the bootstrap intent and tasks

### Requirement: Meaningful Changes

当仓库结构、工作流或长期规则发生实质变化时，必须创建新的 change。

#### Scenario: workflow update

- When collaboration rules materially change
- Then the repository adds a new change with proposal and tasks before large edits proceed

### Requirement: Long-Lived Truth

长期有效的规则必须沉淀到 `openspec/specs/`，而不是只停留在 change 中。

#### Scenario: change completed

- When a change becomes stable baseline
- Then the lasting rules are reflected in `openspec/specs/`
