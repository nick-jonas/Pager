package {
    import org.osflash.signals.Signal;

    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.events.MouseEvent;
    import flash.text.TextField;
    import flash.text.TextFormat;

    /**
     * @author Jonas
     */
    public class Pager {

        public var $onPrevious      : Signal = new Signal();
        public var $onNext          : Signal = new Signal();
        public var $onPage          : Signal = new Signal(Number);

        private const BOUNDARY_MAX  : uint = 3; // number of first/last page numbers to show
        private const MIDDLE_MAX    : uint = 4; // number of page numbers to show around selection index
        private const TOTAL_NUM_MAX : uint = (BOUNDARY_MAX * 2) + MIDDLE_MAX;
        private const PAGE_MARGIN   : Number = 5; // pixel margin between page numbers

        private var _pageNumbers    : Vector.<Sprite>;
        private var _pageCount      : uint;
        private var _currentIndex   : uint;
        private var _ellipsis       : String;

        public function Pager( pageCount:uint = 0, currentIndex:uint = 0, ellipsis:String = "..." )
        {
            _pageCount = pageCount;
            _currentIndex = currentIndex;
            _ellipsis = _ellipsis;

            init();
        }

        private function init() : void
        {
            _pageNumbers = new Vector.<Sprite>();
        }

        public function updatePageCount(pageCount:uint, goToIndex:uint = 0):void{
            _pageCount = pageCount;
            _currentIndex = goToIndex;
            goToPage(_currentIndex);
        }

        public function goToSpecificPage(pageIndex:Number):void
        {
            onNewPageNo(pageIndex);
            $onPage.dispatch(pageIndex);
        }

        private function onNewPageNo( pageNo:uint ):void
        {
            _currentIndex = pageNo;
        }

        // returns list with page numbers for pagination
        private function getPageListFromIndex(index:uint):Array
        {
            var list:Array = [];
            var i:uint;
            if(_pageCount <= TOTAL_NUM_MAX){ // return the first 10 numbers, no need for _ellipsis
                for (i = 0; i < _pageCount; i++) list.push(i);
            }
            else{
                if(_currentIndex < BOUNDARY_MAX){ // lower end (1, 2, [3], 4, 5, 6, 7, 8 ... 59, 70, 71)
                    for (i = 0; i < TOTAL_NUM_MAX - BOUNDARY_MAX; i++) list.push(i);
                    list.push(_ellipsis);
                    for (i = _pageCount - BOUNDARY_MAX; i < _pageCount; i++) list.push(i);
                }
                else{
                    if(_currentIndex > (_pageCount - BOUNDARY_MAX)){ // higher end (1, 2, 3, ... 8, [9], 10, 11, 12, 13, 14)
                        for (i = 0; i < BOUNDARY_MAX; i++) list.push(i);
                        list.push(_ellipsis);
                        for (i = _pageCount - (TOTAL_NUM_MAX - BOUNDARY_MAX); i < _pageCount; i++) list.push(i);
                    }
                    else{ // middle (1, 2, 3, ... 44, 45, [46], 47 ... 60, 61, 62)
                        for (i = 0; i < BOUNDARY_MAX; i++) list.push(i);

                        if(index > BOUNDARY_MAX) list.push(_ellipsis);

                        var m:int = MIDDLE_MAX / 2;
                        var startingIndex:uint = _currentIndex - m;
                        while(startingIndex < BOUNDARY_MAX) startingIndex++;
                        for(i = startingIndex; i < startingIndex + MIDDLE_MAX; i++) list.push(i);

                        if(startingIndex + MIDDLE_MAX > (_pageCount - BOUNDARY_MAX)){
                            for (i = startingIndex + MIDDLE_MAX; i < _pageCount; i++) list.push(i);
                        }
                        else{
                            list.push(_ellipsis);
                            for (i = _pageCount - BOUNDARY_MAX; i < _pageCount; i++) list.push(i);
                        }
                    }
                }
            }
            return list;
        }

        /*
         * ACCESSOR METHODS
         */

        public function get pageCount() : uint{
            return _pageCount;
        }

        public function set pageCount(pageCount : uint) : void{
            _pageCount = pageCount;
        }

        public function get currentIndex():uint{
            return _currentIndex;
        }

        public function set currentIndex(index:uint):void{
            _currentIndex = index;
        }

    }
}
