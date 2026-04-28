# Capability: repository-bootstrap

## Goal

保证空仓库在尚未选定技术栈前，也具备最小可协作、可恢复、可审查的基线。

## Requirements

### Requirement: Core Collaboration Files

仓库必须提供协作和设计入口文件。

#### Scenario: new contributor opens repository

- When a contributor opens the repository
- Then they can find `README.md`, `AGENTS.md`, `DESIGN.md`, and `SUPERPOWERS.md`

### Requirement: OpenSpec Workspace

仓库必须提供可持续维护的 OpenSpec 目录。

#### Scenario: change planning

- When someone needs to propose a meaningful change
- Then `openspec/project.md`, `openspec/CURRENT.md`, `openspec/specs/`, and `openspec/changes/` already exist

### Requirement: GitHub Review Baseline

仓库必须具备基础 PR 协作配置。

#### Scenario: opening a pull request

- When a contributor opens a pull request
- Then the repository provides a PR template, PR-Agent workflow, and repository baseline checks
