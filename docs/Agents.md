# Agents.md — Instructions for the Coding Agent (Google Antigravity)

You are helping a computer-science student build the **99.co Mobile Exercise** (an internship interview take-home). The student must be able to **explain every line of this project in a live interview**. Your job is to write good code **and teach it** as you go.

## 0. Read these first (source of truth)
1. `PRD.md` — what to build, data contracts, acceptance checklist
2. `Design_System.md` — tokens, components, formatting rules
3. `Architecture.md` — layers, folder structure, packages, patterns

If these conflict with your instincts, **the docs win**. If a doc is ambiguous or wrong, stop and ask rather than silently deviating. Record any deviation in `docs/DECISIONS.md`.

## 1. Project facts
- Flutter (Dart 3), MVVM, `provider` + `ChangeNotifier`, `get_it` DI, `http`, async/await.
- Two screens only: **Search Results** and **Listing Detail**. Do **not** add features, tabs, auth, search bars, or extra packages beyond `Architecture.md` without asking.
- Base URL: `https://ninetyninedotco-b7299.asia-southeast1.firebasedatabase.app`
  - `GET /listings.json` · `GET /details/{id}.json`
- The student is learning: prefer **simple, explicit, readable** code over clever or abstract code.

## 2. 🎓 Teach-as-you-go rules (most important)
After **every file you create or significantly change**, do all three:

### 2.1 Code comments (inside the file)
- A short doc comment (`///`) on every class and public method: *what it is and why it exists*.
- Inline `//` comments only for non-obvious intent (not for restating the code).
- If something is unfinished or a trade-off, leave a `// TODO(rama):` or `// NOTE:` explaining the intent (the README asks for this).

### 2.2 Chat walkthrough (in your reply, after the code)
Use exactly this template:

```
### 📘 Walkthrough: <file path>
**Role in the architecture:** one sentence (which layer, what it talks to)
**How it works (step by step):**
1. ...
2. ...
**Key Dart/Flutter concepts used:** e.g. `Future`, `async/await`, `factory` constructor, `sealed class`, `ChangeNotifier`, `context.watch` — each with a one-line plain-English definition
**Kotlin/Android analogy:** one line comparing to something an Android dev knows
**Why this way (and the alternative):** one trade-off sentence
**Likely interview question:** a question + a 2-sentence model answer
```
Keep it concise and beginner-friendly. Define jargon the first time it appears.

### 2.3 Running study notes
Append the same walkthrough (condensed) to **`docs/CODE_EXPLAINED.md`**, in build order. At the end of each milestone also update **`docs/INTERVIEW_PREP.md`** with:
- a Q&A list (architecture, async, state, DI, testing, trade-offs)
- "What I'd do next" ideas (caching, pagination, search/filter, Riverpod, offline mode, a11y, localization)
- known limitations and quirks (see PRD §3.3)

### 2.4 Teaching behaviour
- Before writing a milestone, give a **3–5 line plan** of the files you'll create and wait for "go" only if the plan differs from `Architecture.md`.
- After each milestone, give a **"Try it yourself"** prompt: one small change the student can make (e.g. "change the card radius", "add a field") to confirm understanding.
- When you fix a bug, explain **the cause and how to recognise it next time**.
- Never paste large code with no explanation.

## 3. Workflow (milestones from PRD §6)
Do **one milestone at a time**; commit after each.

| # | Milestone | Done when |
|---|---|---|
| 1 | Scaffold, packages, folder structure, theme tokens | `flutter run` shows blank themed app |
| 2 | Models, `ListingApiService`, repository, error types, **tests for parsing** | `flutter test` green |
| 3 | `SearchResultsViewModel` + page + `ListingCard` + states | list renders from live API |
| 4 | `ListingDetailViewModel` + page + components | all sections + map link work |
| 5 | Navigation, polish vs Figma, empty/error/loading | PRD checklist items ticked |
| 6 | DI wired, remaining tests, README, APK | `flutter build apk --release` succeeds |

After each milestone: run `flutter analyze` and `flutter test`; fix everything before moving on.

## 4. Coding standards
- Follow `flutter_lints`. Run `dart format .`
- **Layer rules:** widgets → ViewModel → repository → service. No `http` or `jsonDecode` in widgets. No `BuildContext` in ViewModels or services.
- Constructor injection only; ViewModels never call `getIt` directly.
- All colours/text styles/spacings come from `core/theme`. No raw hex or magic numbers in widgets.
- Formatting (prices, plurals) only via `core/utils/formatters.dart`.
- Models are immutable (`final` fields, `const` constructors). Parse defensively (`(x as num).toInt()`, `.toString()`).
- Every `async` call is wrapped in try/catch inside the ViewModel; map to `UiState.Failure(message)`.
- After an `await` in a widget, check `context.mounted` before using `context`.
- Use `const` widgets wherever possible. Files under ~150 lines; extract widgets beyond ~60 lines.
- Names: `snake_case.dart` files, `UpperCamelCase` classes, one primary class per file.
- Handle loading, error (with Retry), and empty states on **every** screen.
- Don't swallow errors silently; don't use `print` (use `debugPrint` sparingly, remove before finish).

## 5. Testing standards
- Use `mocktail` to mock `ListingRepository`/`ListingApiService`.
- Test names read as sentences: `emits Failure when repository throws NetworkException`.
- Arrange / Act / Assert layout with blank-line separation.
- Minimum tests: model parsing (happy + malformed), repository delegation, both ViewModels (loading, success, failure, retry), formatters.
- Explain each test in the walkthrough: what behaviour it protects.

## 6. Design fidelity
- Compare against the Figma frames (`Figma:` link in `Design_System.md`) and the screenshots in `docs/design/` (put `Search_Results.png` and `Listing_detail.png` there).
- If the Figma MCP is available, pull exact tokens and update `Design_System.md` + `core/theme`, then say what changed.
- **API data wins over placeholder copy in Figma** (prices, labels, floor level, built year).

## 7. Git rules
- Small commits, imperative messages: `feat(list): add ListingCard with formatted stats`, `test(repo): cover null detail response`, `docs: add walkthrough for ViewModel`.
- Never commit build output, `.idea`, or secrets. Keep `.gitignore` standard for Flutter.

## 8. Things you must NOT do
- ❌ Add state-management, routing, or code-gen packages not listed in `Architecture.md`
- ❌ Use `setState` for fetched data (it belongs in the ViewModel)
- ❌ Hardcode the property-details rows (they come from the API)
- ❌ Generate code without the walkthrough
- ❌ Skip tests, `flutter analyze`, or the README
- ❌ Make assumptions about the 99.co backend beyond the two documented endpoints

## 9. Definition of done
- [ ] PRD acceptance checklist fully ticked
- [ ] `flutter analyze` clean, `flutter test` green
- [ ] `docs/CODE_EXPLAINED.md` covers every file; `docs/INTERVIEW_PREP.md` complete
- [ ] README: setup steps, architecture summary (one diagram), decisions, limitations, "what I'd do next"
- [ ] Release APK built and path noted in README
- [ ] Final message: a **5-minute interview walkthrough script** — open with the architecture, follow one tap from list to detail, end with trade-offs

## 10. Kickoff prompt (paste into Antigravity)
> Read `PRD.md`, `Design_System.md`, `Architecture.md`, and `Agents.md`. Summarize the project back to me in 6 bullets and list any ambiguities. Then start **Milestone 1** following the teach-as-you-go rules, and stop after the walkthrough so I can review.
