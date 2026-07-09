---
name: acq-chat
description: Chat with the ACQ AI Business Advisor (portal.acquisition.com) programmatically. Use when asked to query the Hormozi AI advisor, ask business strategy questions to ACQ AI, or interact with the acquisition.com chatbot.
---

# ACQ AI Business Advisor - Programmatic Chat

Send questions to the ACQ AI Business Advisor at https://portal.acquisition.com/advisor and retrieve responses via the Chrome browser extension. This advisor is trained on Alex Hormozi's strategies from $100M Offers, $100M Leads, and exclusive workshop content.

## Prerequisites

- Chrome browser with Claude browser extension installed and connected
- User must be **logged into https://portal.acquisition.com** in Chrome
- Browser automation tools (`mcp__claude-in-chrome__*`) must be available

## How It Works

The portal uses Clerk authentication with httpOnly session cookies. Direct JavaScript `fetch()` calls from the page context cannot authenticate (the httpOnly cookies are excluded from JS-constructed requests). Instead, we interact through the DOM — typing messages, clicking send, and reading responses from the rendered page. This is reliable because the browser handles all authentication automatically.

### API Reference (for context only — not used directly)

The underlying API uses tRPC. Documented here for debugging reference:

| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/api/trpc-subscriptions/sandbar.chatStream` | POST | Send message, get streamed response |
| `/api/trpc/sandbar.chat` | POST | Create/save chat record |
| `/api/trpc/sandbar.chatList` | GET | List recent chats |
| `/api/trpc/sandbar.chatMessages` | GET | Get messages for a chat |

Chat stream request body (for reference):

```json
{
  "json": {
    "messages": [{"role": "user", "content": "..."}, ...],
    "requestId": "uuid",
    "advisorAgentId": "general",
    "toolContext": {
      "userId": "user_...",
      "companyId": null,
      "chatId": "uuid",
      "messageId": "uuid",
      "newMessageId": "uuid"
    }
  }
}
```

## Step 1: Open the advisor page

```
mcp__claude-in-chrome__tabs_context_mcp (createIfEmpty: true)
```

Check if any existing tab is on `portal.acquisition.com/advisor`. If not, create one and navigate:

```
mcp__claude-in-chrome__tabs_create_mcp
mcp__claude-in-chrome__navigate to https://portal.acquisition.com/advisor
```

Wait 3 seconds, then **verify login state**:

- Use `mcp__claude-in-chrome__read_page (filter: "interactive")`.
- **Logged in:** You'll see a textarea with placeholder "Message ACQ AI..." and a "Send message" button. The tab title will be "ACQ Portal".
- **Not logged in:** The URL will redirect away from `/advisor` (e.g., to a Clerk sign-in page), or the textarea won't be present. Tell the user they need to log in at https://portal.acquisition.com first.

To start a **fresh chat** (not a follow-up), navigate to `/advisor` — this always loads a clean chat page with no prior messages.

## Step 2: Send a message

1. Use `mcp__claude-in-chrome__read_page` with `filter: "interactive"` to find the textarea (placeholder: "Message ACQ AI...") and the "Send message" button.

2. Set the message text. Try `form_input` first:

```
mcp__claude-in-chrome__form_input (ref: <textarea_ref>, value: "YOUR QUESTION")
```

If the Send button remains disabled after this (React may not register the change), fall back to clicking the textarea and typing:

```
mcp__claude-in-chrome__computer (action: "left_click", ref: <textarea_ref>)
mcp__claude-in-chrome__computer (action: "type", text: "YOUR QUESTION")
```

3. Click the "Send message" button:

```
mcp__claude-in-chrome__computer (action: "left_click", ref: <send_button_ref>)
```

## Step 3: Wait for the response

The AI response streams in. Poll for completion by checking interactive elements:

```
mcp__claude-in-chrome__read_page (filter: "interactive")
```

- **"Stop response" button visible** → still streaming. Wait 5-10 seconds and check again.
- **"Send message" button visible** → response is complete.

Check every 5-10 seconds. Responses typically take 10-30 seconds. If "Stop response" persists past 60 seconds, click it to abort and retry.

## Step 4: Read the response

**Primary method** — use `get_page_text` (proven reliable):

```
mcp__claude-in-chrome__get_page_text (tabId: <tab_id>)
```

This returns the full page text including your question and the AI's response. The AI answer contains source citations inline as `[$100M Offers, Page 29]` etc. Parse the response by finding the text between your question and the page footer/input area.

**Optional: DOM extraction** for cleaner parsing (selectors may break across deploys):

```javascript
// Message container: div.flex.flex-col.gap-4.py-2
// User messages have class "flex-row-reverse"; assistant messages don't
// Text content lives in ".leading-relaxed" elements
const container = document.querySelector('div.flex.flex-col.gap-4.py-2');
const children = Array.from(container.children);
const assistantDivs = children.filter(c => !c.className.includes('flex-row-reverse'));
const lastAssistant = assistantDivs[assistantDivs.length - 1];
const textEl = lastAssistant?.querySelector('.leading-relaxed');
textEl ? textEl.innerText : 'no response found'
```

These are Tailwind utility classes and **will break** if the app redesigns. Always fall back to `get_page_text` if they stop working.

## Follow-up questions

Repeat Steps 2-4 without navigating away. The portal maintains conversation context within the same chat. To start a new conversation, navigate to `https://portal.acquisition.com/advisor`.

