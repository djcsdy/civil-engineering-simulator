package uk.co.zutty.ttclone {
    import net.flashpunk.Entity;
    import net.flashpunk.graphics.Spritemap;

    public class Bus extends Entity {

        private static const SPEED:Number = 0.5;

        [Embed(source="/bus.png")]
        private static const BUS_IMAGE:Class;

        private var _sprite:Spritemap;
        private var _direction:String;

        private var _stops:Vector.<BusStop> = new Vector.<BusStop>();
        private var _destination:uint = 0;
        private var _path:Array;

        public function Bus() {
            _sprite = new Spritemap(BUS_IMAGE, 12, 12);
            _sprite.add("n", [2]);
            _sprite.add("s", [3]);
            _sprite.add("w", [0]);
            _sprite.add("e", [1]);
            _sprite.centerOrigin();
            added();
            graphic = _sprite;

            layer = -100;
        }

        override public function added():void {
            _direction = "e";
            updateSprite();
        }

        public function set ns(value:Boolean):void {
            _direction = value ? "s" : "e";
            updateSprite();
        }

        public function addStop(dest:BusStop):void {
            _stops.push(dest);
            _destination = _stops.length - 1;
        }

        public function repath():void {
            _path = Main.gameWorld.roadPathfinder.findPath(x, y, _stops[_destination].x, _stops[_destination].y);
        }

        private function updateSprite():void {
            _sprite.play(_direction);
        }

        private function get reachedNext():Boolean {
            var destX:int = _stops[_destination].x + 8;
            var destY:int = _stops[_destination].y + 8;

            return x == destX && y == destY;
        }

        override public function update():void {
            if(_path.length > 0) {
                var destX:Number = _path[0].x + 8;
                var destY:Number = _path[0].y + 8;

                moveTowards(destX, destY, SPEED);

                if(x == destX && y == destY) {
                    _path.shift();

                    if(reachedNext) {
                        _destination++;
                        if(_destination >= _stops.length) _destination = 0;
                        repath();
                    }
                }
            }
        }
    }
}
