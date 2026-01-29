# Chat End Checklist

## Purpose

This checklist ensures knowledge from each session is captured and context stays current. Run through these items before ending a productive session to preserve learnings and maintain accurate context for future chats.

---

## End of Session Checklist

### 1. 📊 Token Usage Check
**AI monitors throughout session:**
- [ ] Are we approaching context limit (~180K tokens)?
- [ ] If yes, offer to summarize now

**If approaching limit:**
> "We're at ~175K tokens. Should I summarize this session's decisions 
> according to chat-summary-guide.md before we lose context?"

### 2. 📝 Generate Session Summary
**When to summarize:**
- Major decisions made
- Architecture/design choices established
- Patterns implemented
- Problems solved
- Approaching token limit

**AI asks:**
- [ ] "Should I generate a summary of this session's key decisions?"
- [ ] Follow [chat-summary-guide.md](chat-summary-guide.md) format
- [ ] User copies for `dt ai-context update <project>`

### 3. 🎯 Update Technical Skills
**AI identifies skills discussed:**
- [ ] Did we discover new skill levels?
- [ ] Did proficiency change in existing skills?
- [ ] Any new technologies encountered?

**AI presents findings:**
> "Skills discussed this session:
> - Hilt DI: You mentioned learning it → Add as 'learning' level?
> - Compose: Confirmed beginner → Keep current
> - Coroutines: Applied successfully → Update to 'intermediate'?
> 
> Update [technical-skills.md](technical-skills.md)? [y/n]"

**User approves updates before changes made.**

### 4. 📂 Update Project Context
**AI confirms:**
- [ ] Should decisions be added to project context.md?
- [ ] Any architectural changes to document?
- [ ] Patterns established to note?

**User runs:**
```bash
dt ai-context update <project-name>
# Pastes AI-generated summary
```

### 5. 📚 Foundation Docs Updates
**AI flags if foundation docs need updates:**
- [ ] New pattern worth documenting in design-standards?
- [ ] Code convention discovered that should be added?
- [ ] Working-style refinement needed?
- [ ] Sample design to add?

**AI suggests:**
> "We established a new pattern for error handling with sealed classes. 
> Should we add this to design-standards/kotlin-patterns.md?"

**Note:** Foundation docs change less frequently than skills/project context.

### 6. ✅ Session Complete Confirmation
**AI confirms:**
- [ ] All deliverables completed or clearly documented for next time
- [ ] User has files to download/save
- [ ] Clear stopping point established
- [ ] Next steps identified (if applicable)

---

## Checklist Summary (Quick Reference)

```
□ Token limit check → Summarize if needed
□ Generate session summary → Save key decisions
□ Update technical-skills.md → New skills/levels
□ Update project context → Run dt ai-context update
□ Foundation docs → Flag needed updates
□ Session complete → Confirm deliverables
```

---

## Notes

- Not every item applies to every session
- Quick sessions may only need summary
- Long sessions may touch all items
- This checklist evolves as we learn what works best

---

*This checklist evolves as we discover better ways to preserve and transfer knowledge between sessions.*
