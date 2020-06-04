function(doc) {
    // emit yields the output of the map function
    emit(doc._id, {
        rev: doc._rev,
        number: doc.number
    })
}
