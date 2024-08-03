package objects;

import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;

class ErrorText extends FlxText {
    var _error:String;
    var _yTween:FlxTween;

    public function new(error:String, ?errorTimeout:Float = 5) {
        super(-FlxG.width, 2, 0, error);
        setFormat(Paths.font('vcr.ttf'), 16, FlxColor.RED, LEFT, OUTLINE, FlxColor.BLACK);
        scrollFactor.set();
        borderSize = 2;

        _error = error;

        FlxTween.tween(this, {x: 4}, 1, {ease: FlxEase.expoOut});
        new FlxTimer().start(errorTimeout, (tmr) -> {
            FlxTween.tween(this, {alpha: 0}, 1, {
                ease: FlxEase.quadInOut, onComplete: (_) -> this.kill()
            });
        });
    }
}

class ErrorPopup extends FlxTypedSpriteGroup<ErrorText> {
    public function new() { 
        super();
        scrollFactor.set();
    }

    public function popError(errMsg:String) {
        forEachAlive((err) -> {
            @:privateAccess {
                if (err._yTween != null) err._yTween.cancel();
                    err._yTween = FlxTween.tween(err, {y: err.y + 18}, 0.8, {
                        ease: FlxEase.expoOut,
                        onComplete: (twn) -> err._yTween = null
                    });
            }
        });

        var err = new ErrorText(errMsg);
        add(err);

        trace('deployed error message');
    }
}