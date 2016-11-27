

function runWithString(string) {
  return go(string);
}

function runWithItem(item) {
  return go(item.title);
}

function go(str) {
  try {
    var remind = str.replace(/((?:[1-9][0-9]*(?:h|m(?:in)?|s(?:ec)?)\s*)+)$/, "").trim();
    var delay  = RegExp.$1;

    LaunchBar.displayInLargeType({
      'title': '⏰ Reminder',
      'string': remind,
      'sound': 'Glass',
      'delay': delay
    });

    return {
      'title': 'Reminder in ' + delay,
      'subtitle': remind,
      'alwaysShowsSubtitle': true,
      'icon': '/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/AlertNoteIcon.icns'
    };

  } catch (exception) {
    LaunchBar.alert('Timer Error', exception);
  }
}
