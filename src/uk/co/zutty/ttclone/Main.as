package uk.co.zutty.ttclone {
    import net.flashpunk.Engine;
    import net.flashpunk.FP;

    [SWF(width="600", height="800", frameRate="60", backgroundColor="000000")]
    public class Main extends Engine {
        public function Main() {
            super(150, 200, 60, true);

            FP.screen.scale = 4;

            FP.world = new GameWorld();
        }
    }
}
