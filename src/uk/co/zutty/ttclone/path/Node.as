package uk.co.zutty.ttclone.path {
    public class Node {

        private var _x:int;
        private var _y:int;
        private var _pathCost:Number;
        private var _heuristicCost:Number;
        private var _parent:Node;

        public function Node(x:int, y:int, pathCost:Number, heuristicCost:Number, parent:Node) {
            _x = x;
            _y = y;
            _pathCost = pathCost;
            _heuristicCost = heuristicCost;
            _parent = parent;
        }


        public function get x():int {
            return _x;
        }

        public function set x(value:int):void {
            _x = value;
        }

        public function get y():int {
            return _y;
        }

        public function set y(value:int):void {
            _y = value;
        }

        public function get pathCost():Number {
            return _pathCost;
        }

        public function set pathCost(value:Number):void {
            _pathCost = value;
        }

        public function get heuristicCost():Number {
            return _heuristicCost;
        }

        public function set heuristicCost(value:Number):void {
            _heuristicCost = value;
        }

        public function get cost():Number {
            return _pathCost + _heuristicCost;
        }

        public function get parent():Node {
            return _parent;
        }

        public function set parent(value:Node):void {
            _parent = value;
        }

        public function get root():Boolean {
            return _parent == null;
        }
    }
}
