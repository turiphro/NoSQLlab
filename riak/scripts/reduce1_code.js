function (v) {
    // v = [VALUE, VALUE, VALUE]
    var totals = {};
    for (var i in v) {
        for (var style in v[i]) {
            totals[style] = (totals[style] || 0) + v[i][style];
        }
    }
    return [totals];
}
