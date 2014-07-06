package uk.co.zutty.ttclone.path {
    import flash.geom.Point;
    import flash.utils.Dictionary;

    import net.flashpunk.graphics.Tilemap;

    public class Pathfinder {

        private var _tilemap:Tilemap;

        public function Pathfinder(tilemap:Tilemap) {
            _tilemap = tilemap;
        }

        public function findPath(fromX:int, fromY:int, goalX:int, goalY:int):Array {
            return findPathTile(Math.floor(fromX / _tilemap.tileWidth), Math.floor(fromY / _tilemap.tileHeight), Math.floor(goalX / _tilemap.tileWidth), Math.floor(goalY / _tilemap.tileHeight));
        }

        public function findPathTile(fromX:int, fromY:int, goalX:int, goalY:int):Array {
            var h:Function = function (x:int, y:int):Number { return distManhattan(x, y, goalX, goalY); }
            var open:Vector.<Node> = new Vector.<Node>();
            var closed:Dictionary = new Dictionary();

            // Add root node
            open[0] = new Node(fromX, fromY, 0, h(fromX, fromY), null);

            while(open.length > 0) {
                var current:Node = open.shift();

                if(current.x == goalX && current.y == goalY) {
                    return walk(current);
                }

                closed[getTileNum(current.x,  current.y)] = 1;

                // Get neighbors
                for each(var n:Point in neighbours(current)) {
                    if(!(getTileNum(n.x,  n.y) in closed)) {
                        open.push(new Node(n.x, n.y, current.cost + 1, h(n.x, n.y), current));
                    }
                }

                // Sort the open list
                open.sort(function (a:Node, b:Node):Number {
                    return a.cost - b.cost;
                });
            }

            return [];
        }

        private static function distManhattan(x1:Number, y1:Number, x2:Number, y2:Number):Number {
            return Math.abs(x2-x1) + Math.abs(y2 - y1);
        }

        private function getTileNum(x:int, y:int):int {
            return (y * _tilemap.columns) + x;
        }

        private function neighbours(node:Node):Array {
            var neighbours:Array = [];

            if(node.y > 0 && _tilemap.getTile(node.x, node.y - 1) > 0) {
                neighbours.push(new Point(node.x, node.y - 1));
            }
            if(node.y < _tilemap.rows - 1 && _tilemap.getTile(node.x, node.y + 1) > 0) {
                neighbours.push(new Point(node.x, node.y + 1));
            }
            if(node.x > 0 && _tilemap.getTile(node.x - 1, node.y) > 0) {
                neighbours.push(new Point(node.x - 1, node.y));
            }
            if(node.x < _tilemap.columns -1 && _tilemap.getTile(node.x + 1, node.y) > 0) {
                neighbours.push(new Point(node.x + 1, node.y));
            }

            return neighbours;
        }

        private function walk(node:Node):Array {
            var path:Array = [];
            var walk:Node = node;

            while(walk != null) {
                path.unshift(new Point(walk.x * _tilemap.tileWidth, walk.y * _tilemap.tileHeight));
                walk = walk.parent;
            }

            return path;
        }
    }
}
