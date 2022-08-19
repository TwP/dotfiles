/**
 * A Zoom meeting launcher for LaunchBar
 *
 * Provides a quick and convenient way to launch the Zoom application. You can
 * also provide a meeting URL or a meeting ID, and Zoom will connect directly to
 * the meeting. A history of the past ten meetings is available (not sure how
 * useful this feature will prove to be).
 *
 *   `zoom ↩︎`                                - Launch the Zoom application
 *   `zoom ⌘↩︎`                               - Show a history of Zoom meetings
 *   `zoom ␣ 12345678901`                    - Launch zoom and join the meeting
 *   `zoom ␣ https://zoom.us/j/12345678901`  - Launch zoom and join the meeting
 */


/**
 * This is the default function called by LaunchBar. If the user just runs the
 * action without any argument, or there is an argument but none of the more
 * specific function are implemented, this function will be called.
 *
 * It is recommended that every default script implements this function.
 *
 * @param {String|Object} argument - The argument, if the action was run with one.
 * @returns {Array|null} List of result Objects to display [https://developer.obdev.at/launchbar-developer-documentation/#/script-output]
 */
function run(argument) {
  if (typeof argument === 'string' || argument instanceof String) {
    runWithString(argument);

  } else if (argument == undefined) {
    var prefs = getPreferences();

    // running via Cmd-Enter ⌘↩︎ will show previous Zoom meetings
    if (LaunchBar.options.controlKey) {
      return getHistory();
      // return [
      //   {title: 'History', icon: 'font-awesome:history', badge: prefs.history.length.toString(), children: getHistory()},
      // ];

    // just pressing Enter ↩︎ launches the Zoom application
    } else {
      runWithString("");
    }
  }
}

/**
 * This function is called by LaunchBar when the user passes text to the action,
 * either by using text input or by using Send To. If your action supports
 * suggestions or live feedback, this function will be called during text input.
 *
 * @param {String} string - The string argument.
 * @returns {Array|null} List of result Objects to display [https://developer.obdev.at/launchbar-developer-documentation/#/script-output]
 */
function runWithString(string) {
  var input = parseInput(string);
  var cmd = null;

  if (input.confno != null) {
    cmd = "zoommtg://" + input.host + "/join?action=join&confno=" + input.confno;
    if (input.passwd != null) {
      cmd += "&pwd=" + input.passwd;
    }

    addToHistory(string);
  } else {
    cmd = "/Applications/zoom.us.app";
  }

  LaunchBar.execute('/usr/bin/open', cmd);
}

/**
 * Accessor to the preferences object. Sensible defaults are configured if this
 * is the very first time the method is called.
 *
 * @returns {Object} The preferences object
 */
function getPreferences() {
  var prefs = Action.preferences;

  if (!prefs.hasOwnProperty('history'))  prefs.history  = [];

  return prefs;
}

/**
 * Parse the given input string and return an Object representing the parsed
 * input informatin. If the input string is invalid, the returend Object will be
 * poppulated with `null` values. For valid inputs, a `host` and `confno` will
 * always be present in the returned object.
 *
 *   {
 *     host:   "zoom.us",      // the zoom server
 *     confno: 12345678901,    // the meeting ID
 *     passwd: "SwordFish"     // the meeting password
 *   }
 *
 * @param {String} string - The input string typed in by the user
 * @returns {Object} An object containing the parsed information
 */
function parseInput(string) {
  if (string.match(/^https?:\/\/[^\/]+\/my\//)) {
    string = LaunchBar.execute('/bin/bash', 'zoom_lookup.sh', string);
    LaunchBar.alert('replaced', string);
  }
  const rgxp = /^(?:https?:\/\/([^\/]+)\/(?:j\/)?)?([0-9a-fA-F]{9,11})(?:\?pwd=([^&]+))?/;
  var match = string.match(rgxp);
  var input = {
    host:   null,
    confno: null,
    passwd: null
  };

  if (match != null) {
    input.host   = match[1] || "zoom.us";
    input.confno = match[2];
    input.passwd = match[3];
  }

  return input;
}

/**
 * Retrieve the list of previous Zoom meetings and format them as LaunchBar
 * result objects. Selecting a historical Zoom meeting will join that meeting.
 *
 * @returns {Array} The list of previous Zoom meetings formatted as LaunchBar result objects
 */
function getHistory() {
  var actions = [];
  var prefs   = getPreferences();

  actions.push({title: 'Clear History', icon: 'font-awesome:trash-o', action: 'clearHistory'});

  prefs.history.forEach(function(item) {
    actions.push({
      title: item,
      icon: 'font-awesome:repeat',
      action: 'runWithString',
      actionArgument: item
    });
  });

  return actions;
}

/**
 * Add the given Zoom string to the beginning of the history list. New
 * entries are added to the head of the list, and older entries are removed from
 * the tail of the list. The history is limited to 10 entries.
 *
 * If an entry already exists in the list, then the previous entry is removed
 * and the new entry is added to the head of the list. This prevents duplicate
 * entries in the history list.
 *
 * @param {String} string - The string to add to the history array
 * @returns udnefined
 */
function addToHistory(string) {
  var prefs = getPreferences();
  if (string == prefs.message) return;

  var history = prefs.history;
  var index   = history.indexOf(string);

  if (index == 0) return;                    // repeating last Zoom meeting
  if (index > 1 ) history.splice(index, 1);  // remove previous history entry

  history.unshift(string);
  history.splice(10);
}

/**
 * Does what it says on the label - clears the history array of all entries.
 *
 * @returns undefined
 */
function clearHistory() {
  var prefs = getPreferences();
  prefs.history = [];
}
