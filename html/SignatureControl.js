var SignatureControl = function () {
    var _ref = this;
    var _canvas = null;
    var _div = null;
    var _interval = null;
    var _ro = null;
    var _jsro = null;
    var _signaturePad = null;
    var _ready = false;

    var _checkCanvasSize = function () {
        var bounding = _canvas.getBoundingClientRect();
        if ((bounding.width != _canvas.width || bounding.height != _canvas.height) && (_canvas.width > 0 && _canvas.height > 0)) {
            var context = _canvas.getContext("2d");
            var imagedata = context.getImageData(0, 0, _canvas.width, _canvas.height);
            _canvas.width = bounding.width;
            _canvas.height = bounding.height;
            context.putImageData(imagedata, 0, 0);
        } else if (_canvas.width * _canvas.height == 0) {
            _stop();
        }
    };
    var _start = function (signaturepadPanel) {
        _controlID = signaturepadPanel.id;
        _canvas = signaturepadPanel.querySelector("canvas");
        _div = _canvas.parentElement;
        if (_interval) {
            _stop();
        }
        _interval = setInterval(_checkCanvasSize, 250);
        _signaturePad = new SignaturePad(_canvas, { 'minWidth': 0.5, 'maxWidth': 1.5 });

        _jsro = new Thinfinity.JsRO();
        _jsro.on('model:' + _controlID, 'created', function (obj) {
            _ro = _jsro.model[_controlID];
        });

        _jsro.on(_controlID, "clear", function () {
            _signaturePad.clear();
        });

        _jsro.on(_controlID, "save", function (imgtype) {
            if (_signaturePad.isEmpty()) {
                alert("Please provide signature first.");
            } else {
                _ro.data = _signaturePad.toDataURL("image/" + imgtype, 1.0);
            }
        });

        //console.log("SignaturePad " + _controlID + " is ready");
        _ready = true;
    }
    var _stop = function () {
        window.clearInterval(_interval);
        _interval = null;
        _signaturePad.off();
        _signaturePad = null;
        _jsro.__dispose();
        _jsro = null;
        //console.log("SignaturePad " + _controlID + " was stopped.");
    }

    var _getReady = function () { return _ready; }

    Object.defineProperty(_ref, "start", { "value": _start });
    Object.defineProperty(_ref, "ready", { "get": _getReady });
};

var sc = new SignatureControl();

xtag.register('vui-signature-pad', {
    'content': '<div style="background-color:white;width:100%;height:100%"><canvas style="width:100%;height:100%"></canvas></div>',
    'lifecycle': {
        'created': function () {
            var signaturePanel = this;
            window.setTimeout(function () {
                sc.start(signaturePanel);
            }, 200);
        }
    }
});

