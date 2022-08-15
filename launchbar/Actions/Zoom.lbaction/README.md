# Zoom

This LaunchBar action is a little [Zoom](https://zoom.us) helper that can launch
Zoom meetings if you have the meeting ID or meeting URL on the clipboard. It
also keeps a history of previous Zoom meetings for quick joins.

**NB** The actions described below use **␣** to represent a `[space]`
character. So when you see **zoom ␣**, it means you type in the word
`zoom` followed by a `[space]` character to execute the action in LaunchBar.
The `[return]` character is represented as **↩︎**, and the `[cmd]` character is
represented as **⌘**.

## Usage

<dl>
  <dt>zoom ↩︎</dt>
  <dd>
    Launch the Zoom application.
  </dd>
  <dt>zoom ␣</dt>
  <dd>
    Connect to a Zooming meeting. Type in the meeting ID or the Zoom meeting
    URL to connect. If the clipboard contains a Zoom meeting URL, then it will
    be automatically entered as the input. Omitting any value will launch the
    Zoom application.
  </dd>
  <dt>zoom ⌘↩︎</dt>
  <dd>
    Show the Zoom meeting history.
  </dd>
</dl>

## History

The zoom action keeps track of the last 10 meetings. If you highlight one of the
meetings in the history list and hit `[return]`, it will connect you to that
meeting.

If you connect to a meeting in the history list, it will be moved to the top of
the history. This prevents duplicate meetings from appearing in the history
list.
