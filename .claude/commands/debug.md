---
description: Systematically diagnose and fix coding issues with detailed analysis and optimal solutions
argument-hint: "<description of issue>"
---

You are an expert debugging assistant. I need help with: $ARGUMENTS

Please follow this systematic debugging process:

## 1. ISSUE ANALYSIS
- Carefully analyze the described issue
- Identify the type of problem (syntax, logic, performance, dependency, environment, etc.)
- List any assumptions you're making about the codebase or environment
- Ask clarifying questions if the issue description is ambiguous

## 2. INFORMATION GATHERING
- Examine relevant files in the current directory
- Check for error messages, logs, or stack traces
- Review recent changes (git log if applicable)
- Identify dependencies and versions that might be relevant
- Look for configuration files that could be involved

## 3. HYPOTHESIS FORMATION
- Based on the analysis, form 2-3 specific hypotheses about what's causing the issue
- Rank these hypotheses by likelihood
- Explain your reasoning for each hypothesis

## 4. SYSTEMATIC DIAGNOSIS
- Test each hypothesis systematically, starting with the most likely
- Use appropriate debugging tools and techniques:
  * Add logging/print statements to trace execution
  * Use debuggers or profilers if needed
  * Check for common pitfalls (off-by-one errors, null/undefined values, etc.)
  * Verify assumptions about data types, formats, and ranges
  * Test edge cases and boundary conditions

## 5. ROOT CAUSE IDENTIFICATION
- Once you've identified the root cause, explain:
  * What exactly is going wrong
  * Why it's happening
  * How you confirmed this is the actual cause

## 6. SOLUTION DESIGN
- Propose a specific solution
- Explain why this solution is optimal by considering:
  * Correctness: Does it fix the root cause?
  * Maintainability: Is it clean and understandable?
  * Performance: Are there efficiency implications?
  * Robustness: Does it handle edge cases?
  * Compatibility: Does it work with existing code?
  * Best practices: Does it follow coding standards?

## 7. IMPLEMENTATION PLAN
Create a step-by-step plan:
- List files that need to be modified
- Describe changes in order of implementation
- Identify any backup steps needed
- Note any tests that should be added or updated
- Mention any documentation updates required

## 8. EXECUTION
- Implement the solution following your plan
- Test the fix thoroughly
- Verify the original issue is resolved
- Check that no new issues were introduced

## 9. VERIFICATION & CLEANUP
- Run existing tests to ensure nothing broke
- Add new tests if needed to prevent regression
- Clean up any debugging code you added
- Document the fix if appropriate

## 10. SUMMARY
Provide a concise summary including:
- What the issue was
- What caused it
- How you fixed it
- Any preventive measures for the future

Throughout this process, be methodical and explain your reasoning at each step. If you encounter unexpected results during diagnosis, adjust your hypotheses accordingly.

Now, let's begin the systematic debugging process.