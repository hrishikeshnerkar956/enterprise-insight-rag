# Development Workflow

## Table of Contents

- [Overview](#overview)
- [GitFlow Branching Strategy](#gitflow-branching-strategy)
- [Branch Naming Conventions](#branch-naming-conventions)
- [Commit Message Format](#commit-message-format)
- [Pull Request Process](#pull-request-process)
- [Code Review Checklist](#code-review-checklist)
- [Testing Requirements](#testing-requirements)
- [Documentation Update Requirements](#documentation-update-requirements)
- [Merge Conflict Resolution](#merge-conflict-resolution)
- [Related Documentation](#related-documentation)

## Overview

This document defines the development workflow for the Enterprise Insight RAG v1.0 project. All contributors must follow these guidelines to maintain code quality, consistency, and traceability.

**Key Principles:**
- GitFlow branching strategy for organized version control
- Conventional Commits for clear, semantic commit messages
- Mandatory code reviews before merging
- Comprehensive testing before deployment
- Living documentation updated with code changes

## GitFlow Branching Strategy

We use GitFlow to manage our development workflow with two permanent branches and three types of temporary branches.

### Permanent Branches

**`main` Branch:**
- Production-ready code only
- Protected branch (no direct commits)
- Tagged with version numbers (v1.0.0, v1.1.0, etc.)
- Deployed to production environment
- Merges only from `develop` or `hotfix/*` branches

**`develop` Branch:**
- Integration branch for ongoing development
- Protected branch (no direct commits)
- Contains latest development changes
- Merges from `feature/*` and `bugfix/*` branches
- Source for creating `feature/*` branches

### Temporary Branches

**`feature/*` Branches:**
- For new features or enhancements
- Created from: `develop`
- Merged into: `develop`
- Naming: `feature/feature-name`
- Example: `feature/graphrag-implementation`

**`bugfix/*` Branches:**
- For non-critical bug fixes
- Created from: `develop`
- Merged into: `develop`
- Naming: `bugfix/bug-description`
- Example: `bugfix/fix-login-validation`

**`hotfix/*` Branches:**
- For critical production bugs
- Created from: `main`
- Merged into: `main` AND `develop`
- Naming: `hotfix/critical-fix`
- Example: `hotfix/fix-security-vulnerability`

### Branch Lifecycle Diagram

```
main (production)
  │
  ├─── hotfix/critical-fix ──┐
  │                           │
  │◄──────────────────────────┘
  │
  │◄─── develop (integration)
         │
         ├─── feature/new-feature ──┐
         │                           │
         │◄──────────────────────────┘
         │
         ├─── bugfix/fix-issue ──┐
         │                        │
         │◄───────────────────────┘
```

## Branch Naming Conventions

### Format

```
<type>/<description>
```

### Types

- `feature/`: New features or enhancements
- `bugfix/`: Bug fixes for non-critical issues
- `hotfix/`: Critical production bug fixes
- `docs/`: Documentation-only changes (optional)
- `refactor/`: Code refactoring without feature changes (optional)
- `test/`: Test-only changes (optional)

### Description Rules

- Use lowercase letters
- Use hyphens to separate words
- Be descriptive but concise (max 50 characters)
- Use present tense verbs
- No special characters except hyphens

### Examples

✅ **Good:**
- `feature/user-authentication`
- `feature/graphrag-knowledge-graph`
- `bugfix/fix-password-validation`
- `hotfix/fix-sql-injection`
- `docs/update-api-contracts`

❌ **Bad:**
- `feature/Feature1` (uppercase, not descriptive)
- `fix_bug` (wrong type, underscore instead of hyphen)
- `feature/implement-the-new-user-authentication-system-with-jwt` (too long)
- `my-branch` (no type prefix)

## Commit Message Format

We follow the [Conventional Commits](https://www.conventionalcommits.org/) specification for clear, semantic commit messages.

### Format

```
<type>(<scope>): <subject>

<body>

<footer>
```

### Type

Must be one of the following:

- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, missing semicolons, etc.)
- `refactor`: Code refactoring without feature changes
- `test`: Adding or updating tests
- `chore`: Maintenance tasks (dependencies, build config, etc.)
- `perf`: Performance improvements
- `ci`: CI/CD configuration changes

### Scope (Optional)

The scope specifies the area of the codebase affected:

- `auth`: Authentication service
- `ai`: AI service
- `mobile`: Mobile client
- `docs`: Documentation
- `infra`: Infrastructure
- `api`: API endpoints

### Subject

- Use imperative mood ("add" not "added" or "adds")
- Don't capitalize first letter
- No period at the end
- Max 50 characters

### Body (Optional)

- Explain what and why, not how
- Wrap at 72 characters
- Separate from subject with blank line

### Footer (Optional)

- Reference issues: `Closes #123`, `Fixes #456`
- Breaking changes: `BREAKING CHANGE: description`
- Requirements: `Requirements: 1.1, 1.2, 1.3`

### Examples

**Simple commit:**
```
feat(auth): add user registration endpoint

Implement POST /api/auth/register with email validation,
password hashing, and role assignment.

Requirements: 3.1, 3.2
```

**Bug fix:**
```
fix(ai): resolve vector search timeout issue

Increase query timeout from 5s to 30s and add connection
pooling to prevent database connection exhaustion.

Fixes #42
```

**Documentation:**
```
docs: update API contracts with new endpoints

Add documentation for GraphRAG and CRAG endpoints
including request/response schemas and examples.
```

**Breaking change:**
```
feat(api): change authentication token format

BREAKING CHANGE: JWT tokens now use HS512 instead of HS256.
Clients must update their token validation logic.

Requirements: 4.5
```

## Pull Request Process

### Creating a Pull Request

1. **Ensure branch is up-to-date:**
   ```bash
   git checkout develop
   git pull origin develop
   git checkout feature/your-feature
   git merge develop
   ```

2. **Push your branch:**
   ```bash
   git push origin feature/your-feature
   ```

3. **Create PR on GitHub:**
   - Go to repository on GitHub
   - Click "New Pull Request"
   - Select base branch (`develop` for features/bugfixes, `main` for hotfixes)
   - Select compare branch (your feature branch)
   - Fill out PR template

### PR Title Format

Use same format as commit messages:

```
<type>(<scope>): <description>
```

Example: `feat(auth): add user registration endpoint`

### PR Description Template

```markdown
## Description
Brief description of changes

## Type of Change
- [ ] New feature
- [ ] Bug fix
- [ ] Documentation update
- [ ] Refactoring
- [ ] Performance improvement

## Related Issues
Closes #123

## Changes Made
- Change 1
- Change 2
- Change 3

## Testing
- [ ] Unit tests added/updated
- [ ] Integration tests added/updated
- [ ] Manual testing completed

## Documentation
- [ ] Code comments added
- [ ] API documentation updated
- [ ] CODEBASE_EXPLANATION.md updated
- [ ] Other documentation updated (specify)

## Checklist
- [ ] Code follows style guidelines
- [ ] Self-review completed
- [ ] Tests pass locally
- [ ] No merge conflicts
- [ ] Documentation updated

## Screenshots (if applicable)
Add screenshots for UI changes
```

### PR Review Process

1. **Automated Checks:**
   - CI/CD pipeline runs tests
   - Code linting checks pass
   - Build succeeds

2. **Code Review:**
   - At least one approval required
   - Reviewer uses code review checklist
   - Address all review comments

3. **Approval:**
   - Reviewer approves PR
   - All checks pass
   - No merge conflicts

4. **Merge:**
   - Use "Squash and merge" for feature branches
   - Use "Merge commit" for hotfixes
   - Delete branch after merge

## Code Review Checklist

### Functionality

- [ ] Code implements requirements correctly
- [ ] Edge cases are handled
- [ ] Error handling is appropriate
- [ ] No obvious bugs or logic errors

### Code Quality

- [ ] Code is readable and well-organized
- [ ] Functions/methods have single responsibility
- [ ] No code duplication
- [ ] Variable/function names are descriptive
- [ ] Comments explain "why" not "what"

### Testing

- [ ] Unit tests cover new/changed code
- [ ] Tests are meaningful and not trivial
- [ ] Test coverage is at least 80%
- [ ] Integration tests added if needed

### Security

- [ ] No hardcoded credentials or secrets
- [ ] Input validation is present
- [ ] SQL injection prevention (parameterized queries)
- [ ] XSS prevention (input sanitization)
- [ ] Authentication/authorization checks present

### Performance

- [ ] No obvious performance issues
- [ ] Database queries are optimized
- [ ] No N+1 query problems
- [ ] Appropriate use of caching

### Documentation

- [ ] Code comments are clear and helpful
- [ ] API documentation updated (if applicable)
- [ ] CODEBASE_EXPLANATION.md updated
- [ ] README updated (if needed)

### Style

- [ ] Code follows language-specific style guide
- [ ] Linting passes without errors
- [ ] Consistent formatting throughout

## Testing Requirements

### Before Merging to `develop`

**Required:**
- [ ] All unit tests pass
- [ ] Code coverage is at least 80%
- [ ] Integration tests pass (if applicable)
- [ ] Manual testing completed

**Commands:**

```bash
# Java (Auth Service)
./mvnw test
./mvnw verify

# Python (AI Service)
pytest
pytest --cov=app --cov-report=html

# JavaScript (Mobile Client)
npm test
npm run test:coverage
```

### Before Merging to `main`

**Required:**
- [ ] All tests from develop requirements
- [ ] End-to-end tests pass
- [ ] Performance tests pass
- [ ] Security scan passes
- [ ] UAT completed and approved

**Additional Commands:**

```bash
# End-to-end tests
npm run test:e2e

# Load testing
artillery run load-test.yml

# Security scanning
npm audit
safety check
```

## Documentation Update Requirements

### When to Update Documentation

Documentation must be updated in the **same PR** as code changes for:

1. **New files/directories:**
   - Update `CODEBASE_EXPLANATION.md` with file purpose

2. **New functions/classes:**
   - Add entry to `CODEBASE_EXPLANATION.md`
   - Include purpose, parameters, return values, examples

3. **New API endpoints:**
   - Update `API_CONTRACTS.md` with endpoint specification
   - Include request/response schemas and examples

4. **Architectural decisions:**
   - Add ADR to `ARCHITECTURE_DECISIONS.md`
   - Include context, decision, and consequences

5. **Task status changes:**
   - Update `TASK_TRACKER.md` with new status
   - Update completion percentage

6. **Workflow changes:**
   - Update `DEV_WORKFLOW.md` with new process

### Documentation Review

Code reviewers must verify:

- [ ] All affected documentation files are updated
- [ ] Documentation is accurate and complete
- [ ] Cross-references are correct
- [ ] Examples are working and tested

## Merge Conflict Resolution

### Prevention

1. **Keep branches short-lived:**
   - Merge feature branches within 1-2 days
   - Regularly sync with develop

2. **Communicate:**
   - Notify team when working on shared files
   - Coordinate changes to avoid conflicts

3. **Pull frequently:**
   ```bash
   git checkout develop
   git pull origin develop
   git checkout feature/your-feature
   git merge develop
   ```

### Resolution Process

1. **Identify conflicts:**
   ```bash
   git merge develop
   # Conflicts will be listed
   ```

2. **Open conflicted files:**
   - Look for conflict markers: `<<<<<<<`, `=======`, `>>>>>>>`
   - Understand both changes

3. **Resolve conflicts:**
   - Keep necessary changes from both branches
   - Remove conflict markers
   - Test the merged code

4. **Mark as resolved:**
   ```bash
   git add <resolved-file>
   ```

5. **Complete merge:**
   ```bash
   git commit -m "merge: resolve conflicts with develop"
   ```

6. **Test thoroughly:**
   - Run all tests
   - Manual testing if needed

### Getting Help

If conflicts are complex:
- Ask the author of conflicting changes
- Pair program to resolve together
- Escalate to tech lead if needed

## Related Documentation

- [Task Tracker](TASK_TRACKER.md) - Task management and status
- [Architecture Decisions](ARCHITECTURE_DECISIONS.md) - ADR log
- [Codebase Explanation](CODEBASE_EXPLANATION.md) - Code structure
- [API Contracts](API_CONTRACTS.md) - API specifications
- [PRD and SDLC](PRD_AND_SDLC.md) - Project phases and requirements

---

**Document Version:** 1.0.0  
**Last Updated:** Phase 1 - Project Initiation  
**Next Review:** Phase 2 - DevOps & Infrastructure  
**Maintainer:** Development Team

