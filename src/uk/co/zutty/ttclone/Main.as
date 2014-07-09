package uk.co.zutty.ttclone {
    import net.flashpunk.Engine;
    import net.flashpunk.FP;
    import net.flashpunk.graphics.Text;

    {
        Text.size = 8;
    }

    [SWF(width="768", height="480", frameRate="60", backgroundColor="000000")]
    public class Main extends Engine {
        public static const WIDTH:int = 384;
        public static const HEIGHT:int = 240;

        public function Main() {
            super(WIDTH, HEIGHT, 60, true);

            FP.screen.scale = 2;

            FP.world = new GameWorld();
        }
    }
}
