/**
 * A GitHub URL to Markdown converter.
 */

var URL_RGXP=/^https?:\/\/github\.com\/([^\/]+\/[^\/]+)\/(issues|pull)\/([1-9]\d*)(#[A-Za-z]+-\d+)?$/i

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
    var markdown = markdownURL(argument);

    if (markdown != null) {
      LaunchBar.setClipboardString(markdown);
      LaunchBar.displayNotification({
        title: 'Copied markdown link to your clipboard',
      });
    }
    return markdown;
  }
}

function markdownURL(url) {
  var markdown = null;
  url = url.trim();

  if (url.length > 0) {
    var text = url;
    var parsed = parseGitHubURL(url);

    if (parsed != null) {
      text = parsed.nwo + '#' + parsed.number
      url = 'https://github.com/' + parsed.nwo + '/' + parsed.flavor + '/' + parsed.number

      if (parsed.comment && parsed.comment.length > 0) {
        text = text + ' (comment)'
        url = url + parsed.comment
      }
    }
    markdown = '[' + text + '](' + url + ')'
  }
  return markdown;
}

function parseGitHubURL(url) {
  var parsed = null;
  var match  = URL_RGXP.exec(url);

  if (match != null) {
    parsed = {
      nwo:     match[1],
      flavor:  match[2],
      number:  match[3],
      comment: match[4],
    };
  }
  return parsed;
}
