export const axiosPostable = axios => {
  return axios.create({
    headers: {
      'X-CSRF-Token': document.getElementsByName('csrf-token')[0].getAttribute('content'),
      'Accept': 'application/json'
    }
  })
}

export const replaceEditorSelection = (cm, active, startEnd, url) => {
  // Cribbed directly from EasyMDE code

  if (/editor-preview-active/.test(cm.getWrapperElement().lastChild.className))
      return;

  var text;
  var start = startEnd[0];
  var end = startEnd[1];
  var startPoint = {},
      endPoint = {};
  Object.assign(startPoint, cm.getCursor('start'));
  Object.assign(endPoint, cm.getCursor('end'));
  if (url) {
      end = end.replace('#url#', url);
  }
  if (active) {
      text = cm.getLine(startPoint.line);
      start = text.slice(0, startPoint.ch);
      end = text.slice(startPoint.ch);
      cm.replaceRange(start + end, {
          line: startPoint.line,
          ch: 0,
      });
  } else {
      text = cm.getSelection();
      cm.replaceSelection(start + text + end);

      startPoint.ch += start.length;
      if (startPoint !== endPoint) {
          endPoint.ch += start.length;
      }
  }
  cm.setSelection(startPoint, endPoint);
  cm.focus();
}