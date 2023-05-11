var enableDetections = 0
var viewDetections = 0
var enableSelection = 0
var enableReset = 0
var enableFocus = 0
var enableFace = 0
var viewFaceDetections = 0
var enableVisualServoing = 0

function getAbsolutePosition(node) {
      var returnPos = {};
      returnPos.x = 0;
      returnPos.y = 0;
      if(node !== undefined && node !== null) {
          var parentValue = getAbsolutePosition(node.parent);
          returnPos.x = parentValue.x + node.x;
          returnPos.y = parentValue.y + node.y;
      }
      return returnPos;
  }
