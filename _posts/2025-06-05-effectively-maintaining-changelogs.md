---
layout: post
title: "The art and science of effectively maintaining changelogs for your project"
tags: git dotnet open-source
---
Even in 2025, maintaining changelogs isn't an exact science. There is no general consensus or even tooling around how your changelog should look in order to conform to some norms or standards, because there aren't any. After some trial-error and pondering, this is what I came up with for my upcoming FocusBeam project:

```bash
# Focus Beam Changelog

All notable changes to this project will be documented in this file.

## [Unreleased]
### Added
- [x] Dashboard and Timesheet view
- [x] About View
- [x] Settings View
- [x] Project creation and editing
- [x] Task creation and editing
- [x] Enable "Timesheet" button on dashboard
- [ ] Show Total Hours worked on the project on Dashboard View
- [ ] Logged hours computation
- [ ] Notes
- [ ] Mind Maps
- [ ] MCQ
- [ ] Export/Reports
```

This format looks somewhat better than the older version that I still retain for some existing projects:

	R 1.1

	- Pending CRM Reports.
	- Check post script.
	+ Clicking on logos go to home page.
	+ Chart: width on various screens.
	* Chart: Remove decimal from "Total Life (Hrs)"
	* report: pdf: line items: add gap between fields.
	* report: space below header.

Here, the mnemonic prefix is dash (-) to define a pending task, a plus (+) means work is in progress, and asterisk (*) means it's complete. Now, if you're an automation nerd and decided to opt for [conventional commit message spec](/blog/2019/06/how-to-enforce-conventional-commit-messages-using-git-hooks.html), it's possible to maybe construct the changelog automatically by following this spec while committing the code itself!

	- feat: pending CRM Reports
	- chore: check post script
	+ fix: clicking on logos go to home page
	+ feat: chart: width on various screens
	* feat: chart: Remove decimal from "Total Life (Hrs)"
	* fix: report: pdf: line items: add gap between fields
	* fix: report: space below header

This assumes that you've followed the conventional spec while committing your code to git source control. For example, "feat: pending CRM Reports" for implementing this particular feature.