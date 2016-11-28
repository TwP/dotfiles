
var INTERFACE='en0';
var NETWORKSETUP='/usr/sbin/networksetup';

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
  if (LaunchBar.options.spaceKey == 1) {
    return [
      {title: 'Wifi On',  icon: 'font-awesome:toggle-on',  action: 'turnWifiOn',  actionRunsInBackground: true},
      {title: 'Wifi Off', icon: 'font-awesome:toggle-off', action: 'turnWifiOff', actionRunsInBackground: true}
    ];
  }

  toggleWifi();
}

function toggleWifi() {
  var airportStatus = LaunchBar.execute(NETWORKSETUP, '-getairportpower', INTERFACE).trim();  // "Wi-Fi Power (en0): On\n"

  if (/:\s+On$/.test(airportStatus)) {
    turnWifiOff();
  } else {
    turnWifiOn();
  }
}

function turnWifiOn() {
  LaunchBar.execute(NETWORKSETUP, '-setairportpower', INTERFACE, 'on');
}

function turnWifiOff() {
  LaunchBar.execute(NETWORKSETUP, '-setairportpower', INTERFACE, 'off');
}
