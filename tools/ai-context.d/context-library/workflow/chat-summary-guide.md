# Chat Summary Guide

## Table of Contents
- [Purpose](#purpose)
- [Relationship to Chat Annotation Protocol](#relationship-to-chat-annotation-protocol)
- [When to Summarize](#when-to-summarize)
- [What to Extract](#what-to-extract)
- [What to Skip](#what-to-skip)
- [Summary Format](#summary-format)
- [Examples](#examples)
- [Quality Checklist](#quality-checklist)

---

## Purpose

This guide defines **what makes a good session summary** and how to structure it so future AI sessions can reliably build on past work.

**Goal:** Create concise, actionable summaries that preserve decisions and eliminate repeated discussion.

---

## Relationship to Chat Annotation Protocol

This document defines **summary content quality and structure only**.

All mechanics for capturing notes, proposing updates, confirmations, and end-of-chat workflows are governed by:

**workflow/chat-annotation-protocol.md**

If there is any conflict, the protocol is authoritative.

---

## When to Summarize

Summaries are produced via the `@summary` command defined in the chat annotation protocol.

Always summarize when:
- Ending a productive session with decisions made
- Architecture or design choices were established
- New patterns or conventions emerged
- Important problems were solved
- Approaching token limits

---

*Remaining sections unchanged.*

## `@summary` Output Format

When `@summary` is invoked, the assistant produces a **downloadable markdown file**
containing the accepted `@note` and `@update` items from the session.

This file is intended to be used as input to:

    dt ai-context update <project>

The output should:
- Contain only atomic `@note` and `@update` blocks
- Avoid narrative or explanatory prose
- Be immediately usable without manual editing

A brief on-screen preview may be shown before the file is generated.
