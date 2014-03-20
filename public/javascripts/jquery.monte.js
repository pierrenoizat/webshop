// Monte 1.0 - a carousel plugin for jQuery 1.3+
// Copyright (c) 2011 Jack Moore - jacklmoore.com
// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
(function ($) {
    $.monte = function (selector, options) {
        var
        position = 'position',
        zIndex = 'z-index',
        montePaused = 'montePaused',
        controls = {},
        settings = $.extend({}, $.monte.defaults, options || {}),
        $frame = $(selector),
        stack = $frame.children().hide().css(position, 'absolute').get(),
        timeout,
        active = 0,
        state = 0,
        $top = $(stack[0]),
        $prev,
        $next,
        $play = $([]),
        play = settings.auto,
        scale = settings.scale || 1,
        width = settings.width || $top.width(),
        height = settings.height || $top.height(),
        cssTop = {
            left: ($frame.width() - width) / 2, 
            width: width, 
            height: height,
            top: 0
        },
        cssNext = {
            left: $frame.width() - width * scale, 
            width: width * scale, 
            height: height * scale,
            top: (height - height * scale) / 2
        },
        cssPrev = $.extend({}, cssNext, {left: 0}),
        time = false,
        oldTime;

        function setStack() {
            $top = $(stack[0]).css(zIndex, 2).show();
            $prev = $(stack[stack.length - 1]).css(cssPrev).css(zIndex, 1).show();
            $next = $(stack[1]).css(cssNext).css(zIndex, 1).show();
        }

        function callback(func) {
            if ($.isFunction(func)) {
                func.call(stack);
            }
        }

        // Moves either the left or right slide to the center position.
        function toTop() {
            callback(settings.callbackIn);
            oldTime = time;
            time = +new Date();
            $top.animate(cssTop, oldTime ? time - oldTime : settings.speed, function () {
                time = false;
                active = 0;
                callback(settings.callback);
                if (play) {
                    timeout = setTimeout(controls.next, settings.delay);
                }
            });
        }

        /*
            This function moves the center slide left or right, depending on the direction parameter.

            time and oldTime are used to determine how much time is remaining in the animation 
            duration in instances where the direction is reversed mid-animation.  This allows 
            the new animation to have a duration porportional to the amount of animation left.

            State determines wether or not a prev() or next() command can be currently applied.
            For instance, this will prevent next() from being called two times in a row, allowing
            the first call to next() to complete without interuption.
        */
        function move(direction) {
            if ((direction > 0 && active < 1) || (direction < 0 && active > -1)) {
                clearTimeout(timeout);
                state = active;
                active = direction;
                $top.stop();
                if (state === -direction) {
                    toTop();
                } else {
                    callback(settings.callbackAway);
                    oldTime = time;
                    time = +new Date();
                    $top.animate(direction > 0 ? cssPrev : cssNext, oldTime ? time - oldTime : settings.speed, function () {
                        time = false;
                        if (direction > 0) {
                            $prev.css(zIndex, 0).hide();
                            stack.push(stack.shift());
                            active = 2;                            
                        } else {
                            $next.css(zIndex, 0).hide();
                            stack.unshift(stack.pop());
                            active = -2;
                        }
                        setStack();
                        toTop();
                    });                
                }
            }
        }

        controls.next = function () {
            move(1);
        };

        controls.prev = function () {
            move(-1);
        };

        controls.play = function () {
            play = true;
            $play.removeClass(montePaused).text(settings.pause);
            controls.next();
        };

        controls.pause = function () {
            clearTimeout(timeout);
            play = false;
            $play.addClass(montePaused).text(settings.play);
        };

        controls.settings = settings;

        if ($frame.css(position) === 'static') {
            $frame.css(position, 'relative');
        }
        setStack();
        $top.css(cssTop).show();

        function button(className, text) {
            return $('<a href="#"/>').addClass(className).text(text).css(zIndex, 3);
        }

        if (settings.buttons) {
            $frame.append(
                button("montePrev", settings.prev).click(function (e) {
                    e.preventDefault();
                    controls.prev();
                }),
                $play = button("montePlay", settings.pause).click(function (e) {
                    e.preventDefault();
                    controls[play ? 'pause' : 'play']();
                }),
                button("monteNext", settings.next).click(function (e) {
                    e.preventDefault();
                    controls.next();
                })
            );
        }
        
        if (play) {
            timeout = setTimeout(controls.next, settings.delay);
        } else {
            $play.addClass(montePaused).text(settings.play);
        }

        return controls;
    };

    $.monte.defaults = {
        height: false,
        width: false,
        scale: 0.85,
        speed: 450,
        delay: 3500,
        auto: true,
        buttons: true,
        next: 'Next',
        prev: 'Prev',
        play: 'Play',
        pause: 'Pause',
        callbackIn: false,
        callbackAway: false,
        callback: false
    };

}(jQuery));