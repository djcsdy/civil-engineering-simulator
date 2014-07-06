package uk.co.zutty.ttclone {
    import net.flashpunk.Entity;
    import net.flashpunk.graphics.Spritemap;

    public class Bus extends Entity {

        [Embed(source="/bus.png")]
        private static const BUS_IMAGE:Class;

        private var _sprite:Spritemap;
        private var _direction:String;

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

        private function updateSprite():void {
            _sprite.play(_direction);
        }
    }
}
