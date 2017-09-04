// Populate MongoDB database
// Uses Mongo shell commands (not a standalone script)
// Based on 7db book

use geography

// withold one city from the JSON import; inserting via mongo shell command
db.cities.insert({
    name:"Amsterdam",
    country:"NL",
    timezone:"Europe/Amsterdam",
    population:741636,
    famous_for: ["canals", "red light district"],
    mayor: {"party": "pvda"},
    location: { longitude: 52.37403, latitude: 4.88969}
});

print("--------------------------")
print("Documents inserted: ")
db.cities.count()
"--------------------------"

"--------------------------"
const start = 555e4;
const end = 565e4;
print("Inserting " + (end-start) + " phone numbers..")
for (let i=start; i<end; i++) {
    const area = 867 + Math.floor(Math.random() * 5);
    const country = 1 + Math.floor(Math.random() * 32);
    const num = (country * 1e10) + (area * 1e7) + i;
    const display = "+" + country + " " + area + "-" + i;
    if (i % 10000 == 0) {
        print(display);
    }

    db.phones.insert({
        _id: num,
        components: {
            country: country,
            area: area,
            prefix: (i * 1e-4) << 0,
            number: i
        },
        display: display
    })
}
print("Done.")
print("--------------------------")
