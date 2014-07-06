package uk.co.zutty.ttclone {
    import net.flashpunk.Entity;
    import net.flashpunk.graphics.Spritemap;

    public class BusStop extends Entity {

        [Embed(source="/bus_stop.png")]
        private static const BUS_STOP_IMAGE:Class;

        private var _sprite:Spritemap;

        private var _ns:Boolean;
        private var _built:Boolean;
        private var _validBuild:Boolean;
        private var _next:BusStop;

        public function BusStop() {
            _sprite = new Spritemap(BUS_STOP_IMAGE, 16, 16);
            _sprite.add("ns", [0]);
            _sprite.add("we", [1]);
            _sprite.add("ns_plan_bad", [2]);
            _sprite.add("we_plan_bad", [3]);
            _sprite.add("ns_plan_ok", [4]);
            _sprite.add("we_plan_ok", [5]);
            added();
            graphic = _sprite;

            layer = -200;
        }

        override public function added():void {
            _ns = false;
            _built = false;
            _validBuild = false;
            updateSprite();
        }

        public function set ns(value:Boolean):void {
            _ns = value;
            updateSprite();
        }

        public function set built(value:Boolean):void {
            _built = value;
            updateSprite();
        }

        public function set validBuild(value:Boolean):void {
            _validBuild = value;
            updateSprite();
        }

        public function set next(value:BusStop):void {
            _next = value;
        }

        private function updateSprite():void {
            var anim:String = _ns ? "ns" : "we";

            if(!_built) {
                anim += "_plan_" + (_validBuild ? "ok" : "bad");
            }

            _sprite.play(anim);
        }
    }
}
