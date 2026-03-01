# UI/UX Flow Sync Snapshot

This file mirrors the latest team-approved UI/UX flow so collaborators can stay
aligned directly from this repository.

## Core Navigation Roles

- Map: discovery and landmark selection
- Check-in: history/status hub (not new check-in creation)
- Awards: progress and badge feedback
- Routes: route browse and route start
- Landmark Detail `CHECK IN`: the only entry point to create a new check-in

## Main Sequence

1. Map -> select pin -> open Landmark Detail
2. Landmark Detail -> tap `CHECK IN`
3. Validate conditions (permission, distance, duplicate)
4. Save check-in
5. Update Awards progress and Check-in history

## Exception States in Scope

- Out of range (>50m)
- Permission denied
- Duplicate same-day check-in

## Figma Source

- https://www.figma.com/design/FKA7bElUbDF9dobufswn9L/nw_trails?node-id=1-2&t=q2rusy3SHfMQuuMh-1

## Canonical Team Document

- `proj/docs/design/ui_design_sequence_review.md` (workspace-level source)
