package uk.co.zutty.ttclone {
    import flash.display.BitmapData;
    import flash.events.Event;
    import flash.media.Sound;
    import flash.media.SoundChannel;

    import flashx.textLayout.formats.TextAlign;

    import net.flashpunk.Entity;
    import net.flashpunk.World;
    import net.flashpunk.graphics.Image;
    import net.flashpunk.graphics.Text;
    import net.flashpunk.graphics.Tilemap;
    import net.flashpunk.utils.Input;
    import net.flashpunk.utils.Key;

    public class GameWorld extends World {

        [Embed(source="/select.png")]
        private static const SELECT_IMAGE:Class;

        [Embed(source="/tiles.png")]
        private static const TILES_IMAGE:Class;
        private static const TILE_SIZE:uint = 16;

        [Embed(source="/construction.mp3")]
        private static const CONSTRUCTION_SOUND:Class;

        private var _constructionSound:Sound = new CONSTRUCTION_SOUND;

        private var _constructionSoundsQueued:int = 0;

        [Embed(source="/build.mp3")]
        private static const BUILD_SOUND:Class;

        private var _buildSound:Sound = new BUILD_SOUND;

        private var _background:Tilemap;
        private var _road:Tilemap;
        private var _select:Entity;

        private var _score:int = 0;
        private var _scoreText:Text = new Text("0 XDG", 0, 0, {align: TextAlign.RIGHT, width: 150});

        private var _scoredRoad:BitmapData = new BitmapData(Math.ceil(160 / TILE_SIZE), Math.ceil(208 / TILE_SIZE));

        private var _lastMouseTileX:int = -1;
        private var _lastMouseTileY:int = -1;

        public function GameWorld() {
            _background = new Tilemap(TILES_IMAGE, 160, 208, TILE_SIZE, TILE_SIZE);
            _background.setRect(0, 0, 10, 13, 0);
            addGraphic(_background);

            _road = new Tilemap(TILES_IMAGE, 160, 208, TILE_SIZE, TILE_SIZE);
            addGraphic(_road);

            _select = new Entity();
            _select.graphic = new Image(SELECT_IMAGE);
            add(_select);

            addGraphic(_scoreText);
        }

        override public function update():void {
            super.update();

            var mouseTileX:uint = Math.floor(mouseX / TILE_SIZE);
            var mouseTileY:uint = Math.floor(mouseY / TILE_SIZE);

            _select.x = mouseTileX * TILE_SIZE;
            _select.y = mouseTileY * TILE_SIZE;

            if (Input.mouseDown) {
                if (!(mouseTileX == _lastMouseTileX && mouseTileY == _lastMouseTileY)) {
                    var roadChanged:Boolean = Input.check(Key.SHIFT)
                            ? Boolean(clearRoad(mouseTileX, mouseTileY))
                            : Boolean(setRoad(mouseTileX, mouseTileY, true));

                    if (roadChanged) {
                        var buildSoundChannel:SoundChannel = _buildSound.play();
                        buildSoundChannel.addEventListener(Event.SOUND_COMPLETE, onBuildSoundComplete);
                        ++_constructionSoundsQueued;
                        scoreRoad(mouseTileX, mouseTileY);
                    }

                    _lastMouseTileX = mouseTileX;
                    _lastMouseTileY = mouseTileY;
                }
            } else {
                _lastMouseTileX = -1;
                _lastMouseTileY = -1;
            }
        }

        private function onBuildSoundComplete(event:Event):void {
            if (--_constructionSoundsQueued == 0) {
                _constructionSound.play();
            }
        }

        private function setRoad(tileX:uint, tileY:uint, recurse:Boolean):int {
            if (tileX < 0 || tileX > _road.columns - 1
                    || tileY < 0 || tileY > _road.rows - 1) {
                return 0;
            }

            var n:Boolean = tileY > 0 && _road.getTile(tileX, tileY - 1) > 0;
            var s:Boolean = tileY < _road.rows - 1 && _road.getTile(tileX, tileY + 1) > 0;
            var w:Boolean = tileX > 0 && _road.getTile(tileX - 1, tileY) > 0;
            var e:Boolean = tileX < _road.columns - 1 && _road.getTile(tileX + 1, tileY) > 0;

            var tile:uint = 1;

            if (!w && !e) {
                tile = 1;
            } else if (!n && !s) {
                tile = 2;
            } else if (!n && s && !w && e) {
                tile = 3;
            } else if (!n && s && w && !e) {
                tile = 4;
            } else if (n && !s && w && !e) {
                tile = 5;
            } else if (n && !s && !w && e) {
                tile = 6;
            } else if (n && s && w && !e) {
                tile = 7;
            } else if (n && s && !w && e) {
                tile = 8;
            } else if (n && !s && w && e) {
                tile = 9;
            } else if (!n && s && w && e) {
                tile = 10;
            } else if (n && s && w && e) {
                tile = 11;
            }

            var changed:int = int(_road.getTile(tileX, tileY) != tile);

            _road.setTile(tileX, tileY, tile);

            if (recurse) {
                if (n) {
                    changed += setRoad(tileX, tileY - 1, false);
                }

                if (s) {
                    changed += setRoad(tileX, tileY + 1, false);
                }

                if (w) {
                    changed += setRoad(tileX - 1, tileY, false);
                }

                if (e) {
                    changed += setRoad(tileX + 1, tileY, false);
                }
            }

            return changed;
        }

        private function clearRoad(tileX:uint, tileY:uint):int {
            if (tileX < 0 || tileX > _road.columns - 1
                    || tileY < 0 || tileY > _road.rows - 1) {
                return 0;
            }

            var changed:int = int(_road.getTile(tileX, tileY) > 0);

            _road.setTile(tileX, tileY, 0);
            _road.clearTile(tileX, tileY);

            var n:Boolean = _road.getTile(tileX, tileY - 1) > 0;
            var s:Boolean = _road.getTile(tileX, tileY + 1) > 0;
            var w:Boolean = _road.getTile(tileX - 1, tileY) > 0;
            var e:Boolean = _road.getTile(tileX + 1, tileY) > 0;

            if (n) {
                changed += setRoad(tileX, tileY - 1, false);
            }

            if (s) {
                changed += setRoad(tileX, tileY + 1, false);
            }

            if (w) {
                changed += setRoad(tileX - 1, tileY, false);
            }

            if (e) {
                changed += setRoad(tileX + 1, tileY, false);
            }

            return changed;
        }

        private function score(points:int):void {
            _score += points;
            _scoreText.text = _score + " XDG";
        }

        private function scoreRoad(tileX:uint, tileY:uint):void {
            _scoredRoad.fillRect(_scoredRoad.rect, 0xff000000);

            score(scoreRoadRecurse(tileX, tileY));
        }

        private function scoreRoadRecurse(tileX:uint, tileY:uint):int {
            if (tileX < 0 || tileX > _road.columns - 1
                    || tileY < 0 || tileY > _road.rows - 1) {
                return 0;
            }

            if (_road.getTile(tileX, tileY) == 0) {
                return 0;
            }

            if (_scoredRoad.getPixel(tileX, tileY) > 0) {
                return 0;
            }

            _scoredRoad.setPixel(tileX, tileY, 1);

            return 1 + scoreRoadRecurse(tileX, tileY - 1)
                    + scoreRoadRecurse(tileX, tileY + 1)
                    + scoreRoadRecurse(tileX - 1, tileY)
                    + scoreRoadRecurse(tileX + 1, tileY);
        }
    }
}
