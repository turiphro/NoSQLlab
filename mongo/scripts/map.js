map_count = function() {
    emit(
        this.components.area,   // key
        {                       // value
            count: 1,
            max: this.components.number
        }
    );
}
