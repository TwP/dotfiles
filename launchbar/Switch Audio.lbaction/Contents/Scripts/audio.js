
function run() {
  try {
    var audioJson = LaunchBar.execute('/bin/bash', 'audio.sh');
    LaunchBar.debugLog('Output ' + audioJson);
    var audio = JSON.parse(audioJson);

    var items = [];

    if (audio.outputs && audio.outputs.length > 0) {
      for (var i = 0; i < audio.outputs.length; i++) {
        var output = audio.outputs[i];
        items.push(makeOutput({
          'name': output,
          'active': (output == audio.currentOutput ? true : false)
        }));
      }
    } else {
      LaunchBar.log('Audio outputs not available');
    }

    if (audio.inputs && audio.inputs.length > 0) {
      for (var i = 0; i < audio.inputs.length; i++) {
        var input = audio.inputs[i];
        items.push(makeInput({
          'name': input,
          'active': (input == audio.currentInput ? true : false)
        }));
      }
    } else {
      LaunchBar.log('Audio inputs not available');
    }

    return items;
  } catch (exception) {
    LaunchBar.log('Error ' + exception);
    LaunchBar.alert('Error', exception);
  }
}

function switchto(item) {
  try {
    var rtn = LaunchBar.execute('/bin/bash', 'audio.sh', item.name, item.kind);
    LaunchBar.debugLog('Output switch ' + rtn);
    return run();
  } catch (exception) {
    LaunchBar.log('Error switching ' + exception);
    LaunchBar.alert('Error switching', exception);
  }
}

function makeInput(obj) {
  return makeItem(obj.name, 'input', obj.active);
}

function makeOutput(obj) {
  return makeItem(obj.name, 'output', obj.active);
}

function makeItem(name, kind, active) {
  var icon   = (kind == 'input' ? 'microphone.icns' : 'headphones.icns');
  var title  = (active ? '▶︎ ' : '') + name;
  var action = (active ? 'run': 'switchto');
  return {
    'title': title,
    'kind': kind,
    'name': name,
    'action': action,
    'actionReturnsItems': true,
    'icon': icon
  };
}
