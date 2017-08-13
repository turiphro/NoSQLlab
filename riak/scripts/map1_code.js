function(v) {
    // v = {'bucket': .., 'key': .., 'vclock',
    //      'values': [ {'data': .., 'metadata': {..}} ]}
    var parsedData = JSON.parse(v.values[0].data);
    var data = {};
    data[parsedData.style] = parsedData.capacity;           // per room type
    //data[parseInt(v.key) % 100] = parsedData.capacity;    // per floor
    return [data];
}
