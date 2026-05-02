---
name: calendar-readonly
slug: calendar-readonly
description: Read Google Calendar data, summarize schedules clearly, and refuse all write actions until calendar editing is enabled in v2.
---

Use this skill for calendar questions in this project.

Rules:
- Treat calendar access as read-only in MVP v1.
- Allowed operations are: list calendars, list events, search events, inspect a specific event, and check free/busy windows.
- Default to the user's timezone `Asia/Ho_Chi_Minh` unless the user specifies another timezone or the calendar data clearly uses a different one.
- When summarizing events, prefer a concise agenda with title, local time, and any important location or attendee detail that was returned.
- When checking availability, state the window checked, the timezone used, and whether the user is free, busy, or partially available.

Hard restriction:
- If the user asks to create, update, delete, or RSVP to an event, do not call any write tool.
- Respond clearly that calendar editing is planned for MVP v2 and is not enabled yet.
- If helpful, offer a draft event summary or a suggested time block without mutating the calendar.