## Selecting an Advisor Agent

The portal defaults to the "General" advisor. A "Select advisor agent" dropdown button appears at the top-left of the chat area. Click it to see available agents and select a different one. The `advisorAgentId` in the underlying API corresponds to the selected agent (e.g., `"general"`).

## Reading Chat History

1. Click the sidebar toggle button (labeled "Open sidebar" in the top-left area).
2. Past chats appear in the sidebar. Click a chat title to load it.

## Handling Long Responses

If `get_page_text` truncates a long response:

1. Scroll down with `mcp__claude-in-chrome__computer (action: "scroll", scroll_direction: "down")` and call `get_page_text` again.
2. Or use JavaScript to extract all assistant text in chunks:

```javascript
const container = document.querySelector('div.flex.flex-col.gap-4.py-2');
const children = Array.from(container.children);
const assistantDivs = children.filter(c => !c.className.includes('flex-row-reverse'));
const allText = assistantDivs.map(d => {
  const textEl = d.querySelector('.leading-relaxed');
  return textEl ? textEl.innerText : '';
}).filter(Boolean).join('\n---\n');
window.__acqResponse = allText;
const CHUNK = 3000;
JSON.stringify({ text: allText.substring(0, CHUNK), hasMore: allText.length > CHUNK, totalLength: allText.length });
```

Read remaining chunks with increasing offsets:

```javascript
const t = window.__acqResponse;
const OFFSET = 3000;
const CHUNK = 3000;
const slice = t.substring(OFFSET, OFFSET + CHUNK);
JSON.stringify({ text: slice, hasMore: OFFSET + CHUNK < t.length });
```

## Troubleshooting

- **Not logged in**: If the page redirects away from `/advisor` or the textarea is missing, the user must log in at https://portal.acquisition.com. Look for a sign-in redirect or missing "Message ACQ AI..." textarea.
- **Extension disconnected**: Use `mcp__claude-in-chrome__switch_browser` to reconnect, then `mcp__claude-in-chrome__tabs_context_mcp` for fresh tab IDs. Avoid long-running async JavaScript (e.g., `fetch` with stream reading) as it can cause disconnects.
- **Tab not found**: Call `mcp__claude-in-chrome__tabs_context_mcp` to get fresh tab IDs.
- **Session expired mid-chat**: Clerk JWTs expire every ~60 seconds but auto-refresh while the page is open. If you get errors, reload the page and retry.
- **Message not sending / Send button disabled**: `form_input` may not trigger React's change detection. Use the click-then-type fallback described in Step 2.
- **Response never completes**: If "Stop response" persists past 60 seconds, click it to abort and retry.
- **DOM selectors broken**: The Tailwind utility class selectors (`div.flex.flex-col.gap-4.py-2`, `.leading-relaxed`, `flex-row-reverse`) are fragile. Use `get_page_text` as the reliable fallback — it always works regardless of DOM structure.
