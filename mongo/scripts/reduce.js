reduce_count = function(key, values) {
    // Since reducers can be called hierarchically (distributed servers),
    // return the same datatype as the items in 'values'

    return {    // new value
        count: Array.sum(values.map(v => v.count)),
        max: Math.max(...values.map(v => v.max))
        //OR: values.map(v => v.max).reduce((a,b) => Math.max(a,b), 0)
    }
}
