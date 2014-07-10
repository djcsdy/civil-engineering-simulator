package net.noiseinstitute.basecode {
    import flash.geom.Matrix;
    import flash.geom.Point;
    import flash.geom.Rectangle;

    /** Various statically allocated resources, to reduce garbage collection. */
    public class Static {
        /** A point representing the origin (0, 0).
         *
         * Don't modify the properties of this point!
         */
        public static const origin:Point = new Point();

        /** A statically allocated point for temporary storage.
         *
         * Use this point by setting the x and y properties directly.
         *
         * Don't expect this point to retain its values across function
         * calls! */
        public static const point:Point = new Point();

        /** A statically allocated point for temporary storage.
         *
         * Use this point by setting the x and y properties directly.
         *
         * Don't expect this point to retain its values across function
         * calls! */
        public static const point2:Point = new Point();

        /** A statically allocated rectangle for temporary storage.
         *
         * Use this rectangle by setting the x, y, width and height properties
         * directly.
         *
         * Don't expect this rectangle to retain its values across function
         * calls! */
        public static const rect:Rectangle = new Rectangle();

        /** A statically allocated matrix for temporary storage.
         *
         * Use this matrix by setting its properties directly, or calling
         * functions that mutate its properties.
         *
         * Don't expect this matrix to retain its values across function
         * calls! */
        public static const matrix:Matrix = new Matrix();
    }
}
